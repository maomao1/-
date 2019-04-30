//
//  AppDelegate+Push.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate (Push) <JPUSHRegisterDelegate>
- (void)crfEnterBackground:(UIApplication *)application;

- (void)registerNotification:(NSDictionary *)launchOptions;

- (void)uploadToken:(NSData *)deviceToken;
@end
