//
//  CRFProductDetail.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFAgreementDto.h"

@interface CRFProductDetail : NSObject

@property (nonatomic, copy) NSString *expectedBenefitAmount;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic, copy) NSString *closeDate;
@property (nonatomic, copy) NSString *exitDate;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *interestStartDate;
@property (nonatomic, copy) NSString *investAmount;
@property (nonatomic, copy) NSString *investId;
@property (nonatomic, copy) NSString *investNo;
@property (nonatomic, copy) NSString *investStatus;//当笔出资状态（1:待处理，2计息中，3赎回中（可取消赎回），4赎回完成，5赎回审核中（不可取消赎回），6：转投中，7：转投完成，10出资失败，11:等待充值到账,31-申请取消（后台业务人员取消客户出资申请）
@property (nonatomic, copy) NSString *isrede;
@property (nonatomic, copy) NSString *proType;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *ransomAmount;
@property (nonatomic, copy) NSString *redeAmount;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *yearrate;

@property (nonatomic, copy) NSString *planNo;
@property (nonatomic, copy) NSString *isCancelZdxt;//1-未取消自动续投，2-已取消自动续投,3-不显示自动续投
//新增最高最低收益率字段
@property (nonatomic ,copy) NSString      *minYield;
@property (nonatomic ,copy) NSString      *maxYield;
/**
 Html出借协议URL
 */
@property (nonatomic, copy) NSString *agreementHtmlUrl;


@property (nonatomic, copy) NSArray <NSDictionary *>*agreementList;


@property (nonatomic, copy) NSArray <CRFAgreementDto *>*protocols;

/**
 1:不可转投；2:可转投
 */
@property (nonatomic, assign) NSInteger isAbleForward;

/**
 1:未预约；2:已预约
 */
@property (nonatomic, assign) NSInteger isApplyForward;

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


- (NSDictionary *)getDict;

- (NSString *)formatRangeOfExpectYearRate;
@end
