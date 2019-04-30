//
//  CRFRewardViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRewardViewController.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFCovertViewController.h"

@interface CRFRewardViewController ()

@end

@implementation CRFRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configRightButtons];
    weakSelf(self);
    self.reloadCouponDatas = ^ {
        strongSelf(weakSelf);
        [strongSelf.webView reload];
    };
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    [super back];
}

- (void)configRightButtons {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"coupon_help"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"coupon_convert"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(convert) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(0, 0, 71, 20);
     UIBarButtonItem *convertButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItems = @[helpButton,convertButton];
}

- (void)help {
    [self pushToNext:kCouponUseExplainH5];
}

- (void)convert {
    CRFCovertViewController *controller = [CRFCovertViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([self.webView canGoBack]) {
        self.navigationItem.rightBarButtonItems = nil;
    } else {
        [self configRightButtons];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if ([navigationResponse.response.URL.absoluteString containsString:@"platformActivity.html"]) {
        self.tabBarController.selectedIndex = 2;
        [self.navigationController popToRootViewControllerAnimated:YES];
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
    [super webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
}

- (void)pushToNext:(NSString *)url {
    CRFStaticWebViewViewController *controller = [CRFStaticWebViewViewController new];
    controller.urlString = url;
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
