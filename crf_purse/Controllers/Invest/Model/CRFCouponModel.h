//
//  CRFCouponModel.h
//  crf_purse
//
//  Created by maomao on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CRFCouponRule;
@interface CRFCouponModel : NSObject

@property (nonatomic, copy) NSString *giftDetailId;     ///< 奖品记录编号
@property (nonatomic, copy) NSString *giftName;         ///< 奖品名称
@property (nonatomic, copy) NSString *giftRuleDesc;     ///< 使用规则
@property (nonatomic, copy) NSString *giftType;         ///< 奖品类型,1:现金红包，2：返现券，3，加息券
@property (nonatomic, copy) NSString *giftValue;        ///< 奖品值
@property (nonatomic, copy) NSString *invalidTime;      ///< 失效时间（long类型）
@property (nonatomic, copy) NSString *lendAmount;       ///< 出借本金
@property (nonatomic, copy) NSString *payDate;          ///< 支付时间
@property (nonatomic, copy) NSString *planName;         ///< 出资计划
@property (nonatomic, copy) NSString *status;           ///< 使用状态(1:未使用,2:已使用,3:已失效)
@property (nonatomic, copy) NSString *useInfo;          ///< 获奖须知
@property (nonatomic, copy) NSString *useTime;          ///< 使用时间
@property (nonatomic, copy) NSString *winningNotice;    ///< 获奖须知
@property (nonatomic, copy) NSString *createTime;       ///< 有效时间
@property (nonatomic, copy) NSString *couponIsUse;      ///< 优惠券是否可用1：可用,2：不可用

@property (nonatomic, copy) NSString *maxAmount;        ///< 奖励上限
@property (nonatomic, copy) NSString *useRuleItem;      ///< 优惠券使用条件
@property (nonatomic, copy) NSString *awardAmount;      ///< 获奖金额
@property (nonatomic, copy) NSString *channelName;      ///< 渠道来源
@end
//优惠券使用规则
@interface CRFCouponRule : NSObject
@property (nonatomic ,copy) NSString  * lowerLimitAmount;
@property (nonatomic ,copy) NSString  * days;
@property (nonatomic ,copy) NSString  * couponAmount;
@property (nonatomic ,copy) NSString  * upperLimitDays;
@end
