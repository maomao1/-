//
//  CRFInvestOperaStatusViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestOperaStatusViewController.h"
#import "CRFInvestStatusViewController.h"
#import "CRFMyInvestViewController.h"

@interface CRFInvestOperaStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;



@end

@implementation CRFInvestOperaStatusViewController

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.operaStatus == Opera_Logout) {
        self.navigationItem.title = NSLocalizedString(@"title_apply_logout", nil);
        self.promptLabel.text = NSLocalizedString(@"label_apply_logout_success", nil);
    } else {
        self.navigationItem.title = NSLocalizedString(@"title_transfer_feedback", nil);
        self.promptLabel.text = NSLocalizedString(@"label_transfer_success", nil);
    }
}

- (void)back {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"CRFMyInvestViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (IBAction)lookupDetail:(id)sender {
    if (self.operaStatus == Opera_Logout) {
        CRFInvestStatusViewController *controller = [CRFInvestStatusViewController new];
         self.product.investStatus = @"5";
        controller.product = self.product;
         controller.type = 1;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        CRFInvestStatusViewController *controller = [CRFInvestStatusViewController new];
        self.product.investStatus = @"6";
        controller.product = self.product;
        controller.type = 1;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshInvest];
}

- (void)refreshInvest {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CRFMyInvestViewController class]]) {
            ((CRFMyInvestViewController *)vc).refreshProduct();
        }
    }
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
