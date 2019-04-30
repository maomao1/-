//
//  CRFRechargeViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
//typedef NS_ENUM(NSUInteger, PopReChargeType) {
//    PopDefault_recharge              =   0,
//    PopFrom_recharge                 =   1,
//};
typedef NS_ENUM(NSUInteger ,RechargeType){
    Default_recharge    = 0,
    Quick_recharge      = 1,
};
@interface CRFRechargeViewController : CRFBasicViewController

@property (nonatomic, copy) NSString *bankInfo;
//@property (nonatomic, assign) PopReChargeType popType;
@property (nonatomic, assign) RechargeType    rechargeType;
-(void)showQuickRechargeView;
@end
