//
//  CRFRollOutViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRollOutViewController.h"
#import "CRFRecordViewController.h"
#import "CRFRollOutSuccessViewController.h"
#import "UIImage+Color.h"

@interface CRFRollOutViewController () <UITextFieldDelegate>

/**
 顶部银行卡信息文案
 */
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

/**
 金额输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

/**
 手续费
 */
@property (weak, nonatomic) IBOutlet UILabel *procedureLabel;

/**
 到账金额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/**
 验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

/**
 验证码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/**
 验证码定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 倒计时时间
 */
@property (nonatomic, assign) NSUInteger count;

/**
 提现按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rolloutButton;

/**
 是否提现成功
 */
@property (nonatomic, assign) BOOL rollOutSuccess;
@end

@implementation CRFRollOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightBarButton];
    self.rolloutButton.enabled = NO;
    self.count = 60;
    [self.inputTextField setValue:UIColorFromRGBValue(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    UILabel *placeholderLabel = [self.inputTextField valueForKey:@"_placeholderLabel"];
    placeholderLabel.minimumScaleFactor = .3f;
    placeholderLabel.adjustsFontSizeToFitWidth = YES;
    [self.inputTextField setValue:[UIFont systemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
    self.navigationItem.title = NSLocalizedString(@"title_roll_out", nil);
    [self setPromptInfo];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:self.inputTextField];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    // Do any additional setup after loading the view from its nib.
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (IBAction)allIn:(id)sender {
    if ([self.avaibleMoney calculateWithHighPrecision].longLongValue <= 0) return;
    self.inputTextField.text = self.avaibleMoney;
    NSString *string = [NSString stringWithFormat:@"%.2f",([self calculateWithHighPrecisionWithInput:self.inputTextField.text] - 1.0)];
    if ([string doubleValue] <= .0f) {
        self.moneyLabel.text = NSLocalizedString(@"label_default_money", nil);
        return;
    }
    self.moneyLabel.text = [string formatMoney];
}

- (IBAction)sendCode:(id)sender {
    if ([self.inputTextField.text isEmpty]) {
        [CRFUtils showMessage:@"toast_input_money_after_send_code"];
        return;
    }
    [self.view endEditing:YES];
    self.codeButton.userInteractionEnabled = NO;
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendTransformVerifyCodePath),kUuid] paragrams:@{kMobilePhone:[CRFAppManager defaultManager].userInfo.phoneNo,kIntent:@"8",@"type":@"0",@"picCode":@""} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
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

- (void)rightBarButton {
    UIImage *image = [UIImage imageNamed:@"rollout_record"];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rolloutRecord)];
}

- (void)rolloutRecord {
    CRFRecordViewController *controller = [CRFRecordViewController new];
    controller.selectedIndex = 1;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)textFieldDidChanged:(NSNotification *)notification {
    UITextField *tf = notification.object;
    if (self.inputTextField.text.length > 0 && self.codeTextField.text.length > 0) {
        self.rolloutButton.enabled = YES;
    } else {
        self.rolloutButton.enabled = NO;
    }
    if (tf == self.inputTextField) {
        if ([self getAvaibleMoney:tf.text] > [self getAvaibleMoney:self.avaibleMoney]) {
            tf.text = self.avaibleMoney;
        }
        NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[tf.text getOriginString]];
        NSString *string = [NSString stringWithFormat:@"%.2f",(decimalNumber.doubleValue - 1.0)];
        if ([string doubleValue] <= .0f) {
            self.moneyLabel.text = NSLocalizedString(@"label_default_money", nil);
            return;
        }
        self.moneyLabel.text = [string formatMoney];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.inputTextField.text = nil;
    self.moneyLabel.text = nil;
    self.codeTextField.text = nil;
    self.avaibleMoney = [CRFAppManager defaultManager].accountInfo.availableBalance;
    [self setPlaceholderInfo];
}

- (void)setPromptInfo {
    NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"label_roll_out_prompt", nil),self.bankInfo];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attributed addAttribute:NSForegroundColorAttributeName value:kLinkTextColor range:[totalString rangeOfString:self.bankInfo]];
    [attributed addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x999999) range:NSMakeRange(0, totalString.length - self.bankInfo.length)];
    [self.promptLabel setAttributedText:attributed];
}

- (void)setPlaceholderInfo {
    NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"label_roll_out_variable_money", nil),[self.avaibleMoney formatMoney]];
    self.inputTextField.placeholder = totalString;
    if ([[self.avaibleMoney getOriginString] doubleValue] <= .0f) {
        self.rolloutButton.enabled = NO;
        return;
    }
    //    self.rolloutButton.enabled = YES;
}

- (IBAction)rollout:(id)sender {
    [self.view endEditing:YES];
    if ([[self.moneyLabel.text getOriginString] doubleValue] <= 0) {
        [CRFUtils showMessage:@"toast_roll_out_money_error"];
        return;
    }
    if (self.inputTextField.text.length <= 0) {
        [CRFUtils showMessage:@"toast_input_rollout_money"];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [CRFUtils showMessage:@"toast_input_verify_code"];
        return;
    }
    if (self.codeTextField.text.length != 6) {
        [CRFUtils showMessage:@"toast_verify_code_validate"];
        return;
    }
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kDrawPath),kUuid] paragrams:@{@"amount":[self.inputTextField.text calculateWithHighPrecision],@"validateCode":self.codeTextField.text,@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        strongSelf.rollOutSuccess = YES;
        [strongSelf.navigationController pushViewController:[CRFRollOutSuccessViewController new] animated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.codeTextField) {
        if (newText.length > 6) {
            return NO;
        }
    } else {
        if (textField.text.length == 0 && ([string isEqualToString:@"."] || [string isEqualToString:@"0"])) {
            return NO;
        }
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        }
        NSArray <NSString *>*array = [textField.text componentsSeparatedByString:@"."];
        if (array.count > 1) {
            NSString *str = [array lastObject];
            if (str.length >= 2 && string.length > 0) {
                return NO;
            }
        }
    }
    return YES;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.rollOutSuccess) {
        self.avaibleMoney = [NSString stringWithFormat:@"%.2lld",[self getAvaibleMoney:self.avaibleMoney] - [self getAvaibleMoney:self.inputTextField.text]];
    }
    [self stopTimer];
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (long long)getAvaibleMoney:(NSString *)money {
    if ([money isEmpty]) {
        return 0;
    }
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[money getOriginString]];
    NSDecimalNumber *mutableDecimalNumber = [decimalNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1"]];
    return mutableDecimalNumber.longLongValue;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (double)calculateWithHighPrecisionWithInput:(NSString *)inputString {
    NSString *formatString = [inputString getOriginString];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:formatString];
    return decimalNumber.doubleValue;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

