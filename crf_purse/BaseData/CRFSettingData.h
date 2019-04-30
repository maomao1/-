//
//  CRFSettingData.h
//  CashLoan
//
//  Created by crf on 15/10/20.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFTimeUtil.h"
#import "CRFClientInfo.h"
#import "CRFUserInfo.h"
#import "CRFVersionInfo.h"
#import "CRFNewRechargeModel.h"
//#import "PushStatuInfo.h"

@interface CRFSettingData : NSObject{
    Boolean notify;
    Boolean sound;
    Boolean shake;
    Boolean versionCheck;
}
@property Boolean notify;
@property Boolean sound;
@property Boolean shake;
@property Boolean versionCheck;
///**
// *设置是否显示补充OCR弹框
// *
// *  @param flag
// */
//+(void)setToastedSupplyOCR:(BOOL)flag;
///**
// *  判断是否显示补充OCR弹框
// *
// *  @return 保存的显示标识
// */
//+(BOOL)isToastedSupplyOCR;
/**
 设置是否显示版本更新

 @param flag flag
 */
+ (void)setToastedVersionDialog:(BOOL)flag;
/**
 *  判断是否显示版本更新
 *
 */
+ (BOOL)isToastedVersionDialog;
///**
// *  保存红包提醒等url链接
// *
// *  @param array
// */
//+(void)setToastUrlArray:(NSArray *)array;
///**
// *  读取缓存提醒链接
// *
// *  @return
// */
//+(NSArray *)getToastUrlArray;
///**
// *  清理提醒缓存
// */
//+(void)removeToastUrlArray;
///**
// *  保存ToastInfoArray提醒等
// *
// *  @param array
// */
//+(void)setToastInfoArray:(NSArray *)array;
///**
// *  读取ToastInfoArray缓存提醒链接
// *
// *  @return
// */
//+(NSArray *)getToastInfoArray;
///**
// *  清理ToastInfoArray提醒缓存
// */
//+(void)removeToastInfoArray;


/**
 保存BUG数据

 @param crash flag
 */
+ (void)setCrashBugData:(NSString *)crash;
/**
 *  读取缓存BUG数据
 *
 */
+ (NSString *)getCrashBugData;
/**
 *  清除bug缓存
 */
+ (void)removeCrashBugData;

/**
 设置引导页

 @param flag flag
 */
+ (void)setShowAppGuide:(BOOL)flag;

/**
 判断是否显示引导页

 @return value
 */
+ (BOOL)isShowAppGuide;

/**
 保存获取的设备信息

 @param info info
 */
+(void)setCRFClientInfo:(CRFClientInfo *)info;

/**
 获取保存的设备信息

 @return info
 */
+ (CRFClientInfo *)getCRFClientInfo;

/**
 保存当前登录帐号信息

 @param info info
 */
+ (void)setCurrentAccountInfo:(CRFUserInfo *)info;
+(void)setRechargeInfo:(CRFNewRechargeModel*)info;
+(CRFNewRechargeModel*)getRechargeInfo;
/**
 获取当前登录帐号信息

 @return user info
 */
+ (CRFUserInfo *)getCurrentAccountInfo;

///**
// *  保存享分期绑卡列表
// *
// *  @param array
// */
//+(void)setPeriodBundleCardList:(NSArray *)array;
///**
// *  读取保存的享分期绑卡列表
// *
// *  @return
// */
//+(NSArray *)getPeriodBundleCardList;
///**
// *  开放申请保存支付宝凭证状态
// *
// *  @param flag
// *  @param uid
// */
//+(void)setApply3UpdateAlipayStatus:(BOOL)flag userId:(NSString *)uid;
///**
// *  开放申请保存支付宝凭证状态
// *
// *  @param uid
// *
// *  @return
// */
//+(BOOL)getApply3UpdateAlipayStatus:(NSString *)uid;
///**
// *  开放申请活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setApply3LivenessCount:(NSInteger)count userId:(NSString *)uid;
///**
// *  开放申请活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getApply3LivenessCount:(NSString *)uid;
///**
// *  地推提额活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setQuotasDituiLivenessCount:(NSInteger)count userId:(NSString *)uid;
///**
// *  地推提额活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getQuotasDituiLivenessCount:(NSString *)uid;
///**
// *  提额二期活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setQuotasLivenessCount:(NSInteger)count userId:(NSString *)uid;
///**
// *  提额二期活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getQuotasLivenessCount:(NSString *)uid;
///**
// *  开放申请二期活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setApply2LivenessCount:(NSInteger)count userId:(NSString *)uid;
///**
// *  开放申请二期活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getApply2LivenessCount:(NSString *)uid;
///**
// *  P2P活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setP2PLivenessCount:(NSInteger)count userId:(NSString *)uid;
///**
// *  P2P活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getP2PLivenessCount:(NSString *)uid;

@end
