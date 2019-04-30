//
//  CRFExclusivePopView.h
//  crf_purse
//
//  Created by maomao on 2018/3/23.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"
#import "CRFPopViewDelegate.h"
@interface CRFExclusivePopView : CRFBasicView
@property (nonatomic ,strong) CRFProductModel *productItem;
@property (nonatomic ,strong) NSString  *exclusiveAmount;
@property (nonatomic ,assign) NSInteger couponsCount;
@property (nonatomic ,strong) NSArray *protocolArray;
@property (nonatomic ,assign) BOOL isAgree;
@property (nonatomic ,assign) BOOL isShow;
@property (nonatomic ,weak) id <CRFPopViewDelegate> popViewDelegate;
@property (nonatomic ,assign) NSInteger rowHeight;


- (void)dismiss;

- (void)showInView:(UIView *)view;
/**
 设置选中优惠券
 @param couponName 优惠券名字
 */
- (void)selectedCoupon:(NSString *)couponName;
@end
