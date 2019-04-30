//
//  CRFEvaluatingViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFEvaluatingViewController.h"
#import "CRFAlertUtils.h"

@interface CRFEvaluatingViewController ()

@property (nonatomic, assign) BOOL showAlert;

@end

@implementation CRFEvaluatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    if (self.showAlert) {
        weakSelf(self);
        [CRFAlertUtils showAlertTitle:@"本次风险能力测评还未完成，退出后将不会保存当前进度，确定退出？" message:nil container:self cancelTitle:@"退出" confirmTitle:@"继续" cancelHandler:^{
            strongSelf(weakSelf);
            if (strongSelf.backHandler) {
                strongSelf.backHandler();
            }
            [super back];
        } confirmHandler:nil];
        return;
    }
    if (self.backHandler) {
        self.backHandler();
    }
    [super back];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSString *urlString = navigationResponse.response.URL.absoluteString;
    if ([urlString containsString:@"evaluating/evaluating_tm."]) {
        self.showAlert = YES;
    } else {
        self.showAlert = NO;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}


@end
