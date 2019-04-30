//
//  CRFRewardViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFStaticWebViewViewController.h"

@interface CRFRewardViewController : CRFStaticWebViewViewController


@property (nonatomic, copy) void (^(reloadCouponDatas))(void);

@end
