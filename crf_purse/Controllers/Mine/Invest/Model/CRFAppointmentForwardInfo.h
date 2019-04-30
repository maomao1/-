//
//  CRFAppointmentForwardInfo.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/29.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFAppointmentForwardInfo : NSObject

/*
 closeTime (string, optional): 计划到期日期 ,
 destPlanNo (string, optional): 目标产品编号 ,
 giftName (string, optional): 优惠券名称 ,
 investWay (string, optional): 转投方式，1：本金；2：本息 ,
 productName (string, optional): 目标产品名称 ,
 sourceInvestNo (string, optional): 原出资编号 ,
 startInvestTime (string, optional): 开始投资日期 ,
 status (string, optional): 处理状态 : [1 已预约 ,2已激活3，已完成，4已取消,5,失败 ,
 yInterestRate (number, optional): 期望年化收益率
 */
@property (nonatomic, copy) NSString *productType;
@property (nonatomic, copy) NSString *closeTime;
@property (nonatomic, copy) NSString *destPlanNo;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, copy) NSString *investWay;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *sourceInvestNo;
@property (nonatomic, copy) NSString *startInvestTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *yInterestRate;
//新增最高最低收益率字段
@property (nonatomic ,copy) NSString      *minYield;
@property (nonatomic ,copy) NSString      *maxYield;
-(NSString *)rangeOfYInterstRate;
@end
