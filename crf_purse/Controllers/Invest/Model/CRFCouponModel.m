//
//  CRFCouponModel.m
//  crf_purse
//
//  Created by maomao on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCouponModel.h"

@implementation CRFCouponModel
- (NSString *)useRuleItem{
    if (!_useRuleItem) {
        _useRuleItem = @"";
    }else{
        _useRuleItem = [_useRuleItem formatJsonToString];
    }
    return _useRuleItem;
}
@end
@implementation CRFCouponRule
@end
