//
//  CRFPopViewDelegate.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/20.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRFPopViewDelegate <NSObject>

@optional

/**
 预览出资协议
 
 @param urlString url
 */
- (void)reviewProtocol:(NSString *)urlString;

/**
 选择优惠券
 */
- (void)gotoCouponsViewController;

/**
 金额发生改变
 
 @param changedAmount 改变后的金额
 */
- (void)amountValueDidChanged:(NSString *)changedAmount;

/**
 自动选择优惠券
 
 @param investAmount 金额
 */
- (void)autoSelectedCoupon:(NSString *)investAmount;

/**
 取消
 */
- (void)cancel;

@end
