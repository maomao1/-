//
//  CRFCommonResultView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFCommonResultView.h"
#import "UIImage+Color.h"

@interface CRFCommonResultView()

@property (nonatomic, strong) UIImageView *resultImageView;

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, copy) NSString *result, *reason;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSArray <NSString *>*buttonTitles;

@property (nonatomic, strong) UIButton *resultButton, *otherButton;

@end

@implementation CRFCommonResultView

- (UIButton *)resultButton {
    if (!_resultButton) {
        _resultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resultButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _resultButton.tag = 0;
        _resultButton.layer.masksToBounds = YES;
        _resultButton.layer.cornerRadius = 5.0f;
        UIColor *color = kButtonNormalBackgroundColor;
        _resultButton.layer.borderColor = color.CGColor;
        [_resultButton setTitleColor:kTextWhiteColor forState:UIControlStateNormal];
         [_resultButton setTitleColor:kTextWhiteColor forState:UIControlStateHighlighted];
        [_resultButton setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
         [_resultButton setBackgroundImage:[UIImage imageWithColor:kTextRedHighLightColor] forState:UIControlStateHighlighted];
        _resultButton.layer.borderWidth = 1.0f;
        [_resultButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resultButton;
}

- (UIButton *)otherButton {
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _otherButton.tag = 1;
        _otherButton.layer.masksToBounds = YES;
        _otherButton.layer.cornerRadius = 5.0f;
        _otherButton.layer.borderWidth = 1.0f;
        UIColor *color = kButtonNormalBackgroundColor;
        _otherButton.layer.borderColor = color.CGColor;
        [_otherButton setTitleColor:kTextWhiteColor forState:UIControlStateNormal];
        [_otherButton setTitleColor:kTextWhiteColor forState:UIControlStateHighlighted];
        [_otherButton setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
        [_otherButton setBackgroundImage:[UIImage imageWithColor:kTextRedHighLightColor] forState:UIControlStateHighlighted];
         [_otherButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}

- (UIImageView *)resultImageView {
    if (!_resultImageView) {
        _resultImageView = [UIImageView new];
    }
    return _resultImageView;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [UILabel new];
        _resultLabel.textColor = kTextDefaultColor;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _resultLabel;
}

- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [UILabel new];
        _reasonLabel.textColor = kTextEnableColor;
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
        _reasonLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _reasonLabel;
}

- (instancetype)initWithResultImage:(UIImage *)image result:(NSString *)result reason:(NSString *)reason buttonTitles:(NSArray <NSString *>*)buttonTitles {
    if (self = [super init]) {
        self.image = image;
        self.result = result;
        self.reason = reason;
        self.buttonTitles = buttonTitles;
        [self initializeView];
        [self setContent];
    }
    return self;
}

- (void)initializeView {
    [self addSubview:self.resultImageView];
    [self addSubview:self.resultLabel];
    [self addSubview:self.reasonLabel];
    if (self.buttonTitles.count == 1) {
        [self addSubview:self.resultButton];
    } else if (self.buttonTitles.count > 1) {
        [self addSubview:self.resultButton];
        [self.resultButton setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateNormal];
        [self.resultButton setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateHighlighted];
        [self.resultButton setBackgroundImage:[UIImage imageWithColor:kTextWhiteColor] forState:UIControlStateNormal];
        [self.resultButton setBackgroundImage:[UIImage imageWithColor:kTextWhiteHighLightColor] forState:UIControlStateHighlighted];
        [self addSubview:self.otherButton];
    }
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(45);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.resultImageView.mas_bottom).with.offset(kSpace);
        make.height.mas_equalTo(18);
    }];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.resultLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(self.reason?14.0:0);
    }];
    if (self.buttonTitles.count == 1) {
        [self.resultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reasonLabel.mas_bottom).with.offset(45);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(165 * kWidthRatio, 46 * kWidthRatio));
        }];
    } else if (self.buttonTitles.count > 1) {
        CGFloat buttonWidth = (kScreenWidth - kSpace * 3) / 2.0;
        [self.resultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 46 * kWidthRatio));
            make.top.equalTo(self.reasonLabel.mas_bottom).with.offset(45);
            make.left.equalTo(self).with.offset(kSpace);
        }];
        [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.resultButton);
            make.right.equalTo(self).with.offset(-kSpace);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 46 * kWidthRatio));
        }];
    }
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.commonResultDelegate respondsToSelector:@selector(commonResultDidTouched:)]) {
        [self.commonResultDelegate commonResultDidTouched:sender.tag];
    }
}

- (void)setContent {
    self.resultImageView.image = self.image;
    self.resultLabel.text = self.result;
    self.reasonLabel.text = self.reason;
    if (self.buttonTitles.count == 1) {
        [self.resultButton setTitle:[self.buttonTitles firstObject] forState:UIControlStateNormal];
        [self.resultButton setTitle:[self.buttonTitles firstObject] forState:UIControlStateHighlighted];
    } else if (self.buttonTitles.count > 1) {
        [self.resultButton setTitle:[self.buttonTitles firstObject] forState:UIControlStateNormal];
        [self.resultButton setTitle:[self.buttonTitles firstObject] forState:UIControlStateHighlighted];
        [self.otherButton setTitle:[self.buttonTitles lastObject] forState:UIControlStateNormal];
        [self.otherButton setTitle:[self.buttonTitles lastObject] forState:UIControlStateHighlighted];
    }
}

@end
