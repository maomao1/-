//
//  CRFRollOutViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFRollOutViewController : CRFBasicViewController

/**
 银行卡信息
 */
@property (nonatomic, copy) NSString *bankInfo;

/**
 可用余额
 */
@property (nonatomic, copy) NSString *avaibleMoney;

@end
