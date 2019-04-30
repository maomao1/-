//
//  UIImage+Color.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageNameWithOriginMode:(NSString *)imageName;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)bgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame;

+ (UIImage *)imageWithGIFNamed:(NSString *)name;


+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (UIImage *)imageWithUIView:(UIView *)view;

- (UIColor *)getPixelColorAtLocation:(CGPoint)point;

+ (UIImage *)gradientImage:(NSArray <UIColor *>*)colors location:(CGRect)frame;
@end
