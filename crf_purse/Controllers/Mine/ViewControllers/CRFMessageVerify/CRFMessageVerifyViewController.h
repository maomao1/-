//
//  CRFMessageVerifyViewController.h
//  crf_purse
//
//  Created by maomao on 2018/6/15.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
typedef NS_ENUM(NSUInteger, SuccessType) {
    SuccessDefault       = 0,
    OpenResult           = 1,
    RelateResult         = 2,
    CloseResult          = 3,
};
@interface CRFMessageVerifyViewController : CRFBasicViewController
@property (nonatomic , assign) SuccessType  ResultType;

@end
