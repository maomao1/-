//
//  AppDelegate+UMeng.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UMAnalytics/MobClick.h>

@interface AppDelegate (UMeng)

/**
 集成友盟分享
 */
- (void)registerUMSDK;

/**
 集成友盟统计
 */
- (void)registerUMengStatistics;

@end
