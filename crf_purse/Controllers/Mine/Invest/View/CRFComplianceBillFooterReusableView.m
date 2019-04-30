//
//  CRFComplianceBillFooterReusableView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFComplianceBillFooterReusableView.h"
#import "CRFHomeConfigHendler.h"
#import "CRFLabel.h"


@interface CRFComplianceBillFooterReusableView ()

@property (nonatomic, strong) CRFLabel *explainLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CRFComplianceBillFooterReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
        [self setContent];
    }
    return self;
}

- (void)initializeView {
    _titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = UIColorFromRGBValue(0x666666);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self).with.offset(20);
        make.width.mas_equalTo(kScreenWidth - kSpace * 2);
        make.height.mas_equalTo(14);
    }];
    _explainLabel = [CRFLabel new];
    _explainLabel.textColor = UIColorFromRGBValue(0x666666);
    _explainLabel.font = [UIFont systemFontOfSize:14.0];
    _explainLabel.verticalAlignment = VerticalAlignmentTop;
    _explainLabel.numberOfLines = 0;
    [self addSubview:self.explainLabel];
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kScreenWidth - kSpace * 2);
        make.bottom.equalTo(self);
    }];
}

- (void)setContent {
     self.titleLabel.text = @"注：";
    NSString *content = [CRFHomeConfigHendler defaultHandler].monthBillTips.content;
    if (!content) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:5.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:4.0];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [self.explainLabel setAttributedText:attributedString];
}

@end
