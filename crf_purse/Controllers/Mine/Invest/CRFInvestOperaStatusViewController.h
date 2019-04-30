//
//  CRFInvestOperaStatusViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

/**
 成功反馈页面

 - Opera_Logout: 退出成功
 - Opera_Transform: 转投成功
 */
typedef NS_ENUM(NSUInteger, OperaStatus) {
    Opera_Logout            = 0,
    Opera_Transform         = 1,
};

@interface CRFInvestOperaStatusViewController : CRFBasicViewController

/**
 反馈类型
 */
@property (nonatomic, assign) OperaStatus operaStatus;

/**
 成功后的产品model
 */
@property (nonatomic, strong) CRFMyInvestProduct *product;

@end
