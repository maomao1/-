//
//  CRFRegisterViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRegisterViewController.h"
#import "CRFRegisterTableViewCell.h"
#import "CRFGraphCodeView.h"
#import "CRFRegisterFooterView.h"
#import "CRFSetPwdViewController.h"
#import "UITableView+Custom.h"
#import "CRFHomeConfigHendler.h"
#import "CRFStaticWebViewViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"

static NSString *const kRegisterCellIdentifier = @"registerCell";

typedef NS_ENUM(NSUInteger, RegisterType) {
    Default         = 0,
    Exception       = 1,
};

@interface CRFRegisterViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray <NSString *>*defauleDatas;
    CRFRegisterFooterView *footerView;
    UILabel *linkTextView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *registerTableView;
@property (nonatomic, assign) NSUInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, assign) RegisterType type;
@property (nonatomic, strong) CRFGraphCodeView *graphCodeView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, copy) NSString *codeType;
//@property (nonatomic, assign) BOOL linkEnable;

@end

@implementation CRFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeType = @"0";
    [self backBarbuttonForBlack];
    [self.registerTableView setTextEidt:YES];
    [self backBarbuttonForBlack];
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        self.logoImageView.hidden = YES;
    }
    if (self.cType == Register_User) {
        self.navigationItem.title = NSLocalizedString(@"title_register", nil);
    } else {
        self.navigationItem.title = NSLocalizedString(@"title_forget_pwd", nil);
    }
    self.registerTableView.scrollEnabled = NO;
    self.imageView.contentMode = UIViewContentModeCenter;
    [self confitDatas];
    self.registerTableView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [self tableFooterView];
}

- (CRFGraphCodeView *)graphCodeView {
    if (!_graphCodeView) {
        _graphCodeView = [[CRFGraphCodeView alloc] init];
        weakSelf(self);
        [_graphCodeView commitResult:^(NSString *value) {
            strongSelf(weakSelf);
            [strongSelf verifyCodeRequest:value];
        }];
        [_graphCodeView setCancelHandler:^{
            strongSelf(weakSelf);
            [strongSelf getVerifyCodeView].enable = YES;
        }];
    }
    return _graphCodeView;
}
- (void)crf_protocolEvent:(NSURL*)url{
    CRFStaticWebViewViewController *webViewController = [[CRFStaticWebViewViewController alloc] init];
    webViewController.urlString = url.absoluteString;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)back {
    if (self.popToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [super back];
}

- (void)tableFooterView {
    BOOL value = NO;
#ifdef WALLET
//    if ([CRFAppManager defaultManager].majiabaoFlag) {
//        value = YES;
//    } else {
        value = self.cType == Register_User?YES:NO;
//    }
#else
     value = self.cType == Register_User?YES:NO;
#endif
    footerView = [[CRFRegisterFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110) hasProtocol:value];
    
    self.registerTableView.tableFooterView = footerView;
    footerView.enable = YES;
    weakSelf(self);
    __weak __typeof(footerView) weakFooter = footerView;
    [footerView setProtocolClick:^(NSURL *url){
        [weakSelf crf_protocolEvent:url];
    }];
    [footerView setRegisterHandle:^{
        if (weakSelf.cType == Register_User) {
            [CRFAPPCountManager setEventID:@"REGISTER_NEXTBTN_EVENT" EventName:@"注册页下一步"];
        } else {
            [CRFAPPCountManager setEventID:@"FORGET_NEXTBTN_EVENT" EventName:@"忘记密码下一步"];
        }
        if (![weakSelf verifyUser]) {
            return ;
        }
        if (!weakFooter.enable) {
            [CRFUtils showMessage:@"toast_read_crf_protocol"];
            return ;
        }
        UITextField *tf = ((CRFRegisterTableViewCell *)[weakSelf.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField;
        if (weakSelf.cType == Forget_User) {
            [weakSelf forgetPwd:tf.text];
            return;
        }
        [weakSelf checkCode:tf.text];
    }];
    NSArray *protocols = [CRFAppManager defaultManager].majiabaoFlag?[CRFHomeConfigHendler defaultHandler].applyRegisterProtocols:[[CRFHomeConfigHendler defaultHandler].homeDataDicM objectForKey:kRegister_protocolKey];
    if (protocols.count <= 0) {
        NSString *url = [CRFAppManager defaultManager].majiabaoFlag?kApplyRegisterProtocol:kRegister_protocolKey;
        weakSelf(footerView);
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),url] success:^(CRFNetworkCompleteType errorType, id response) {
            NSArray <CRFProtocol *>*list = [CRFResponseFactory handleProtocolForResult:response ForKey:url];
            weakSelf.registerProtoocl = list;
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            NSLog(@"==获取协议失败=");
            [CRFUtils showMessage:response[kMessageKey]];
        }];
    } else {
        footerView.registerProtoocl = protocols;
    }
}

