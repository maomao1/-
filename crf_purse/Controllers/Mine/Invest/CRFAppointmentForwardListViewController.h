//
//  CRFAppointmentForwardListViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/23.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFProductDetail.h"

@interface CRFAppointmentForwardListViewController : CRFBasicViewController

/**
 产品详情
 */
@property (nonatomic, strong) CRFProductDetail *productInfo;

/**
 转投方式
 */
@property (nonatomic, assign) NSInteger appointmentStyle;

/**
 出借期限
 */
@property (nonatomic, assign) NSInteger appointmentTimeItem;

/**
 结算方式
 */
@property (nonatomic, assign) NSInteger appointmentEndItem;

/**
 转投金额
 */
@property (nonatomic, assign) NSString *investAmount;

@property (nonatomic, assign) CRFForwardProductType forwardType;

/**
 原计划编号
 */
@property (nonatomic, copy) NSString *planNo;

@end
