//
//  CRFAppointmentForwardHelpView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardHelpView.h"
#import "CRFStringUtils.h"
#import <YYImage/YYAnimatedImageView.h>

@interface CRFAppointmentForwardHelpView()

@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) YYLabel *contentLabel2;
@property (nonatomic, strong) YYLabel *contentLabel3;


@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIVisualEffectView *effectview;

@property (nonatomic, copy) void (^(dismissHandler))(void);

@end

@implementation CRFAppointmentForwardHelpView

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:_effectStyle];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _effectview.alpha = 0;
    }
    return _effectview;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.closeButton];
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = 21.0f;
    self.closeButton.backgroundColor = UIColorFromRGBValue(0xff604f);
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.closeButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.closeButton setTitle:@"下一步" forState:UIControlStateSelected];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    self.closeButton.imageView.contentMode = UIViewContentModeCenter;
//    [self.closeButton setImage:[UIImage imageNamed:@"mine_close_icon"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@(140 * kWidthRatio));
        make.height.mas_equalTo(18);
    }];
    _line = [UIView new];
    [self addSubview:self.line];
    self.line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
        make.left.equalTo(@(30));
        make.right.equalTo(@(-30));
    }];
    _contentLabel = [YYLabel new];
    _contentLabel.textColor = kCellTitleTextColor;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _contentLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).with.offset(20);
        make.left.right.equalTo(self.line);
        make.height.mas_greaterThanOrEqualTo(240);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(160, 42));
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.mas_offset(0);
        make.centerX.equalTo(self);
    }];
    _contentLabel2 = [YYLabel new];
    _contentLabel2.textColor = kCellTitleTextColor;
    _contentLabel2.numberOfLines = 0;
    _contentLabel2.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _contentLabel2.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.contentLabel2];
    _contentLabel3 = [YYLabel new];
    _contentLabel3.textColor = kCellTitleTextColor;
    _contentLabel3.numberOfLines = 0;
    _contentLabel3.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _contentLabel3.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.contentLabel3];

}

