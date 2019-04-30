//
//  CRFQueryRedeemInfo.h
//  crf_purse
//
//  Created by xu_cheng on 2018/2/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFQueryRedeemInfo : NSObject

/**
 总资产
 */
@property(nonatomic, copy) NSString *totalAssets;

/**
 实际到账金额
 */
@property(nonatomic, copy) NSString *actualAmount;

/**
 当前时间（时间戳）
 */
@property(nonatomic, copy) NSString *deadLine;

/**
 手续费
 */
@property(nonatomic, copy) NSString *serviceCharge;

@end
