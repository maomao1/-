//
//  CRFEvaluationView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFEvaluationView.h"

@interface CRFEvaluationView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *evaluationButton;

@end

@implementation CRFEvaluationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _blackView = [UIView new];
    _blackView.alpha = 0;
    _blackView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.4f];
    [_blackView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.blackView);
        make.size.mas_equalTo(CGSizeMake(275 * kWidthRatio, 250 * kWidthRatio));
    }];
    _titleLabel = [UILabel new];
    _titleLabel.text = @"尊敬的用户：";
    [self addSubview:self.titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor = UIColorFromRGBValue(0x333333);
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.textColor = UIColorFromRGBValue(0x666666);
    _contentLabel.text = @"您需完成《投资风险承受能力测评》";
    _contentLabel.minimumScaleFactor = .8f;
    _contentLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.contentLabel];
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invest_popup_img"]];
    [self addSubview:self.imageView];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_cancelButton setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 5.0f;
    _cancelButton.layer.borderWidth = 1.0f;
    _cancelButton.layer.borderColor = kBtnEnableBgColor.CGColor;
    [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    _evaluationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _evaluationButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_evaluationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _evaluationButton.layer.masksToBounds = YES;
    _evaluationButton.layer.cornerRadius = 5.0f;
    _evaluationButton.layer.borderWidth = 1.0f;
    [_evaluationButton setTitle:@"去测评" forState:UIControlStateNormal];
    _evaluationButton.layer.borderColor = (kButtonNormalBackgroundColor).CGColor;
    [_evaluationButton setBackgroundColor:kButtonNormalBackgroundColor];
     [_evaluationButton addTarget:self action:@selector(evaluationClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.evaluationButton];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(110 * kWidthRatio);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(20 * kWidthRatio);
        make.left.equalTo(self).with.offset(20 * kWidthRatio);
        make.right.equalTo(self).with.offset(-20 * kWidthRatio);
        make.height.mas_equalTo(16 * kWidthRatio);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10 * kWidthRatio);
        make.height.mas_equalTo(14.0f * kWidthRatio);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(20 * kWidthRatio);
        make.left.equalTo(self).with.offset(20 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(105 * kWidthRatio, 40 * kWidthRatio));
    }];
    [self.evaluationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelButton);
        make.right.equalTo(self).with.offset(-20 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(105 * kWidthRatio, 40 * kWidthRatio));
    }];
}

- (void)evaluationClick {
     [self removePopView];
    if (self.clickHandler) {
        self.clickHandler(1);
    }
}

- (void)cancelClick {
    [self removePopView];
    if (self.clickHandler) {
        self.clickHandler(0);
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    [UIView animateWithDuration:.1f animations:^{
        self.blackView.alpha = 1;
    }];
}

- (void)removePopView {
    [UIView animateWithDuration:.1f animations:^{
        self.blackView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
    }];
}

@end