- (void)drawContent:(NSString *)content {
    UIColor *color = self.contentColor ? self.contentColor : kCellTitleTextColor;
    if (self.helpStyle == CRFHelpViewStyleImageView) {
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tip01"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(0, 0, 25, 23);
        NSMutableAttributedString *attributed1 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
        NSString *string1 = @"总资产\n用户在信而富平台上拥有的计息中资产总额。";
        NSMutableAttributedString *attributedString = [CRFStringUtils setAttributedString:string1 lineSpace:10 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:16.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string1 rangeOfString:@"总资产"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range2:[string1 rangeOfString:@"用户在信而富平台上拥有的计息中资产总额。"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
        [attributedString appendAttributedString:attributed1];
        [self.contentLabel setAttributedText:attributedString];
        
        YYAnimatedImageView *imageView2 = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tip02"]];
        imageView2.contentMode = UIViewContentModeCenter;
        imageView2.frame = CGRectMake(0, 0, 25, 23);
        NSMutableAttributedString *attributed2 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView2 contentMode:UIViewContentModeCenter attachmentSize:imageView2.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
        NSString *string2 = @"可用余额\n用户可直接支配的金额。一般来说，用户进行充值后，资金会进入可用余额。出借计划完成结算后，本息也会进入可用余额。可用余额里的资金用户可提现到银行卡也可以继续出借。";
        NSMutableAttributedString *attributedString2 = [CRFStringUtils setAttributedString:string2 lineSpace:10 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:16.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string2 rangeOfString:@"可用余额"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range2:[string2 rangeOfString:@"用户可直接支配的金额。一般来说，用户进行充值后，资金会进入可用余额。出借计划完成结算后，本息也会进入可用余额。可用余额里的资金用户可提现到银行卡也可以继续出借。"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
        [attributedString2 appendAttributedString:attributed2];
        [self.contentLabel2 setAttributedText:attributedString2];
        
        YYAnimatedImageView *imageView3 = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tip03"]];
        imageView3.contentMode = UIViewContentModeCenter;
        imageView3.frame = CGRectMake(0, 0, 25, 23);
        NSMutableAttributedString *attributed3 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView3 contentMode:UIViewContentModeCenter attachmentSize:imageView3.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
        NSString *string3 = @"累计收益\n用户在平台上获得的历史出借计划收益总和。";
        NSMutableAttributedString *attributedString3 = [CRFStringUtils setAttributedString:string3 lineSpace:10 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:16.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string3 rangeOfString:@"累计收益"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range2:[string3 rangeOfString:@"用户在平台上获得的历史出借计划收益总和。"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
        [attributedString3 appendAttributedString:attributed3];
        [self.contentLabel3 setAttributedText:attributedString3];
    }else{
        [self.contentLabel setAttributedText:[CRFStringUtils setAttributedString:content lineSpace:10 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:color} range1:NSMakeRange(0, content.length) attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = _titleColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)show:(UIView *)view {
    [view addSubview:self.effectview];
    [self.effectview.contentView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.effectview);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    if (CGPointEqualToPoint(self.dissmissPoint, CGPointZero)) {
        self.effectview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 1;
            self.effectview.alpha = 1;
        }];
    } else {
        self.effectview.center = self.dissmissPoint;
        self.effectview.bounds = CGRectZero;
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 1;
            self.effectview.alpha = 1;
            self.effectview.center = view.center;
            self.effectview.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.helpStyle != CRFHelpViewStyleContainCancelBtn) {
        [self close];
    }
}

- (void)show:(UIView *)view dismissHandler:(void (^)(void))handler {
    self.dismissHandler = handler;
    [self show:view];
}

- (void)close {
    if (CGPointEqualToPoint(self.dissmissPoint, CGPointZero)) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = .0f;
            self.effectview.alpha = .0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.effectview removeFromSuperview];
            if (self.dismissHandler) {
                self.dismissHandler();
            }
        }];
    } else {
        [UIView animateWithDuration:.5 animations:^{
            self.effectview.center = self.dissmissPoint;
            self.effectview.bounds = CGRectZero;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.effectview removeFromSuperview];
            if (self.dismissHandler) {
                self.dismissHandler();
            }
        }];
    }
}

- (void)setHelpStyle:(CRFHelpViewStyle)helpStyle {
    _helpStyle = helpStyle;
    switch (_helpStyle) {
        case CRFHelpViewStyleOnlyContent: {
            self.closeButton.hidden = YES;
            self.titleLabel.hidden = YES;
            self.line.hidden = YES;
            self.contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
            self.contentLabel.textVerticalAlignment = NSTextAlignmentCenter;
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.left.equalTo(@(30));
                make.right.equalTo(@(-30));
                make.height.mas_greaterThanOrEqualTo(200);
            }];
            
        }
            break;
        case CRFHelpViewStyleContainTitleAndContext: {
             self.closeButton.hidden = YES;
        }
            break;
        case CRFHelpViewStyleIllustration: {
            
        }
            break;
        case CRFHelpViewStyleScrollIllustration: {
            
        }
            break;
        case CRFHelpViewStyleContainCancelBtn: {
            
        }
            break;
        case CRFHelpViewStyleImageView: {
            self.contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
            self.contentLabel.textVerticalAlignment = NSTextAlignmentCenter;
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.left.equalTo(@(30));
                make.right.equalTo(@(-30));
                make.top.equalTo(self.line.mas_bottom).with.offset(20);
            }];
            [self.contentLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.left.equalTo(@(30));
                make.right.equalTo(@(-30));
                make.top.equalTo(self.contentLabel.mas_bottom).with.offset(20);
            }];
            [self.contentLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.left.equalTo(@(30));
                make.right.equalTo(@(-30));
                make.top.equalTo(self.contentLabel2.mas_bottom).with.offset(20);
            }];
            
            self.closeButton.imageView.contentMode = UIViewContentModeCenter;
            [self.closeButton setImage:[UIImage imageNamed:@"mine_close_icon"] forState:UIControlStateNormal];
            [self.closeButton setTitle:@"" forState:UIControlStateNormal];
            [self.closeButton setTitle:@"" forState:UIControlStateSelected];
            
            [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(38, 38));
                make.bottom.mas_equalTo(80);
                make.centerX.equalTo(self);
            }];
        }
            break;
    }
}
@end
