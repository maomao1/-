//
//  CRFUserInfo.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/6.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFUserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *accessToken;    ///<访问Token

@property (nonatomic, copy) NSString *userId;         ///<用户ID

@property (nonatomic, copy) NSString *userName;       ///<用户名

@property (nonatomic, copy) NSString *idNo;           ///<身份证号

@property (nonatomic, copy) NSString *headUrl;        ///<头像

@property (nonatomic, copy) NSString *emailNo;        ///<邮箱号

@property (nonatomic, copy) NSString *phoneNo;        ///<手机号

@property (nonatomic, copy) NSString *customerUid;    ///<首页需用

@property (nonatomic, copy) NSString *financialPhone;    ///<

@property (nonatomic, copy) NSString *financialName;    ///<

/**
 刷新token
 */
@property (nonatomic, copy) NSString *refreshToken;

/**
 是否授权上海银行
 */
@property (nonatomic, copy) NSString *tograntauthorization;

/**
 授权电子签章
 */
@property (nonatomic, copy) NSString *protocolValidation;///<'1:未授权；2已授权；3无需授权'

/**
 开户状态
 */
@property (nonatomic, copy) NSString *accountStatus; ///< 1 No 2yes

/**
 投资状态
 */
@property (nonatomic, copy) NSString *customerStatus;///<1 no 2yes

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 开户人身份证号
 */
@property (nonatomic, copy) NSString *openAccountIdno;

@property (nonatomic, copy) NSString *riskLevel;///<风险评估等级[1、稳健性 2、成熟性 3 激进性]

/**
 开户银行卡
 */
@property (nonatomic, copy) NSString *openBankCardNo;

/**
 风险揭示书是否授权（1：未授权，2：已授权，3：无需授权）
 */
@property (nonatomic, copy) NSString *riskConfirm;


/**
 <#Description#>
 */
@property (nonatomic, copy) NSString *bankCode;

/**
 <#Description#>
 */
@property (nonatomic, copy) NSString *bankPicUrl;
/**
 1：已授权，2：未授权，3：信息异常，4，修改卡未授权 5  6不处理
 */
@property (nonatomic, copy) NSString *accountSigned;
/**
 格式化手机号

 @return string
 */
- (NSString *)formatMobilePhone;

/**
 格式化身份证号

 @return string
 */
- (NSString *)formatIdNo;

/**
 格式化银行卡号

 @return string
 */
- (NSString *)formatBankCardNo;

/**
 <#Description#>

 @return <#return value description#>
 */
- (NSString *)formatUserName;

/**
 <#Description#>

 @return <#return value description#>
 */
- (NSString *)formatChangeBankCardUserName;

@end