- (BOOL)verifyUser {
    if ([self.nameTextField.text isEmpty]) {
        [self getVerifyCodeView].enable = YES;
        [CRFUtils showMessage:@"toast_phone_number_not_null"];
        return NO;
    }
    if (![self.nameTextField.text validatePhoneNumber]) {
        [self getVerifyCodeView].enable = YES;
        [CRFUtils showMessage:@"toast_error_number"];
        return NO;
    }
    if (self.index == 0) {
        [CRFUtils showMessage:@"toast_send_verify_first"];
        return NO;
    }
    UITextField *tf = ((CRFRegisterTableViewCell *)[self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField;
    if ([tf.text isEmpty] || tf.text.length != 6) {
        [self getVerifyCodeView].enable = YES;
        [CRFUtils showMessage:@"toast_error_verify_code"];
        return NO;
    }
    return YES;
}

- (void)confitDatas {
    defauleDatas = @[@"请输入手机号",@"请输入验证码"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRegisterCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFRegisterTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
        if (indexPath.section == 0 && indexPath.row == 0) {
            self.nameTextField = cell.textField;
        }
        cell.textField.clearButtonMode = UITextFieldViewModeAlways;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.type = Verify;
        if (self.cType == Forget_User) {
            cell.textField.text = self.mobilePhone;
        }
        [self addVerify:cell];
    } else {
        cell.type = Normal;
    }
    NSString *title = nil;
    title = defauleDatas[indexPath.row];
    [cell configCell:title];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return defauleDatas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.type == Verify) {
        if (section != 0) {
            return nil;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43.0)];
        linkTextView = [[UILabel alloc] initWithFrame:CGRectMake(kRegisterSpace-2, 13/ 2.0f, kScreenWidth - kRegisterSpace, 30.0)];
        linkTextView.backgroundColor = [UIColor clearColor];
        linkTextView.userInteractionEnabled = YES;
        [view addSubview:linkTextView];
        linkTextView.font = [UIFont systemFontOfSize:14.0];
        [self textViewEnable:YES];
        linkTextView.enabledTapEffect = NO;
        weakSelf(self);
        [linkTextView yb_addAttributeTapActionWithStrings:@[NSLocalizedString(@"label_voice_verify", nil)] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            strongSelf(weakSelf);
            if (![strongSelf getVerifyCodeView].enable) {
                return ;
            }
            strongSelf.codeType = @"1";
            [strongSelf voiceRequest];
            [strongSelf textViewEnable:NO];
        }];
        return view;
    }
    return nil;
}

- (void)verifyCodeRequest:(NSString *)value {
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] put:APIFormat(kSendVerifyCodePath) paragrams:[self paragramsWithPicCode:value type:self.codeType] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf codeTextFieldBecomeFirstResponder];
        if (strongSelf.codeType.integerValue == 0) {
            strongSelf.index ++;
            [CRFUtils showMessage:@"toast_send_verify_code"];
            
            [[strongSelf getVerifyCodeView] startSendVerify];
            if (strongSelf.type == Exception) {
                [strongSelf textViewEnable:NO];
            }
        } else {
            [CRFUtils showMessage:@"toast_voice_verify_code_sended"];
            [[strongSelf getVerifyCodeView] startSendVerify];
            [strongSelf textViewEnable:NO];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        if (strongSelf.codeType.integerValue == 0) {
            if ([response[@"code"] isEqualToString:@"FAPP_1004"]) {
                [strongSelf getVerifyCodeView].enable = YES;
                [CRFUtils showMessage:response[kMessageKey]];
            } else if ([response[@"code"] isEqualToString:@"FAPP_1001"]) {
                strongSelf.graphCodeView.phoneNumber = strongSelf.nameTextField.text;
                [strongSelf.graphCodeView refreshImage];
                [strongSelf.graphCodeView addSubView];
            } else {
                [strongSelf getVerifyCodeView].enable = YES;
                [CRFUtils showMessage:response[kMessageKey]];
            }
        } else {
            if ([response[@"code"] isEqualToString:@"FAPP_1001"]){
                strongSelf.graphCodeView.phoneNumber = strongSelf.nameTextField.text;
                [strongSelf.graphCodeView refreshImage];
                [strongSelf.graphCodeView addSubView];
                if (strongSelf.type == Exception) {
                    [strongSelf textViewEnable:YES];
                }
            } else{
                [CRFUtils showMessage:response[kMessageKey]];
                [strongSelf textViewEnable:YES];
            }
        }
    }];
    
}

