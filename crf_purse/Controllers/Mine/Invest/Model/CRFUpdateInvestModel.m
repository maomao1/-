//
//  CRFUpdateInvestModel.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUpdateInvestModel.h"

@implementation CRFUpdateInvestModel

- (NSString *)debtMakeDate {
    if (!_debtMakeDate) {
        _debtMakeDate = @"";
    }
    return _debtMakeDate;
}

- (NSString *)debtAmount {
    if (!_debtAmount) {
        _debtAmount = @"";
    }
    return [_debtAmount formatMoney];
}

- (NSString *)idleAmount {
    if (!_idleAmount) {
    _idleAmount = @"";
    }
    return [_idleAmount formatMoney];
}

@end
