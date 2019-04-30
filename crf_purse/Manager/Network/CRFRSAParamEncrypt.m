//
//  CRFRSAParamEncrypt.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRSAParamEncrypt.h"
#import "NSDictionary+Sign.h"

@implementation CRFRSAParamEncrypt : NSObject

+ (NSDictionary *)rsaEncrypt:(NSDictionary *)paragrams url:(NSString *)url {
    if (!paragrams) {
        paragrams = @{};
        return @{};
    }
    if (paragrams.allKeys.count <= 0) return paragrams;
    if (![url containsString:@"auth/register/mobilePhone"] && ![url containsString:@"auth/resetPwd/modify"] && ![url containsString:@"auth/login"] && ![url containsString:@"auth/login/smsCode"] && ![url containsString:@"auth/modifyPwd/"] && ![url containsString:@"account/open/"] && ![url containsString:@"account/link/"] && ![url containsString:@"recharge"] && ![url containsString:@"withdraw"] && ![url containsString:@"redemption"] && ![url containsString:@"product/transfer"] && ![url containsString:@"auth/register/check"] && ![url containsString:@"account/certification/"] && ![url containsString:@"account/address/"] && ![url containsString:@"account/cardinfo"] && ![url containsString:@"account/fuiou/userinfo"] && ![url containsString:@"account/changeCard/"] && ![url containsString:@"/app/feedback"] && ![url containsString:@"sms/verifycode"] && ![url containsString:@"auth/token"] && ![url containsString:@"auth/resetPwd/check"] && ![url containsString:@"account/verify/phone"] && ![url containsString:@"account/changeCard/"] && ![url containsString:@"/subscribe/saveSubscribeInvest"] && ![url containsString:@"/earlyRedeem"]&&![url containsString:@"prepareChangeCard"]) {
        return paragrams;
    }
    DLog(@"origin paragrams is %@",paragrams);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:paragrams];
    NSArray <NSString *>*allKeys = dict.allKeys;
    /*
     登录密码
     */
    [self setRSAKey:@"loginPwd" sourceKeys:allKeys sourceParams:dict];
    /*
     登录手机号
     */
    [self setRSAKey:@"mobilePhone" sourceKeys:allKeys sourceParams:dict];
    /*
     旧密码
     */
    [self setRSAKey:@"oldPwd" sourceKeys:allKeys sourceParams:dict];
    /*
     新密码
     */
    [self setRSAKey:@"newPwd" sourceKeys:allKeys sourceParams:dict];
    /*
     身份证号
     */
    [self setRSAKey:@"idNo" sourceKeys:allKeys sourceParams:dict];
    /*
     开户银行卡
     */
    [self setRSAKey:@"openBankCardNo" sourceKeys:allKeys sourceParams:dict];
    /*
     开户手机号
     */
    [self setRSAKey:@"openMobilePhone" sourceKeys:allKeys sourceParams:dict];
    /*
     用户姓名
     */
    [self setRSAKey:@"userName" sourceKeys:allKeys sourceParams:dict];
    /*
     优惠券兑换码
     */
    [self setRSAKey:@"couponsCode" sourceKeys:allKeys sourceParams:dict];
    /*
     验证码
     */
    [self setRSAKey:@"verifyCode" sourceKeys:allKeys sourceParams:dict];
    /*
     图形验证码
     */
    [self setRSAKey:@"picCode" sourceKeys:allKeys sourceParams:dict];
    /*
     银行卡
     */
    [self setRSAKey:@"bankCardNo" sourceKeys:allKeys sourceParams:dict];
    /*
     手机号
     */
    [self setRSAKey:@"phoneNo" sourceKeys:allKeys sourceParams:dict];
    /*
     验证码
     */
    [self setRSAKey:@"validateCode" sourceKeys:allKeys sourceParams:dict];
    /*
     新卡号
     */
    [self setRSAKey:@"newCardNo" sourceKeys:allKeys sourceParams:dict];
    /*
     联系人姓名
     */
    [self setRSAKey:@"contactName" sourceKeys:allKeys sourceParams:dict];
    /*
     图片路径
     */
    [self setRSAKey:@"imagePath" sourceKeys:allKeys sourceParams:dict];
    /*
     原出自编号
     */
    [self setRSAKey:@"sourceInvestNo" sourceKeys:allKeys sourceParams:dict];
    /*
     优惠券编号
     */
    [self setRSAKey:@"couponsId" sourceKeys:allKeys sourceParams:dict];
    /*
     产品编号
     */
    [self setRSAKey:@"investNo" sourceKeys:allKeys sourceParams:dict];
   
    return [dict signature];
}

+ (void)setRSAKey:(NSString *)key sourceKeys:(NSArray *)keys sourceParams:(NSDictionary __strong*)sourceParams {
    if ([keys containsObject:key]) {
        NSString *originString = [sourceParams[key] copy];
        [sourceParams setValue:[originString rsaEncrypt] forKey:key];
    }
}

@end
