//
//  WMLoginViewController.m
//  WMWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJLoginViewController.h"
#import "CRFLoginTableViewCell.h"
#import "WMMJLoginFooterView.h"
#import "WMMJLoginHeaderView.h"
#import "CRFSettingData.h"
#import "CRFControllerManager.h"
#import "CRFTabBarViewController.h"
#import "WMMJTabBarViewController.h"
#import "CRFRegisterViewController.h"

static NSString *const kLoginCellIdentifier = @"loginCell";

@interface WMMJLoginViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate> {
    NSArray <NSString *>*datas;
    NSArray <NSString *>*placeholders;
}
@property (weak, nonatomic) IBOutlet UITableView *loginTableView;
@property (strong,nonatomic) WMMJLoginHeaderView *headerView;
@property (strong,nonatomic) WMMJLoginFooterView *footerView;
@property (copy  ,nonatomic) NSString            *userAccount;
@property (copy  ,nonatomic) NSString            *passwd;
@end

@implementation WMMJLoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString* cName = @"登录";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnter:cName];
    [self clearData];
}

- (void)clearData {
    self.passwd = nil;
    CRFLoginTableViewCell *cell = (CRFLoginTableViewCell *)[self.loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.textField.text = nil;
}

// 退出页面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = @"登录";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnd:cName];
}
- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.needBack) {
         [self customNavigationBackForWhite];
    }
    [self initDataSources];
    self.headerView = [[WMMJLoginHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210 * kWidthRatio)];
    self.loginTableView.tableHeaderView = self.headerView;
    
    self.footerView = [[WMMJLoginFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    __weak typeof(self) weakSelf = self;
    [self.footerView footLoginBtnCallback:^(UIButton *loginBtn){
        strongSelf(weakSelf);
        DLog(@"登录");
        [strongSelf crfGetLogin:loginBtn];
    } registerCallback:^(UIButton *registerBtn){
        DLog(@"注册");
        registerBtn.enabled = YES;
        [weakSelf crf_pushRegisterVC];
    } forgetCallback:^(UIButton *forgetBtn){
        DLog(@"忘记密码");
        forgetBtn.enabled = YES;
        [weakSelf crf_pushForgetVC];
    }];
    self.loginTableView.tableFooterView = self.footerView;
    
    [self.loginTableView setTextEidt:YES];
    [self.loginTableView registerNib:[UINib nibWithNibName:@"WMLoginTableViewCell" bundle:nil] forCellReuseIdentifier:kLoginCellIdentifier];
    
}
-(void)crf_pushForgetVC{
    CRFRegisterViewController *controller = [CRFRegisterViewController new];
    controller.mobilePhone = self.userAccount;
    controller.cType = Forget_User;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)crf_pushRegisterVC{
    CRFRegisterViewController *controller = [CRFRegisterViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)back {
    if (self.popType == PopHome) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 0;
    } else if(self.popType == PopFrom){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)initDataSources{
    datas = @[@"majiabao_login_mobile_phone",@"majiabao_login_pwd"];
    placeholders = @[NSLocalizedString(@"placeholder_user_name_login", nil),NSLocalizedString(@"placeholder_password_input", nil)];
    if ([CRFUserDefaultManager getInputAccout]) {
        self.userAccount =[CRFUserDefaultManager getInputAccout];
    }
}
- (void)crfGetLogin:(UIButton *)btn {
    if (![self.userAccount validatePhoneNumber]) {
        [CRFUtils showMessage:@"用户名或密码错误，请重新输入"];
        return;
    }
    if (!self.userAccount.length) {
        [CRFUtils showMessage:@"请输入手机号"];
    } else if (!self.passwd.length) {
        [CRFUtils showMessage:@"请输入密码"];
    } else {
        [self crfGetData];
    }
}

- (void)crfGetData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.userAccount                                               forKey:kMobilePhone];//账户（手机号码）
    [param setValue:self.passwd                                                    forKey:kLoginPwd];//用户密码
    [param setValue:[CRFAppManager defaultManager].clientInfo.versionNum                                     forKey: @"appVersion"];//当前登录应用版本号
    [param setValue:[CRFAppManager defaultManager].clientInfo.deviceId             forKey: @"deviceNo"];//手机设备号
    [param setValue:[CRFAppManager defaultManager].clientInfo.clientId             forKey: @"clientId"];//消息推送客户端ID，可为空
    [param setValue:@"IOS"                                                         forKey: @"mobileOs"];//手机系统，Android、IOS
    [param setValue:[NSString getCurrentDeviceModel]                                 forKey: @"model"];//手机型号
    [param setValue:[UIDevice currentDevice].name                                 forKey: @"deviceName"];//手机设备名称
//    [param setValue:[CRFAppManager defaultManager].locationInfo.longitude          forKey: @"longitude"];//经度，可为空
//    [param setValue:[CRFAppManager defaultManager].locationInfo.latitude           forKey: @"latitude"];//维度，可为空
//    [param setValue:[CRFAppManager defaultManager].locationInfo.city               forKey: @"loginAddr"];//用户登录地理位置，可为空
    [param setValue:[NSString getAppId]                     forKey: @"appId"];//
    [param setValue:[CRFAppManager defaultManager].clientInfo.idfa forKey:@"idfa"];
    [param setValue:[NSString getMacAddress] forKey:@"macAddress"];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kUserLoginPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf paserResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf paserResponse:response];
    }];
}

