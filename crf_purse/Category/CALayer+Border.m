//
//  CALayer+Border.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CALayer+Border.h"

@implementation CALayer (Border)

- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
