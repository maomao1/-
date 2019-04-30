//
//  CRFQueryRedeemInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2018/2/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFQueryRedeemInfo.h"
#import "CRFTimeUtil.h"

@implementation CRFQueryRedeemInfo

- (NSString *)deadLine {
    if (!_deadLine) {
        _deadLine = @"0";
    }
    return [CRFTimeUtil formatLongTime:_deadLine.longLongValue pattern:@"yyyy-MM-dd"];
}

- (NSString *)totalAssets {
    if (!_totalAssets) {
        _totalAssets = @"";
    }
    return [_totalAssets formatBeginMoney];
}

- (NSString *)actualAmount {
    if (!_actualAmount) {
        _actualAmount = @"";
    }
    return [_actualAmount formatBeginMoney];
}

- (NSString *)serviceCharge {
    if (!_serviceCharge) {
        _serviceCharge = @"";
    }
    return [NSString stringWithFormat:@"%@%%",_serviceCharge];
}

@end
