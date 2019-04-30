//
//  CRFViewUtils.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFViewUtils.h"

@implementation CRFViewUtils

+ (UIButton *)buttonWithFont:(UIFont *)font
                 norTitleColor:(UIColor *)norTitleColor
                        norImg:(NSString *)norImg
                titleEdgeInset:(UIEdgeInsets)titleEdgeInset
                 imgEdgeInsets:(UIEdgeInsets)imgEdgeInsets {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitleColor:norTitleColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    btn.titleEdgeInsets = titleEdgeInset;
    btn.imageEdgeInsets = imgEdgeInsets;
    return btn;
}

+ (UIButton *)buttonWithFont:(UIFont *)font norTitleColor:(UIColor *)norTitleColor selTitleColor:(UIColor *)selTitleColor norImg:(NSString *)norImg selImg:(NSString *)selImg titleEdgeInset:(UIEdgeInsets)titleEdgeInset imgEdgeInsets:(UIEdgeInsets)imgEdgeInsets {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitleColor:norTitleColor forState:UIControlStateNormal];
    [btn setTitleColor:selTitleColor forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    if (norImg||btn.selected) {
        btn.titleEdgeInsets = titleEdgeInset;
    }
    btn.titleEdgeInsets = titleEdgeInset;
    btn.imageEdgeInsets = imgEdgeInsets;
    return btn;
}


@end
