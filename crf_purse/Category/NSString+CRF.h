//
//  NSString+CRF.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CRF)

+ (NSString *)appName;

/**
 验证身份证号

 @return result
 */
- (BOOL)validateIdentityCard;

/**
 验证银行卡卡号

 @return result
 */
- (BOOL)validateBankCardNumber;

/**
 银行卡后四位

 @return result
 */
- (BOOL)validateBankCardLastNumber;

/**
 是否为空

 @return value
 */
- (BOOL)isEmpty;

/**
 是否为手机号

 @return value
 */
- (BOOL)validatePhoneNumber;

/**
 密码是否有效

 @return value
 */
- (BOOL)isValidPwd;

/**
 <#Description#>

 @return <#return value description#>
 */
- (BOOL)stringIsNumber;


/**
 邮箱的合法性

 @return value
 */
- (BOOL)isEmailAddress;

/**
 校验姓名

 @return value
 */
- (BOOL)validateUserName;

/**
 高精度计算金额 (单位：分)

 @return 金额
 */
- (NSString *)calculateWithHighPrecision;

/**
 获取设备型号

 @return string
 */
+ (NSString *)getCurrentDeviceModel;


/**
 <#Description#>

 @return <#return value description#>
 */
- (CRFBankCardInfo *)getBankCardInfo;

/**
 格式化手机号（掩码）e.g：131******90

 @return string
 */
- (NSString *)formatMoblePhone;

/**
 <#Description#>

 @return <#return value description#>
 */
- (CRFBankCardInfo *)getBankCode;
//
- (CRFBankCardInfo *)getValidateBankCardInfo;

/**
 获取appid

 @return string
 */
+ (NSString *)getAppId;

/**
 校验银行卡是否有效

 @return value
 */
- (BOOL)validateBankCard;

- (NSString *)formatMoney;

/**
 format 起投金额

 @return string
 */
- (NSString *)formatBeginMoney;

/**
 还原格式化后的金额（e.g：13，993 -> 13993）

 @return string
 */
- (NSString *)getOriginString;

/**
 格式化百分比（e.g:13.34% -> 13.34, 20.00% -> 20%）

 @return string
 */
- (NSString *)formatPercent;

/**
 format 收益

 @return string
 */
- (NSString *)formatProfitMoney;

/**
 不明（不知道这是干啥的）

 @return string
 */
- (NSString *)formatPlaceholderMoney;

/**
 获取mac地址

 @return string
 */
+ (NSString *)getMacAddress;

/**
 rsa解密
 
 @return string md5
 */
- (NSString *)md5;

/**
 sha256解密

 @return string
 */
- (NSString *)sha256;

/**
 sha512解密

 @return string
 */
- (NSString *)sha512;

//URLEncode

/**
 url加密

 @return string
 */
- (NSString *)urlencode;

/**
 rsa解密

 @return string
 */
- (NSString *)rsaDecrypt;

/**
 rsa加密

 @return string
 */
- (NSString *)rsaEncrypt;

//NSData 转为成HexStr
- (NSString *)convertDataToHexStr:(NSData *)data;


/**
 <#Description#>

 @return <#return value description#>
 */
- (NSString *)formatJsonToString;

- (NSString *)formatJsonStirng;






@end
