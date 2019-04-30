//
//  CRFSetPwdViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSetPwdViewController.h"
#import "CRFRegisterTableViewCell.h"
#import "UITableView+Custom.h"
#import "CRFSettingData.h"
#import "CRFAlertUtils.h"
#import "AppTrack_2616.h"
#import "CRFControllerManager.h"
#import "CRFStringUtils.h"
#import "CRFGestureManager.h"

static NSString *const kRegisterCellIdentifier = @"registerCell";

@interface CRFSetPwdViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray <NSString *>*datas;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *pwdTextField;

@end

@implementation CRFSetPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.type == NewPassword) {
           self.navigationItem.title = NSLocalizedString(@"title_set_pwd", nil);
    } else if (self.type == ForgetPassword){
        self.navigationItem.title = NSLocalizedString(@"title_set_new_pwd", nil);
    } else {
        self.navigationItem.title = NSLocalizedString(@"title_modify_pwd", nil);
    }
    [self.tableView setTextEidt:YES];
    [self backBarbuttonForBlack];
    self.tableView.scrollEnabled = NO;
    datas = @[NSLocalizedString(@"placeholder_password_input", nil),NSLocalizedString(@"placeholder_password_input_again", nil)];
    [self tableViewFooter];
}

- (void)tableViewFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    self.tableView.tableFooterView = view;
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:commitButton];
    [commitButton setTitle:NSLocalizedString(@"button_commit", nil) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kRegisterButtonBackgroundColor];
    [commitButton addTarget:self action:@selector(commitSet) forControlEvents:UIControlEventTouchUpInside];
    
    commitButton.layer.masksToBounds = YES;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.crf_acceptEventInterval = 0.5;
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(kRegisterSpace);
        make.top.equalTo(view).with.offset(20);
        make.height.mas_equalTo(kRegisterButtonHeight);
        make.right.equalTo(view).with.offset(-kRegisterSpace);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRegisterCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFRegisterTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
        cell.textField.secureTextEntry = YES;
        cell.textField.hiddenMenu = YES;
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        if (indexPath.section == 0 && indexPath.row == 0) {
            self.pwdTextField = cell.textField;
        } else {
            cell.hiddenSecret = YES;
        }
        cell.textField.clearButtonMode = UITextFieldViewModeAlways;
        [cell setType:Normal];
    }
    [cell configCell:datas[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kRegisterSpace, 0, kScreenWidth - kRegisterSpace * 2, 43)];
    label.backgroundColor = [UIColor clearColor];
     label.textColor = UIColorFromRGBValue(0x999999);
    label.text = NSLocalizedString(@"label_prompt_input_password", nil);
   [label setAttributedText:[CRFStringUtils setAttributedString:label.text lineSpace:0 attributes1:@{NSForegroundColorAttributeName:kLinkTextColor} range1:[label.text rangeOfString:@"6-20"] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
   
    UIFont *font = [UIFont systemFontOfSize:14.0];
    if (kScreenWidth == 320) {
        font = [UIFont systemFontOfSize:13.0];
    }
    label.font = font;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (void)commitSet {
    [self.view endEditing:YES];
    if (self.type == NewPassword) {
        [CRFAPPCountManager setEventID:@"SETTINGPWD_SUBMIT_EVENT" EventName:@"设置密码页提交按钮"];
    } else if (self.type == ForgetPassword){
//          修改登录密码确定MODIFYPWD_EVENT
          [CRFAPPCountManager setEventID:@"FORGETPWD_SUBMIT_EVENT" EventName:@"忘记密码页提交按钮"];
    } else {
      
    }
    if (![self validatePwd:self.pwdTextField]) {
        return;
    }
    UITextField *tf = ((CRFRegisterTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField;
    if ([tf.text isEmpty]) {
        [CRFUtils showMessage:@"请确认密码"];
        return;
    }
    if (![self.pwdTextField.text isEqualToString:tf.text]) {
        [CRFUtils showMessage:@"toast_twice_pwd_diff"];
        return;
    }
    if (self.type == ForgetPassword) {
        [self resetPwd];
        return;
    }
    [self setPwd];
}

- (void)openTouchID {
    if (![[CRFAppManager defaultManager] supportTouchID]) {
        weakSelf(self);
        [CRFAlertUtils showAlertTitle:@"注册成功" imagedName:@"alert_success" container:self cancelTitle:nil confirmTitle:@"我知道了" cancelHandler:nil confirmHandler:^{
            strongSelf(weakSelf);
             [strongSelf userLoginIsTouchId:NO];
        }];
        return;
    }
    weakSelf(self);
    NSString *message = [NSString stringWithFormat:@"%@支持%@解锁，是否启动？",[NSString appName],[[CRFAppManager defaultManager] supportFaceID]?@"FaceID":@"TouchID指纹" ];
    [CRFAlertUtils showAlertTitle:@"注册成功" message:message imagedName:@"alert_success" container:self cancelTitle:@"稍后再说" confirmTitle:@"启动" cancelHandler:^{
        strongSelf(weakSelf);
        [CRFUtils getMainQueue:^{
            [strongSelf userLoginIsTouchId:NO];
        }];
    } confirmHandler:^{
        strongSelf(weakSelf);
        [[CRFAppManager defaultManager] verifyTouchID:^(TouchStatus status) {
            if (status == VerifySuccess) {
                [strongSelf userLoginIsTouchId:YES];
            } else if (status == VerifyFailed) {
                [CRFUtils showMessage:[[CRFAppManager defaultManager] supportFaceID]?@"FaceID验证失败":@"指纹验证失败"];
                [CRFUtils delayAfert:kToastDuringTime handle:^{
                    [strongSelf gotoLoginVC];
                }];
            } else {
                [CRFUtils delayAfert:kToastDuringTime handle:^{
                    [strongSelf gotoLoginVC];
                }];
            }
        }];
    }];
}

- (void)gotoLoginVC {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"CRFLoginViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [CRFControllerManager pushLoginViewControllerFrom:self popType:PopDefault];
}

- (void)userLoginIsTouchId:(BOOL)isTouch {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.mobilePhone                                               forKey:kMobilePhone];//账户（手机号码）
    [param setValue:self.pwdTextField.text                                                    forKey:kLoginPwd];//用户密码
    [param setValue:[CRFAppManager defaultManager].clientInfo.versionNum                                     forKey: @"appVersion"];//当前登录应用版本号
    [param setValue:[CRFAppManager defaultManager].clientInfo.deviceId             forKey: @"deviceNo"];//手机设备号
    [param setValue:[CRFAppManager defaultManager].clientInfo.clientId             forKey: @"clientId"];//消息推送客户端ID，可为空
    [param setValue:[NSString stringWithFormat:@"%@",[CRFAppManager defaultManager].clientInfo.deviceToken]  forKey: @"uMengId"];//消息推送客户端deviceToken，可为空
    [param setValue:@"IOS"                                                         forKey: @"mobileOs"];//手机系统，Android、IOS
    [param setValue:[NSString getCurrentDeviceModel]                                 forKey: @"model"];//手机型号
    [param setValue:[UIDevice currentDevice].name                                 forKey: @"deviceName"];//手机设备名称
//    [param setValue:[CRFAppManager defaultManager].locationInfo.longitude          forKey: @"longitude"];//经度，可为空
//    [param setValue:[CRFAppManager defaultManager].locationInfo.latitude           forKey: @"latitude"];//维度，可为空
//    [param setValue:[CRFAppManager defaultManager].locationInfo.city               forKey: @"loginAddr"];//用户登录地理位置，可为空
    [param setValue:[NSString getAppId]                     forKey: @"appId"];//
    [param setValue:[CRFAppManager defaultManager].clientInfo.idfa forKey:@"idfa"];
     [param setValue:[NSString getMacAddress] forKey:@"macAddress"];
    [[CRFStandardNetworkManager defaultManager] destory];
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kUserLoginPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        CRFUserInfo *userInfo = [CRFResponseFactory hadleLoginDataForResult:response];
        userInfo.phoneNo = strongSelf.mobilePhone;
        [CRFRefreshUserInfoHandler defaultHandler].userInfo = userInfo;
        [CRFAppManager defaultManager].userInfo = userInfo;
        [[CRFStandardNetworkManager defaultManager] destory];
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            [CRFLoadingView dismiss];
            if (success) {
                [CRFUserDefaultManager setTouchIDSwitch:isTouch];
                [[CRFStandardNetworkManager defaultManager] destory];
                [CRFUserDefaultManager setInputAccountInfo:strongSelf.mobilePhone];
                [CRFUserDefaultManager setUserLoginTime];
                [CRFControllerManager resetMineConfig];
                [CRFControllerManager resetHomeConfig];
                strongSelf.tabBarController.selectedIndex = 0;
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                [CRFGestureManager settingGesture];
            } else {
                [CRFUtils showMessage:response[kMessageKey]];
                [CRFAppManager defaultManager].userInfo = nil;
                [strongSelf gotoLoginVC];
            }
        }];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf gotoLoginVC];
    }];
}

