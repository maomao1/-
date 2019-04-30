//
//  CRFChangeMBView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFChangeMBView.h"
#import "CRFBasicView.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface CRFChangeMBView() <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *MBTextField;
@property (nonatomic, strong) UILabel *voiveTextView;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CRFBasicView *blackView;
@property (nonatomic, strong) UIWindow *rootWindow;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) BOOL linkEnable;

@end

@implementation CRFChangeMBView

- (UIImageView *)closeImageView {
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close_change_MB"]];
        _closeImageView.userInteractionEnabled = YES;
        [_closeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelf)]];
    }
    return _closeImageView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 12.0;
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEidt)]];
    }
    return _bgView;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [CRFBasicView new];
        _blackView.backgroundColor = [UIColor colorWithWhite:.0 alpha:0.5];
        _blackView.userInteractionEnabled = YES;
    }
    return _blackView;
}

- (UIWindow *)rootWindow {
    if (!_rootWindow) {
        _rootWindow = [UIApplication sharedApplication].delegate.window;
    }
    return _rootWindow;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.text = NSLocalizedString(@"label_changed_mobile_phone", nil);
    }
    return _titleLabel;
}

- (UITextField *)MBTextField {
    if (!_MBTextField) {
        _MBTextField = [UITextField new];
        _MBTextField.delegate = self;
        _MBTextField.borderStyle = UITextBorderStyleRoundedRect;
        _MBTextField.font = [UIFont systemFontOfSize:16.0f];
        _MBTextField.placeholder = NSLocalizedString(@"placeholder_input_mobile_phone", nil);
        _MBTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.codeButton setTitle:NSLocalizedString(@"button_get_verify_code", nil) forState:UIControlStateNormal];
        [self.codeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
        self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self.codeButton setTitleColor:UIColorFromRGBValue(0xFBB203) forState:UIControlStateNormal];
        [rightView addSubview:self.codeButton];
        self.codeButton.frame = rightView.frame;
        _MBTextField.rightView = rightView;
        _MBTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _MBTextField;
}

- (UILabel *)voiveTextView {
    if (!_voiveTextView) {
        _voiveTextView = [UILabel new];
        _voiveTextView.userInteractionEnabled = YES;
        _voiveTextView.font = [UIFont systemFontOfSize:10.0];
        _voiveTextView.enabledTapEffect = NO;
    }
    return _voiveTextView;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.delegate = self;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.borderStyle = UITextBorderStyleRoundedRect;
        _codeTextField.placeholder = NSLocalizedString(@"placeholder_verify_code", nil);
        _codeTextField.font = [UIFont systemFontOfSize:16.0f];
    }
    return _codeTextField;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:NSLocalizedString(@"button_commit", nil) forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 5;
        _commitButton.backgroundColor = kRegisterButtonBackgroundColor;
        [_commitButton addTarget:self action:@selector(commitCode) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _commitButton;
}

- (void)commitCode {
    if ([self validateMB]) {
        if (self.codeTextField.text.length < 6) {
            [CRFUtils showMessage:@"验证码不合法"];
            return;
        }
    } else {
        return;
    }
    [self closeSelf];
    if (self.commitHandler) {
        self.commitHandler(self.codeTextField.text, self.MBTextField.text);
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self configUI];
        [self layoutViews];
        [self configText];
    }
    return self;
}

- (void)configUI {
    [self.blackView addSubview:self.bgView];
    [self.bgView addSubview:self.closeImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.MBTextField];
    [self.bgView addSubview:self.voiveTextView];
    [self.bgView addSubview:self.codeTextField];
    [self.bgView addSubview:self.commitButton];
}

- (void)layoutViews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.blackView.mas_centerX);
        make.top.equalTo(self.blackView).with.offset(216 * kHeightRatio);
        make.size.mas_equalTo(CGSizeMake(275, 269));
    }];
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).with.offset(-kSpace);
        make.top.equalTo(self.bgView).with.offset(kSpace);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).with.offset(20);
        make.height.mas_equalTo(18);
    }];
    [self.MBTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(20);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(44);
    }];
    [self.voiveTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(kSpace);
        make.top.equalTo(self.MBTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.bgView);
        make.height.mas_equalTo(15);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(20);
        make.top.equalTo(self.voiveTextView.mas_bottom).with.offset(20);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom).with.offset(20);
        make.height.mas_equalTo(40);
        make.left.right.equalTo(self.codeTextField);
    }];
}

