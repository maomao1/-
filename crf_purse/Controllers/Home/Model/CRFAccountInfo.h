//
//  CRFAccountInfo.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/24.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFAccountInfo : NSObject

/**
 投资本经
 */
@property (nonatomic, copy) NSString *accountAmount;

/**
 可用余额
 */
@property (nonatomic, copy) NSString *availableBalance;

/**
 投资本金
 */
@property (nonatomic, copy) NSString *capital;

/**
 冻结余额
 */
@property (nonatomic, copy) NSString *freezeBalance;

/**
 投资收益
 */
@property (nonatomic, copy) NSString *profits;

@end
