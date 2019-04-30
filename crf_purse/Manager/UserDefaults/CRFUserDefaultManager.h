//
//  CRFUserDefaultManager.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFUserDefaultManager : NSObject

/**
 set current version no

 @param value version no
 */
+ (void)setLocalVersionValue:(NSString *)value;

/**
 get current version no

 @return version no
 */
+ (NSString *)getLocalVersionValue;

/**
 set user login`s mobile phone

 @param value mobile phone
 */
+ (void)setInputAccountInfo:(NSString *)value;

/**
 get user mobile phone

 @return mobile phone
 */
+ (NSString *)getInputAccout;

/**
 set touchID switch value

 @param on value
 */
+ (void)setTouchIDSwitch:(BOOL)on;

/**
 get touchID switch value

 @return value
 */
+ (BOOL)getTouchID;

/**
 set user login time
 */
+ (void)setUserLoginTime;

/**
 get user login time

 @return time
 */
+ (long long)getUserLoginTime;

/**
 remove login time
 */
+ (void)removeLoginTime;

/**
 get device UUID

 @return uuid
 */
+ (NSString *)getDeviceUUID;

/**
 设置银行卡审核失败，错误提示的flag
 */
+ (void)setBankCardAuditErrorFlag:(BOOL)flag;

/**
 获取银行卡审核失败，错误提示的flag

 @return flag
 */
+ (BOOL)getBankCardAuthErrorFlag;


/**
 设置银行卡数据版本号

 @param version 版本号
 */
+ (void)setBankDatasVersion:(NSInteger)version;

/**
 获取银行卡数据版本号

 @return 版本号
 */
+ (NSInteger)getBankDatasVersion;


/**
 设置用户资产掩码开关

 @param secret 开关
 */
+ (void)setUserAccountSecret:(BOOL)secret;

/**
 获取用户资产掩码开关

 @return value
 */
+ (BOOL)getUserAccountSecret;

/**
 设置银行卡是否是审核中

 @param status status
 */
+ (void)setBankAuditStatus:(BOOL)status;


/**
 获取银行卡审核状态

 @return value
 */
+ (BOOL)bankAuditStatus;


/**
 设置资源文件标示，是否下载过该文件

 @param sourcePath path
 @param sourceKey key
 */
+ (void)setResourceFlag:(NSString *)sourcePath key:(NSString *)sourceKey;


/**
 获取资源文件标识

 @param sourceKey key
 @return value
 */
+ (NSString *)getResourceFlag:(NSString *)sourceKey;

/**
 存储临时的手势密码

 @param gesture 手势密码
 */
+ (void)saveTemporaryGesture:(NSString *)gesture;

/**
 存储最终的手势密码

 @param gesture 手势密码
 */
+ (void)saveFinalGesture:(NSString *)gesture;

/**
 获取最终的手势密码

 @return 手势密码
 */
+ (NSString *)getFinalGesture;

/**
 获取临时的手势密码

 @return 手势密码
 */
+ (NSString *)getTemporaryGesture;

/**
 设置app进入后台的时间
 */
+ (void)setAppBackgroundTime;

/**
 获取app进入后台的时间

 @return time
 */
+ (long long)getAppBackgroungTime;

/**
 设置第一次安装应用的标示
 */
+ (void)setFirstInstallFlag;

/**
 获取第一次应用安装的标示

 @return falg
 */
+ (BOOL)getFirstInstallFlag;

+ (void)setGestureErrorMaxFlag:(BOOL)flag;

+ (BOOL)getGestureErrorMaxFlag;

@end
