//
//  CRFProductDetail.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFProductDetail.h"

@implementation CRFProductDetail

- (NSDictionary *)getDict {
    return @{@"amount":self.amount,
             @"applyDate":self.applyDate,
             @"closeDate":self.closeDate,
             @"exitDate":self.exitDate,
             @"interest":self.interest,
             @"expectedBenefitAmount":self.expectedBenefitAmount,
             @"interestStartDate":self.interestStartDate,
             @"investAmount":self.investAmount,
             @"investId":self.investId,
             @"investNo":self.investNo,
             @"investStatus":self.investStatus,
             @"isrede":self.isrede,
             @"proType":self.proType,
             @"productName":self.productName,
             @"ransomAmount":self.ransomAmount,
             @"redeAmount":self.redeAmount,
             @"source":self.source,
             @"yearrate":self.yearrate,
             @"minYield":self.minYield,
             @"maxYield":self.maxYield,
             @"isCancelZdxt":self.isCancelZdxt
             };
}

- (NSArray<CRFAgreementDto *> *)protocols {
    if (!_protocols) {
        _protocols = [NSArray yy_modelArrayWithClass:[CRFAgreementDto class] json:self.agreementList];
    }
    return _protocols;
}
-(NSString *)isCancelZdxt{
    if (!_isCancelZdxt) {
        _isCancelZdxt = @"2";
    }
    return _isCancelZdxt;
}
- (NSString *)amount {
    if (!_amount) {
        _amount = @"0.00";
    }
    return [_amount formatBeginMoney];
}

- (NSString *)interest {
    if (!_interest) {
        _interest = @"0.00";
    }
    return [_interest formatMoney];
}
- (NSString *)expectedBenefitAmount {
    if (!_expectedBenefitAmount) {
        _expectedBenefitAmount = @"0.00";
    }
    return [_expectedBenefitAmount formatMoney];
}
- (NSString *)applyDate {
    if (!_applyDate) {
        _applyDate = @"- -";
    }
    return _applyDate;
}
- (NSString *)exitDate {
    if (!_exitDate || [_exitDate isEmpty]) {
        _exitDate = @"- -";
    }
    return _exitDate;
}

- (NSString *)closeDate {
    if (!_closeDate) {
        _closeDate = @"- -";
    }
    return _closeDate;
}

- (NSString *)interestStartDate {
    if (!_interestStartDate) {
        _interestStartDate = @"- -";
    }
    return _interestStartDate;
}

- (NSString *)investAmount {
    if (!_investAmount) {
        _investAmount = @"";
    }
    return _investAmount;
}

- (NSString *)investId {
    if (!_investId) {
        _investId = @"";
    }
    return _investId;
}

- (NSString *)investNo {
    if (!_investNo) {
        _investNo = @"";
    }
    return _investNo;
}

- (NSString *)investStatus {
    if (!_investStatus) {
        _investStatus = @"";
    }
    return _investStatus;
}

- (NSString *)isrede {
    if (!_isrede) {
        _isrede = @"";
    }
    return _isrede;
}

- (NSString *)proType {
    if (!_proType) {
        _proType = @"";
    }
    return _proType;
}

- (NSString *)productName {
    if (!_productName) {
        _productName = @"";
    }
    return _productName;
}

- (NSString *)ransomAmount {
    if (!_ransomAmount) {
        _ransomAmount = @"";
    }
    return _ransomAmount;
}

- (NSString *)redeAmount {
    if (!_redeAmount) {
        _redeAmount = @"";
    }
    return _redeAmount;
}

- (NSString *)source {
    if (!_source) {
        _source = @"";
    }
    return _source;
}

- (NSString *)yearrate {
    if (!_yearrate) {
        _yearrate = @"0.00";
    }
    return _yearrate;
}
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
-(NSString *)formatRangeOfExpectYearRate{
    if (self.proType.integerValue == 7) {
        return [NSString stringWithFormat:@"%.2f%%+%.2f",self.minYield.doubleValue,self.maxYield.doubleValue];
    }
    return [NSString stringWithFormat:@"%.2f~%.2f",self.minYield.doubleValue,self.maxYield.doubleValue];
}
@end
