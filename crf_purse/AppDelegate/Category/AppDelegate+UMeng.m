//
//  AppDelegate+UMeng.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate+UMeng.h"


@implementation AppDelegate (UMeng)

- (void)registerUMengStatistics {
    
    [UMConfigure initWithAppkey:kUmengAppKey channel:kChannelId];
    [MobClick setCrashReportEnabled:YES];

    
#ifdef DEBUG
    [UMConfigure setLogEnabled:YES];
#else
    [UMConfigure setLogEnabled:NO];
#endif
}

- (void)registerUMSDK {
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
    
#else
    [[UMSocialManager defaultManager] openLog:NO];
#endif
    
#ifdef WALLET
    NSString *wechatAppKey = @"wx4672fc64ef4cfaca";
    NSString *wechatAppSecret = @"9f9a5d823a96302984b9be6e33c30a1e";
    NSString *qqAppKey = @"1287807337";
    NSString *qqAppSecret = @"a87o6iH8YIfZzwSm";
#else
    NSString *wechatAppSecret = @"ab2f5fe5a520e0c55371c27435809007";
    NSString *wechatAppKey = @"wx1570839907b0a0fa";
    NSString *qqAppKey = @"1105238191";
    NSString *qqAppSecret = @"UZKNuxUa9L4K1C2H";
#endif
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wechatAppKey appSecret:wechatAppSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppKey appSecret:qqAppSecret redirectURL:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    return [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
}


@end
