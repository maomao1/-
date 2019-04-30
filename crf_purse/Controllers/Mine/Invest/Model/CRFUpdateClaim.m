//
//  CRFUpdateClaim.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUpdateClaim.h"
@implementation CRFInvestInfo

- (NSString *)investAmount {
    if (!_investAmount) {
        _investAmount = @"0.00";
    }
    return _investAmount;
}

- (NSString *)intentionAvailableAmount {
    if (!_intentionAvailableAmount) {
        _intentionAvailableAmount = @"0.00";
    }
    return _intentionAvailableAmount;
}

- (NSString *)cycleAvailableAmount {
    if (!_cycleAvailableAmount) {
        _cycleAvailableAmount = @"0.00";
    }
    return _cycleAvailableAmount;
}

- (NSString *)actualPrincipalBalance {
    if (!_actualPrincipalBalance) {
        _actualPrincipalBalance = @"0.00";
    }
    return _cycleAvailableAmount;
}

- (NSString *)lendedAmount {
    if (!_lendedAmount) {
        _lendedAmount = @"0.00";
    }
    return _lendedAmount;
}

- (NSString *)loanAmount {
    if (!_loanAmount) {
        _loanAmount = @"0.00";
    }
    return _loanAmount;
}

@end


@implementation CRFUpdateClaim

- (NSString *)result {
    if (!_result) {
        _result = @"0.00";
    }
    return _result;
}

- (CRFInvestInfo *)investInfo {
    if (!_investInfo) {
        _investInfo = [CRFInvestInfo yy_modelWithJSON:self.invest];
        if (!_investInfo) {
            _investInfo = [CRFInvestInfo new];
        }
    }
    return _investInfo;
}

@end
