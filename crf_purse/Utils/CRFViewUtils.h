//
//  CRFViewUtils.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFViewUtils : NSObject

//button
+ (UIButton *)buttonWithFont:(UIFont *)font
                 norTitleColor:(UIColor *)norTitleColor
                        norImg:(NSString *)norImg
                titleEdgeInset:(UIEdgeInsets)titleEdgeInset
                 imgEdgeInsets:(UIEdgeInsets)imgEdgeInsets;

+ (UIButton *)buttonWithFont:(UIFont *)font
                 norTitleColor:(UIColor *)norTitleColor
                 selTitleColor:(UIColor *)selTitleColor
                        norImg:(NSString*)norImg
                        selImg:(NSString *)selImg
                titleEdgeInset:(UIEdgeInsets)titleEdgeInset
                 imgEdgeInsets:(UIEdgeInsets)imgEdgeInsets;

@end
