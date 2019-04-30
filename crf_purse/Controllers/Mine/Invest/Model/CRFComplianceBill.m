//
//  CRFComplianceBill.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFComplianceBill.h"

@implementation CRFComplianceCurrentBill

- (NSString *)actualAnnualizedYieldDouble {
    if (!_actualAnnualizedYieldDouble) {
        _actualAnnualizedYieldDouble = @"0.00";
    }
    return [NSString stringWithFormat:@"%@%%",_actualAnnualizedYieldDouble];
}

- (NSString *)cycleDate {
    if (!_cycleDate) {
        _cycleDate = @"";
    }
    return _cycleDate;
}


@end

@implementation CRFComplianceHistoryBill

- (NSString *)cycleDate {
    if (!_cycleDate) {
        _cycleDate = @"";
    }
    return _cycleDate;
}

@end


@implementation CRFComplianceBill


- (NSArray *)totalBills {
    if (!_totalBills) {
        NSArray *historyBills = [NSArray yy_modelArrayWithClass:[CRFComplianceHistoryBill class] json:self.listBillInfo];
        CRFComplianceCurrentBill *currentBill = [CRFComplianceCurrentBill yy_modelWithJSON:self.finalBillInfo];
        NSMutableArray *bills = [NSMutableArray arrayWithArray:historyBills];
        if (currentBill) {
//             [bills addObject:currentBill];
            [bills insertObject:currentBill atIndex:0];
        }
        _totalBills = bills;
    }
    return _totalBills;
}

- (NSString *)annualizedYieldDouble {
    if (!_annualizedYieldDouble) {
        _annualizedYieldDouble = @"0.00";
    }
    return [NSString stringWithFormat:@"%@%%",_annualizedYieldDouble];
}

- (NSString *)annualizedYieldSingle {
    if (!_annualizedYieldSingle) {
        _annualizedYieldSingle = @"0.00";
    }
    return [NSString stringWithFormat:@"%@%%",_annualizedYieldSingle];
}


@end
