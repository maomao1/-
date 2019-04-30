//
//  CRFAppManager.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFUserInfo.h"
#import "CRFClientInfo.h"
#import "CRFLocationInfo.h"
#import "CRFAccountInfo.h"
#import "CRFBankCardInfo.h"
#import "CRFNewRechargeModel.h"

/**
 指纹验证状态

 - VerifySuccess: 验证成功
 - InputPassword: 输入登录密码
 - UserCancel: 用户取消验证
 - VerifyFailed: 验证失败
 - NotFoundTouchID: 没有发现TouchID
 - SystemCancel: 系统被挂起，验证取消
 - ForceLogout: 密码被锁
 */
typedef NS_ENUM(NSUInteger, TouchStatus) {
    VerifySuccess               = 0,
    InputPassword               = 1,
    UserCancel                  = 2,
    VerifyFailed                = 3,
    NotFoundTouchID             = 4,
    SystemCancel                = 5,
    ForceLogout                 = 6
};

@interface CRFAppManager : NSObject

+ (instancetype)defaultManager;
@property (nonatomic, strong) CRFNewRechargeModel *rechargeModel;
/**
 是否登录
 */
@property (nonatomic, assign) BOOL login;

/**
 是否开户(YES:已开户)
 */
@property (nonatomic, assign) BOOL accountStatus;

/**
 获取用户信息的model
 */
@property (nonatomic, strong) CRFUserInfo *userInfo;

/**
 获取本地客户端信息model
 */
@property (nonatomic, strong) CRFClientInfo *clientInfo;

/**
 获取定位信息model
 */
@property (nonatomic, strong) CRFLocationInfo *locationInfo;

/**
 获取用户资产model
 */
@property (nonatomic, strong) CRFAccountInfo *accountInfo;

/**
 获取银行卡列表
 */
@property (nonatomic, strong) NSArray <CRFBankCardInfo *>* bankCards;

/**
 获取收获地址
 */
@property (nonatomic, strong) CRFAddress *address;

/**
 角标（未读消息数量）
 */
@property (nonatomic, copy)  NSString    *unMessageCount;

/**
 当前时间
 */
@property (nonatomic, assign) long long nowTime;

/**
 用户收获地址列表
 */
@property (nonatomic, strong) NSArray <CRFAddress *>*addresses;

/**
 是否切换马甲包审核模式
 */
@property (nonatomic, assign) BOOL majiabaoFlag;

/**
 导航栏标题是否支持配置（图片）
 */
@property (nonatomic, assign) BOOL supportPageConfig;

@property (nonatomic, copy) NSString *bankListPath;

@property (nonatomic, assign) BOOL needReloadIcon;

@property (nonatomic, copy) NSString *resourcePath;


@property (nonatomic, assign) BOOL hotStart;

/**
 当前设备是否支持TouchID

 @return value
 */
- (BOOL)supportTouchID;

/**
 当前设备是否支持faceID

 @return value  
 */
- (BOOL)supportFaceID;

/**
 校验TouchID

 @param resultCallback callback
 */
- (void)verifyTouchID:(void (^)(TouchStatus status))resultCallback;

/**
 出资验证TouchID

 @param resultCallback callback
 */
- (void)verifyInvestTouchID:(void (^)(TouchStatus))resultCallback;

/**
 推送开关是否打开

 @return value
 */
- (BOOL)isOpenRemoteNotificationStatus;

/**
 用户信息是否过期

 @return value
 */
- (BOOL)userInfoExpired;

/**
 移除window层添加的试图
 */
- (void)removeWindowSubViews;

/**
 移除window层除了广告页的视图
 */
- (void)removeWindowUsenessViews;

- (void)addRemoteBankInfoWithLocal:(CRFCardSupportInfo *)bankCardInfo;

@end
