//
//  CRFControllerManager.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFLoginViewController.h"

@interface CRFControllerManager : NSObject

/**
 收到推送消息内容弹窗（设备登录）

 @param message message
 @param confirmTitle confirmTitle
 */
+ (void)receivePushMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle;

/**
 收到推送消息直接到登录
 */
+ (void)receivePushMessageGotoLogin;

/**
 重置所有配置信息
 */
+ (void)resetAppConfig;

/**
 重置首页配置信息
 */
+ (void)resetHomeConfig;

/**
 重置我的信息
 */
+ (void)resetMineConfig;

/**
 刷新首页总资产
 */
+ (void)refreshHomeUserAssert;

/**
 刷新我的
 */
+ (void)refreshMine;

/**
 加载首页用户头像
 */
+ (void)loadingHomeUserAvatar;

+ (void)refreshUserInfo;

+ (void)refreshTotalAssert;

/**
 goto login

 @param contorller controller
 @param popType popType
 */
+ (void)pushLoginViewControllerFrom:(UIViewController *)contorller popType:(PopType)popType;

@end
