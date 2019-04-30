//
//  CRFVerifyLoginView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/4/10.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFVerifyLoginView.h"

@interface CRFVerifyLoginView() <UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *errorMessageLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation CRFVerifyLoginView

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"提示";
        _titleLabel.textColor = kTextDefaultColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.text = @"验证登录密码后可关闭";
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.textColor = kCellTitleTextColor;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UILabel *)errorMessageLabel {
    if (!_errorMessageLabel) {
        _errorMessageLabel = [UILabel new];
        _errorMessageLabel.font = [UIFont systemFontOfSize:13];
        _errorMessageLabel.textColor = kRegisterButtonBackgroundColor;
        _errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorMessageLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.placeholder = @"请输入登录密码";
        _textField.tintColor = kButtonNormalBackgroundColor;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.secureTextEntry = YES;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateSelected];
        [_cancelButton setTitleColor:kTextDefaultColor forState:UIControlStateSelected];
        [_cancelButton setTitleColor:kTextDefaultColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelVerify) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton setTitle:@"验证" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"验证" forState:UIControlStateSelected];
        [_confirmButton setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateSelected];
        [_confirmButton setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmVerify) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.textField];
    [self addSubview:self.errorMessageLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
    [self layoutViews];
}

- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@20);
        make.height.mas_equalTo(16);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(14);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).with.offset(15);
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.height.mas_equalTo(44);
    }];
    [self.errorMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).with.offset(7);
        make.left.right.equalTo(self);
//        make.bottom.equalTo(self.cancelButton.mas_top).with.offset(-7);
        //        make.height.mas_lessThanOrEqualTo(34);
        make.height.mas_equalTo(@0);
        
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
//        make.height.mas_equalTo(46);
        make.top.equalTo(self.errorMessageLabel.mas_bottom).with.offset(7);
        make.width.mas_equalTo(274 / 2.0);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.equalTo(self.cancelButton);
        make.width.mas_equalTo(274 / 2.0);
    }];
    
    UIView *sLine = [UIView new];
    sLine.backgroundColor = kCellLineSeparatorColor;
    [self addSubview:sLine];
    [sLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.cancelButton.mas_top);
    }];
    UIView *vLine = [UIView new];
    vLine.backgroundColor = kCellLineSeparatorColor;
    [self addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(sLine.mas_bottom);
        make.width.mas_equalTo(1);
    }];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bgView];
    self.errorMessageLabel.text = nil;
    self.textField.text = nil;
    [self.bgView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).with.offset(225 * kWidthRatio);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(184);
    }];
    [self.errorMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (void)confirmVerify {
    if (self.confirmEvent) {
        self.confirmEvent(self.textField.text);
    }
}

- (void)cancelVerify {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:.3f animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(@kScreenHeight);
            make.width.mas_equalTo(275);
            make.height.mas_equalTo(184);
        }];
        [self.errorMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)showErrorMessage:(NSString *)errorMessage {
     self.errorMessageLabel.text = errorMessage;
    if (errorMessage && ![errorMessage isEmpty]) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(218);
        }];
        [self.errorMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(34);
        }];
    } else {
        [self.errorMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(184);
        }];
        
    }
    
   
//    [self layoutIfNeeded];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = nil;
    [self showErrorMessage:nil];
    return YES;
}



@end
