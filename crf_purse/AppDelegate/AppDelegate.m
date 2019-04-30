//
//  AppDelegate.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate.h"
#import "CALayer+Border.h"
#import "AppDelegate+Welcome.h"
#import "AppDelegate+Push.h"
#import "AppDelegate+UpdateVersion.h"
#import "AppDelegate+UMeng.h"
#import "CRFExceptionManager.h"
#import "IQKeyboardManager.h"
#import "UIImage+Color.h"
#import "AppDelegate+WKWebView.h"
#import "AppDelegate+Resource.h"
#import "CRFGestureManager.h"
#import "AppDelegate+Service.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setWebViewUserAgent];
    _apiNum = 1;
#ifdef WALLET
    NSLog(@"nothing TODO");
#else
//    [self getApplyStatus];
#endif
    [CRFGestureManager registerNotification];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [AppDelegate catchWkWebViewContentViewCrash];
    [self registerUMengStatistics];//友盟
    [self registerUMSDK];
#ifndef SIMULATOR_TEST
     [self registerNotification:launchOptions];
#endif
    [self configKeyboardManager];
    [CRFAPPCountManager crf_setupWithConfiguration];
    [CRFExceptionManager InstallUncaughtExceptionHandler];
    [CRFExceptionManager uploadCrashInfo];
    [self setBarColor];
    [self.window makeKeyAndVisible];
    [self welcomeView];
    [self loadResource];
//    [self channelDrainageCallBack];//积分墙回调
    return YES;
}
-(void)setWebViewUserAgent{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUagent = [NSString stringWithFormat:@"%@/investApp",secretAgent];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    webView = nil;
}
//- (void)getApplyStatus {
//    [CRFAppManager defaultManager].majiabaoFlag = NO;
//    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),@"packageInfo"] success:^(CRFNetworkCompleteType errorType, id response) {
//        NSArray *array = [CRFResponseFactory handleBannerDataForResult:response ForKey:@"majiabao"];
//        if (array.count <= 0) {
//            [CRFAppManager defaultManager].majiabaoFlag = NO;
//            return;
//        }
//        for (CRFAppHomeModel *model in array) {
//            if ([model.urlKey isEqualToString:[NSString getAppId]]) {
//                [CRFAppManager defaultManager].majiabaoFlag = [model.iconUrl boolValue];
//                break;
//            }
//        }
//    } failed:^(CRFNetworkCompleteType errorType, id response) {
//         [CRFAppManager defaultManager].majiabaoFlag = NO;
////        [self toastAlertGotoSetNet];
//    }];
//}
//-(void)toastAlertGotoSetNet{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请检查您的网络连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去设置", nil];
//    [alertView show];
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        exit(0);
//    }
//}
- (void)configKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
}

- (void)setBarColor {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGBValue(0x333333)];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"nav_line"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(CGFLOAT_MIN, CGFLOAT_MIN) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGBValue(0x333333), NSFontAttributeName:[UIFont systemFontOfSize:18]};
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"register notification failed:%@",error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //TODO
    DLog(@"register notification success. token is %@",deviceToken.description);
    [self uploadToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self crfEnterBackground:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //packaging "XXX" "XXX"  "Release"  "/Users/maowo-001/Desktop/XXX" "/Users/maowo-001/Desktop/XXX/build" "adhocExportOptions.plist"

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // [JSPatch sync];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
