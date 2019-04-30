//
//  CRFRegisterTableViewCell.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRegisterTableViewCell.h"

@interface CRFRegisterTableViewCell()

@property (nonatomic, strong) UIButton *secretButton;

@end

@implementation CRFRegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textField setValue:UIColorFromRGBValue(0xBBBBBB) forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont boldSystemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self addCodeView];
    [self addSecretButton];
}

- (void)addSecretButton {
    _secretButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.secretButton];
    self.secretButton.imageView.contentMode = UIViewContentModeCenter;
    [self.secretButton addTarget:self action:@selector(secret:) forControlEvents:UIControlEventTouchUpInside];
    [self.secretButton setImage:[UIImage imageNamed:@"unsecret"] forState:UIControlStateNormal];
    [self.secretButton setImage:[UIImage imageNamed:@"secret"] forState:UIControlStateSelected];
    [self.secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).with.offset(-kRegisterSpace);
        make.width.mas_equalTo(30);
    }];
}

- (void)addCodeView {
    _verifyCodeView = [[CRFVerifyCodeView alloc] init];
    [self addSubview:self.verifyCodeView];
    _verifyCodeView.hidden = YES;
    [self.verifyCodeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(27);
    }];
    [_verifyCodeView initialTitle:NSLocalizedString(@"button_verify_normal_title", nil)];
    [_verifyCodeView titleNormalColor:UIColorFromRGBValue(0xF5A623) disableColor:UIColorFromRGBValue(0xBBBBBB)];
    [_verifyCodeView sendingTitle:NSLocalizedString(@"button_re_get_verify_code", nil)];
    [_verifyCodeView resetTitle:NSLocalizedString(@"button_verify_normal_title", nil)];
}

- (void)setType:(CellType)type {
    _type = type;
    if (_type == Verify) {
        self.verifyCodeView.hidden = NO;
        self.secretButton.hidden = YES;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-kButtonWidth);
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(kRegisterSpace);
        }];
    } else if (_type == Normal){
        self.secretButton.hidden = YES;
        self.verifyCodeView.hidden = YES;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-kRegisterSpace);
             make.top.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(kRegisterSpace);
        }];
    } else {
        self.verifyCodeView.hidden = YES;
        self.textField.secureTextEntry = YES;
        self.secretButton.hidden = self.hiddenSecret;
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(kRegisterSpace);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.secretButton.mas_left).with.offset(-kRegisterSpace / 2);
        }];
    }
}

- (void)setHiddenSecret:(BOOL)hiddenSecret {
    _hiddenSecret = hiddenSecret;
    self.secretButton.hidden = _hiddenSecret;
}

- (void)secret:(UIButton *)button {
    self.secretButton.selected = !self.secretButton.selected;
    self.textField.secureTextEntry = !self.secretButton.selected;
    if (self.updateTextFieldHandler) {
        self.updateTextFieldHandler(self.textField.secureTextEntry);
    }
}

- (void)configCell:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
