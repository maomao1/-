//
//  CRFOperateView.h
//  crf_purse
//
//  Created by maomao on 2017/8/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//


#import "CRFProductModel.h"
#import "CRFCouponModel.h"
#import "CRFBasicView.h"
#import "CRFPopViewDelegate.h"

@interface CRFOperateView : CRFBasicView
@property (nonatomic ,strong) CRFProductModel *productItem;
@property (nonatomic ,assign) NSInteger  couponsCount;
@property (nonatomic ,copy)   NSString         *investAmount;
@property (nonatomic ,strong) NSArray  * protocolArray;
@property (nonatomic ,assign) BOOL             isAgree;
@property (nonatomic ,assign) BOOL             isShow;///<当前view是否正在显示
@property (nonatomic ,weak) id<CRFPopViewDelegate> crf_delegate;

@property (nonatomic ,assign) NSInteger    RowHeight;


- (void)dismiss;

- (void)showInView:(UIView *)view;
/**
 设置选中优惠券
 @param couponName 优惠券名字
 */
- (void)selectedCoupon:(NSString *)couponName;

@end
