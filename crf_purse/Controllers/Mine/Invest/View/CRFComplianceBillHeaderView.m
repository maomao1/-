//
//  CRFComplianceBillHeaderView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFComplianceBillHeaderView.h"
#import "CRFStringUtils.h"


@interface CRFComplianceBillHeaderView ()

@property (nonatomic, strong) UILabel *payPatternLabel;
@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UILabel *currencyUnitLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *compoundLabel;
@end

@implementation CRFComplianceBillHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (UIFont *)adjustsFont {
    if (kScreenWidth == 320) {
        return [UIFont systemFontOfSize:10];
    }
    return [UIFont systemFontOfSize:12];
}

- (void)initializeView {
    _payPatternLabel = [UILabel new];
    _beginTimeLabel = [UILabel new];
    _currencyUnitLabel = [UILabel new];
    _endTimeLabel = [UILabel new];
    _discountLabel = [UILabel new];
    _compoundLabel = [UILabel new];
    _payPatternLabel.font = _beginTimeLabel.font = _currencyUnitLabel.font = _endTimeLabel.font = _discountLabel.font = _compoundLabel.font = [self adjustsFont];
    _payPatternLabel.textColor = _beginTimeLabel.textColor = _currencyUnitLabel.textColor = _endTimeLabel.textColor = _discountLabel.textColor = _compoundLabel.textColor = UIColorFromRGBValue(0x888888);
    [self addSubview:self.payPatternLabel];
    [self addSubview:self.beginTimeLabel];
    [self addSubview:self.currencyUnitLabel];
    [self addSubview:self.endTimeLabel];
    [self addSubview:self.discountLabel];
    [self addSubview:self.compoundLabel];
    [self.payPatternLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth / 2 - kSpace - 10);
        make.height.mas_equalTo(12);
    }];
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self.payPatternLabel.mas_bottom).with.offset(10);
        make.width.height.equalTo(self.payPatternLabel);
       
    }];
    [self.currencyUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).with.offset(10);
        make.top.equalTo(self).with.offset(kSpace);
//        make.right.equalTo(self).with.offset(-kSpace);
        make.width.mas_equalTo(kScreenWidth / 2 - kSpace - 10);
        make.height.equalTo(self.beginTimeLabel);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.currencyUnitLabel);
        make.width.equalTo(self.currencyUnitLabel); make.top.equalTo(self.currencyUnitLabel.mas_bottom).with.offset(10);
    }];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self.beginTimeLabel.mas_bottom).with.offset(10);
        make.right.height.equalTo(self.payPatternLabel);
    }];
    [self.compoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.currencyUnitLabel);
        make.width.equalTo(self.currencyUnitLabel); make.top.equalTo(self.endTimeLabel.mas_bottom).with.offset(10);
    }];
}

- (void)setBill:(CRFComplianceBill *)bill {
    _bill = bill;
    UIColor *highlightColor = UIColorFromRGBValue(0x333333);
    NSString *payPatternString = [NSString stringWithFormat:@"收益支付方式：%@",_bill.benefitPayMode];
    [self.payPatternLabel setAttributedText:[CRFStringUtils setAttributedString:payPatternString highlightText:_bill.benefitPayMode highlightColor:highlightColor]];
    NSString *currencyUnitString = [NSString stringWithFormat:@"货币单位：%@",_bill.currencyUnit];
    [self.currencyUnitLabel setAttributedText:[CRFStringUtils setAttributedString:currencyUnitString highlightText:_bill.currencyUnit highlightColor:highlightColor]];
    NSString *beginTimeString = [NSString stringWithFormat:@"起息日期：%@",_bill.interestStartDate];
    [self.beginTimeLabel setAttributedText:[CRFStringUtils setAttributedString:beginTimeString highlightText:_bill.interestStartDate highlightColor:highlightColor]];
    NSString *endTimeString = [NSString stringWithFormat:@"到期日期：%@",_bill.interestEndDate];
    [self.endTimeLabel setAttributedText:[CRFStringUtils setAttributedString:endTimeString highlightText:_bill.interestEndDate highlightColor:highlightColor]];
    NSString *discountString = [NSString stringWithFormat:@"期望收益率（单利）：%@",_bill.annualizedYieldSingle];
    [self.discountLabel setAttributedText:[CRFStringUtils setAttributedString:discountString highlightText:_bill.annualizedYieldSingle highlightColor:highlightColor]];
    NSString *compoundString = [NSString stringWithFormat:@"期望收益率（复利）：%@",_bill.annualizedYieldDouble];
    [self.compoundLabel setAttributedText:[CRFStringUtils setAttributedString:compoundString highlightText:_bill.annualizedYieldDouble highlightColor:highlightColor]];
}


@end
