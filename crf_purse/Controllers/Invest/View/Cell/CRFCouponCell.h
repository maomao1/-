//
//  CRFCouponCell.h
//  crf_purse
//
//  Created by maomao on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CRFCouponCell_Id = @"CRFCouponCell_Identifier";
@interface CRFCouponCell : UICollectionViewCell

@property (nonatomic, assign, readonly) BOOL couponSelected;
@property (nonatomic, strong) CRFCouponModel *coupon;

@property (nonatomic, copy) void (^(couponDidSelectedHandler))(CRFCouponCell *cell);


- (void)resetUI;

- (void)selected;


@end
