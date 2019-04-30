//
//  CRFRechargeFooterView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/17.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@interface CRFRechargeRollOutFooterView : CRFBasicView

@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) void (^(operaHandler))(BOOL enable);

- (instancetype)initWithFrame:(CGRect)frame actionTitle:(NSString *)title;

- (void)setContent:(NSString *)content;

@end

