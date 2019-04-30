//
//  CRFOpenAccountStatusViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFOpenAccountStatusViewController.h"
#import "CRFRechargeContainerViewController.h"
#import "CRFControllerManager.h"

@interface CRFOpenAccountStatusViewController ()

@end

@implementation CRFOpenAccountStatusViewController

- (IBAction)backHome:(id)sender {
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)recharge:(id)sender {
    
    [self.navigationController pushViewController:[CRFRechargeContainerViewController new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_create_account_status", nil);
    [CRFControllerManager resetMineConfig];
    [CRFControllerManager resetHomeConfig];
    [CRFControllerManager refreshUserInfo];
    // Do any additional setup after loading the view from its nib.
}
- (void)back{
    if (self.tabBarController.selectedIndex != 3) {
         self.tabBarController.selectedIndex = 3;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (BOOL)fd_interactivePopDisabled {
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
