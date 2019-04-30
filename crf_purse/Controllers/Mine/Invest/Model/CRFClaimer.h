//
//  CRFClaimer.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFAgreementDto.h"

@interface CRFClaimer : NSObject


/**
 出资编号
 */
@property (nonatomic, copy) NSString *investNo;

/**
 债权编号
 */
@property (nonatomic, copy) NSString *rightsNo;

/**
 借款人名称
 */
@property (nonatomic, copy) NSString *loanerName;

/**
 借款人证件号码
 */
@property (nonatomic, copy) NSString *loanerIdNo;

/**
 借款合同号
 */
@property (nonatomic, copy) NSString *loanContractNo;

/**
 借款产品编号
 */
@property (nonatomic, copy) NSString *loanProductNo;

/**
 债权金额
 */
@property (nonatomic, copy) NSString *rightsAmount;

/**
 债权余额
 */
@property (nonatomic, copy) NSString *rightsBalance;

/**
 债权状态
 */
@property (nonatomic, copy) NSString *rightsStatus;

/**
 剩余期数
 */
@property (nonatomic, copy) NSString *effectiveDate;

/**
 生效日期
 */
@property (nonatomic, copy) NSString *closedDate;

/**
 借款人 ID
 */
@property (nonatomic, copy) NSString *crfUid;

/**
 出借协议URL
 */
@property (nonatomic, copy) NSString *agreementHtmlUrl;


@property (nonatomic, copy) NSArray <NSDictionary *>*agreementList;


@property (nonatomic, copy) NSArray <CRFAgreementDto *>*protocols;

@end
