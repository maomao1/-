//
//  CRFModifyEmailView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFModifyEmailView.h"
#import "CRFStringUtils.h"

@interface CRFModifyEmailView()

@property (nonatomic, strong) UIWindow *rootWindow;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *subContentLabel;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, copy) void (^(finishedCallback))(void);
@property (nonatomic, copy) NSString *title;

@end

@implementation CRFModifyEmailView

- (UIWindow *)rootWindow {
    if (!_rootWindow) {
        _rootWindow = [UIApplication sharedApplication].delegate.window;
        _rootWindow.userInteractionEnabled = YES;
    }
    return _rootWindow;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email"]];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.5f];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13.0];
        _contentLabel.userInteractionEnabled = YES;
        [_contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)]];
    }
    return _contentLabel;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:NSLocalizedString(@"alert_view_i_known", nil) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(buttonFinished) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.layer.masksToBounds = YES;
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _commitButton.layer.cornerRadius = 5;
        _commitButton.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
    }
    return _commitButton;
}

- (UILabel *)subContentLabel {
    if (!_subContentLabel) {
        _subContentLabel = [UILabel new];
        _subContentLabel.numberOfLines = 0;
        UIFont *font = nil;
        if (kScreenWidth == 320) {
            font = [UIFont systemFontOfSize:13.0f];
        } else {
            font = [UIFont systemFontOfSize:14.0f];
        }
        _subContentLabel.textColor = UIColorFromRGBValue(0x888888);
        _subContentLabel.font = font;
         _subContentLabel.text = @"未收到验证邮件？\n1、30秒后可重新发送\n2、请检查是否邮件被一直放在垃圾箱中";
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"未收到验证邮件？\n1、30秒后可重新发送\n2、请检查是否邮件被一直放在垃圾箱中"];
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4 * kHeightRatio];
        [att addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, _subContentLabel.text.length)];
        [_subContentLabel setAttributedText:att];
    }
    return _subContentLabel;
}

- (instancetype)initWithLinkUrl:(NSString *)linkUrl {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.title = linkUrl;
        [self addViews];
        [self layoutViews];
        [self setTitle];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.contentLabel];
    [self.bgImageView addSubview:self.subContentLabel];
    [self.bgImageView addSubview:self.commitButton];
}

- (void)layoutViews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(275, 290));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).with.offset(80);
        make.left.equalTo(self.bgImageView).with.offset(20);
        make.right.equalTo(self.bgImageView.mas_right).with.offset(-20);
        make.height.mas_equalTo(65);
    }];
    [self.subContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.bgImageView).with.offset(20);
        make.right.equalTo(self.bgImageView).with.offset(-20);
        make.height.mas_equalTo(60);
    }];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).with.offset(20);
        make.right.equalTo(self.bgImageView).with.offset(-20);
        make.bottom.equalTo(self.bgImageView).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
}

- (void)setTitle {
    NSString *total = [NSString stringWithFormat:@"我们已经发送了一封邮件至%@。请查阅邮箱，并点击链接完成邮箱验证。",self.title];
    [self.contentLabel setAttributedText:[CRFStringUtils setAttributedString:total lineSpace:3 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:NSMakeRange(0, @"我们已经发送了一封邮件至".length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:kLinkTextColor} range2:[total rangeOfString:self.title] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[total rangeOfString:@"。请查阅邮箱，并点击链接完成邮箱验证。"] attributes4:nil range4:NSRangeZero]];
}

- (void)show:(void(^)(void))handler {
    self.finishedCallback = handler;
    [self.rootWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rootWindow);
    }];
    [UIView animateWithDuration:.3 animations:^{
        self.bgView.alpha = 1;
    }];
}

- (void)tapLabel:(UITapGestureRecognizer *)tap {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.title]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.title]];
    }
//    [self buttonFinished];
}

- (void)buttonFinished {
    if (self.finishedCallback) {
        self.finishedCallback();
    }
    [self removeFromSuperview];
}

@end
