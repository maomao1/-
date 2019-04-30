//
//  CRFAppointmentForwardPopView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/20.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"
#import "CRFPopViewDelegate.h"

@interface CRFAppointmentForwardPopView : CRFBasicView

@property (nonatomic, assign) CRFForwardProductType forwardType;

@property (nonatomic ,strong) CRFProductModel *productItem;
@property (nonatomic ,assign) NSInteger couponsCount;
@property (nonatomic ,strong) NSArray *protocolArray;
@property (nonatomic ,assign) BOOL isAgree;
@property (nonatomic ,weak) id <CRFPopViewDelegate> popViewDelegate;
@property (nonatomic ,assign) NSInteger rowHeight;

@property (nonatomic, assign) NSInteger item;

@property (nonatomic, copy) NSString *investAmount;


- (void)dismiss;

- (void)showInView:(UIView *)view;
/**
 设置选中优惠券
 @param couponName 优惠券名字
 */
- (void)selectedCoupon:(NSString *)couponName;



@end
