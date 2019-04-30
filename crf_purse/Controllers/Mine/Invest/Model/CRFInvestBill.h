//
//  CRFInvestBill.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFInvestBill : NSObject

//source 2
@property (nonatomic, copy) NSString *annualisedReturnRate;
@property (nonatomic, copy) NSString *billEndDate;
@property (nonatomic, copy) NSString *billStartDate;

/**
 每笔投资周期 
 */
@property (nonatomic, copy) NSString *cycleDate;
@property (nonatomic, copy) NSString *endingProfitSum;
@property (nonatomic, copy) NSString *investAmount;
@property (nonatomic, copy) NSString *investProfit;

//source 1

/**
 初期金额
 */
@property (nonatomic, copy) NSString *startDebtAmount;

/**
 当期出资及赎回
 */
@property (nonatomic, copy) NSString *withdrawedCapital;

/**
 平台活动（返利）
 */
@property (nonatomic, copy) NSString *rebateInterest;

/**
 当期实际收益
 */
@property (nonatomic, copy) NSString *debtProfit;

/**
 平台补贴
 */
@property (nonatomic, copy) NSString *ptProfit;

/**
 累积当期收益
 */
@property (nonatomic, copy) NSString *profit;

/**
 当期年化收益利率
 */
@property (nonatomic, copy) NSString *interest;

/**
 期末余额
 */
@property (nonatomic, copy) NSString *endAmount;

/**
 累积收益金额
 */
@property (nonatomic, copy) NSString *addUpProfits;

/**
 当期出资金额
 */
@property (nonatomic, copy) NSString *investCapital;

/**
 当期赎回金额
 */
@property (nonatomic, copy) NSString *redeemCapital;

/**
 实际年化收益利率
 */
@property (nonatomic, copy) NSString *realInterestRate;



@end
