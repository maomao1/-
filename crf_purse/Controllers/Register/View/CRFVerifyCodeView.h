//
//  CRFVerifyCodeView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ButtonType) {
    Border_Have        = 0,
    Border_None          = 1,
};
@interface CRFVerifyCodeView : UIView
@property (nonatomic ,assign) ButtonType buttonType;
@property (nonatomic, copy) void (^(callback))(void);

@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) void (^(timeoutHandle))(void);

- (void)resetTitle:(NSString *)title;

- (void)initialTitle:(NSString *)title;

- (void)sendingTitle:(NSString *)title;

- (void)startSendVerify;

- (void)stopSendVerify;

//- (void)borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

//- (void)cornerRadius:(CGFloat)radius;

- (void)titleNormalColor:(UIColor *)normalColor disableColor:(UIColor *)disableColor;

//- (void)backgroundColor:(UIColor *)backgroundColor;

- (void)titleFont:(UIFont *)font;


@end
