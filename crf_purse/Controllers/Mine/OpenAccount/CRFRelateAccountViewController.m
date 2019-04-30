//
//  CRFRelateAccountViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRelateAccountViewController.h"
#import "CRFRelateAccountStatusViewController.h"
#import "CRFAlertUtils.h"
#import "CRFMessageVerifyViewController.h"

@interface CRFRelateAccountViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end

@implementation CRFRelateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_relate_account_success", nil);
    [self setPromptText];
    // Do any additional setup after loading the view from its nib.
}

- (void)setPromptText {
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"label_relate_account_prompt", nil),self.relatePhone];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributed addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range:NSMakeRange(0, string.length)];
    [attributed addAttribute:NSForegroundColorAttributeName value:kLinkTextColor range:[string rangeOfString:self.relatePhone]];
    [self.promptLabel setAttributedText:attributed];
}


- (IBAction)verifyUser:(id)sender {
    [self.view endEditing:YES];
    if ([self.userNameTextField.text isEmpty]) {
        [CRFUtils showMessage:@"toast_input_real_name"];
        return;
    }
    if ([self.userIdTextField.text isEmpty]) {
        [CRFUtils showMessage:@"toast_input_identifier"];
        return;
    }
    if (![self.userIdTextField.text validateIdentityCard]) {
        [CRFUtils showMessage:@"toast_valide_identifier"];
        return;
    }
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"alert_view_verify_relate_user_info", nil),self.userNameTextField.text,self.userIdTextField.text];
    [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_view_title_verify_user", nil) contentLeftMessage:string container:self cancelTitle:NSLocalizedString(@"alert_view_button_cancel", nil) confirmTitle:NSLocalizedString(@"alert_view_button_verify", nil) cancelHandler:nil confirmHandler:^{
        weakSelf(self);
        [CRFLoadingView loading];
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kRelateAccountPath),kUuid] paragrams:@{@"userName":self.userNameTextField.text,@"idNo":self.userIdTextField.text,@"phoneNo":self.relatePhone} success:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            strongSelf(weakSelf);
            if (![response[kResult] isEqualToString:kSuccessResultStatus]) {
                 [CRFUtils showMessage:response[kMessageKey]];
                return ;
            }
            [CRFUtils showMessage:@"toast_relate_account_success"];
            [CRFAPPCountManager setEventID:@"ASSOCIATED_ACCOUNT_EVENT" EventName:@"关联账户成功"];
            [CRFUtils delayAfert:kToastDuringTime handle:^{
                [CRFUtils delayAfert:kToastDuringTime handle:^{
                    [strongSelf parseResponseStatus:response];
//                    [strongSelf.navigationController pushViewController:[CRFRelateAccountStatusViewController new] animated:YES];
//                    CRFMessageVerifyViewController *verifyVc = [CRFMessageVerifyViewController new];
//                    verifyVc.ResultType = RelateResult;
//                    [strongSelf.navigationController pushViewController:verifyVc animated:YES];
                }];
            }];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            if ([response[@"code"] isEqualToString:@"FUS_4009"]) {
                strongSelf(weakSelf);
                NSString *desMessges = [NSString stringWithFormat:NSLocalizedString(@"alert_view_message_relate_failed", nil),strongSelf.relatePhone];
                [CRFAPPCountManager setFailedEventID:@"open_account_failed" reason:[NSString stringWithFormat:@"关联失败：%@",desMessges] productNo:@""];
                [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_view_title_relate_failed", nil) message:desMessges container:strongSelf cancelTitle:NSLocalizedString(@"alert_view_i_known", nil) confirmTitle:nil cancelHandler:nil confirmHandler:nil];
            } else {
                [CRFUtils showMessage:response[kMessageKey]];
                [CRFAPPCountManager setFailedEventID:@"open_account_failed" reason:[NSString stringWithFormat:@"关联失败：%@",response[kMessageKey]] productNo:@""];
            }
        }];
    }];
}
-(void)parseResponseStatus:(id)response{
    NSDictionary *result = (NSDictionary*)response;
    NSInteger status  = [result[@"data"][@"signed"] integerValue];
    if (status == 6||status == 1) {
        [self.navigationController pushViewController:[CRFRelateAccountStatusViewController new] animated:YES];
    }else{
        CRFMessageVerifyViewController *verifyVc = [CRFMessageVerifyViewController new];
        verifyVc.ResultType = RelateResult;
        [self.navigationController pushViewController:verifyVc animated:YES];
    }
}
- (IBAction)helpButtonClick:(id)sender {
    [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_view_call_message", nil) message:nil container:self cancelTitle:NSLocalizedString(@"alert_view_i_known", nil) confirmTitle:NSLocalizedString(@"alert_view_call", nil) cancelHandler:nil confirmHandler:^{
        NSURL *callUrl = [NSURL
                          URLWithString:[NSString stringWithFormat:@"tel:400-178-9898"]];
        if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
            [[UIApplication sharedApplication] openURL:callUrl];
        }
    }];
}

//- (void)AFNHttpResponseSuccess:(id)response tag:(NSUInteger)tag {
//    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
//        [CRFUtils showMessage:@"toast_relate_account_success"];
//        [CRFUtils delayAfert:kToastDuringTime handle:^{
//            [self.navigationController pushViewController:[CRFRelateAccountStatusViewController new] animated:YES];
//        }];
//    } else {
//        if ([response[@"code"] isEqualToString:@"FUS_4009"]) {
//            NSString *desMessges = [NSString stringWithFormat:NSLocalizedString(@"alert_view_message_relate_failed", nil),self.relatePhone];
//            [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_view_title_relate_failed", nil) message:desMessges container:self cancelTitle:NSLocalizedString(@"alert_view_i_known", nil) confirmTitle:nil cancelHandler:nil confirmHandler:nil];
//        } else {
//            [CRFUtils showMessage:response[kMessageKey]];
//        }
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > 18) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
