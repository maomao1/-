//
//  CRFProductDetailViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2018/2/6.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFStaticWebViewViewController.h"

typedef NS_ENUM(NSInteger, CRFProductStyle) {
    CRFProductStyleNormal                   = 0,
    CRFProductStyleAppointmentForward       = 1,
    CRFProductStyleExclusive                = 2,
    CRFProductStyleAutoInvest               = 3,
};

@interface CRFProductDetailViewController : CRFStaticWebViewViewController

/**
 详情类型
 */
@property (nonatomic, assign) CRFProductStyle productStyle;

/**
 专属定制的金额
 */
@property  (nonatomic, copy) NSString *exclusiveAmount;

/**
 产品编号
 */
@property (nonatomic, strong) NSString *productNo;

/**
 转投所需要的参数（key:investDeadLine(出借期限 <长中短>),investWay(转投类型<本金or本息>),sourceInvestNo(原出资编号),investAmount(转投金额),closeDate(原出资的结束时间),productType(产品类型), planNo）
 */
@property (nonatomic, strong) NSDictionary *appointmentForwardParams;

@end
