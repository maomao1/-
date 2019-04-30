//
//  WMMJMineCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJMineCollectionViewCell.h"

@implementation WMMJMineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _imageView = [UIImageView new];
    [self addSubview:self.imageView];
    _titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = UIColorFromRGBValue(0x333333);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(30 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(30 * kWidthRatio, 30 * kWidthRatio));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(10 * kWidthRatio);
        make.height.mas_equalTo(15 * kWidthRatio);
    }];
}

@end
