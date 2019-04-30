//
//  CRFUploadImageView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUploadImageView.h"
#import "CRFStringUtils.h"

@interface CRFUploadImageView ()


@property (nonatomic, strong) UIImageView *tapImageView;


@end

@implementation CRFUploadImageView

- (instancetype)init {
    if (self = [super init]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = UIColorFromRGBValue(0x666666);
    NSString *titleString = [NSString stringWithFormat:@"请上传您(%@)手持身份证、新银行卡的照片",[[CRFAppManager defaultManager].userInfo formatChangeBankCardUserName]];
    [titleLabel setAttributedText:[CRFStringUtils setAttributedString:titleString lineSpace:0 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[titleString rangeOfString:[NSString stringWithFormat:@"您(%@)手持身份证、新银行卡",[[CRFAppManager defaultManager].userInfo formatChangeBankCardUserName]]] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload_image_default"]];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5.0f;
    [self addSubview:_imageView];
    _tapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload_image"]];
    _tapImageView.contentMode = UIViewContentModeCenter;
    _tapImageView.userInteractionEnabled = YES;
    [_tapImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    [self addSubview:_tapImageView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.height.mas_equalTo(15);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(275 * kWidthRatio, 275 * kWidthRatio));
    }];
    [self.tapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
}

- (void)setHasImage:(BOOL)hasImage {
    _hasImage = hasImage;
    self.tapImageView.image = [UIImage imageNamed:_hasImage?@"re_upload_image":@"upload_image"];
}

- (void)tap {
    if (self.tapHandler) {
        self.tapHandler();
    }
}

@end
