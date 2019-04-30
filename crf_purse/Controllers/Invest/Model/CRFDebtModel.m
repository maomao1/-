//
//  CRFDebtModel.m
//  crf_purse
//
//  Created by maomao on 2018/9/21.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDebtModel.h"
#import "NSString+CRF.h"
@implementation CRFDebtModel
-(NSString *)downRateRange{
    if (!_downRateRange) {
        _downRateRange = @"0.00";
    }
    return _downRateRange;
}
-(NSString *)upRateRange{
    if (!_upRateRange) {
        _upRateRange = @"0.00";
    }
    return _upRateRange;
}
-(NSString *)transferAmount{
    if (!_transferAmount) {
        _transferAmount = @"0.00";
    }
    return _transferAmount;
}
-(NSString *)transferStatus{
    if (!_transferStatus) {
        _transferStatus = @"10";
    }
    return _transferStatus;
}
-(NSString*)dealTransAmount{
    NSString * amount = [NSString stringWithFormat:@"%.2f",_transferAmount.floatValue/100];
    return [amount formatMoney];
}
-(NSString *)formatRate{
    return [NSString stringWithFormat:@"%.2f~%.2f",self.downRateRange.floatValue*100,self.upRateRange.floatValue*100];
}
@end
