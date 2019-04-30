//
//  CRFFeedbackViewController.m
//  crf_purse
//
//  Created by crf on 2017/6/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFFeedbackViewController.h"
#import "CRFTextView.h"
#import "CRFAlertUtils.h"

@interface CRFFeedbackViewController ()
@property (weak, nonatomic) IBOutlet CRFTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation CRFFeedbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIStyle];
    [self backBarbuttonForBlack];
    self.navigationItem.title = NSLocalizedString(@"title_feedback", nil);
    [self addObserver];
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = UIColorFromRGBValue(0xcccccc);
}

- (void)setUIStyle{
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.layer.cornerRadius = 5.0f;
    self.textView.maxTextLength = 300;
    self.textView.placeholder   = NSLocalizedString(@"placeholder_feedback", nil);
}

- (void)back {
    if (self.textView.text.length > 0 || ![self.contactTextField.text isEmpty]) {
        weakSelf(self);
        [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_title_give_up_feedback", nil) message:nil container:self cancelTitle:NSLocalizedString(@"alert_view_button_give_up", nil) confirmTitle:NSLocalizedString(@"alert_view_button_feedback_continue", nil) cancelHandler:^{
//            [super back];
            strongSelf(weakSelf);
             [strongSelf.navigationController popViewControllerAnimated:YES];
        } confirmHandler:nil];
        return;
    }
    [super back];
}

- (void)addObserver {
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textViewContentDidChanged:) name:UITextViewTextDidChangeNotification object:self.textView];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldContentDidChanged:) name:UITextFieldTextDidChangeNotification object:self.contactTextField];
}

- (void)commitButtonEnable {
    if (self.textView.text.length > 0 && ![self.contactTextField.text isEmpty]) {
        self.commitButton.enabled = YES;
        self.commitButton.backgroundColor =kButtonNormalBackgroundColor;
    } else {
        self.commitButton.enabled = NO;
        self.commitButton.backgroundColor = kBtnEnableBgColor;
    }
}

- (void)textViewContentDidChanged:(NSNotification *)notification {
    [self commitButtonEnable];
}

- (void)textFieldContentDidChanged:(NSNotification *)notification {
    [self commitButtonEnable];
}

- (IBAction)commit:(id)sender {
    [self.view endEditing:YES];
    self.contactTextField.text = [self.contactTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.contactTextField.text isEmailAddress] || [self.contactTextField.text validatePhoneNumber]) {
        weakSelf(self)
        [CRFLoadingView loading];
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kFeedbackPath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:@{@"content":self.textView.text,@"contact":self.contactTextField.text} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
                [CRFUtils showMessage:@"toast_feedback_success"];
                [CRFUtils delayAfert:kToastDuringTime handle:^{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }];
        } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
             [CRFLoadingView dismiss];
            [CRFUtils showMessage:response[kMessageKey]];
        }];
        return;
    }
    if (!self.contactTextField.text.length) {
        [CRFUtils showMessage:@"toast_feedback_contact_null"];
        return;
    }
    [CRFUtils showMessage:@"toast_feedback_contact_validate"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [CRFNotificationUtils removeObserver:self];
    DLog(@"%@ dealloc.", NSStringFromClass([self class]));
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
