//
//  BackgroundLocationViewController.m
//  AMapLocationKit
//
//  Created by liubo on 8/4/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import "BackgroundLocationViewController.h"

@interface BackgroundLocationViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) UISegmentedControl *backgroundSegment;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@end

@implementation BackgroundLocationViewController

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
}

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 1)
    {
        //停止定位
        [self.locationManager stopUpdatingLocation];
        
        //移除地图上的annotation
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.pointAnnotaiton = nil;
    }
    else
    {
        //开始进行连续定位
        [self.locationManager startUpdatingLocation];
    }
}

- (void)backgroundSegmentAction:(UISegmentedControl *)sender
{
    [self.locationManager stopUpdatingLocation];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.pointAnnotaiton = nil;
    _showSegment.selectedSegmentIndex = 1;
    
    if (sender.selectedSegmentIndex == 1)
    {
        //设置允许系统暂停定位
        [self.locationManager setPausesLocationUpdatesAutomatically:YES];
        
        //设置禁止在后台定位
        [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    }
    else
    {
        //为了方便演示后台定位功能，这里设置不允许系统暂停定位
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设置允许在后台定位
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    
    //获取到定位信息，更新annotation
    if (self.pointAnnotaiton == nil)
    {
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    
    [self.mapView setCenterCoordinate:location.coordinate];
    [self.mapView setZoomLevel:15.1 animated:NO];
}

#pragma mark - Initialization

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
    }
}

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    self.showSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"开始定位", @"停止定位", nil]];
    [self.showSegment addTarget:self action:@selector(showsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.showSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:self.showSegment];
    
    self.backgroundSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"开启后台", @"禁止后台", nil]];
    [self.backgroundSegment addTarget:self action:@selector(backgroundSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.backgroundSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *bgItem = [[UIBarButtonItem alloc] initWithCustomView:self.backgroundSegment];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, showItem, flexble, bgItem, flexble, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initToolBar];
    
    [self initMapView];
    
    [self configLocationManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.translucent   = YES;
    self.navigationController.toolbarHidden         = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = NO;
        annotationView.animatesDrop     = NO;
        annotationView.draggable        = NO;
        annotationView.image            = [UIImage imageNamed:@"icon_location.png"];
        
        return annotationView;
    }
    
    return nil;
}

@end
