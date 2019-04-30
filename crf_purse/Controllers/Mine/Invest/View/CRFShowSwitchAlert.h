//
//  CRFShowSwitchAlert.h
//  crf_purse
//
//  Created by maomao on 2018/6/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"
typedef void (^dismissBlock)();
typedef void (^confirmHandler)();
@interface CRFShowSwitchAlert : CRFBasicView
@property (nonatomic ,copy) dismissBlock dismiss;
@property (nonatomic ,copy) confirmHandler  confirmHandler;
-(instancetype)initWithFrame:(CGRect)frame AlertTitle:(NSString *)title content:(NSString*)content dismissHandler:(dismissBlock)dismiss confirmHandler:(confirmHandler)confirmHandler;
//-(instancetype)showAlertTitle:(NSString *)title content:(NSString*)content dismissHandler:(dismissBlock)dismiss confirmHandler:(confirmHandler)confirmHandler frame:(CGRect)frame;
- (void)showInView:(UIView*)view;
-(void)changeButtonTitle:(NSString*)btnTitle Content:(NSString*)content;
@end
