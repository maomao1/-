//
//  CRFSettingData.m
//  CashLoan
//
//  Created by crf on 15/10/20.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import "CRFSettingData.h"



static NSString *const TAG_toast_url_list = @"home-toast-url-list";
static NSString *const TAG_toast_info_list = @"home-toast-info-list";

static NSString *const TAG_crash_bugsReport = @"crash_bugs_report";
static NSString *const TAG_show_app_guide = @"show_app_guide_view";

#ifdef WALLET
static NSString *const TAG_current_account_info = @"mj_current_account_info";
static NSString *const TAG_current_client = @"mj_current_client_info";
#else
static NSString *const TAG_current_client = @"current_client_info";
static NSString *const TAG_current_account_info = @"current_account_info";
#endif
static NSString *const TAG_current_push_notification = @"current_push_notification_info";
static NSString *const TAG_bundle_bankcard_info_list = @"bundle-bankcard-info-list";
static NSString *const TAG_apply3_alipay_status = @"apply3_prepare_update_alipay";
static NSString *const TAG_liveness_apply2_times = @"liveness_apply2_times";
static NSString *const TAG_liveness_p2p_times = @"liveness_p2p_times";
static NSString *const TAG_liveness_apply3_times = @"liveness_apply3_times";
static NSString *const TAG_liveness_quotas_ditui_times = @"liveness_quotas_dotui_times";
static NSString *const TAG_liveness_quotas2_times = @"liveness_quotas2_times";

static NSString *const TAG_recharge_info         = @"recharge_quick_info";

@implementation CRFSettingData

@synthesize notify,sound,shake,versionCheck;
- (id)init{
    if(self = [super init]){
        notify =  NO;
        sound =  NO;
        shake =  NO;
        versionCheck = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}

/**
 设置是否显示版本更新

 @param flag flag
 */
+ (void)setToastedVersionDialog:(BOOL)flag{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%@",@"userdefaults-toasted-version-dialog-flag",[CRFTimeUtil getCurrentDate:0]];
    [ud setBool:flag forKey:key];
    [ud synchronize];
}
/**
 判断是否显示版本更新

 @return value
 */
+ (BOOL)isToastedVersionDialog{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%@",@"userdefaults-toasted-version-dialog-flag",[CRFTimeUtil getCurrentDate:0]];
    return [ud boolForKey:key];
}

/**
 保存BUG数据

 @param crash flag
 */
+(void)setCrashBugData:(NSString *)crash{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:crash forKey:TAG_crash_bugsReport];
    [ud synchronize];
}

/**
 读取缓存BUG数据

 @return value
 */
+(NSString *)getCrashBugData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:TAG_crash_bugsReport];
}

/**
 清除bug缓存
 */
+ (void)removeCrashBugData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:TAG_crash_bugsReport];
    [ud synchronize];
}

/**
 设置引导页

 @param flag flag
 */
+ (void)setShowAppGuide:(BOOL)flag{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:flag forKey:TAG_show_app_guide];
    [ud synchronize];
}

/**
 判断是否显示引导页

 @return value
 */
+ (BOOL)isShowAppGuide{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:TAG_show_app_guide];
}
/**
 保存获取的设备信息

 @param info info
 */
+ (void)setCRFClientInfo:(CRFClientInfo *)info{
    if (!info) {
        info = [[CRFClientInfo alloc]init];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:info];
    [ud setObject:newEncodedObject forKey:TAG_current_client];
    [ud synchronize];
}
/**
 获取保存的设备信息

 @return info
 */
+ (CRFClientInfo *)getCRFClientInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [ud objectForKey:TAG_current_client];
    CRFClientInfo *info =nil;
    if([myEncodedObject length]>0){
        info = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    }
    if (!info)
        info = [[CRFClientInfo alloc]init];
    return  info;
}
/**
 保存当前登录帐号信息

 @param info info
 */
+ (void)setCurrentAccountInfo:(CRFUserInfo *)info{
    if (!info) {
        info = [[CRFUserInfo alloc]init];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:info];
    [ud setObject:newEncodedObject forKey:TAG_current_account_info];
    [ud synchronize];
}

/**
 获取当前登录帐号信息

 @return user info
 */
