//
//  CRFEditEmailViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFEditEmailViewController.h"
#import "CRFModifyEmailView.h"
#import "CRFProfileViewController.h"
#import "CRFEmailViewController.h"

@interface CRFEditEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation CRFEditEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[CRFAppManager defaultManager].userInfo.emailNo isEmpty]) {
        self.navigationItem.title = NSLocalizedString(@"title_create_email", nil);
    } else {
        self.navigationItem.title = NSLocalizedString(@"title_modify_email", nil);
    }
    [self modifyPlaceholder];
}

- (void)modifyPlaceholder {
    [self.textField setValue:UIColorFromRGBValue(0xBBBBBB) forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont boldSystemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
}

- (IBAction)commit:(id)sender {
    [self.view endEditing:YES];
    if (![self.textField.text isEmailAddress]) {
        [CRFUtils showMessage:@"toast_email_validate"];
        return;
    }
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kModifyEmailPath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:@{@"email":self.textField.text} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
        [CRFLoadingView dismiss];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
    }];
}

- (void)parseResponse:(id)response {
    [self update];
    CRFModifyEmailView *view = [[CRFModifyEmailView alloc] initWithLinkUrl:self.textField.text];
    [view show:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)update {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CRFProfileViewController class]]) {
            ((CRFProfileViewController *)vc).updateProfileHandler(self.indexPath);
        }
        if ([vc isKindOfClass:[CRFEmailViewController class]]) {
            ((CRFEmailViewController *)vc).refreshUserInfo();
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
