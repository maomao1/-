//
//  CRFCouponVC.h
//  crf_purse
//
//  Created by maomao on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFCouponVC : CRFBasicViewController

@property (nonatomic, strong) NSArray <CRFCouponModel *>*coupons;

@property (nonatomic, copy) void (^(couponDidSelectedHandler))(CRFCouponModel *coupon);

@property (nonatomic, strong) CRFCouponModel *selectedCoupon;

@property (nonatomic, copy) NSString *investAmount;

@property (nonatomic, copy) NSString *planNo;

@end
