//
//  CRFRelateAccountStatusViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRelateAccountStatusViewController.h"
//#import "CRFRechargeViewController.h"
#import "CRFRechargeContainerViewController.h"
#import "CRFControllerManager.h"

@interface CRFRelateAccountStatusViewController ()

@end

@implementation CRFRelateAccountStatusViewController

- (void)back {
    if (self.tabBarController.selectedIndex != 3) {
         self.tabBarController.selectedIndex = 3;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_create_account_status", nil);
    //TODO  :
    [CRFControllerManager refreshUserInfo];
    [CRFControllerManager resetHomeConfig];
    [CRFControllerManager refreshUserInfo];
}

- (IBAction)recharge:(id)sender {
    CRFRechargeContainerViewController *controller = [[CRFRechargeContainerViewController alloc] init];
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    controller.bankInfo = [NSString stringWithFormat:NSLocalizedString(@"format_bank_card", nil),[userInfo.bankCode getBankCode].bankName,[userInfo.openBankCardNo substringFromIndex:userInfo.openBankCardNo.length - 4]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)gotoHome:(UIButton *)sender {
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
