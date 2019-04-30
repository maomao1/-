//
//  CRFMoreViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMoreViewController.h"
#import "CRFModifyPwdViewController.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFFeedbackViewController.h"
#import "CRFDeviceManagerViewController.h"
#import "CRFAboutViewController.h"
#import "PCCircleViewConst.h"
//view
#import "CRFAboutTableViewCell.h"
//model
#import "CRFAppCache.h"
#import "CRFAlertUtils.h"
#import "CRFControllerManager.h"
#ifdef WALLET
#import "WMMJAboutViewController.h"
#endif
#import "CRFGestureVerifyViewController.h"
#import "CRFGestureViewController.h"
#import "CRFBasicNavigationController.h"

@interface CRFMoreViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray <NSMutableArray <NSString *>*>*datas;
}
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (assign, nonatomic) BOOL  isChange;

@property (nonatomic, assign) BOOL notificationStatus;


@end

@implementation CRFMoreViewController

- (void)updateNotificationStatus {
    [self configTableViewDatas];
    [self.settingTableView reloadData];
    if ([[CRFAppManager defaultManager] isOpenRemoteNotificationStatus] != self.notificationStatus) {
        [self.settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        self.notificationStatus = [[CRFAppManager defaultManager]isOpenRemoteNotificationStatus];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(updateNotificationStatus) name:UIApplicationWillEnterForegroundNotification];
    self.notificationStatus = [[CRFAppManager defaultManager] isOpenRemoteNotificationStatus];
    self.navigationItem.title = NSLocalizedString(@"title_setting", nil);
    [self.settingTableView registerClass:[CRFAboutTableViewCell class] forCellReuseIdentifier:CRFAboutCell_ID];
    [self.settingTableView registerClass:[CRFAboutTableViewCell class] forCellReuseIdentifier:CRFMoreSettingCell_ID];
    [self.settingTableView setSeparatorColor:kCellLineSeparatorColor];
    [self tableViewFooterView];
    [self autoLayoutSizeContentView:self.settingTableView];
    [self configTableViewDatas];
    [self.settingTableView reloadData];
}

- (void)configTableViewDatas {
    if ([[CRFAppManager defaultManager] supportTouchID]) {
        datas = @[@[NSLocalizedString(@"cell_label_modify_pwd", nil),[[CRFAppManager defaultManager] supportFaceID]?@"使用FaceID 登录":NSLocalizedString(@"cell_label_touchID_login", nil),@"手势密码",[CRFUserDefaultManager getFinalGesture]?@"修改手势密码":nil,NSLocalizedString(@"cell_label_device_manager", nil)],@[NSLocalizedString(@"cell_label_push", nil),NSLocalizedString(@"cell_label_feedback", nil),NSLocalizedString(@"cell_label_about", nil),NSLocalizedString(@"cell_label_clear_cache", nil)]];
    } else {
        datas = @[@[NSLocalizedString(@"cell_label_modify_pwd", nil),@"手势密码",[CRFUserDefaultManager getFinalGesture]?@"修改手势密码":nil,NSLocalizedString(@"cell_label_device_manager", nil)],@[NSLocalizedString(@"cell_label_push", nil),NSLocalizedString(@"cell_label_feedback", nil),NSLocalizedString(@"cell_label_about", nil),NSLocalizedString(@"cell_label_clear_cache", nil)]];
    }
}

- (void)tableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 63)];
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton setTitle:NSLocalizedString(@"button_logout", nil) forState:UIControlStateNormal];
    UIColor *color = kButtonNormalBackgroundColor;
    [logoutButton setTitleColor:color forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    logoutButton.backgroundColor = [UIColor whiteColor];
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius  = 5;
    logoutButton.layer.borderWidth = 1.0f;
    logoutButton.layer.borderColor = color.CGColor;
    [footerView addSubview:logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.height.mas_equalTo(42);
        make.top.equalTo(footerView).with.offset(kRegisterSpace);
    }];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.settingTableView.tableFooterView = footerView;
}


