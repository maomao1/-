//
//  CRFMyInvestProduct.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFAgreementDto.h"

@interface CRFMyInvestProduct : NSObject


/**
 出资主键
 */
@property (nonatomic, copy) NSString *investId;

/**
  出资编号
 */
@property (nonatomic, copy) NSString *investNo;

/**
 产品名称
 */
@property (nonatomic, copy) NSString *productName;

/**
 计息日
 */
@property (nonatomic, copy) NSString *interestStartDate;

/**
 到期时间(封闭期)
 */
@property (nonatomic, copy) NSString *closeDate;

/**
  封闭天数
 */
@property (nonatomic, copy) NSString *closeDays;

/**
 出资本金
 */
@property (nonatomic, copy) NSString *amount;

/**
 出借中的金额
 */
@property (nonatomic, copy) NSString *accountAmount;

/**
 已赎回本金
 */
@property (nonatomic, copy) NSString *redeAmount;

/**
 年化利率
 */
@property (nonatomic, copy) NSString *yearRate;

/**
 年化利率最高
 */
@property (nonatomic, copy) NSString *maxYield;

/**
 年化利率最低
 */
@property (nonatomic, copy) NSString *minYield;

/**
 等待天数
 */
@property (nonatomic, copy) NSString *queueDays;

/**
 出资状态。当笔出资状态（1:待处理，2计息中，3赎回中（不可取消赎回），4赎回完成，5赎回审核中（可取消赎回），6：转投中(之前不管)，7：转投完成，10出资失败，11:（等待充值到账），   31-申请取消（后台业务人员取消客户出资申请）
 */

@property (nonatomic, copy) NSString *investStatus;

/**
 是否可赎回 1:不可赎回2：可赎回
 */
@property (nonatomic, copy) NSString *isrede;

/**
 累计收益
 */
@property (nonatomic, copy) NSString *interest;
/**
 累计收益(新)
 */
@property (nonatomic, copy) NSString *expectedBenefitAmount;

/**
 线上线下标识 线上1，线下2
 */
@property (nonatomic, copy) NSString *source;

/**
 赎回金额
 */
@property (nonatomic, copy) NSString *ransomAmount;

/**
 申请日期
 */
@property (nonatomic, copy) NSString *applyDate;

/**
 产品类型 1：连盈：2月盈 4：灵活留
 */
@property (nonatomic, copy) NSString *proType;

/**
 退出时间
 */
@property (nonatomic, copy) NSString *exitDate;

/**
 剩余天数
 */
@property (nonatomic, copy) NSString *remainDays;

/**
 来源。APS、FPS、NCP(新资金系统)
 */
@property (nonatomic, copy) NSString *investSource;

/**
 Html出借协议URL
 */
@property (nonatomic, copy) NSString *agreementHtmlUrl;


@property (nonatomic, copy) NSArray <NSDictionary *>*agreementList;


@property (nonatomic, copy) NSArray <CRFAgreementDto *>*protocols;

/**
 * 是否可灵活转投 1-不可，2-可以
 */
@property (nonatomic, copy) NSString *isAbleFlexibleForward;

/**
 * 是否可灵活赎回 1-不可，2-可以
 */
@property (nonatomic, copy) NSString *isAbleFlexibleredeem;

/**
 转投类型 1-预约转投。 2-自动转投
 */
@property (nonatomic, copy) NSString *forwardType;

/**
 赎回类型 1-提前赎回。2-灵活赎回
 */
@property (nonatomic, copy) NSString *redeemType;

- (NSString *)applyTime;

- (NSString *)frezzTime;

- (NSString *)capital;

- (NSString *)currentAssert;
- (NSString *)currentRangeOfRate;

- (NSString *)expireTime;

- (NSString *)getAssert;

- (NSString *)getProfit;

- (NSString *)getYearMoney;

- (NSString *)getDay;

- (NSString *)formatYearRate;
- (NSString *)formatCloseDays;
- (NSString *)formatRangeOfRate;

/**
 获取计息天数

 @return days
 */
- (NSInteger)getBearingDays;


@end
