//
//  CRFMyInvestViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFMyInvestViewController : CRFBasicViewController

/**
 默认选中的标签（0，1，2 ）-> (未计息、计息中、已结束)
 未计息、计息中修改为 出借中 退出中（3，4）
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 刷新列表
 */
@property (nonatomic, copy) void (^(refreshProduct))(void);

@end
