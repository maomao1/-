//
//  CRFBankCardInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBankCardInfo.h"

@implementation CRFBankCardInfo

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cardBin":@"card_bin",
             @"bankCode":@"bank_code",
             @"bankName":@"bank_name",
             @"bankcc":@"cc"};
}

- (NSString *)phone {
    if (!_phone) {
        _phone = @"";
    }
    return _phone;
}

- (NSString *)bankcc {
    if (!_bankcc) {
        _bankcc = @"";
    }
    return _bankcc;
}

- (NSString *)bankName {
    if (!_bankName) {
        _bankName = @"银行";
    }
    return _bankName;
}


@end
