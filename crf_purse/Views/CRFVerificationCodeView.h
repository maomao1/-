//
//  CRFVerificationCodeView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE

@interface CRFVerificationCodeView : UIView


/**
 定时器初始文案
 */
@property (nonatomic, copy) IBInspectable NSString *initializeText;

/**
 重新发送验证码文案
 */
@property (nonatomic, copy)  IBInspectable NSString *againInitializeText;

/**
 字体大小
 */
@property (nonatomic, strong) IBInspectable UIFont *textFont;

/**
 定时器运行时文案
 */
@property (nonatomic, copy) IBInspectable NSString *sendingText;

/**
 开始发送验证码
 */
@property (nonatomic, copy) void (^(beginSendCode))(void);

/**
 按钮不可用时，文字颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *disableColor;

/**
 按钮可用时，文字颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *normalColor;

/**
 按钮不可用时，边框颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *disableBorderColor;

/**
 按钮可用时，边框颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *normalBorderColor;

/**
 按钮边框宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 按钮圆角大小
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 按钮位置
 */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

/**
 按钮是否可用
 */
@property (nonatomic, assign) BOOL enable;

/**
 定时器开始运行
 */
- (void)timerStart;

/**
 重置定时器
 */
- (void)resetTimer;

/**
 销毁定时器
 */
- (void)destory;

@end
