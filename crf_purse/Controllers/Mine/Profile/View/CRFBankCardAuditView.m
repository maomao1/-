//
//  CRFBankCardAuditView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBankCardAuditView.h"

@interface CRFBankCardAuditView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CRFBankCardAuditView


- (instancetype)init {
    if (self = [super init]) {
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bankCard_audit_wait"]];
    [self addSubview:self.imageView];
    _contentLabel = [UILabel new];
    [self addSubview:self.contentLabel];
    self.contentLabel.textColor = UIColorFromRGBValue(0xAAAAAA);
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.numberOfLines = 0;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(kSpace);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.right.equalTo(self).with.offset(-kSpace);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(kSpace);
        make.bottom.equalTo(self);
    }];
    
    NSString *contentString = @"您的银行卡更换申请正在审核中。期间原卡仍可继续使用直到新卡更换成功。敬请知悉。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:4.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:10.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
    
    [self.contentLabel setAttributedText:attributedString];
    
}

@end
