//
//  CRFNoticeView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNoticeView.h"
#import <WebKit/WebKit.h>

@interface CRFNoticeWeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id <WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end


@implementation CRFNoticeWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
@interface CRFNoticeView()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic , strong) WKWebView * webView;
@property (nonatomic, strong) CRFNoticeWeakScriptMessageDelegate *scriptMessageDelegagte;

@end


@implementation CRFNoticeView
-(instancetype)init{
    self=[super init];
    if (self) {
        [self addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (void)show {
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kSystemNoticeH5]]];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}
///
#pragma mark = WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DLog(@"finished");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    DLog(@"didReceiveScriptMessage");
    NSDictionary *dict = message.body;
    if ([dict[@"body"] isEqualToString:@"exitApp"]) {
        [self closeApp];
    }
}
-(void)closeApp{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        exit(0);
    });
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"failed");
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    DLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

//开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DLog(@"didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@"didFailProvisionalNavigation");
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    DLog(@"didCommitNavigation");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    [CRFLoadingView loading];
        decisionHandler (WKNavigationResponsePolicyAllow);
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//
//}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
}
//
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
-(WKWebView *)webView{
    if (!_webView) {
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        NSString *jSString =@"";
        config.allowsInlineMediaPlayback = YES;
        if ([[UIDevice currentDevice].systemVersion floatValue] <= 9.0) {
            config.mediaPlaybackAllowsAirPlay = NO;
            config.mediaPlaybackRequiresUserAction = NO;
        } else {
            config.allowsPictureInPictureMediaPlayback = NO;
            config.allowsAirPlayForMediaPlayback = NO;
            config.requiresUserActionForMediaPlayback = NO;
        }
        config.selectionGranularity = (WKSelectionGranularityCharacter | WKSelectionGranularityDynamic);
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.processPool = [[WKProcessPool alloc] init];
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        config.userContentController = wkUController;
        [wkUController addUserScript:wkUserScript];
        [wkUController addUserScript:[self addUserScript]];
        _scriptMessageDelegagte = [[CRFNoticeWeakScriptMessageDelegate alloc] initWithDelegate:self];
        [config.userContentController addScriptMessageHandler:self.scriptMessageDelegagte name:@"AppModel"];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
    }
    return _webView;
}
@end
