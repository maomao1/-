//
//  CRFBankListCell.m
//  crf_purse
//
//  Created by maomao on 2019/3/7.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import "CRFBankListCell.h"

@implementation CRFBankListCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    _titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = UIColorFromRGBValue(0x666666);
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.bottom.equalTo(self).with.offset(-8);
        make.height.mas_equalTo(15);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.titleLabel.mas_top).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}
@end