#pragma mark  99Click getRegisterInfo
- (void)crf_99ClickRegisterInfo:(CRFUserInfo*)userInfo{
    NSDictionary *para = @{@"userid"   :userInfo.customerUid,
                           @"trackArg1":[CRFAppManager defaultManager].clientInfo.versionCode
                          };
    [AppTrack countView:@"注册成功" andPageOzprm:para];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.pwdTextField) {
        [self validatePwd:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.pwdTextField) {
         UITextField *tf = ((CRFRegisterTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField;
        [tf becomeFirstResponder];
    }
    return YES;
}

- (BOOL)validatePwd:(UITextField *)tf {
    if ([tf.text isEmpty]) {
        [CRFUtils showMessage:@"toast_pwd_not_null"];
        return NO;
    } else if (tf.text.length < 6) {
        [CRFUtils showMessage:@"toast_pwd_length_error"];
        return NO;
    } else {
        if (![tf.text isValidPwd]) {
            [CRFUtils showMessage:@"toast_pwd_format_error"];
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.pwdTextField) {
         NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 20) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetPwd {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kResetPwdPath) paragrams:@{kVerifyId:self.verifyId,kMobilePhone:self.mobilePhone,kNewPwd:self.pwdTextField.text} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [CRFUtils showMessage:@"toast_reset_pwd_success"];
        [CRFUtils delayAfert:2.0 handle:^{
            [strongSelf gotoLoginVC];
        }];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
         [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)setPwd {
    NSString * promoteCodeStr = nil;
#ifdef WALLET
    promoteCodeStr = @"ios-2";
#else
    promoteCodeStr = @"ios-1";
#endif
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kSetPwdPath) paragrams:@{kVerifyId:self.verifyId,kLoginPwd:self.pwdTextField.text,kMobilePhone:self.mobilePhone,@"appId":[NSString getAppId],@"rootRecommCode":@"",@"inviteSource":@"",@"promoteCode":promoteCodeStr} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        CRFUserInfo *userInfo = [CRFResponseFactory hadleLoginDataForResult:response];
        [strongSelf crf_99ClickRegisterInfo:userInfo];
        [CRFUtils getMainQueue:^{
             [strongSelf openTouchID];
        }];
        [CRFAPPCountManager setEventID:@"SETTINGPWD_SUBMIT_EVENT" EventName:@"注册成功"];
    
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFAPPCountManager setEventFailed:@"SETTINGPWD_SUBMIT_EVENT" reason:[NSString stringWithFormat:@"注册失败:%@",response[kMessageKey]]];
    }];
}

@end
