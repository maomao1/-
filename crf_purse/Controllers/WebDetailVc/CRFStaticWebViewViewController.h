//
//  CRFStaticWebViewViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import <WebKit/WebKit.h>
//typedef void (^refreshEvaluate)();
@protocol CRFStaticWebViewViewControllerDelegate <NSObject>
-(void)loginSuccess;
@end
/**
 导航栏样式

 - WebNav: 有导航栏
 - WebFull: 无导航栏
 */
typedef NS_ENUM(NSUInteger, WebViewType) {
    WebNav          = 0,
    WebFull         = 1
};

/**
 webView 是否关闭

 - WebViewClose: 关闭
 - WebViewGoBack: 网页后退
 */
typedef NS_ENUM(NSUInteger, WebViewBack) {
    WebViewClose            = 0,
    WebViewGoBack           = 1,
};

/**
 导航栏右边按钮的样式

 - WebViewRightStyle_None: 无按钮
 - WebViewRightStyle_Shared: 有分享按钮
 */
typedef NS_ENUM(NSUInteger, WebViewRightStyle) {
    WebViewRightStyle_None          = 0,
    WebViewRightStyle_Shared        = 1,
};

/**
 返回按钮的样式

 - WebViewBackViewStyle_Black: 黑色返回按钮
 - WebViewBackViewStyle_White: 白色返回按钮
 - WebViewBackViewStyle_None: 无返回按钮
 */
typedef NS_ENUM(NSUInteger, WebViewBackViewStyle) {
    WebViewBackViewStyle_Black      = 0,
    WebViewBackViewStyle_White      = 1,
    WebViewBackViewStyle_None       = 2,
};

@interface CRFStaticWebViewViewController : CRFBasicViewController
@property (nonatomic ,weak) id <CRFStaticWebViewViewControllerDelegate>delegate;
//@property (nonatomic, copy) refreshEvaluate evaluateRefresh;
//@property (nonatomic, assign) BOOL isRefreshUserInfo;
@property (nonatomic, assign) BOOL statusBarIsWhite;
/**
 加载的url string， 可设置导航标题
 */
@property (nonatomic, copy) NSString *urlString, *webTitle;

/**
 侧滑手势是否关闭，默认开启
 */
@property (nonatomic, assign) BOOL popGestureDisable;

/**
 设置导航栏样式
 */
@property (nonatomic, assign) WebViewType webType;

/**
 webView
 */
@property (nonatomic, strong) WKWebView *webView;

/**
 导航栏右边按钮的样式
 */
@property (nonatomic, assign) WebViewRightStyle rightStyle;

/**
 返回按钮的样式
 */
@property (nonatomic, assign) WebViewBack backType;

/**
 webView 是否可返回
 */
@property (nonatomic, assign) WebViewBackViewStyle backViewStyle;

@property (nonatomic, assign) BOOL haveDelegate;

/**
 监听webView的title变化

 @param keyPath keyPath description
 @param object object description
 @param change change description
 @param context context description
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context;

/**
 拦截url，决定是否加载该url

 @param webView webView description
 @param navigationAction navigationAction description
 @param decisionHandler decisionHandler description
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/**
 拦截url，决定是否加载该url

 @param webView webView description
 @param navigationResponse navigationResponse description
 @param decisionHandler decisionHandler description
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;



@end
