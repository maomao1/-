//
//  CRFAccountInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/24.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAccountInfo.h"

@implementation CRFAccountInfo

- (NSString *)accountAmount {
    if (!_accountAmount) {
        _accountAmount = @"0.00";
    }
    return [_accountAmount formatMoney];
}

- (NSString *)availableBalance {
    if (!_availableBalance) {
        _availableBalance = @"0.00";
    }
    return [_availableBalance formatMoney];
}

- (NSString *)capital {
    if (!_capital) {
        _capital = @"0.00";
    }
    return [_capital formatMoney];
}

- (NSString *)freezeBalance {
    if (!_freezeBalance) {
        _freezeBalance = @"0.00";
    }
    return [_freezeBalance formatMoney];
}

- (NSString *)profits {
    if (!_profits) {
        _profits = @"0.00";
    }
    return [_profits formatMoney];
}


@end
