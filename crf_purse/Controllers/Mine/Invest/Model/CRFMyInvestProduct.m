//
//  CRFMyInvestProduct.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMyInvestProduct.h"
#import "CRFTimeUtil.h"

@implementation CRFMyInvestProduct

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

- (NSString *)yearRate {
    return [NSString stringWithFormat:@"%@",_yearRate];
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
- (NSString *)formatYearRate {
    return [NSString stringWithFormat:@"%@%%",[self yearRate]];
}

- (NSString *)formatCloseDays {
    return[NSString stringWithFormat:@"%@天",self.closeDays];
}
-(NSString *)formatRangeOfRate{
    if (self.proType.integerValue == 7) {
        return [NSString stringWithFormat:@"%.2f%%+%.2f%%",self.minYield.doubleValue,self.maxYield.doubleValue];
    }
    return [NSString stringWithFormat:@"%.2f~%.2f%%",self.minYield.doubleValue,self.maxYield.doubleValue];
}
- (NSString *)applyTime {
    return [NSString stringWithFormat:@"%@申请",self.applyDate];
}

- (NSString *)frezzTime {
//    long long beginDay = [CRFTimeUtil getTimeIntervalWithFormatDate:self.applyDate];
//    long long desDays = beginDay + [CRFTimeUtil getTimeIntervalWithDay:[self.queueDays integerValue]];
//    NSString *time = [CRFTimeUtil formatLongTime:desDays pattern:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@起息",self.interestStartDate];
}

- (NSString *)interest {
    if (!_interest || [_interest isEmpty]) {
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
- (NSString *)capital {
   return [NSString stringWithFormat:@"%@\n期初出借本金(元)",self.amount];
}

- (NSString *)exitDate {
    if (!_exitDate || [_exitDate isEmpty]) {
        _exitDate = @"- -";
    }
    return _exitDate;
}

- (NSString *)amount {
    if (!_amount) {
        _amount = @"";
    }
    return [_amount formatBeginMoney];
}

- (NSString *)currentAssert {
    return [NSString stringWithFormat:@"%@\n当前资产(元)",self.accountAmount];
}
- (NSString *)currentRangeOfRate {
    return [NSString stringWithFormat:@"%@\n期望年化收益率",[self formatRangeOfRate]];
}

- (NSString *)accountAmount {
    if (!_accountAmount) {
        _accountAmount = @"";
    }
    return [_accountAmount formatMoney];
}

- (NSString *)closeDays {
    return _closeDays;
}

- (NSString *)getNCPDays {
    long long beginDays = [CRFTimeUtil formatDateString:self.closeDate pattern:@"yyyy-MM-dd"] / 1000;
    long long endDays = [CRFTimeUtil formatDateString:self.applyDate pattern:@"yy-MM-dd"] / 1000;
    long long differenceTime = beginDays - endDays;
    NSInteger days = ([CRFTimeUtil getDays:differenceTime]) - 1;
    
    if (days <= 0) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%ld",days];;
}

- (NSString *)getDay {
    return self.remainDays;
}

- (NSString *)expireTime {
    return [NSString stringWithFormat:@"%@\n剩余天数(天)",[self getDay]];
}

- (NSString *)getAssert; {
    //本金*利率*封闭期天数/360
    return [NSString stringWithFormat:@"%@\n到期预计收益(元)",[self getYearMoney]];
}

- (NSString *)getTotalAmount {
    return [self.amount getOriginString];
}

- (NSString *)getProfit {
    return [NSString stringWithFormat:@"%@\n累计收益(元)",self.expectedBenefitAmount];
}

- (NSString *)investNo {
    if (!_investNo) {
        _investNo = @"";
    }
    return _investNo;
}

- (NSString *)getYearMoney {
    NSInteger day =[self getBearingDays];
   CGFloat MinMoney  = [CRFUtils incomeAmount:[self getTotalAmount] yInterestRate:self.minYield day:day NCP:[CRFUtils complianceProduct:self.investSource] type:self.proType.integerValue != 2];
    CGFloat MaxMoney  = [CRFUtils incomeAmount:[self getTotalAmount] yInterestRate:self.maxYield day:day NCP:[CRFUtils complianceProduct:self.investSource] type:self.proType.integerValue != 2];
//    CGFloat money = ([[self getTotalAmount] doubleValue] * day  * [self.yearRate doubleValue] / 100) / 365;
    return [NSString stringWithFormat:@"%@~%@",[[NSString stringWithFormat:@"%.2f",MinMoney] formatMoney],[[NSString stringWithFormat:@"%.2f",MaxMoney] formatMoney]];
}

- (NSInteger)getBearingDays {
    NSInteger day = self.closeDays.integerValue;
    if ([CRFUtils complianceProduct:self.investSource]) {
        day = [self getNCPDays].integerValue;
    }
    return day;
}

@end
