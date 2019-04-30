//
//  CRFEmailViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFEmailViewController.h"
#import "CRFEditEmailViewController.h"

@interface CRFEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation CRFEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_email", nil);
     self.emailLabel.text = [CRFAppManager defaultManager].userInfo.emailNo;
    [self refreshUser];
}

- (IBAction)editEmail:(id)sender {
    CRFEditEmailViewController *controller = [CRFEditEmailViewController new];
    controller.indexPath = self.indexPath;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshUser {
    weakSelf(self);
    self.refreshUserInfo = ^ {
        strongSelf(weakSelf);
        [CRFRefreshUserInfoHandler defaultHandler].userInfo = [CRFAppManager defaultManager].userInfo;
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            if (success) {
                strongSelf.emailLabel.text = [CRFAppManager defaultManager].userInfo.emailNo;
            } else {
                [CRFUtils showMessage:response[kMessageKey]];
            }
        }];
    };
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
