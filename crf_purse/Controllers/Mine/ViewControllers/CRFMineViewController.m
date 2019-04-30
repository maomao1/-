//
//  CRFMineViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMineViewController.h"
#import "CRFProfileViewController.h"
#import "CRFMoreViewController.h"
#import "CRFLoginViewController.h"
#import "CRFRegisterViewController.h"
#import "CRFFeedbackViewController.h"
#import "CRFMessageScrollViewController.h"
#import "CRFIMViewController.h"
#import "CRFMineTableViewCell.h"
#import "CRFMineHeaderView.h"
#import "CRFCreateAccountViewController.h"
#import "CRFRollOutViewController.h"
//#import "CRFRechargeViewController.h"
#import "CRFRewardViewController.h"
#import "CRFRelateAccountViewController.h"
#import "CRFMyInvestViewController.h"
#import "MJRefresh.h"
#import "CRFControllerManager.h"
#import "CRFAuthView.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFDepositAccountViewController.h"
#import "CRFAlertUtils.h"
#import "CRFMessageVerifyViewController.h"
#import "CRFVerifyInfoViewController.h"
#import "CRFShowSwitchAlert.h"
#import "CRFRechargeContainerViewController.h"
#import "CRFQAView.h"
#import "CRFStringUtils.h"
static NSString *const kMineCellIdentifier = @"mineCell";

@interface CRFMineViewController ()<UITableViewDelegate, UITableViewDataSource, HeaderViewDelegate,CRFAuthViewDelegate,CRFMineTableViewCellDelegate> {
    NSArray  <NSString *>*datas;
    NSArray <NSArray <UIImage *>*>*images;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger unreadMessageCount;
@property (nonatomic, strong) CRFMineHeaderView *headerView;
//@property (nonatomic, strong) NSArray <CRFMyInvestProduct *>*products;
@property (nonatomic, strong) CRFAuthView *authView;
@property (nonatomic, assign) BOOL repeated;

@property (nonatomic, strong) CRFQAView *qaView;

@end

@implementation CRFMineViewController
- (CRFAuthView *)authView{
    if (!_authView) {
        _authView = [[CRFAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _authView.crf_delegate = self;
    }
    return _authView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _repeated = YES;
    if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].accountStatus) {
        self.headerView.accountInfo = [CRFAppManager defaultManager].accountInfo;
        self.headerView.userStatus = On_line;
    } else {
        self.headerView.accountInfo = [CRFAppManager defaultManager].accountInfo;
        if (![CRFAppManager defaultManager].login) {
            self.headerView.userStatus = Off_line;
        } else {
            self.headerView.userStatus = On_line;
        }
    }
    [self.tableView reloadData];
    NSString* cName = @"我";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnter:cName];
    if ([CRFUserDefaultManager bankAuditStatus]) {
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
            if (!success) {
                [CRFUtils showMessage:response[kMessageKey]];
            }
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self crf_showAuthView];
}

- (void)crf_showAuthView{
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    if ([userInfo.accountStatus isEqualToString:@"2"] && [userInfo.tograntauthorization isEqualToString:@"0"]) {
        [self.authView crfSetContent];
        [self.authView showInView:[UIApplication sharedApplication].delegate.window];
    }
}

- (void)crf_agreeAuthBank{
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kAuthBankPath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf.authView dismiss];
        [CRFControllerManager refreshUserInfo];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
    }];
}

- (void)crf_pushPotocol:(NSString *)urlStr{
    CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
    webViewController.urlString = urlStr;
    webViewController.backType = WebViewClose;
    webViewController.hidesBottomBarWhenPushed = YES;
    webViewController.popGestureDisable = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}
// 退出页面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = @"我";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnd:cName];
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[CRFAppManager defaultManager] removeWindowUsenessViews];
}

- (void)resourceDidUpdate {
    [self loadImages];
    [self.tableView reloadData];
}

