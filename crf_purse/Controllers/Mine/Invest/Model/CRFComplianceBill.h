//
//  CRFComplianceBill.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 当月账单
 */
@interface CRFComplianceCurrentBill : NSObject

/**
 账单周期
 */
@property (nonatomic, copy) NSString *cycleDate;

/**
 账单日期
 */
@property (nonatomic, copy) NSString *billDate;

/**
 计划编号
 */
@property (nonatomic, copy) NSString *planNo;

/**
 出资编号
 */
@property (nonatomic, copy) NSString *investNo;

/**
 计息天数
 */
@property (nonatomic, copy) NSString *investDays;

/**
 应付本金
 */
@property (nonatomic, copy) NSString *payablePrincipal;

/**
 实付本金
 */
@property (nonatomic, copy) NSString *actualPayPrincipal;

/**
 累计应付收益
 */
@property (nonatomic, copy) NSString *payableBenefitTotal;

/**
 累计预支收益
 */
@property (nonatomic, copy) NSString *prepayBenefitTotal;

/**
 本期实付收益
 */
@property (nonatomic, copy) NSString *actualPayBenefit;

/**
 实际年化收益率
 */
@property (nonatomic, copy) NSString *actualAnnualizedYieldDouble;

@end

/**
 历史账单
 */
@interface CRFComplianceHistoryBill : NSObject

/**
 账单周期
 */
@property (nonatomic, copy) NSString *cycleDate;

/**
 账单日期
 */
@property (nonatomic, copy) NSString *billDate;

/**
 计划编号
 */
@property (nonatomic, copy) NSString *planNo;

/**
 出资编号
 */
@property (nonatomic, copy) NSString *investNo;

/**
 本月账单计息开始时间
 */
@property (nonatomic, copy) NSString *billStartDate;

/**
 本月账单计息结束时间
 */
@property (nonatomic, copy) NSString *billEndDate;

/**
 本月账单计息天数
 */
@property (nonatomic, copy) NSString *billDays;

/**
 期初金额（元）
 */
@property (nonatomic, copy) NSString *beginningAmount;

/**
 期末金额（元）
 */
@property (nonatomic, copy) NSString *endingAmount;

/**
 本月出资金额（元）
 */
@property (nonatomic, copy) NSString *investAmount;

/**
 本月赎回金额（元）
 */
@property (nonatomic, copy) NSString *redeemAmount;

/**
 本月逾期收益（元）
 */
@property (nonatomic, copy) NSString *payableBenefit;

/**
 本月预支收益（元）
 */
@property (nonatomic, copy) NSString *prepayBenefit;

/**
 累计预期收益（元）
 */
@property (nonatomic, copy) NSString *payableBenefitTotal;

/**
 累计预支收益（元）
 */
@property (nonatomic, copy) NSString *prepayBenefitTotal;


@end

@interface CRFComplianceBill : NSObject

/**
 出资编号
 */
@property (nonatomic, copy) NSString *investNO;

/**
 货币单位
 */
@property (nonatomic, copy) NSString *currencyUnit;

/**
 收益支付方式
 */
@property (nonatomic, copy) NSString *benefitPayMode;

/**
 起息日期
 */
@property (nonatomic, copy) NSString *interestStartDate;

/**
 到期日期
 */
@property (nonatomic, copy) NSString *interestEndDate;

/**
 期望收益率（单利）
 */
@property (nonatomic, copy) NSString *annualizedYieldSingle;

/**
 期望收益率（复利）
 */
@property (nonatomic, copy) NSString *annualizedYieldDouble;

/**
 计划到期之前的各月账单
 */
@property (nonatomic, strong) NSArray <NSDictionary *> *listBillInfo;

/**
 计划到期当月的账单
 */
@property (nonatomic, strong) NSDictionary *finalBillInfo;

@property (nonatomic, strong) NSArray *totalBills;

@end
