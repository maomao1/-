//
//  CRFClaimer.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFClaimer.h"

@implementation CRFClaimer

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

@end
