//
//  CRFDiscoveryHeader.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDiscoveryHeader.h"

@interface CRFDiscoveryHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *barbutton;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation CRFDiscoveryHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(updateNewResource) name:kReloadResourceNotificationName];
        [self addSubviews];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)barbutton {
    if (!_barbutton) {
        _barbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_barbutton addTarget:self action:@selector(nextTarget) forControlEvents:UIControlEventTouchUpInside];
#ifdef WALLET
        if ([CRFAppManager defaultManager].majiabaoFlag) {
            [_barbutton setTitle:@"更多" forState:UIControlStateNormal];
            [_barbutton setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
            _barbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        }
#else
        [_barbutton setImage:[UIImage imageNamed:@"discover_service"] forState:UIControlStateNormal];
        [_barbutton.imageView setContentMode:UIViewContentModeCenter];
        _barbutton.hidden = YES;
   
#endif
     _barbutton.crf_acceptEventInterval = 0.5;
    }
    return _barbutton;
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = UIColorFromRGBValue(0xE2E2E2);
        _line.hidden = YES;
    }
    return _line;
}

- (void)updateNewResource {
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"disconvery_title_image"]) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self).with.offset(kStatusBarHeight);
        }];
    }
}

- (void)addSubviews {
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"disconvery_title_image"]) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self).with.offset(kStatusBarHeight);
        }];
    } else {
    [self addSubview:self.titleLabel];
    [self addSubview:self.barbutton];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
            make.bottom.equalTo(self).with.offset(-14);
            make.height.mas_equalTo(17);
        }];
        [self.barbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.bottom.equalTo(self).with.offset(-11);
        }];
    }
    [self addSubview:self.line];
   
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)nextTarget {
    if (self.pushNextHandle) {
        self.pushNextHandle();
    }
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = _hiddenLine;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

@end
