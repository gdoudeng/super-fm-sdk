//
//  ViewController.m
//  SuperFmClient
//
//  Created by dwb on 2022/12/26.
//

#import <SuperFmSDK/SuperFmSDK.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"ViewController";

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 300, 200, 38);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"点我一下"
            forState:UIControlStateNormal];
    [button    addTarget:self
                  action:@selector(onButtonClick)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onButtonClick {
    [self.navigationController pushViewController:[MainViewController new] animated:YES];
}

@end
