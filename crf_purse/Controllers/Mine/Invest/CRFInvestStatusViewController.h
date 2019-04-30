//
//  CRFInvestStatusViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFInvestStatusViewController : CRFBasicViewController


/**
 类型： 0-> 未计息 (3 出借中)；1-> 计息中（4 退出中）；2 -> 已结束
 */
@property (nonatomic, assign) NSUInteger type;

/**
 产品model
 */
@property (nonatomic, strong) CRFMyInvestProduct *product;

/**
 刷新产品详情
 */
@property (nonatomic, copy) void (^(refreshProductInfo))(void);


@end