- (void)pushCheckoutLogin{
    CRFCheckLoginViewController *checkLoginVC = [CRFCheckLoginViewController new];
    checkLoginVC.userAccount = self.userAccount;
    checkLoginVC.passwd      = self.passwd;
    [self.navigationController pushViewController:checkLoginVC animated:YES];
}

- (void)paserResponse:(id)response {
    NSDictionary *resultDic = (NSDictionary*)response;
    NSString  *status = resultDic[kResult];
            DLog(@"登录接口成功");
            if ([status isEqualToString:kSuccessResultStatus]) {
                CRFUserInfo *userInfo = [CRFResponseFactory hadleLoginDataForResult:response];
                userInfo.phoneNo = self.userAccount;
                kUserInfo = userInfo;
                [CRFRefreshUserInfoHandler defaultHandler].userInfo = userInfo;
                weakSelf(self);
                [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
                    strongSelf(weakSelf);
                    if (success) {
                        [CRFUserDefaultManager setInputAccountInfo:strongSelf.userAccount];
                        if ([CRFAppManager defaultManager].majiabaoFlag) {
                            [self pushMajiabaoViewController];
                            return ;
                        }
                        [CRFUserDefaultManager setUserLoginTime];
                        [CRFControllerManager resetHomeConfig];
                        [CRFControllerManager resetMineConfig];
                        [strongSelf back];
                    } else {
                        kUserInfo = nil;
                        [CRFUtils showMessage:@"登录失败"];
                    }
                }];
            } else if ([resultDic[@"code"] isEqualToString:kChangeDevice]) {
                [self pushCheckoutLogin];
            } else {
                [CRFUtils showMessage:resultDic[kMessageKey]];
            }
}

#pragma UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoginCellIdentifier];
    cell.textField.tag = 1001+indexPath.row;
    cell.textField.delegate = self;
    if (indexPath.row == 1) {
        cell.textField.hiddenMenu = YES;
    }
    weakSelf(self);
    [cell cellLeftImgName:datas[indexPath.row] placeholder:placeholders[indexPath.row] editCompleteCallback:^(NSString *content) {
        strongSelf(weakSelf);
        switch (indexPath.row) {
            case 0:
                strongSelf.userAccount = content;
                break;
            case 1:
                strongSelf.passwd = content;
                break;
            default:
                break;
        }
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger maxCount;
    if (textField.tag == 1001) {
        maxCount = 11;
    } else{
        maxCount = 20;
    }
    if (newText.length > maxCount) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)pushMajiabaoViewController {
    if ([self.userAccount isEqualToString:kTestMoblePhone]) {
      WMMJTabBarViewController *viewController = [WMMJTabBarViewController new];
       
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        CRFTabBarViewController *tabbar = [CRFTabBarViewController new];
        [self presentViewController:tabbar animated:YES completion:nil];
    }
}



@end
