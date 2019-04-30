//
//  CRFIMViewController.m
//  crf_purse
//
//  Created by crf on 2017/6/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFIMViewController.h"
#import "DESHelper.h"
@interface CRFIMViewController ()

@end

@implementation CRFIMViewController

- (void)viewDidLoad {
    self.webType = WebFull;
    self.backViewStyle = WebViewBackViewStyle_None;
    self.urlString = [NSString stringWithFormat:kOnlineCustomerService,[DESHelper encrypt:[CRFAppManager defaultManager].userInfo.phoneNo],[DESHelper encrypt:[CRFAppManager defaultManager].userInfo.userName]];
    [super viewDidLoad];
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight)];
    statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusView];
    self.webView.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    if ([URL.absoluteString containsString:@"#goRCSMine"]) {
        [self back];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
