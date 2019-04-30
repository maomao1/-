//
//  CRFCheckoutLoginVC.m
//  crf_purse
//
//  Created by SHLPC1321 on 2017/7/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCheckLoginViewController.h"
#import "CRFSettingData.h"
#import "CRFControllerManager.h"
#import "CRFGestureManager.h"

#ifdef WALLET
#import "WMMJTabBarViewController.h"
#import "CRFTabBarViewController.h"
#endif


@interface CRFCheckLoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)   UILabel  * propmtLabel;//提示更换设备
@property (nonatomic,strong)   UILabel  * phoneLabel;//提示验证码发送手机Label
@property (nonatomic,strong)   UIButton * checkoutBtn;
@property (nonatomic,strong)   UITextField *textField;

@end

@implementation CRFCheckLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"登录验证"];
    [self backBarbuttonForBlack];
    [self setDefautBarColor];
    [self setLayoutUI];
}
- (void)setLayoutUI{
    self.propmtLabel = [[UILabel alloc]init];
    self.phoneLabel  = [[UILabel alloc]init];
    self.checkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.textField   = [[UITextField alloc]init];
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    [self sendVersionCode];
    
    [self.view addSubview:self.propmtLabel];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.checkoutBtn];
    
    [self.propmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.propmtLabel.mas_left);
        make.right.mas_equalTo(self.propmtLabel.mas_right);
        make.top.equalTo(self.propmtLabel.mas_bottom).mas_offset(18);
        make.centerX.equalTo(self.propmtLabel.mas_centerX);
        
    }];
    self.phoneLabel.textAlignment  = NSTextAlignmentCenter;
    self.propmtLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneLabel.numberOfLines  = 0;
    self.propmtLabel.numberOfLines = 0;
    
    self.propmtLabel.text = NSLocalizedString(@"label_changed_device_send_code_first", nil);
    self.phoneLabel.text  = [NSString stringWithFormat:NSLocalizedString(@"label_message_code_send_mobile_phone", nil),[self.userAccount formatMoblePhone]];
    self.propmtLabel.font = [UIFont systemFontOfSize:15];
    self.phoneLabel.font  = [UIFont systemFontOfSize:15];
    self.propmtLabel.textColor = UIColorFromRGBValue(0x333333);
    self.phoneLabel.textColor = UIColorFromRGBValue(0x888888);
    NSInteger pading = 13*kWidthRatio;
    NSInteger itemW  = 45*kWidthRatio;
    for (int i = 0; i<6; i++) {
        UILabel *codeShow = [[UILabel alloc]init];
        codeShow.tag  = 1000+i;
        [self.view addSubview:codeShow];
        [codeShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20+(itemW+pading)*i);
            make.top.equalTo(self.phoneLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(itemW, itemW));
        }];
        codeShow.layer.borderColor = UIColorFromRGBValue(0xDCDEE3).CGColor;
        codeShow.layer.borderWidth = 1;
        codeShow.layer.masksToBounds = YES;
        codeShow.layer.cornerRadius = 2.0f;
        codeShow.backgroundColor = UIColorFromRGBValue(0xffffff);
        codeShow.font = [UIFont systemFontOfSize:25];
        codeShow.textAlignment = NSTextAlignmentCenter;
        codeShow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setResonder)];
        [codeShow addGestureRecognizer:tap];
        
    }
    UILabel *textLabel = [self.view viewWithTag:1000];
    [self.checkoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(kRegisterButtonHeight);
        make.top.equalTo(textLabel.mas_bottom).offset(29);
    }];
    self.checkoutBtn.backgroundColor = kRegisterButtonBackgroundColor;
    [self.checkoutBtn setTitle:@"验证" forState:UIControlStateNormal];
    self.checkoutBtn.titleLabel.font= [UIFont systemFontOfSize:16];
    
    [self.checkoutBtn setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateNormal];
    
    self.checkoutBtn.layer.masksToBounds = YES;
    self.checkoutBtn.layer.cornerRadius = 5.0f;
    [self.checkoutBtn addTarget:self action:@selector(checkCode) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)sendVersionCode{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.userAccount                                               forKey:kMobilePhone];//账户（手机号码）
    [param setValue:@"0"                                                    forKey:kVerifyCodeType];//
    [param setValue:@"3"                                     forKey: kIntent];//
    [param setValue:@""                                      forKey: kPicCode];//
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] put:APIFormat(kSendVerifyCodePath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"验证码发送成功");
        [CRFLoadingView dismiss];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"验证码发送失败： %@",response);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)setResonder{
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField becomeFirstResponder];
}
//验证 输入是否正确
- (void)checkCode{
    if (self.textField.text.length<6) {
        [CRFUtils showMessage:@"请输入正确的验证码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.userAccount             forKey: @"mobilePhone"];//账户（手机号码）
    [param setValue:self.passwd                   forKey: @"loginPwd"];//用户密码
    [param setValue:[CRFAppManager defaultManager].clientInfo.versionNum    forKey: @"appVersion"];//当前登录应用版本号
    [param setValue:[CRFUtils getDeviceUUId]      forKey: @"deviceNo"];//手机设备号
    [param setValue:[CRFAppManager defaultManager].clientInfo.clientId              forKey: @"clientId"];//消息推送客户端ID，可为空
    [param setValue:[NSString stringWithFormat:@"%@",[CRFAppManager defaultManager].clientInfo.deviceToken]  forKey: @"uMengId"];//消息推送客户端deviceToken，可为空
    [param setValue:@"IOS"              forKey: @"mobileOs"];//手机系统，Android、IOS
    [param setValue:[NSString getCurrentDeviceModel]                                 forKey: @"model"];//手机型号
    [param setValue:[UIDevice currentDevice].name                                 forKey: @"deviceName"];//手机设备名称
    //    [param setValue:[CRFAppManager defaultManager].locationInfo.longitude              forKey: @"longitude"];//经度，可为空
    //    [param setValue:[CRFAppManager defaultManager].locationInfo.latitude              forKey: @"latitude"];//维度，可为空
    //    [param setValue:[CRFAppManager defaultManager].locationInfo.city              forKey: @"loginAddr"];//用户登录地理位置，可为空
    [param setValue:self.textField.text              forKey: @"smsCode"];//短信验证码
    [param setValue:[NSString getAppId]                    forKey: @"appId"];//
    [param setValue:[CRFAppManager defaultManager].clientInfo.idfa forKey:@"idfa"];
    [param setValue:[NSString getMacAddress] forKey:@"macAddress"];
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kVerifyLoginPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
    
}
- (void)parseResponse:(id)response {
        [CRFAppManager defaultManager].userInfo = nil;
        CRFUserInfo *userInfo = [CRFResponseFactory hadleLoginDataForResult:response];
        userInfo.phoneNo = self.userAccount;
        [CRFAppManager defaultManager].userInfo = userInfo;
        [CRFRefreshUserInfoHandler defaultHandler].userInfo = userInfo;
        weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] destory];
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            [CRFLoadingView dismiss];
            strongSelf(weakSelf);
            if (success) {
                [[CRFStandardNetworkManager defaultManager] destory];
                [CRFUserDefaultManager setInputAccountInfo:strongSelf.userAccount];
                [CRFUserDefaultManager setUserLoginTime];
#ifdef WALLET
                if ([CRFAppManager defaultManager].majiabaoFlag) {
                    [self pushMajiabaoViewController];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [CRFControllerManager resetMineConfig];
                    //                        [CRFControllerManager resetHomeConfig];
                    
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                    [CRFGestureManager firstInstallAfterSettingGesture];
                }
#else
                [CRFControllerManager resetMineConfig];
                //                        [CRFControllerManager resetHomeConfig];
                
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                [CRFGestureManager firstInstallAfterSettingGesture];
#endif
                
                
                
                
            } else {
                [CRFAppManager defaultManager].userInfo = nil;
                [CRFUtils showMessage:response[kMessageKey]];
            }
        }];
}
#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    DLog(@"输入%@",string);
    if (range.location>5) {
        return NO;
    }
    UILabel *showLabel = [self.view viewWithTag:1000+range.location];
    showLabel.text    = string;
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushMajiabaoViewController {
#ifdef WALLET
    if ([self.userAccount isEqualToString:kTestMoblePhone]) {
        WMMJTabBarViewController *viewController = [WMMJTabBarViewController new];
        
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        CRFTabBarViewController *tabbar = [CRFTabBarViewController new];
        [self presentViewController:tabbar animated:YES completion:nil];
    }
#endif
}

@end
