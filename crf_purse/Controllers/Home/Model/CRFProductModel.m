//
//  CRFProductModel.m
//  crf_purse
//
//  Created by maomao on 2017/7/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFProductModel.h"

@implementation CRFProductModel
-(NSString *)investunit{
    if (!_investunit) {
        _investunit = @"";
    }
    return _investunit;
}
- (NSString *)lowestAmount {
    if (!_lowestAmount.length) {
        _lowestAmount = @"0";
    }
    return [_lowestAmount formatPercent];
}
-(NSString *)remainDays{
    if (!_remainDays) {
        _remainDays = @"0";
    }
    return _remainDays;
}
- (NSString *)highestAmount {
    if (!_highestAmount.length) {
        _highestAmount = @"0";
    }
    return [_highestAmount formatPercent];
}

- (NSString *)name {
    _name = _productName;
    return _name;
}

- (NSString *)isFull {
    if (![_isFull boolValue]) {
        if ([self.alreadyInvestPercent floatValue] >= 100) {
            return @"1";
        }
    }
    return _isFull;
}

- (NSString *)alreadyInvestPercent {
    return [NSString stringWithFormat:@"%.2f",[_finishAmount getOriginString].doubleValue/[_planAmount getOriginString].doubleValue * 100];
}

- (NSString *)investContent {
    if ([_lowestAmount formatPercent].length > 4) {
        if (![_type isEqualToString:@"4"]) {
            return [NSString stringWithFormat:@"%@万元起投 | 锁定出借期%@天",[[[_lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [_lowestAmount formatPercent].length - 4)] formatBeginMoney],_freezePeriod];
        }else{
            return [NSString stringWithFormat:@"%@万元起投 | 出借天数%@天",[[[_lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [_lowestAmount formatPercent].length - 4)] formatBeginMoney],_remainDays];
        }
        
    }
    if (![_type isEqualToString:@"4"]) {
       return [NSString stringWithFormat:@"%@元起投 | 锁定出借期%@天",[[_lowestAmount formatPercent] formatBeginMoney],_freezePeriod];
    }else{
       return [NSString stringWithFormat:@"%@元起投 | 出借天数%@天",[[_lowestAmount formatPercent] formatBeginMoney],_remainDays];
    }
    
}

- (NSString *)content {
    if ([_lowestAmount formatPercent].length > 4) {
        if ([self.productType integerValue] != 3) {
            return [NSString stringWithFormat:@"%@万元起投 | 出借期%@天", [[[_lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [_lowestAmount formatPercent].length - 4)] formatBeginMoney],_freezePeriod];
        }
        if ([self.isFull integerValue] == 1) {
             return [NSString stringWithFormat:NSLocalizedString(@"cell_label_home_subTitle_2", nil), [[[_lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [_lowestAmount formatPercent].length - 4)] formatBeginMoney],_freezePeriod];
        }
        return [NSString stringWithFormat:NSLocalizedString(@"cell_label_home_subTitle_1", nil), [[[_lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [_lowestAmount formatPercent].length - 4)] formatBeginMoney],_freezePeriod,[self.alreadyInvestPercent formatPercent]];
    }
    if ([self.productType integerValue] != 3) {
        return [NSString stringWithFormat:@"%@元起投 | 出借期%@天", [[_lowestAmount formatPercent] formatBeginMoney],_freezePeriod];
    }
    if ([self.isFull integerValue] == 1) {
          return [NSString stringWithFormat:NSLocalizedString(@"cell_label_home_subTitle_3", nil),[[_lowestAmount formatPercent] formatBeginMoney],_freezePeriod];
    }
    return [NSString stringWithFormat:NSLocalizedString(@"cell_label_home_subTitle", nil),[[_lowestAmount formatPercent] formatBeginMoney],_freezePeriod,[self.alreadyInvestPercent formatPercent]];
}
- (NSString *)others {
    return [NSString stringWithFormat:NSLocalizedString(@"cell_label_home_title", nil),self.yInterestRate.floatValue];
}

- (NSString *)formatYInterestRate {
    return [NSString stringWithFormat:@"%.2f%%",self.yInterestRate.doubleValue];;
}

-(NSString*)formatterCloseTimeTag:(NSInteger)tag{
    NSTimeInterval interval    =[self.closeTime doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    if (tag == 1) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat:@"yyyy年MM月dd日"];
    }
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

/**
 
 */
-(NSString *)rangeOfYInterstRate{
    if (self.isNewBie.integerValue ==4) {
        return [NSString stringWithFormat:@"%.2f%%+%.2f",self.minYield.doubleValue,self.maxYield.doubleValue];
    }
    return [NSString stringWithFormat:@"%.2f~%.2f",self.minYield.doubleValue,self.maxYield.doubleValue];
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self encodeWithCoder:encoder];
}

- (NSString *)shareUrl {
    if (!_shareUrl) {
        _shareUrl = @"";
    }
    return _shareUrl;
}

- (NSString *)tipsStart {
    if (!_tipsStart) {
        _tipsStart = @"";
    }
    return _tipsStart;
}
- (NSString *)productName{
    if (!_productName) {
        _productName = @"";
    }
    return _productName;
}
-(NSString *)minYield{
    if (!_minYield) {
        _minYield = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",_minYield.doubleValue];
}
-(NSString *)maxYield{
    if (!_maxYield) {
        _maxYield = @"0.00";
    }
    return [NSString stringWithFormat:@"%.2f",_maxYield.doubleValue];
}
-(NSString *)newBieSort{
    if (!_newBieSort) {
        _newBieSort = @"100";
    }
    return _newBieSort;
}
@end


