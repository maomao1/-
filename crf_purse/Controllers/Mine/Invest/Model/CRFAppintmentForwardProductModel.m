//
//  CRFAppintmentForwardProductModel.m
//  crf_purse
//
//  Created by xu_cheng on 2018/4/3.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppintmentForwardProductModel.h"

@implementation CRFAppintmentForwardProductModel
-(NSString *)maxYield{
    if (!_maxYield) {
        _maxYield = @"0.00";
    }
    return _maxYield;
}
-(NSString *)minYield{
    if (!_minYield) {
        _minYield = @"0.00";
    }
    return _minYield;
}
- (NSString *)formatYInterestRate {
    return [NSString stringWithFormat:@"%.2f~%.2f%%",self.minYield.doubleValue,self.maxYield.doubleValue];
}



@end
