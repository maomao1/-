//
//  CRFBankListModel.m
//  crf_purse
//
//  Created by maomao on 2017/8/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBankListModel.h"

@implementation CRFBankListModel
- (NSString *)bankSigle{
    NSArray *moneyArr = [self.quotaMap objectForKey:@"appSignWithholdQuata"];
    NSString *str = moneyArr[0];
    if ([str isEqualToString:@"-1"]) {
        return @"-";
    }
    if (str.length>4) {
         str = [NSString stringWithFormat:@"%@万元",[str substringWithRange:NSMakeRange(0, str.length-4)]];
    }else{
        str = [NSString stringWithFormat:@"%@元",str];
    }
    return str;
}
- (NSString *)bankDay{
    NSArray *moneyArr = [self.quotaMap objectForKey:@"appSignWithholdQuata"];
    NSString *str = moneyArr[1];
    if ([str isEqualToString:@"-1"]) {
        return @"-";
    }
    if (str.length>4) {
        str = [NSString stringWithFormat:@"%@万元",[str substringWithRange:NSMakeRange(0, str.length-4)]];
    }else{
        str = [NSString stringWithFormat:@"%@元",str];
    }
    return str;
}
- (NSString *)bankMonth{
    NSArray *moneyArr = [self.quotaMap objectForKey:@"appSignWithholdQuata"];
    NSString *str = moneyArr[2];
    if ([str isEqualToString:@"-1"]) {
        return @"-";
    }
    if (str.length>4) {
        str = [NSString stringWithFormat:@"%@万元",[str substringWithRange:NSMakeRange(0, str.length-4)]];
    }else{
        str = [NSString stringWithFormat:@"%@元",str];
    }
    return str;
}

- (NSString *)formatSingleOrder {
    if ([self.bankSigle isEqualToString:@"-"]) {
        return @"不限";
    }
    return [self.bankSigle substringToIndex:self.bankSigle.length - 1];
}

- (NSString *)formatDayOrder {
    if ([self.bankDay isEqualToString:@"-"]) {
        return @"不限";
    }
    return [self.bankDay substringToIndex:self.bankDay.length - 1];
}

- (NSString *)formatMonthOrder {
    if ([self.bankMonth isEqualToString:@"-"]) {
        return @"不限";
    }
    return [self.bankMonth substringToIndex:self.bankMonth.length - 1];
}

@end
