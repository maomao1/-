//
//  CRFDebtDetailViewController.m
//  crf_purse
//
//  Created by maomao on 2018/9/26.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDebtDetailViewController.h"

@interface CRFDebtDetailViewController ()

@end

@implementation CRFDebtDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadUrl];
    [self setUI];
    
}
- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super back];
    }
}
-(void)setUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(0);
    }];
}
//- (void)loadUrl {
//    NSString *url = nil;
//    url = [NSString stringWithFormat:kDebtDetailH5,self.proDebtModel.transferStatus,self.proDebtModel.transferingNo,self.proDebtModel.rightsNo];
//    self.urlString = url;
////    self.urlString = [NSString stringWithFormat:@"%@&%@",url,kH5NeedHeaderInfo];
//    
//}
#pragma mark -- WKWebView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([keyPath isEqualToString:@"title"]) {
        self.webTitle = self.webView.title;
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
