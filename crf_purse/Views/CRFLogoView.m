//
//  CRFLogoView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFLogoView.h"
#import "CRFHomeConfigHendler.h"

@interface CRFLogoView ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftLine;
@property (nonatomic, strong) UIImageView *rightLine;

@end

@implementation CRFLogoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if ([CRFUtils normalUser]) {
            [self initializeView];
            [self layoutViews];
        }
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        if ([CRFUtils normalUser]) {
            [self initializeView];
            [self layoutViews];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        if ([CRFUtils normalUser]) {
            [self initializeView];
            [self layoutViews];
        }
    }
    return self;
}

- (void)initializeView {
    _infoLabel = [UILabel new];
    _infoLabel.textColor = UIColorFromRGBValue(0x999999);
    _infoLabel.text = [CRFHomeConfigHendler defaultHandler].bankInfoTipModel.name;
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.infoLabel];
    _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_icon"]];
    [self addSubview:self.leftImageView];
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_icon"]];
    [self addSubview:self.rightImageView];
    _leftLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_left_line"]];
    [self addSubview:self.leftLine];
    _rightLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_right_line"]];
    [self addSubview:self.rightLine];
}

- (void)layoutViews {
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(146);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.right.equalTo(self.infoLabel.mas_left).with.offset(-10);
    }];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self);
         make.size.mas_equalTo(CGSizeMake(54, 1));
        make.right.equalTo(self.leftImageView.mas_left).with.offset(-3);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.left.equalTo(self.infoLabel.mas_right).with.offset(10);
    }];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.equalTo(self.leftLine);
        make.left.equalTo(self.rightImageView.mas_right).with.offset(3);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
