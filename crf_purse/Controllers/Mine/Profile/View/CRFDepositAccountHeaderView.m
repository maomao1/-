//
//  CRFDepositAccountHeaderView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDepositAccountHeaderView.h"

@interface CRFDepositAccountHeaderView()

/**
 可用余额label
 */
@property (nonatomic, strong) UILabel *availableBalanceLabel;

/**
 未到账金额
 */
@property (nonatomic, strong) UILabel *collectedBalanceLabel;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UILabel *availablePromptLabel;

@property (nonatomic, strong) UILabel *collectedPromptLabel;

@property (nonatomic, copy) NSString *available, *collected;

@end

@implementation CRFDepositAccountHeaderView

- (UILabel *)availableBalanceLabel {
    if (!_availableBalanceLabel) {
        _availableBalanceLabel = [UILabel new];
        _availableBalanceLabel.font = [UIFont systemFontOfSize:22.0];
        _availableBalanceLabel.textAlignment = NSTextAlignmentCenter;
        _availableBalanceLabel.textColor = kButtonNormalBackgroundColor;
    }
    return _availableBalanceLabel;
}

- (UILabel *)collectedBalanceLabel {
    if (!_collectedBalanceLabel) {
        _collectedBalanceLabel = [UILabel new];
        _collectedBalanceLabel.font = [UIFont systemFontOfSize:22.0];
        _collectedBalanceLabel.textAlignment = NSTextAlignmentCenter;
        _collectedBalanceLabel.textColor = kButtonNormalBackgroundColor;
    }
    return _collectedBalanceLabel;
}

- (UILabel *)availablePromptLabel {
    if (!_availablePromptLabel) {
        _availablePromptLabel = [UILabel new];
        _availablePromptLabel.font = [UIFont systemFontOfSize:12.0];
        _availablePromptLabel.text = @"可用余额(元)";
        _availablePromptLabel.textAlignment = NSTextAlignmentCenter;
        _availablePromptLabel.textColor = kTextEnableColor;
    }
    return _availablePromptLabel;
}

- (UILabel *)collectedPromptLabel {
    if (!_collectedPromptLabel) {
        _collectedPromptLabel = [UILabel new];
        _collectedPromptLabel.textAlignment = NSTextAlignmentCenter;
        _collectedPromptLabel.text = @"未到账金额(元)";
        _collectedPromptLabel.font = [UIFont systemFontOfSize:12.0];
        _collectedPromptLabel.textColor = kTextEnableColor;
    }
    return _collectedPromptLabel;
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = kCellLineSeparatorColor;
    }
    return _line;
}

- (instancetype)initWithFrame:(CGRect)frame availableBalance:(NSString *)availableBalance collectedBalance:(NSString *)collectedBalance {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.available = availableBalance;
        self.collected = collectedBalance;
        [self initializeView];
        [self setContent];
    }
    return self;
}

- (void)initializeView {
    [self addSubview:self.availablePromptLabel];
    [self addSubview:self.availableBalanceLabel];
    if ([self.collected getOriginString].doubleValue > 0.00) {
        [self addSubview:self.line];
        [self addSubview:self.collectedPromptLabel];
        [self addSubview:self.collectedBalanceLabel];
    }
    [self layoutViews];
}

- (void)layoutViews {
    if ([self.collected getOriginString].doubleValue <= 0.00) {
        [self.availableBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(20);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 22));
        }];
        [self.availablePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(11);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 12));
        }];
    } else {
        [self.availableBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(20);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, 22));
        }];
        [self.availablePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.availableBalanceLabel.mas_bottom).with.offset(11);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, 12));
        }];
        [self.collectedBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(20);
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, 22));
        }];
        [self.collectedPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectedBalanceLabel.mas_bottom).with.offset(11);
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, 12));
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(20);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(2, 40));
        }];
    }
}

- (void)setContent {
     self.availableBalanceLabel.text = [self.available formatMoney];
    if ([self.collected getOriginString].doubleValue > 0.00) {
        self.collectedBalanceLabel.text = [self.collected formatMoney];
    }
}

@end
