//
//  CRFModifyPwdViewController.m
//  crf_purse
//
//  Created by maomao on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFModifyPwdViewController.h"
#import "CRFLoginViewController.h"
#import "CRFRegisterViewController.h"
#import "CRFTextField.h"
#import "CRFAlertUtils.h"
#import "CRFControllerManager.h"
#import "UIButton+CRFRepeatClick.h"
@interface CRFModifyPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CRFTextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet CRFTextField *lastPwdTextField;
@property (weak, nonatomic) IBOutlet CRFTextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
//@property (weak, nonatomic) IBOutlet UIButton *secretBtn;

- (IBAction)btnConfirmClick;
//- (IBAction)secretAction:(UIButton *)sender;

@end

@implementation CRFModifyPwdViewController
- (void)setUI{
    [self.oldPwdTextField setValue:UIColorFromRGBValue(0xBBBBBB) forKeyPath:@"_placeholderLabel.textColor"];
    [self.oldPwdTextField setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    [self.lastPwdTextField setValue:UIColorFromRGBValue(0xBBBBBB) forKeyPath:@"_placeholderLabel.textColor"];
    [self.lastPwdTextField setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    [self.confirmPwdTextField setValue:UIColorFromRGBValue(0xBBBBBB) forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPwdTextField setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    self.oldPwdTextField.delegate = self;
    self.lastPwdTextField.delegate = self;
    self.confirmPwdTextField.delegate = self;
    _confirmBtn.backgroundColor = kButtonNormalBackgroundColor;
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius  = 5.0;
    _confirmBtn.crf_acceptEventInterval = 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setSyatemTitle:@"修改登录密码"];
}

- (void)crfGetData{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:self.oldPwdTextField.text forKey:@"oldPwd"];
    [param setValue:self.lastPwdTextField.text forKey:@"newPwd"];
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kModifyPwdPath),kUuid] paragrams:param success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf handlerResponseSuccess:response];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf handlerResponseSuccess:response];
    }];
}

- (void)gotoLogin {
    [CRFControllerManager pushLoginViewControllerFrom:self popType:PopDefault];
}

- (void)gotoForget {
    CRFRegisterViewController *forgetVc = [CRFRegisterViewController new];
    forgetVc.cType = Forget_User;
    forgetVc.popToRoot = YES;
    [self.navigationController pushViewController:forgetVc animated:YES];
}

- (void)handlerResponseSuccess:(id)response{
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        weakSelf(self);
        [CRFAlertUtils showAlertTitle:@"密码修改成功，请重新登录。" imagedName:@"alert_success" container:self cancelTitle:nil confirmTitle:@"去登录" cancelHandler:nil confirmHandler:^() {
            [weakSelf gotoLogin];
            [CRFControllerManager resetAppConfig];
        }];
    } else if ([response[@"code"] isEqualToString:@"FUS_1009"]) {
        weakSelf(self);
        [CRFAlertUtils showAlertTitle:response[kMessageKey] message:nil container:self cancelTitle:@"关闭" confirmTitle:@"忘记密码" cancelHandler:nil confirmHandler:^{
            strongSelf(weakSelf);
            [strongSelf logout];
            [CRFControllerManager resetAppConfig];
            [strongSelf gotoForget];
        }];
    } else if ([response[@"code"] isEqualToString:@"FUS_1010"]) {
        weakSelf(self);
        [self logout];
        [CRFControllerManager resetAppConfig];
        [CRFAlertUtils showAlertTitle:response[kMessageKey] message:nil container:self cancelTitle:@"重新登录" confirmTitle:@"忘记密码" cancelHandler:^{
            strongSelf(weakSelf);
            [strongSelf gotoLogin];
        } confirmHandler:^{
            strongSelf(weakSelf);
            [strongSelf gotoForget];
        }];
    } else {
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnConfirmClick {
    DLog(@"点击确定按钮");
    [self.view endEditing:YES];
    if (!self.oldPwdTextField.text.length) {
        [CRFUtils showMessage:@"请输入原密码"];
    }
//    else if (self.oldPwdTextField.text.length <6){
//        [CRFUtils showMessage:@"密码长度必须6-20位"];
//    }
//    else if (![self.oldPwdTextField.text isValidPwd]){
//        [CRFUtils showMessage:@"原密码输入错误"];
//    }
    else if (!self.lastPwdTextField.text.length){
        [CRFUtils showMessage:@"请输入新密码"];
    }
    else if (self.lastPwdTextField.text.length <6){
        [CRFUtils showMessage:@"密码长度必须6-20位"];
    }
    else if (![self.lastPwdTextField.text isValidPwd]){
        [CRFUtils showMessage:@"密码格式错误"];
    }else if (![self.lastPwdTextField.text isEqualToString:self.confirmPwdTextField.text]){
        [CRFUtils showMessage:@"新密码两次输入不一致"];
    }else{
        [self crfGetData];
    }
}

//- (IBAction)secretAction:(UIButton *)sender {
//    self.lastPwdTextField.secureTextEntry = sender.selected;
//    self.oldPwdTextField.secureTextEntry = sender.selected;
//    self.confirmPwdTextField.secureTextEntry=sender.selected;
//    sender.selected = !sender.selected;
//}
#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    DLog(@"输入%@",string);
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString:@"\n"]) {
        switch (textField.tag) {
            case 100:
                [self.lastPwdTextField becomeFirstResponder];
                break;
            case 101:
                [self.confirmPwdTextField becomeFirstResponder];
                break;
            case 102:
                [self btnConfirmClick];
                break;
                
            default:
                break;
        }
    }
    NSInteger maxCount = 20;
    if (newText.length > maxCount) {
        return NO;
    }
    return YES;
}

- (void)logout {
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kLogoutPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        DLog(@"logout success");
        [CRFLoadingView dismiss];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        DLog(@"logout failed");
        [CRFLoadingView dismiss];
    }];
}


@end
