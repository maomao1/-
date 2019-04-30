//
//  CRFColorButton.m
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  渐变方向
 *  暂时没有用到***
 */
typedef NS_ENUM(NSInteger, CRFGradientDirection){
    /**
     *  水平方向
     */
    CRFGradientDirectionHor,
    /**
     *  垂直方向
     */
    CRFGradientDirectionVer
};

@interface CRFGradientColor : NSObject

/**
 *  Array of UIColor
 */
@property (nonatomic, strong, readonly) NSArray *colors;

/**
 *  初始化渐变色对象
 *
 *  @param colors 颜色数组，从上到下的顺序
 *
 *  @return 渐变色对象
 */
+ (instancetype)gradientColorWithColors:(NSArray *)colors;

@end

@interface CRFColorButton : UIButton

/**
 *  边框宽, 默认0，无边框
 */
@property (nonatomic, assign) CGFloat borderWidth;
/**
 *  边框颜色，默认nil，无颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  圆角，默认UIRectCornerAllCorners
 */
@property (nonatomic, assign) UIRectCorner corner;
/**
 *  圆角半径，默认0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;

- (void)setGradientColor:(CRFGradientColor *)gradientColor forState:(UIControlState)state;
- (CRFGradientColor *)gradientColorForState:(UIControlState)state;

@end
