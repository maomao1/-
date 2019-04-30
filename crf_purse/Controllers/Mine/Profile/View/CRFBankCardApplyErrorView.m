//
//  CRFBankCardApplyErrorView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBankCardApplyErrorView.h"

@interface CRFBankCardApplyErrorView ()

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, copy) NSString *contentString;

@property (nonatomic, copy) NSString *promptString;

@end

@implementation CRFBankCardApplyErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGBValue(0xFFF7EA);
        [self initializeView];
        [self setContent];
        [self addObserver];
    }
    return self;
}

- (void)initializeView {
    self.contentString = @"很抱歉，您的新银行卡未通过审核，原因可能是：证件或银行卡信息与本人不符。";
    self.promptString = @"你可以继续使用原银行卡，也可以重新申请更换银行卡。";
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"bankCard_apply_error"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.closeButton];
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = UIColorFromRGBValue(0xFFB540);
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    _promptLabel = [UILabel new];
    _promptLabel.numberOfLines = 0;
    _promptLabel.textColor = UIColorFromRGBValue(0xFFB540);
    _promptLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.contentLabel];
    [self addSubview:self.promptLabel];
}

- (void)layoutViews {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(kSpace);
        make.bottom.equalTo(self).with.offset(- ([self getPromptStringHeight] + kSpace + 10));
        make.right.equalTo(self).with.offset(-50);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-kSpace);
        make.left.right.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10);
    }];
}

- (void)addObserver {
    [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    BOOL value = [change[@"new"] boolValue];
    if (!value) {
        [self layoutViews];
    }
    
}

- (void)setContent {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentString];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
     [paragraphStyle setLineSpacing:3.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:1.0];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentString length])];
    [self.contentLabel setAttributedText:attributedString];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.promptString];
    NSMutableParagraphStyle   *paragraphStyle1   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle1 setLineSpacing:3.0];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.promptString length])];
    [self.promptLabel setAttributedText:attributedString1];
}

- (CGFloat)getContentStringHeight {
     CGFloat contentHeight = [self.contentString boundingRectWithSize:CGSizeMake(kScreenWidth - kSpace - 50, CGFLOAT_MAX) fontNumber:12.0 lineSpace:3.0 paragraphSpace:1].height;
    return contentHeight;
}

- (CGFloat)getPromptStringHeight {
     CGFloat promptHeight = [self.promptString boundingRectWithSize:CGSizeMake(kScreenWidth - kSpace - 50, CGFLOAT_MAX) fontNumber:12 lineSpace:3].height;
    return promptHeight;
}

- (CGFloat)getThisHeight {
    return kSpace * 2 + [self getPromptStringHeight] + [self getContentStringHeight] + 10;
}

- (void)closeView {
    DLog(@"close");
      [CRFUserDefaultManager setBankCardAuditErrorFlag:YES];
    if (self.closeHandler) {
        self.closeHandler();
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"hidden"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
