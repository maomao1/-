//
//  CRFCovertViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCovertViewController.h"
#import "CRFAlertUtils.h"
#import "CRFRewardViewController.h"

@interface CRFCovertViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation CRFCovertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_convert_coupon", nil);
    [self rightButton];
}

- (IBAction)convert:(id)sender {
    if (self.inputTextField.text.length <= 0) {
        [CRFUtils showMessage:@"toast_input_convert_code"];
        return;
    }
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kConvertCouponPath),kUuid,self.inputTextField.text] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
        [CRFLoadingView dismiss];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
    }];
}

- (void)parseResponse:(id)response {
    [self.view endEditing:YES];
    [self reloadDatas];
    weakSelf(self);
    [CRFAlertUtils showAlertTitle:@"兑换成功!" imagedName:@"alert_success" container:self cancelTitle:nil confirmTitle:@"确定" cancelHandler:nil confirmHandler:^{
        strongSelf(weakSelf);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reloadDatas {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CRFRewardViewController class]]) {
            ((CRFRewardViewController *)vc).reloadCouponDatas();
        }
    }
}

- (void)rightButton {
    UIImage *image = [UIImage imageNamed:@"know_convert_code"];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(knowCode)];
}

- (void)knowCode {
    CRFStaticWebViewViewController *controller = [CRFStaticWebViewViewController new];
    controller.urlString = kKnowCouponCodeH5;
    [self.navigationController pushViewController:controller animated:YES];
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
