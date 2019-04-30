//
//  CRFAppointmentForwardViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFProductDetail.h"

@interface CRFAppointmentForwardViewController : CRFBasicViewController

@property (nonatomic, strong) CRFProductDetail *productDetail;


@property (nonatomic, strong) CRFMyInvestProduct *product;

@property (nonatomic, assign) CRFForwardProductType forwardType;

/**
 本息
 */
@property (nonatomic, copy) NSString *interestAmount;

/**
 本金
 */
@property (nonatomic, copy) NSString *principalAmount;

@end