- (void)show {
    self.codeTextField.text = nil;
    self.MBTextField.text = nil;
    [self stopTimer];
    _count = 60;
    [CRFUtils getMainQueue:^{
        [self.rootWindow addSubview:self.blackView];
        [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.rootWindow);
        }];
    }];
}

- (void)closeSelf {
    [self.blackView removeFromSuperview];
}

- (void)configText {
    [self setTextColorEnable:YES];
}

- (void)setTextColorEnable:(BOOL)enable {
    self.linkEnable = enable;
    NSString *totalString = NSLocalizedString(@"label_prompt_not_receive", nil);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (!enable) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:NSMakeRange(0, totalString.length)];
        [self.voiveTextView setAttributedText:attributedString];
        return;
    }
    [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[totalString rangeOfString:NSLocalizedString(@"label_voice_verify", nil)]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[totalString rangeOfString:NSLocalizedString(@"label_prompt_not_receive_sub", nil)]];
    [self.voiveTextView setAttributedText:attributedString];
    weakSelf(self);
    [self.voiveTextView yb_addAttributeTapActionWithStrings:@[NSLocalizedString(@"label_voice_verify", nil)] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        DLog(@"=======");
        strongSelf(weakSelf);
        if (!strongSelf.linkEnable) {
            return ;
        }
        if ([strongSelf validateMB]) {
            [CRFLoadingView loading];
            strongSelf.codeButton.userInteractionEnabled = NO;
            [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendTransformVerifyCodePath),kUuid] paragrams:@{kMobilePhone:strongSelf.MBTextField.text,kIntent:@"9",@"type":@"1",@"picCode":@""} success:^(CRFNetworkCompleteType errorType, id response) {
                [CRFLoadingView dismiss];
                [CRFUtils showMessage:@"toast_voice_code_send_success"];
                [strongSelf paserResponse:response];
            } failed:^(CRFNetworkCompleteType errorType, id response) {
                [CRFLoadingView dismiss];
                strongSelf.codeButton.userInteractionEnabled = YES;
                [CRFUtils showMessage:response[kMessageKey]];
            }];
        }
    }];
}

- (BOOL)validateMB {
    if ([self.MBTextField.text isEmpty]) {
        [CRFUtils showMessage:@"toast_phone_number_not_null"];
        return NO;
    }
    if (![self.MBTextField.text validatePhoneNumber]) {
        [CRFUtils showMessage:@"toast_error_number"];
        return NO;
    }
    return YES;
}

- (void)sendCode {
    [self.bgView endEditing:YES];
    if ([self validateMB]) {
        self.codeButton.userInteractionEnabled = NO;
        weakSelf(self);
        [CRFLoadingView loading];
        [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendTransformVerifyCodePath),kUuid] paragrams:@{kMobilePhone:self.MBTextField.text,kIntent:@"9",@"type":@"0",@"picCode":@""} success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            [CRFUtils showMessage:@"toast_send_verify_code"];
            [strongSelf paserResponse:response];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            strongSelf.codeButton.userInteractionEnabled = YES;
            [CRFUtils showMessage:response[kMessageKey]];
        }];
    }
}

- (void)paserResponse:(id)response {
    [self.codeButton setTitleColor:UIColorFromRGBValue(0xBBBBBB) forState:UIControlStateNormal];
    [self setTextColorEnable:NO];
    [self.timer setFireDate:[NSDate distantPast]];
}

#pragma mark ----
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect rect = [textField.superview convertRect:textField.frame toView:self.blackView];
    if (kScreenHeight - rect.origin.y - rect.size.height < 216) {
        [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rootWindow).with.offset((kScreenHeight - rect.origin.y - rect.size.height - 216));
        }];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.MBTextField) {
        if (newText.length > 11) {
            return NO;
        }
    } else {
        if (newText.length > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)timerHandler {
    _count --;
    if (self.count == 0) {
        [self stopTimer];
    } else {
        [self.codeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"button_re_get_verify_code", nil),self.count] forState:UIControlStateNormal];
    }
}

- (void)stopTimer {
    self.codeButton.userInteractionEnabled = YES;
    [self.codeButton setTitle:NSLocalizedString(@"button_get_verify_code", nil) forState:UIControlStateNormal];
    _count = 60;
    [self.codeButton setTitleColor:UIColorFromRGBValue(0xFBB203) forState:UIControlStateNormal];
    [self setTextColorEnable:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)dealloc {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (void)endEidt {
    [self.bgView endEditing:YES];
    [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootWindow);
    }];
}
@end
