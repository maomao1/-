//
//  CRFRedeemView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRedeemView.h"
#import "CRFStringUtils.h"
#import "CRFControllerManager.h"

static CGFloat const kViewHeight = 207;

@interface CRFRedeemView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) UIView *rootView;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) BOOL updateFrame;
@end

@implementation CRFRedeemView

- (void)setAccountAmount:(NSString *)accountAmount {
    _accountAmount = accountAmount;
    NSString *string = [NSString stringWithFormat:@"退出金额:%@元",_accountAmount];
    [self.moneyLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"退出金额:"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[string rangeOfString:_accountAmount] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[string rangeOfString:@"元"] attributes4:nil range4:NSRangeZero]];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.4];
    }
    return _blackView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.codeTextField.delegate = self;
    self.count = 60;
     [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification];
}

- (IBAction)sendCodeClick:(id)sender {
    self.codeButton.userInteractionEnabled = NO;
    [self sendCode];
}

- (IBAction)logout:(id)sender {
    if (!self.flag) {
        [CRFUtils showMessage:@"请先发送验证码"];
        return;
    }
    if ([self.codeTextField.text isEmpty]) {
         [CRFUtils showMessage:@"请输入验证码"];
        return;
    }
    if (self.codeTextField.text.length != 6) {
         [CRFUtils showMessage:@"验证码格式有误"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(ransom:)]) {
        [self.delegate ransom:self.codeTextField.text];
    }
}

- (IBAction)close:(id)sender {
    [self.rootView endEditing:YES];
    [self hidden];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)addView:(UIView *)view {
    self.rootView = view;
    self.frame = CGRectMake(0, [self getWindowY], CGRectGetWidth(self.rootView.frame), kViewHeight);
    [view addSubview:self];
}

- (void)show {
    self.updateFrame = YES;
    [self stopTimer];
    self.codeTextField.text = nil;
    [self.rootView addSubview:self.blackView];
    [self.rootView bringSubviewToFront:self];
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(0, [self getWindowY] - kViewHeight, CGRectGetWidth(self.rootView.frame), kViewHeight);
    }];
}

- (void)hidden {
    self.updateFrame = NO;
    [self.blackView removeFromSuperview];
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(0, [self getWindowY], CGRectGetWidth(self.rootView.frame), kViewHeight);
    }];
}

- (void)sendCode {
    self.flag = YES;
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendTransformVerifyCodePath),kUuid] paragrams:@{kMobilePhone:[CRFAppManager defaultManager].userInfo.phoneNo,kIntent:@"6",@"type":@"0",@"picCode":@""} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        strongSelf.codeButton.userInteractionEnabled = YES;
        [CRFUtils showMessage:@"toast_send_verify_code"];
        [strongSelf.codeButton setTitleColor:UIColorFromRGBValue(0xBBBBBB) forState:UIControlStateNormal];
        strongSelf.codeButton.layer.borderColor = UIColorFromRGBValue(0xBBBBBB).CGColor;
        [strongSelf.timer setFireDate:[NSDate distantPast]];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        strongSelf.codeButton.userInteractionEnabled = YES;
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)dealloc {
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
     [CRFNotificationUtils removeObserver:self];
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (void)timerHandler {
    _count --;
    if (self.count == 0) {
        [self stopTimer];
    } else {
        [self.codeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"button_re_get_verify_code", nil),(unsigned long)self.count] forState:UIControlStateNormal];
    }
}

- (void)stopTimer {
    self.codeButton.userInteractionEnabled = YES;
    [self.codeButton setTitle:NSLocalizedString(@"button_get_verify_code", nil) forState:UIControlStateNormal];
    _count = 60;
    [self.codeButton setTitleColor:UIColorFromRGBValue(0xFBB203) forState:UIControlStateNormal];
    self.codeButton.layer.borderColor = UIColorFromRGBValue(0xFBB203).CGColor;
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect rect = [textField.superview convertRect:textField.frame toView:self.rootView];
    if (kScreenHeight - rect.origin.y - rect.size.height < 216) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame = CGRectMake(0, [self getWindowY] - kViewHeight - 168, CGRectGetWidth(self.rootView.frame), kViewHeight);
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0, [self getWindowY] - kViewHeight, CGRectGetWidth(self.rootView.frame), kViewHeight);
    }];
    return YES;
}

- (CGFloat)getWindowY {
    if (kScreenWidth == 320) {
        return CGRectGetHeight(self.rootView.frame);
    }
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

- (void)keyboardShow:(NSNotification *)notification {
    if (!self.updateFrame) {
        return;
    }
    CGFloat keybaordHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITextField *textField = self.codeTextField;
    CGRect rect = [self convertRect:textField.frame toView:self.blackView];
    if (kScreenHeight - rect.origin.y - rect.size.height < keybaordHeight) {
       self.frame = CGRectMake(0, kScreenHeight - (kViewHeight - 50) - keybaordHeight, CGRectGetWidth(self.rootView.frame), kViewHeight);
    }
    DLog(@"keyboard show is %@",[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]);
}

@end
