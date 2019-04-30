//
//  CRFUpdateClaim.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 planNo":"XFYY20171205007",
 "planName":"幸富月盈20171125",
 "investNo":"XFYY201712050070035",
 "investStatus":"newinvest",
 "investCrfUid":"a74b280d5488135399843d6a99cbaae7",
 "investAmount":100000,
 "actualPrincipalBalance":100000,
 "intentionAvailableAmount":100000,
 "cycleAvailableAmount":0,
 "lendedAmount":0,
 "applyDate":"2017-11-21 18:46:48",
 "clearingDate":null,
 "interestStartDate":"2017-11-23 10:46:53",
 "interestEndDate":"2017-12-25 15:59:59",
 "maturityPaymentMethod":"single",
 "annualizedYieldSingle":6,
 "annualizedYieldDouble":6.17,
 "exitMode":"expiredUnfree"
 */

@interface CRFInvestInfo : NSObject


@property (nonatomic, copy) NSString *investAmount;

@property (nonatomic, copy) NSString *actualPrincipalBalance;

@property (nonatomic, copy) NSString *intentionAvailableAmount;

@property (nonatomic, copy) NSString *cycleAvailableAmount;

@property (nonatomic, copy) NSString *lendedAmount;

@property (nonatomic, copy) NSString *loanAmount;

@end

@interface CRFUpdateClaim : NSObject

@property (nonatomic, copy) NSString *failCode;

@property (nonatomic, copy) NSString *failReason;

@property (nonatomic, strong) NSDictionary *invest;

@property (nonatomic, copy) NSString *nowDay;

@property (nonatomic, copy) NSString *requestRefNo;

@property (nonatomic, copy) NSString *result;


@property (nonatomic, strong) CRFInvestInfo *investInfo;

@end
