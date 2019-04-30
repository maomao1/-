//
//  CRFSelTargetViewController.h
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFSelTargetViewController : CRFBasicViewController

/**
 转投金额
 */
@property (nonatomic, copy) NSString *investment;

/**
 选中的转投产品
 */
@property (nonatomic, copy) void (^(didSelectedProduct))(CRFProductModel *product);

@end
