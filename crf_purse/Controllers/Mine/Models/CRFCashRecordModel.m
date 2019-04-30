//
//  CRFCashRecordModel.m
//  crf_purse
//
//  Created by maomao on 2017/8/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCashRecordModel.h"
#import "CRFTimeUtil.h"
@implementation CRFCashRecordModel
- (NSString *)title{
    if ([_jyType isEqualToString:@"1"]) {
        return @"充值";
    }
    return @"提现";
}
- (NSString *)amount{
    if ([_jyType isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"+%.2f",[_amount doubleValue]];
    }else{
        return [NSString stringWithFormat:@"-%.2f",[_amount doubleValue]];
    }
}
- (NSString *)jyTime{
    return [CRFTimeUtil getTimeToShowWithTimestamp:_jyTime];
}
@end
