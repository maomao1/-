//
//  CRFEvaluatingViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFStaticWebViewViewController.h"

@interface CRFEvaluatingViewController : CRFStaticWebViewViewController

@property (nonatomic, copy) void (^(backHandler))(void);

@end
