//
//  UIButton+Color.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "UIButton+Color.h"
#import "UIImage+Color.h"

@implementation UIButton (Color)

- (void)setHighlightedImageColor:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateHighlighted];
}

- (void)setEnabledImageColor:(UIColor *)color {
     [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateDisabled];
}

- (void)setNormalImageColor:(UIColor *)color {
     [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
}


@end