- (void)voiceRequest {
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] put:APIFormat(kSendVerifyCodePath) paragrams:[self paragramsWithPicCode:@"" type:@"1"] success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [CRFUtils showMessage:@"toast_voice_verify_code_sended"];
        [strongSelf codeTextFieldBecomeFirstResponder];
        [[strongSelf getVerifyCodeView] startSendVerify];
        [strongSelf textViewEnable:NO];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        if ([response[@"code"] isEqualToString:@"FAPP_1001"]){
            strongSelf.graphCodeView.phoneNumber = self.nameTextField.text;
            [strongSelf.graphCodeView refreshImage];
            [strongSelf.graphCodeView addSubView];
            if (strongSelf.type == Exception) {
                [strongSelf textViewEnable:YES];
            }
        } else{
            [CRFUtils showMessage:response[kMessageKey]];
            [strongSelf textViewEnable:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == Default) {
        return kTopSpace / 2.0;
    }
    return 43.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)paragramsWithPicCode:(NSString *)pic_code type:(NSString *)type{
    return @{kMobilePhone:self.nameTextField.text,kIntent:self.cType == Register_User?@"1":@"2",kVerifyCodeType:type,kPicCode:pic_code};
}

- (void)addVerify:(CRFRegisterTableViewCell *)cell {
    weakSelf(self);
    [cell.verifyCodeView setCallback:^{
        
        strongSelf(weakSelf);
        if ([strongSelf.nameTextField.text isEmpty]) {
            [CRFUtils showMessage:@"toast_phone_number_not_null"];
            [strongSelf getVerifyCodeView].enable = YES;
            return ;
        }
        if ([strongSelf.nameTextField.text validatePhoneNumber]) {
            [strongSelf.view endEditing:YES];
            strongSelf.codeType = @"0";
            [strongSelf sendCode];
            return ;
        }
        [CRFUtils showMessage:@"toast_error_number"];
        [strongSelf getVerifyCodeView].enable = YES;
    }];
    [cell.verifyCodeView setTimeoutHandle:^{
        strongSelf(weakSelf);
        if (strongSelf.index >= 2) {
            [strongSelf textViewEnable:YES];
            strongSelf.type = Exception;
            [strongSelf.registerTableView reloadData];
            return ;
        }
    }];
}

- (void)codeTextFieldBecomeFirstResponder {
    weakSelf(self);
    [CRFUtils delayAfert:kToastDuringTime handle:^{
        strongSelf(weakSelf);
        [((CRFRegisterTableViewCell *)[strongSelf.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField becomeFirstResponder];
    }];
    
}

#pragma mark ----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField) {
        if (range.location == 0 && range.length == 0) {
            if (![string isEqual:@"1"]) {
                return NO;
            }
        }
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length == 11) {
            if (![newText validatePhoneNumber]) {
                [CRFUtils showMessage:@"toast_error_number"];
                return YES;
            }
        }
        if (newText.length > 11) {
            return NO;
        }
    } else {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        if (textField.text.length == 0) {
            [CRFUtils showMessage:@"toast_phone_number_not_null"];
        } else if (textField.text.length < 11) {
            [CRFUtils showMessage:@"toast_error_number"];
        }
        self.mobilePhone = textField.text;
    } else {
        if (textField.text.length < 6) {
            [CRFUtils showMessage:@"toast_error_verify_code"];
        }
    }
}

