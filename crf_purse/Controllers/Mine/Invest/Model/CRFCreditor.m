//
//  CRFCreditor.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCreditor.h"

@implementation CRFCreditor

- (NSString *)agreementHtmlUrl {
    if (!_agreementHtmlUrl) {
        _agreementHtmlUrl = @"";
    }
    return _agreementHtmlUrl;
}

- (NSArray<CRFAgreementDto *> *)protocols {
    if (!_protocols) {
        _protocols = [NSArray yy_modelArrayWithClass:[CRFAgreementDto class] json:self.agreementList];
    }
    return _protocols;
}

- (NSString *)formatPayTerm {
    return [NSString stringWithFormat:@"%@期",self.payTerm];
}

- (NSString *)formatDueinTerm {
    return [NSString stringWithFormat:@"%@期",self.dueinTerm];
}

- (NSString *)formatTransferCapital {
    return [NSString stringWithFormat:@"%@元",self.transferCapital];
}

- (NSString *)transferCapital {
    if (!_transferCapital) {
        _transferCapital = @"";
    }
    return [_transferCapital formatMoney];
}

- (NSString *)formatDueinCapital {
    return [NSString stringWithFormat:@"%@元",self.dueinCapital];
}

- (NSString *)dueinCapital {
    if (!_dueinCapital) {
        _dueinCapital = @"";
    }
    return [_dueinCapital formatMoney];
}

@end
