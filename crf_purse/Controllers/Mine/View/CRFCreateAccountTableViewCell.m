//
//  CRFCreateAccountTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCreateAccountTableViewCell.h"
#import "UIButton+CRFRepeatClick.h"
@interface CRFCreateAccountTableViewCell()

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIButton *button;


@end

@implementation CRFCreateAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.textColor = UIColorFromRGBValue(0x666666);
        [self config];
        [self.textField setValue:UIColorFromRGBValue(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [self.textField setValue:[UIFont systemFontOfSize:13.0f] forKeyPath:@"_placeholderLabel.font"];
    }
    return self;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        [_rightView addSubview:self.button];
        [_rightView addSubview:self.codeBtn];
        _rightView.userInteractionEnabled = YES;
    }
    return _rightView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _button.crf_acceptEventInterval = 0.3;
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
-(CRFButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [CRFButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _codeBtn.crf_acceptEventInterval = 0.3;
        [_codeBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}
- (void)config {
    _textField = [[CRFBankNoTextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:15.0];
    _textField.textColor = UIColorFromRGBValue(0x333333);
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(90);
        make.top.right.bottom.equalTo(self);
    }];
}

- (void)updateWithTitle:(NSString *)title {
    CGFloat width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) fontNumber:15.0].width;
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace + 20 + width);
    }];
}

- (void)setRightViewStyle:(RightViewStyle)rightViewStyle {
    _rightViewStyle = rightViewStyle;
    self.button.frame = CGRectZero;
    self.codeBtn.frame = CGRectZero;
    switch (_rightViewStyle) {
        case Help: {
            self.textField.enabled = YES;
            self.textField.rightView = self.rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.rightView.frame = CGRectMake(0, 0, 40, 51);
            self.button.imageView.contentMode = UIViewContentModeCenter;
            [self.button setTitle:nil forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"relate_account_icon_help"] forState:UIControlStateNormal];
            self.button.frame = CGRectMake(40 - kSpace - 16, (51 - 16) / 2, 16, 16);
            self.button.layer.borderWidth = .0f;
        }
            break;
        case Verify: {
            self.textField.enabled = YES;
            self.textField.rightView = self.rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.rightView.frame = CGRectMake(0, 0, 40, 51);
            self.button.imageView.contentMode = UIViewContentModeCenter;
            [self.button setTitle:nil forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"relate_account_icon_help"] forState:UIControlStateNormal];
            self.button.frame = CGRectMake(40 - kSpace - 16, (51 - 16) / 2, 16, 16);
            self.button.layer.borderWidth = .0f;
        }
            break;
        case PhoneNumber: {
            self.textField.enabled = YES;
            self.textField.rightView = self.rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.rightView.frame = CGRectMake(0, 0, 40, 51);
            self.button.imageView.contentMode = UIViewContentModeCenter;
            [self.button setTitle:nil forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"coupon_help"] forState:UIControlStateNormal];
            self.button.frame = CGRectMake(40 - kSpace - 20, (51 - 20) / 2, 20, 20);
            self.button.layer.borderWidth = .0f;
        }
            break;
        case List: {
            self.textField.enabled = YES;
            self.textField.rightView = self.rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.rightView.frame = CGRectMake(0, 0, 102, 51);
            self.button.frame = CGRectMake(kSpace, 12, 72, 27);
            [self.button setBackgroundImage:nil forState:UIControlStateNormal];
            [self.button setTitle:NSLocalizedString(@"button_bankcard_list", nil) forState:UIControlStateNormal];
            UIColor *color = kButtonBorderNormalBackgroundColor;
            [self.button setTitleColor:color forState:UIControlStateNormal];
            self.button.layer.masksToBounds = YES;
            self.button.layer.cornerRadius = 27.0 / 2;
            self.button.layer.borderColor = color.CGColor;
            self.button.layer.borderWidth = 1.0f;
        }
            break;
        case CodeValue: {
            self.textField.enabled = YES;
            self.textField.rightView = self.rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.rightView.frame = CGRectMake(0, 0, 115, 51);
            self.codeBtn.frame = CGRectMake(kSpace, 12, 90, 27);
            UIColor *color = kRegisterButtonBackgroundColor;
            [self.codeBtn setTitleColor:color forState:UIControlStateNormal];
            self.codeBtn.layer.masksToBounds = YES;
            self.codeBtn.layer.cornerRadius = 3.0;
            self.codeBtn.layer.borderColor = color.CGColor;
            self.codeBtn.layer.borderWidth = 1.0f;
        }
            break;
        case Modify: {
            self.textField.enabled = YES;
            self.textField.rightView = self.rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.rightView.frame = CGRectMake(0, 0, 46 + kSpace * 2, 51);
            self.button.frame = CGRectMake(kSpace, 12, 46, 27);
            [self.button setBackgroundImage:nil forState:UIControlStateNormal];
            [self.button setTitle:NSLocalizedString(@"button_modify", nil) forState:UIControlStateNormal];
            [self.button setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
            self.button.layer.masksToBounds = YES;
            self.button.layer.cornerRadius = 27.0 / 2;
            self.button.layer.borderColor = UIColorFromRGBValue(0x999999).CGColor;
            self.button.layer.borderWidth = 1.0f;
            
        }
            break;
        case Default: {
            self.textField.enabled = NO;
            self.textField.rightView = nil;
        }
            break;
        case CanEdit: {
            self.textField.enabled = YES;
            self.textField.rightView = nil;
        }
            break;
        default:
            break;
    }
}

- (void)buttonClick {
    if (self.rightHandler) {
        self.rightHandler(self.rightViewStyle);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
