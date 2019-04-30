//
//  CRFRedeemAccount.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/23.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRedeemAccount.h"

@implementation CRFRedeemAccount

- (NSString *)totalProfit {
    if (!_totalProfit) {
        _totalProfit = @"";
    }
    return [_totalProfit formatProfitMoney];
}

- (NSString *)totalCapital {
    if (!_totalCapital) {
        _totalCapital = @"";
    }
    return [_totalCapital formatProfitMoney];
}

@end
