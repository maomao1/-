//
//  CRFReceiveCashModel.m
//  crf_purse
//
//  Created by maomao on 2019/4/25.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import "CRFReceiveCashModel.h"
@implementation CRFReceiveCashDetail
-(NSString *)cashAmount{
    if (!_cashAmount) {
        _cashAmount = @"0.00";
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",_cashAmount.floatValue/100];
    return [str formatMoney];
}
@end
@implementation CRFReceiveCashModel
-(NSString *)receivedcash{
    if (!_receivedcash) {
        _receivedcash = @"0.00";
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",_receivedcash.floatValue/100];
    return [str formatMoney];
}
-(NSString *)uncollectedcash{
    if (!_uncollectedcash) {
        _uncollectedcash = @"0.00";
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",_uncollectedcash.floatValue/100];
    return [str formatMoney];
}

@end