#pragma mark ---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFAboutTableViewCell *cell ;
    if (indexPath.section == 0) {
        if ([CRFAppManager defaultManager].supportTouchID) {
            if (indexPath.row == 1 || indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:CRFMoreSettingCell_ID];
                if (indexPath.row == 1) {
                    [cell.mm_switch setOn:[CRFUserDefaultManager getTouchID]];
                } else {
                    [cell.mm_switch setOn:[CRFUserDefaultManager getFinalGesture]];
                    [self setCellSwitchHandler:cell];
                }
            } else {
                cell= [tableView dequeueReusableCellWithIdentifier:CRFAboutCell_ID];
                cell.versionRed.hidden = YES;
            }
        } else {
            if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:CRFMoreSettingCell_ID];
                [cell.mm_switch setOn:[CRFUserDefaultManager getFinalGesture]];
                [self setCellSwitchHandler:cell];
            } else {
                cell= [tableView dequeueReusableCellWithIdentifier:CRFAboutCell_ID];
                cell.versionRed.hidden = YES;
            }
        }
    } else if (indexPath.section == 1 && indexPath.row ==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CRFMoreSettingCell_ID];
        cell.isCanSet = NO;
        [cell.mm_switch setOn:[[CRFAppManager defaultManager] isOpenRemoteNotificationStatus] animated:YES];
    } else {
        cell= [tableView dequeueReusableCellWithIdentifier:CRFAboutCell_ID];
        cell.versionRed.hidden = YES;
    }
    if (indexPath.section ==1 &&indexPath.row ==3) {
        cell.versionLabel.text = [[CRFAppCache shared]getAppCacheSize];
    } else {
        cell.versionLabel.hidden =YES;
    }
    cell.view = self.view;
    cell.titleLabel.text = datas[indexPath.section][indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //埋点
    [CRFAPPCountManager getEventIdForKey:datas[indexPath.section][indexPath.row]];
    
    UIViewController *controller = nil;
    if (indexPath.section == 0) {
        NSString *title = datas[indexPath.section][indexPath.row];
        if ([title isEqualToString:@"修改登录密码"]) {
            controller = [CRFModifyPwdViewController new];
        } else if ([title isEqualToString:@"使用指纹登录"]) {
            NSLog(@"指纹登录");
        } else if ([title isEqualToString:@"手势密码"]) {
            NSLog(@"手势密码");
        } else if ([title isEqualToString:@"修改手势密码"]) {
            controller = [CRFGestureVerifyViewController new];
            CRFBasicNavigationController *nav = [[CRFBasicNavigationController alloc] initWithRootViewController:controller];
            [controller setValue:@1 forKey:@"type"];
            [self.tabBarController presentViewController:nav animated:YES completion:nil];
            return;
        } else if ([title isEqualToString:@"设备管理"]) {
            controller = [CRFDeviceManagerViewController new];
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                DLog(@"推送提醒");
                //                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                //                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                //
                //                    [[UIApplication sharedApplication] openURL:url];
                //                }
            }
                break;
                
            case 1: {
                controller = [CRFFeedbackViewController new];
            }
                break;
            case 2: {
#ifdef WALLET
                controller = [WMMJAboutViewController new];
#else
                controller = [CRFAboutViewController new];
#endif
            }
                break;
            case 3:{
                DLog(@"清除缓存");
                [CRFAlertUtils showAlertTitle:@"确定删除缓存数据？" message:nil container:self cancelTitle:@"取消" confirmTitle:@"确定" cancelHandler:nil confirmHandler:^{
                    [CRFLoadingView loading];
                    [[CRFAppCache shared]clearAppCache:^{
                        [CRFUtils delayAfert:kToastDuringTime handle:^{
                            [CRFLoadingView dismiss];
                            CRFAboutTableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                            cell.versionLabel.text = @"0.00B";
                        }];
                    }];
                }];
                
            }
                break;
                
            default:
                break;
        }
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)logout {
    weakSelf(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"action_title", nil)] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"action_logout", nil)] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        strongSelf(weakSelf);
        [CRFLoadingView loading];
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kLogoutPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
            [strongSelf parseResponse:response];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [strongSelf parseResponse:response];
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"alert_view_button_cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)parseResponse:(id)response {
    DLog(@"logout success");
    [CRFLoadingView dismiss];
    [CRFUserDefaultManager saveFinalGesture:nil];
    [[CRFStandardNetworkManager defaultManager] destory];
    
#ifdef WALLET
        if ([CRFAppManager defaultManager].majiabaoFlag) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
#else
   
#endif
    [CRFControllerManager resetAppConfig];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setCellSwitchHandler:(CRFAboutTableViewCell *)cell {
    weakSelf(self);
    [cell setSwitchHandler:^(UISwitch *control){
        strongSelf(weakSelf);
        NSString *password = [CRFUserDefaultManager getFinalGesture];
        UIViewController *controller = nil;
        if (!password) {
            controller = [CRFGestureViewController new];
            [controller setValue:@1 forKey:@"type"];
            [((CRFGestureViewController *)controller) setResultHandler:^(BOOL result){
                [self updateNotificationStatus];
            }];
        } else {
            controller = [CRFGestureVerifyViewController new];
            [controller setValue:@2 forKey:@"type"];
            [((CRFGestureVerifyViewController *)controller) setResultHandler:^{
                [self updateNotificationStatus];
            }];
        }
        [strongSelf presentViewController:controller animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