- (void)loadImages {
    images = @[@[[CRFUtils loadImageResource:@"mine_invest"],[CRFUtils loadImageResource:@"mine_red_packet"]],@[[CRFUtils loadImageResource:@"mine_notify"],[CRFUtils loadImageResource:@"mine_IM"],[CRFUtils loadImageResource:@"mine_setting"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    datas = @[@[NSLocalizedString(@"cell_label_invest", nil),NSLocalizedString(@"cell_label_reward", nil)],@[NSLocalizedString(@"cell_label_notify", nil),NSLocalizedString(@"cell_label_IM", nil),NSLocalizedString(@"cell_label_setting", nil)]];
    [self loadImages];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[CRFMineTableViewCell class] forCellReuseIdentifier:CRFMineTableViewCellId];
    [self.tableView registerClass:[CRFMineTableViewCell class] forCellReuseIdentifier:CRFMineTableBgCellId];
    [self tableHeaderView];
    [self configDatas];
    [self refresh];
    [self setHandler];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
#endif
}

- (void)configDatas {
    [CRFControllerManager loadingHomeUserAvatar];
    self.headerView.userStatus = On_line;
    if ([CRFAppManager defaultManager].accountStatus) {
        [self getUserAssetsTotal];
    } else {
        if ([CRFAppManager defaultManager].login) {
            [self refreshUnreadMessageCount];
        }
    }
}

- (void)setHandler {
    weakSelf(self);
    self.refreshUserAssertAccount = ^ {
        strongSelf(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        if ([CRFAppManager defaultManager].login) {
            if ([CRFAppManager defaultManager].accountStatus) {
                [strongSelf getUserAssetsTotal];
            } else {
                [strongSelf refreshUnreadMessageCount];
            }
        }
    };
}

- (void)tableHeaderView {
    _headerView = [[CRFMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20+285 * kWidthRatio)];
    _headerView.userStatus = [CRFAppManager defaultManager].login?On_line:Off_line;
    _headerView.headerDelegate = self;
    self.tableView.tableHeaderView = _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFMineTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CRFMineTableViewCellId];
        if ([CRFAppManager defaultManager].login) {
            if (self.unreadMessageCount > 0) {
                cell.badgeNumber = self.unreadMessageCount;
                cell.messageStyle = Number;
            } else {
                cell.messageStyle = None;
            }
        }else{
            cell.messageStyle = None;
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CRFMineTableBgCellId];
        NSArray *titles = @[@"电话客服",@"专属顾问",@"在线客服",@"我的设置"];
        NSArray *images = @[@"new_mine_kefu",@"new_mine_guwen",@"new_mine_IM",@"new_mine_setting"];
        NSString *phone = @"400-178-9898";
        NSString *name = @"";
        if ([CRFAppManager defaultManager].login) {
             CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
            if (userInfo.financialPhone.length) {
                name = [NSString stringWithFormat:@"%@ %@",userInfo.financialPhone,userInfo.financialName];
            }
        }
        NSArray *secondTitles = @[phone,name,@"",@""];
        cell.titles = titles;
        cell.images = images;
        cell.secondTitles = secondTitles;
    }
    cell.delegate = self;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0? 110 : 190*kWidthRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *keyName = datas[indexPath.section][indexPath.row];
//    if ([keyName isEqualToString:@"头像"]) {
//        keyName = @"个人资料头像";
//    }
//    [CRFAPPCountManager getEventIdForKey:keyName];//埋点

}
-(void)crfSelectedMineIndex:(NSInteger)index{
    datas = @[@"我的投资",@"优惠红包",@"消息中心",@"电话客服",@"专属顾问",@"在线客服",@"我的设置"];
    NSString *keyName = datas[index];
    [CRFAPPCountManager getEventIdForKey:keyName];//埋点
    UIViewController *controller = nil;
    if (![CRFAppManager defaultManager].login) {
        controller = [[CRFLoginViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    if (index == 0) {
        if ([CRFAppManager defaultManager].accountStatus) {
            controller = [CRFMyInvestViewController new];
            ((CRFMyInvestViewController *)controller).selectedIndex = 0;
        } else {
            [self checkUserAccountStatus];
        }
    }
    if (index == 1) {
        controller = [CRFRewardViewController new];
        NSString *urlString = [NSString stringWithFormat:@"%@?%@",kRedAndCouponH5,kH5NeedHeaderInfo];
        ((CRFRewardViewController *)controller).urlString = urlString;
    }
    if (index == 2) {
        controller = [CRFMessageScrollViewController new];
        weakSelf(self);
        ((CRFMessageScrollViewController*)controller).refreshUnReadBlock = ^{
            [weakSelf refreshUnreadMessageCount];
        };
    }
    if (index == 3) {
        NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:400-178-9898"]];
        if ([CRFUtils validateCurrentMobileSystem10_2]) {
            if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                    [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                }
                else {
                    [[UIApplication sharedApplication] openURL:callUrl];
                }
            }
        }else{
            [CRFAlertUtils showAlertTitle:@"400 178 9898" container:self cancelTitle:@"取消" confirmTitle:@"呼叫" cancelHandler:nil confirmHandler:^{
                if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                        [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL:callUrl];
                    }
                }
            }];
        }
        
        return;
    }
    if (index ==4) {
        CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
        if (userInfo.financialPhone.length) {
            NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",userInfo.financialPhone]];
            if ([CRFUtils validateCurrentMobileSystem10_2]) {
                if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                        [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL:callUrl];
                    }
                }
            }else{
                NSString *title = [NSString stringWithFormat:@"您的专属顾问：\n%@ %@",userInfo.financialPhone,userInfo.financialName];
                [CRFAlertUtils showAlertTitle:title container:self cancelTitle:@"取消" confirmTitle:@"呼叫" cancelHandler:nil confirmHandler:^{
                    
                    if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                        if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                            [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL:callUrl];
                        }
                    }
                }];
            }
            return;
        }else{
            [CRFAlertUtils showAlertTitle:nil message:@"您暂时没有专属顾问哦~" container:self cancelTitle:nil confirmTitle:@"我知道了" cancelHandler:nil confirmHandler:nil];
        }
        
    }
    if (index == 5) {
        [CRFUtils showMessage:@"暂未开放,敬请期待" drution:1.5];
    }
    if (index == 6) {
        controller = [[CRFMoreViewController alloc] init];
    }
    
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark HeaderViewDelegate
-(void)explainHelpView{
  [self.qaView show];
}
- (void)userInfo {
    UIViewController *controller = nil;
    if ([CRFAppManager defaultManager].login) {
        controller = [CRFProfileViewController new];
    } else {
        controller = [CRFLoginViewController new];
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)userRecharge {
    //    UIViewController *controller = nil;
    if ([CRFAppManager defaultManager].login) {
        if (![CRFAppManager defaultManager].accountStatus) {
            [self checkUserAccountStatus];
        } else {
            [self showVerifyInfo];
        }
    } else {
        UIViewController *controller = [CRFLoginViewController new];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)userTransform {
    UIViewController *controller = nil;
    if ([CRFAppManager defaultManager].login) {
        CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
        if ([userInfo.accountStatus integerValue] == 1) {
            [self checkUserAccountStatus];
        } else {
            controller = [CRFRollOutViewController new];
            if (userInfo.openBankCardNo.length<4) {
                return;
            }
            ((CRFRollOutViewController *)controller).bankInfo =  [NSString stringWithFormat:@"%@卡(%@)",[userInfo.bankCode getBankCode].bankName,[userInfo.openBankCardNo substringFromIndex:userInfo.openBankCardNo.length - 4]];
            ((CRFRollOutViewController *)controller).avaibleMoney = [CRFAppManager defaultManager].accountInfo.availableBalance;
        }
    } else {
        controller = [CRFLoginViewController new];
    }
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(void)showVerifyInfo{
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    UIViewController *controller = nil;
//    controller = [CRFMessageVerifyViewController new];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
//    return;
    switch ([userInfo.accountSigned integerValue]) {
        case 1:{//1：已授权，2：未授权，3：信息异常，4，修改卡未授权 5
            controller = [CRFRechargeContainerViewController new];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:{//不验签
            CRFRechargeContainerViewController *rechargeVC = [CRFRechargeContainerViewController new];
//            rechargeVC.popType = PopFrom_recharge;
            rechargeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case 2:{
            controller = [CRFMessageVerifyViewController new];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:{
            CRFShowSwitchAlert *alertView =[[CRFShowSwitchAlert alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) AlertTitle:@"存管信息有误" content:@"尊敬的用户：\n您的第三方银行存管账户信息已失效，请按照下面的提示进行操作，感谢您的配合。\n1)如果您当前的注册手机号与银行预留手机号不一致，请前往银行网点或联系信而富客服400-178-9898进行修改。\n2)如果是姓名、身份证号或银行卡其中任何一项存在问题，请联系信而富客服400-178-9898进行存管账户注销；注销后重新开户即可。\n感谢您的理解与支持~" dismissHandler:nil confirmHandler:^{
                
            }];
            [alertView showInView:[UIApplication sharedApplication].delegate.window];
        }
            break;
        case 4:{
            [CRFAlertUtils showAlertTitle:@"温馨提示" contentLeftMessage:@"您已更改银行卡信息，请您进行短信验证操作，验证通过便可立即正常使用。" container:self cancelTitle:@"下次再说" confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                CRFMessageVerifyViewController *verifyVc = [[CRFMessageVerifyViewController alloc]init];
                verifyVc.hidesBottomBarWhenPushed = YES;
                verifyVc.ResultType = CloseResult;
                [self.navigationController pushViewController:verifyVc animated:YES];
            }];
        }
            break;
        case 5:{
            [CRFAlertUtils showAlertTitle:@"温馨提示" contentLeftMessage:@"您已成功修改存管账户信息，请您进行短信验证操作，验证通过便可正常充值。" container:self cancelTitle:@"下次再说" confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                CRFMessageVerifyViewController *verifyVc = [[CRFMessageVerifyViewController alloc]init];
                verifyVc.hidesBottomBarWhenPushed = YES;
                verifyVc.ResultType = CloseResult;
                [self.navigationController pushViewController:verifyVc animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)refreshUnreadMessageCount {
    [self.tableView reloadData];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUnreadMessagePath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        
        DLog(@"get un read message count success.");
        strongSelf.unreadMessageCount = [response[@"data"][@"count"] integerValue];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [CRFAppManager defaultManager].unMessageCount = [NSString stringWithFormat:@"%ld",(long)strongSelf.unreadMessageCount];
        
        [strongSelf.tableView.mj_header endRefreshing];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)checkUserAccountStatus {
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        
        if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
            CRFRelateAccountViewController *controller = [CRFRelateAccountViewController new];
            controller.hidesBottomBarWhenPushed = YES;
            controller.relatePhone = [CRFAppManager defaultManager].userInfo.phoneNo;
            [strongSelf.navigationController pushViewController:controller animated:YES];
        } else {
            CRFCreateAccountViewController *controller = [CRFCreateAccountViewController new];
            controller.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:controller animated:YES];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)getInvestInfo {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestListPath),kUuid] paragrams:@{kPageSizeKey:@"100000",@"investStatusType":@"0"} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        DLog(@"get invest list count success.");
//        strongSelf.products = [CRFResponseFactory myInvestList:response];
        //计息中1笔（共5笔）
        strongSelf.investInfo = [NSString stringWithFormat:@"计息中%@笔(共%@笔)",response[kDataKey][@"holdCount"],response[kDataKey][@"totalCount"]];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        [strongSelf refreshUnreadMessageCount];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf refreshUnreadMessageCount];
    }];
}

- (void)getUserAssetsTotal {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUserAssetsTotalPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        NSLog(@"===============================");
        DLog(@"get user assets success.");
        CRFAccountInfo *info = [CRFResponseFactory getAccountInfo:response];
        [CRFAppManager defaultManager].accountInfo = info;
        strongSelf.headerView.accountInfo = info;
        [strongSelf getInvestInfo];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf getInvestInfo];
    }];
}