+ (CRFUserInfo *)getCurrentAccountInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [ud objectForKey:TAG_current_account_info];
    CRFUserInfo *info =nil;
    if([myEncodedObject length]>0){
        info = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    }
    if (!info)
        info = [[CRFUserInfo alloc]init];
    return  info;
}
+(void)setRechargeInfo:(CRFNewRechargeModel *)info{
    if (!info) {
        info = [[CRFNewRechargeModel alloc]init];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:info];
    [ud setObject:newEncodedObject forKey:TAG_recharge_info];
    [ud synchronize];
}
+(CRFNewRechargeModel*)getRechargeInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [ud objectForKey:TAG_recharge_info];
    CRFNewRechargeModel *info =nil;
    if([myEncodedObject length]>0){
        info = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    }
    if (!info)
        info = [[CRFNewRechargeModel alloc]init];
    return  info;
}
/**
 清除未读信息

 @param uid uid
 */
+ (void)removePushStatusInfo:(NSString *)uid{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:[NSString stringWithFormat:@"%@%@",uid,TAG_current_push_notification]];
    [ud synchronize];
}
///**
// *  保存享分期绑卡列表
// *
// *  @param array
// */
//+(void)setPeriodBundleCardList:(NSArray *)array{
//    if (!array) {
//        array = [[NSArray alloc]init];
//    }
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:array];
//    [ud setObject:userData forKey:TAG_bundle_bankcard_info_list];
//    [ud synchronize];
//}
///**
// *  读取保存的享分期绑卡列表
// *
// *  @return
// */
//+(NSArray *)getPeriodBundleCardList{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSData *myEncodedObject1 = [ud objectForKey:TAG_bundle_bankcard_info_list];
//    NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject1];
//    if (!list) {
//        list = [[NSArray alloc]init];
//    }
//    return list;
//}
///**
// *  开放申请保存支付宝凭证状态
// *
// *  @param flag
// *  @param uid
// */
//+(void)setApply3UpdateAlipayStatus:(BOOL)flag userId:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@",TAG_apply3_alipay_status,uid];
//    [ud setBool:flag forKey:key];
//    [ud synchronize];
//}
///**
// *  开放申请保存支付宝凭证状态
// *
// *  @param uid
// *
// *  @return
// */
//+(BOOL)getApply3UpdateAlipayStatus:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@",TAG_apply3_alipay_status,uid];
//    return [ud boolForKey:key];
//}
///**
// *  开放申请活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setApply3LivenessCount:(NSInteger)count userId:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_apply3_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    [ud setInteger:count forKey:key];
//    [ud synchronize];
//}
///**
// *  开放申请活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getApply3LivenessCount:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_apply3_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    return [ud integerForKey:key];
//}
///**
// *  地推提额活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setQuotasDituiLivenessCount:(NSInteger)count userId:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_quotas_ditui_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    [ud setInteger:count forKey:key];
//    [ud synchronize];
//}
///**
// *  地推提额活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getQuotasDituiLivenessCount:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_quotas_ditui_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    return [ud integerForKey:key];
//}
///**
// *  地推提额活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setQuotasLivenessCount:(NSInteger)count userId:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_quotas2_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    [ud setInteger:count forKey:key];
//    [ud synchronize];
//}
///**
// *  地推提额活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getQuotasLivenessCount:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_quotas2_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    return [ud integerForKey:key];
//}
///**
// *  开放申请二期活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setApply2LivenessCount:(NSInteger)count userId:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_apply2_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    [ud setInteger:count forKey:key];
//    [ud synchronize];
//}
///**
// *  开放申请二期活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getApply2LivenessCount:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_apply2_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    return [ud integerForKey:key];
//}
///**
// *  P2P活体检测试错次数
// *
// *  @param count
// *  @param uid
// */
//+(void)setP2PLivenessCount:(NSInteger)count userId:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_p2p_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    [ud setInteger:count forKey:key];
//    [ud synchronize];
//}
///**
// *  P2P活体检测试错次数
// *
// *  @param uid
// *
// *  @return
// */
//+(NSInteger)getP2PLivenessCount:(NSString *)uid{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",TAG_liveness_p2p_times,uid,[CRFTimeUtil getCurrentDate:0]];
//    return [ud integerForKey:key];
//}
@end
