//
//  CRFInvestBill.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestBill.h"

@implementation CRFInvestBill

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"investCapital":@"newCapital"
             };
}

- (NSString *)endAmount {
    if (!_endAmount) {
        _endAmount = @"0.00";
    }
    return [_endAmount formatMoney];
}

- (NSString *)investAmount {
    if (!_investAmount) {
        _investAmount = @"0.00";
    }
    return [_investAmount formatMoney];
}

- (NSString *)startDebtAmount {
    if (!_startDebtAmount) {
        _startDebtAmount = @"0.00";
    }
    return [_startDebtAmount formatMoney];
}

- (NSString *)debtProfit {
    if (!_debtProfit) {
        _debtProfit = @"0.00";
    }
    return [_debtProfit formatMoney];
}

- (NSString *)redeemCapital {
    if (!_redeemCapital) {
        _redeemCapital = @"0.00";
    }
    return [_redeemCapital formatMoney];
}

- (NSString *)investCapital {
    if (!_investCapital) {
        _investCapital = @"0.00";
    }
    return [_investCapital formatMoney];
}

- (NSString *)endingProfitSum {
    if (!_endingProfitSum) {
        _endingProfitSum = @"0.00";
    }
    return [_endingProfitSum formatMoney];
}

- (NSString *)investProfit {
    if (!_investProfit) {
        _investProfit = @"0.00";
    }
    return [_investProfit formatMoney];
}

- (NSString *)interest {
    if (!_interest) {
        _interest = @"0.00";
    }
    return _interest;
}

@end