- (void)refresh {
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        if ([CRFAppManager defaultManager].login) {
            [strongSelf.headerView refreshImageView];
            [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
                NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
                if (!success) {
                    [CRFUtils showMessage:response[kMessageKey]];
                }
            }];
            if ([CRFAppManager defaultManager].accountStatus) {
                [weakSelf crf_showAuthView];
                [strongSelf getUserAssetsTotal];
            } else {
                [self refreshUnreadMessageCount];
            }
            
        } else {
            [strongSelf.tableView.mj_header endRefreshing];
        }
    }];
    if ([CRFUtils isIPhoneXAll]) {
        self.tableView.mj_header.mj_h = 64;
    }
}

- (CRFQAView *)qaView {
    if (!_qaView) {
        _qaView = [[[NSBundle mainBundle] loadNibNamed:@"CRFQAView" owner:nil options:nil] lastObject];
        _qaView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kScreenHeight);
        _qaView.qaStyle = CRFQAExplain;
        _qaView.title = @"金额说明";
        _qaView.content1 = @"用户在信而富平台上拥有的计息中资产总额。";
        _qaView.content2 = @"用户可直接支配的金额。一般来说，用户进行充值后，资金会进入可用余额。出借计划完成结算后，本息也会进入可用余额。可用余额里的资金用户可提现到银行卡也可以继续出借。";
        _qaView.content3 = @"用户在平台上获得的历史出借计划收益总和。";
        _qaView.title1 = @"总资产";
        _qaView.title2 = @"可用余额";
        _qaView.title3 = @"累计收益";
    }
    return _qaView;
}
@end
