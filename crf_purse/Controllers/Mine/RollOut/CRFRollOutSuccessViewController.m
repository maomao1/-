//
//  CRFRollOutSuccessViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRollOutSuccessViewController.h"
#import "CRFControllerManager.h"

@interface CRFRollOutSuccessViewController ()

@end

@implementation CRFRollOutSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_feedback_roll_out", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [CRFControllerManager refreshTotalAssert];
    // Do any additional setup after loading the view from its nib.
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (IBAction)rollOutContinue:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goHome:(id)sender {
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
