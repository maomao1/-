//
//  CRFGestureManager.h
//  crf_purse
//
//  Created by xu_cheng on 2018/4/10.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFGestureManager : NSObject

+ (void)registerNotification;

+ (void)verifyPassword:(NSString *)password handler:(void (^)(BOOL success, id response))handler;

/**
 热启动
 */
+ (void)hotStartVerifyGesture;

/**
 冷启动
 */
+ (void)coolStartVerifyGesture;

/**
 设置手势密码
 */
+ (void)settingGesture;

/**
 第一次安装应用并登录成功时候，设置手势密码
 */
+ (void)firstInstallAfterSettingGesture;

+ (void)gotoLogin;

+ (void)upgradeVersion;

@end
