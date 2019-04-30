//
//  CRFRechargeContainerViewController.h
//  crf_purse
//
//  Created by maomao on 2018/8/14.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFSegmentHead.h"
typedef NS_ENUM(NSUInteger, PopReChargeType) {
    PopDefault_recharge              =   0,
    PopFrom_recharge                 =   1,
};
@interface CRFRechargeContainerViewController : CRFBasicViewController
@property (nonatomic, assign) PopReChargeType popType;
@property (nonatomic, copy) NSString *bankInfo;
@end
