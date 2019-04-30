//
//  CRFNCPClaimSectionView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNCPClaimSectionView.h"

@interface CRFNCPClaimSectionView()

@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *protocolLabel;

@end

@implementation CRFNCPClaimSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _noLabel = [UILabel new];
    _noLabel.text = @"借款协议编号";
    _userLabel = [UILabel new];
    _userLabel.text = @"借款人";
    _amountLabel = [UILabel new];
    _amountLabel.text = @"匹配债权金额";
    _protocolLabel = [UILabel new];
    _protocolLabel.text = @"借款协议";
    [self addSubview:self.noLabel];
    [self addSubview:self.userLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.protocolLabel];
    self.noLabel.textAlignment = self.userLabel.textAlignment = self.amountLabel.textAlignment = self.protocolLabel.textAlignment = NSTextAlignmentCenter;
    self.noLabel.textColor = self.userLabel.textColor = self.amountLabel.textColor = self.protocolLabel.textColor = UIColorFromRGBValue(0x999999);
    self.noLabel.font = self.userLabel.font = self.amountLabel.font = self.protocolLabel.font = [UIFont systemFontOfSize:12.0];
    [self.noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(26 * kWidthRatio);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(125 * kWidthRatio);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.noLabel.mas_right);
        make.width.mas_equalTo(60 * kWidthRatio);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.userLabel.mas_right);
        make.width.mas_equalTo(96 * kWidthRatio);
    }];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountLabel.mas_right);
        make.bottom.top.equalTo(self);
        make.width.mas_equalTo(68 *kWidthRatio);
    }];
}


@end
