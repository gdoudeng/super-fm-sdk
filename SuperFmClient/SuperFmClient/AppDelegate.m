//
//  AppDelegate.m
//  SuperFmClient
//
//  Created by dwb on 2022/12/26.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <SuperFmSDK/SuperFmSDK.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - UISceneSession lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self configureAPIKey];
    
    /*
     * 调用隐私合规处理方法
     */
    [AMapPrivacyUtility handlePrivacyAgreeStatus];
    
    return YES;
}

- (void)configureAPIKey
{
    if ([APIKey length] == 0) {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

        [alert show];
    }

    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

@end
