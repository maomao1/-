//
//  CRFInvestUserViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFCreditor.h"

@interface CRFInvestUserViewController : CRFBasicViewController

@property (nonatomic, strong) CRFCreditor *creditor;
@property (nonatomic, assign) NSInteger source;

@end
