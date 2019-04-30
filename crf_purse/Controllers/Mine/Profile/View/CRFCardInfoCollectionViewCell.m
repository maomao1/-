//
//  CRFCardInfoCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCardInfoCollectionViewCell.h"

@interface CRFCardInfoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *cardNameLabel;

@property (nonatomic, strong) UILabel *cardTypeLabel;

@property (nonatomic, strong) UILabel *cardNoLabel;

@property (nonatomic, strong) UIImageView *bankCardStatusImageView;

@end

@implementation CRFCardInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeView];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initializeView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bank_card_default"]];
    [self addSubview:self.imageView];
    _cardNameLabel = [UILabel new];
    _cardNameLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.cardNameLabel];
    _cardTypeLabel = [UILabel new];
    _cardTypeLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.cardTypeLabel];
    _cardNoLabel = [UILabel new];
    _cardNoLabel.font = [UIFont systemFontOfSize:18.0];
    self.cardNameLabel.textColor = self.cardTypeLabel.textColor = self.cardNoLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.cardNoLabel];
    _bankCardStatusImageView = [[UIImageView alloc] init];
    _bankCardStatusImageView.contentMode = UIViewContentModeTopRight;
    [self addSubview:self.bankCardStatusImageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(75* kWidthRatio);
        make.top.equalTo(self).with.offset(18 * kWidthRatio);
        make.right.equalTo(self);
        make.height.mas_equalTo(17* kWidthRatio);
    }];
    [self.cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cardNameLabel);
        make.top.equalTo(self.cardNameLabel.mas_bottom).with.offset(7* kWidthRatio);
        make.height.mas_equalTo(14.0* kWidthRatio);
    }];
    [self.cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cardNameLabel);
        make.top.equalTo(self.cardTypeLabel.mas_bottom).with.offset(23* kWidthRatio);
        make.height.mas_equalTo(21* kWidthRatio);
    }];
    [self.bankCardStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl =imageUrl;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"bank_card_default"]];
    NSURL *url = [NSURL URLWithString:[_imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bank_card_default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(error? @"loading bankImage failed":@"loading bankImage success");
    }];
}

- (void)setCardName:(NSString *)cardName {
    _cardName = cardName;
    self.cardNameLabel.text = _cardName;
}

- (void)setCardNo:(NSString *)cardNo {
    _cardNo = cardNo;
    self.cardNoLabel.text =_cardNo;
}

- (void)setCardType:(NSString *)cardType {
    _cardType = cardType;
    self.cardTypeLabel.text = _cardType;
}

- (void)setBankCardStatus:(CRFBankCardStatus)bankCardStatus {
    _bankCardStatus = bankCardStatus;
    if (_bankCardStatus == CRFBankCardStatus_Normal) {
        _bankCardStatusImageView.hidden = YES;
    } else if (_bankCardStatus == CRFBankCardStatus_Audit) {
        _bankCardStatusImageView.hidden = NO;
        _bankCardStatusImageView.image = [UIImage imageNamed:@"bankCard_audit"];
    } else {
        _bankCardStatusImageView.hidden = NO;
        _bankCardStatusImageView.image = [UIImage imageNamed:@"bankCard_pause_use"];
    }
}

@end
