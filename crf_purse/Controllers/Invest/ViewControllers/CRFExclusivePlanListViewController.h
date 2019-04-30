//
//  CRFExclusivePlanListViewController.h
//  crf_purse
//
//  Created by maomao on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFExclusivePlanListViewController : CRFBasicViewController
@property  (nonatomic, copy) NSString *exclusiveAmount;
@property  (nonatomic, assign) NSInteger investDeadLine;///<1短 2中 3长
@property  (nonatomic, assign) NSInteger destProType;///< 1连盈 2月盈

@end
