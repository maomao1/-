//
//  CRFCity.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCity.h"

@implementation CRFCity

- (NSArray<CRFSubCity *> *)subCities {
    if (!_subCities) {
        _subCities = [NSArray yy_modelArrayWithClass:[CRFSubCity class] json:self.city];
        }
    
    return _subCities;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"postCode":@"postcode"};
}

- (NSString *)postCode {
    if (!_postCode) {
        _postCode = @"";
    }
    return _postCode;
}

@end

@implementation CRFSubCity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"townes":@"district"};
}

- (NSArray<CRFTown *> *)lastTowns {
    
    if (!_lastTowns) {
        _lastTowns = [NSArray yy_modelArrayWithClass:[CRFTown class] json:self.townes];
    }
    return _lastTowns;
}


@end

@implementation CRFTown



@end


@implementation CRFBankCity

- (NSArray<CRFSubBankCity *> *)bankCities {
    if (!_bankCities) {
        _bankCities = [NSArray yy_modelArrayWithClass:[CRFSubBankCity class] json:self.area];
    }
    return _bankCities;
}

@end

@implementation CRFSubBankCity



@end
