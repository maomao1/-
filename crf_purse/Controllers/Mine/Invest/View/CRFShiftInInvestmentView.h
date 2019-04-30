//
//  CRFShiftInInvestmentView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRFShiftInInvestmentViewDelegate;

@interface CRFShiftInInvestmentView : UIView

/**
 delegate
 */
@property (nonatomic, weak) id <CRFShiftInInvestmentViewDelegate> investmentDelegate;

/**
 选中的转投产品
 */
@property (nonatomic, strong) CRFProductModel *selctedProduct;

/**
 选中的优惠券
 */
@property (nonatomic, strong) CRFCouponModel *selectedCoupon;

/**
 转投金额
 */
@property (nonatomic, copy) NSString *accountAmount;

/**
 验证码
 */
@property (nonatomic, copy) NSString *verifyCode;

/**
 添加view

 @param view view
 */
- (void)addInView:(UIView *)view;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end


@protocol CRFShiftInInvestmentViewDelegate <NSObject>

@optional

/**
 转投
 */
- (void)shiftInInvestment;

/**
 选择优惠券
 */
- (void)selectedCoupon;

/**
 选择转投产品
 */
- (void)chooseProduct;

/**
 打开协议链接

 @param urlString urlString
 */
- (void)openProtocolUrl:(NSString *)urlString;

/**
 关闭弹窗
 */
- (void)closeView;

/**
 更新约束
 */
- (void)updateViewLayoutWithAnimationDuration:(CGFloat)duration;

@end
