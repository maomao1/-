//
//  CRFEvaluationView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@interface CRFEvaluationView : CRFBasicView

@property (nonatomic, copy) void (^ (clickHandler))(NSInteger index);

- (void)show;

@end