- (CRFVerifyCodeView *)getVerifyCodeView {
    return ((CRFRegisterTableViewCell *)[self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).verifyCodeView;
}

- (void)textViewEnable:(BOOL)enable {
    //    self.linkEnable = enable;
    NSMutableAttributedString *artString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"label_prompt_not_receive", nil)];
    [artString addAttributes:@{NSForegroundColorAttributeName:enable? kLinkTextColor:UIColorFromRGBValue(0x999999)} range:[NSLocalizedString(@"label_prompt_not_receive", nil) rangeOfString:NSLocalizedString(@"label_voice_verify", nil)]];
    [artString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x999999) range:NSMakeRange(0, NSLocalizedString(@"label_prompt_not_receive", nil).length - NSLocalizedString(@"label_voice_verify", nil).length)];
    [linkTextView setAttributedText:artString];
}

- (void)sendCode {
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendVerifyCodePath),self.nameTextField.text] paragrams:[self paragramsWithPicCode:@"" type:@"0"] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        strongSelf.index ++;
        [CRFUtils showMessage:@"toast_send_verify_code"];
        [[strongSelf getVerifyCodeView] startSendVerify];
        [strongSelf codeTextFieldBecomeFirstResponder];
        if (strongSelf.type == Exception) {
            [strongSelf textViewEnable:NO];
        }
        if (strongSelf.cType == Register_User) {
            [CRFAPPCountManager setEventID:@"REGISTER_GETCODE_EVENT" EventName:@"注册页获取验证码 成功"];
        }else{
            [CRFAPPCountManager setEventID:@"FORGET_GETCODE_EVENT" EventName:@"忘记密码页获取验证码 成功"];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        if ([response[@"code"] isEqualToString:@"FAPP_1001"]){
            strongSelf.graphCodeView.phoneNumber = strongSelf.nameTextField.text;
            [strongSelf.graphCodeView refreshImage];
            [strongSelf.graphCodeView addSubView];
            if (strongSelf.type == Exception) {
                [strongSelf textViewEnable:YES];
            }
        } else {
            [strongSelf getVerifyCodeView].enable = YES;
            [CRFUtils showMessage:response[kMessageKey]];
            if (strongSelf.cType == Register_User) {
                [CRFAPPCountManager setEventFailed:@"REGISTER_GETCODE_EVENT" reason:[NSString stringWithFormat:@"注册页失败：%@",response[kMessageKey]]];
            }else{
                [CRFAPPCountManager setEventFailed:@"REGISTER_GETCODE_EVENT" reason:[NSString stringWithFormat:@"忘记密码页失败：%@",response[kMessageKey]]];
            }
            if (strongSelf.type == Exception) {
                [strongSelf textViewEnable:YES];
            }
        }
    }];
}

- (void)checkCode:(NSString *)code {
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckVerifyCodePath) paragrams:@{kMobilePhone:self.nameTextField.text,kVerifyCode:code} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        DLog(@"this phone number correct");
        CRFSetPwdViewController *controller = [CRFSetPwdViewController new];
        if (strongSelf.cType == Register_User) {
            controller.type = NewPassword;
            [CRFAPPCountManager setEventID:@"REGISTER_NEXTBTN_EVENT" EventName:@"注册页校验 成功"];

        } else {
            controller.type = ForgetPassword;
            [CRFAPPCountManager setEventID:@"FORGET_NEXTBTN_EVENT" EventName:@"忘记密码校验 成功"];

        }
        controller.mobilePhone = strongSelf.nameTextField.text;
        controller.verifyId = response[kDataKey][kVerifyId];
        [strongSelf.navigationController pushViewController:controller animated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        strongSelf(weakSelf);
        if (strongSelf.cType == Register_User) {
            [CRFAPPCountManager setEventFailed:@"REGISTER_NEXTBTN_EVENT" reason:[NSString stringWithFormat:@"注册页下一步失败:%@",response[kMessageKey]]];
        } else {
            [CRFAPPCountManager setEventFailed:@"FORGET_NEXTBTN_EVENT" reason:[NSString stringWithFormat:@"忘记密码下一步失败:%@",response[kMessageKey]]];
        }
    }];
}

- (void)forgetPwd:(NSString *)code {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kForgetPwdPath) paragrams:@{kMobilePhone:self.nameTextField.text,kVerifyCode:code} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        CRFSetPwdViewController *controller = [CRFSetPwdViewController new];
        if (strongSelf.cType == Register_User) {
            controller.type = NewPassword;
        } else {
            controller.type = ForgetPassword;
        }
        controller.mobilePhone = strongSelf.nameTextField.text;
        controller.verifyId = response[kDataKey][kVerifyId];
        [strongSelf.navigationController pushViewController:controller animated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}


@end
