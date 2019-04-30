//
//  CRFAppointmentForwardInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/29.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardInfo.h"
#import "CRFTimeUtil.h"

@implementation CRFAppointmentForwardInfo

- (NSString *)yInterestRate {
    if (!_yInterestRate) {
        _yInterestRate = @"0";
    }
    return [NSString stringWithFormat:@"%.2f%%",_yInterestRate.floatValue * 100];
}

- (NSString *)startInvestTime {
    if (!_startInvestTime) {
        _startInvestTime = [CRFTimeUtil getCurrentTimeStamp];
    }
    return [CRFTimeUtil formatLongTime:_startInvestTime.longLongValue pattern:@"yyyy-MM-dd"];
}

- (NSString *)closeTime {
    if (!_closeTime) {
        _closeTime = [CRFTimeUtil getCurrentTimeStamp];
    }
    return [CRFTimeUtil formatLongTime:_closeTime.longLongValue pattern:@"yyyy-MM-dd"];
}

- (NSString *)investWay {
    if (_investWay.integerValue == 1) {
        return @"本金转投";
    }
    return @"本息转投";
}

-(NSString * )minYield{
    if (!_minYield) {
        _minYield = @"0.00";
    }
    return _minYield;
}
-(NSString *)maxYield{
    if (!_maxYield) {
        _maxYield = @"0.00";
    }
    return _maxYield;
}
/**
 
 */
-(NSString *)rangeOfYInterstRate{
    return [NSString stringWithFormat:@"%.2f~%.2f%%",self.minYield.doubleValue*100,self.maxYield.doubleValue*100];
}
- (NSString *)giftName {
    if (!_giftName) {
        _giftName = @"";
    }
    return _giftName;
}

@end
