//
//  CRFInvestdetailCell.m
//  crf_purse
//
//  Created by maomao on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestdetailCell.h"
#import "MJRefresh.h"

@interface CRFInvestdetailCell()

@end

@implementation CRFInvestdetailCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        NSString *jSString =@"";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        config.userContentController = wkUController;
        [wkUController addUserScript:wkUserScript];
        [wkUController addUserScript:[self addUserScript]];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) configuration:config];
        //        [contentScroll addSubview:_webView];
        [self addSubview:_webView];
        self.webView.navigationDelegate = self;
        weakSelf(self);
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongSelf(weakSelf);
            [strongSelf.webView reload];
        } ];
        [self.webView addObserver:self
                       forKeyPath:@"title"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
        //        _investBtn.backgroundColor = kBtnAbleBgColor;
        //        [_investBtn setTitle:@"马上投资" forState:UIControlStateNormal];
        //        _investBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //        _investBtn.titleLabel.textColor = [UIColor whiteColor];
        //        [_investBtn addTarget:self action:@selector(investEvent) forControlEvents:UIControlEventTouchUpInside];
        //        _investBtn.frame = CGRectMake(0, frame.size.height-kButtonHeight, kScreenWidth, kButtonHeight);
        //        [self.webView removeObserver];
    }
    return self;
}

- (WKUserScript *)addUserScript {
    NSString *source = @"var style = document.createElement('style'); \
    style.type = 'text/css'; \
    style.innerText = '*:not(input):not(textarea) { -webkit-user-select: none; -webkit-touch-callout: none; }'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(style);";
    // javascript注入
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    return noneSelectScript;
}

- (void)loadWebViewWithUrl:(NSString *)urlStr{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0]];
    [CRFLoadingView loading];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (self.webTitleBlock) {
            self.webTitleBlock(self.webView.title, [self.webView canGoBack]);
        }
    }
}
#pragma mark = WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView.scrollView.mj_header endRefreshing];
    [CRFLoadingView dismiss];
    DLog(@"finished");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webView.scrollView.mj_header endRefreshing];
    [CRFLoadingView dismiss];
    DLog(@"failed");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webView.scrollView.mj_header endRefreshing];
    [CRFLoadingView dismiss];
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s", __FUNCTION__);
}

//开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    if ([navigationResponse.response.URL.absoluteString containsString:@"webp2p_static/invests/views/evaluating/evaluating"]) {
        if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].accountStatus) {
            decisionHandler(WKNavigationResponsePolicyAllow);
            if ([navigationResponse.response.URL.absoluteString containsString:@"evaluating/evaluating_tm."]) {
                self.webViewCanGoBack(Warning);
            } else if ([navigationResponse.response.URL.absoluteString containsString:@"views/evaluating/evaluating_result"]) {
                self.webViewCanGoBack(Close);
            } else {
                self.webViewCanGoBack(GoBack);
            }
            return;
        } else {
            decisionHandler(WKNavigationResponsePolicyCancel);
            if (self.gotoLoginAndCreateAccount) {
                self.gotoLoginAndCreateAccount();
            }
        }
        return;
    }
    self.webViewCanGoBack(GoBack);
    BOOL success;
//     [CRFLoadingView loading];
    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 404) {
        success = NO;
          [CRFLoadingView dismiss];
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        success = YES;
        decisionHandler (WKNavigationResponsePolicyAllow);
    }
    [CRFNotificationUtils postNotificationName:kWebViewNotFoundNotificationName userInfo:@{@"status":@(success)}];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    DLog(@"didReceiveScriptMessage");
    NSDictionary *dict = message.body;
    if ([dict[@"body"] isEqualToString:@"errorAlert"]) {
        if (self.showErrorForWebView) {
            self.showErrorForWebView(Show_Error_Alert,dict[@"params"]);
        }
    } else if ([dict[@"body"] isEqualToString:@"showToast"]) {
        if (self.showErrorForWebView) { self.showErrorForWebView(Show_Error_Toast,dict[@"params"]);
        }
    } else if ([dict[@"body"] isEqualToString:@"callNativeRefreshToken"]) {
        self.showErrorForWebView(Show_Error_RefreshToken,dict[@"params"]);
    } else if ([dict[@"body"] isEqualToString:@"finishCurrentPage"]) {
        self.showErrorForWebView(Show_Pop,nil);
    }
}


//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"%s", __FUNCTION__);
    NSString *urlStr = webView.URL.absoluteString ;
    NSLog(@"%@",urlStr);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    _webView = nil;
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"appModel"];
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}
@end
