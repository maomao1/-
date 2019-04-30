//
//  CRFRechargeFooterView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/17.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRechargeRollOutFooterView.h"
#import "CRFLogoView.h"
#import "UIImage+Color.h"

@interface CRFRechargeRollOutFooterView()

@property (nonatomic, strong) UILabel *promptInfoLabel;

@property (nonatomic, strong) CRFLogoView *logoView;

@property (nonatomic, strong) UIButton *rechargeButton;

@property (nonatomic, copy) NSString *buttonTitle;

@end

@implementation CRFRechargeRollOutFooterView

- (instancetype)initWithFrame:(CGRect)frame actionTitle:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.buttonTitle = title;
        [self initializeView];
        [self layoutViews];
    }
    return self;
}

- (void)initializeView {
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeButton.layer.masksToBounds = YES;
    _rechargeButton.layer.cornerRadius = 5.0f;
    _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _rechargeButton.enabled = NO;
    [_rechargeButton setTitle:self.buttonTitle forState:UIControlStateHighlighted];
    [_rechargeButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    [_rechargeButton setTitle:self.buttonTitle forState:UIControlStateDisabled];
    [_rechargeButton setBackgroundImage:[UIImage imageWithColor:kTextRedHighLightColor] forState:UIControlStateHighlighted];
    [_rechargeButton setBackgroundImage:[UIImage imageWithColor:kBtnEnableBgColor] forState:UIControlStateDisabled];
    [_rechargeButton setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
    [self addSubview:self.rechargeButton];
    [self.rechargeButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    _promptInfoLabel = [UILabel new];
    _promptInfoLabel.textColor = kTextEnableColor;
    _promptInfoLabel.numberOfLines = 0;
    _promptInfoLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.promptInfoLabel];
    _logoView = [CRFLogoView new];
    [self addSubview:self.logoView];
}

- (void)layoutViews {
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.left.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.height.mas_equalTo(kRegisterButtonHeight);
    }];
    [self.promptInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.top.equalTo(self.rechargeButton.mas_bottom).with.offset(20);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.promptInfoLabel.mas_bottom).with.offset(50);
        make.height.mas_equalTo(18);
//        make.bottom.mas_lessThanOrEqualTo(-20);
    }];
}

- (void)rechargeAction {
    if (self.operaHandler) {
        self.operaHandler(self.rechargeButton.enabled);
    }
}

- (void)setContent:(NSString *)content {
//   NSString *info = @"温馨提示：\n1.为了您能顺利完成充值，请使用在银行办理的一类账户进行交易。\n2.充值手续费和充值到账时间相关。\n3.所有账户金额将充入由银行存管账户。信而富本身不存放用户的出借资金 。\n4.当前优惠期内，用户无需支付因充值所产生的转账费用。\n3.若有疑问请联系客服热线：400-688-8692 。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:4.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:10.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [self.promptInfoLabel setAttributedText:attributedString];
    [self layoutIfNeeded];
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.rechargeButton.enabled = !_enable;
}

@end
