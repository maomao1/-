//
//  CRFStaticWebViewViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFStaticWebViewViewController.h"
#import "CRFSharedView.h"
#import "CRFAlertUtils.h"
#import "CRFLoginViewController.h"
#import "CRFControllerManager.h"
#import "CRFAppCache.h"
#import "CRFProductDetailViewController.h"
#import "CRFMessageScrollViewController.h"
#import "CRFRechargeViewController.h"
#import "CRFRechargeContainerViewController.h"
#import "CRFMyInvestViewController.h"
#import "CRFRefreshTokenTool.h"
#import <AVFoundation/AVFoundation.h>
#import "MJRefresh.h"
#import "CRFPhotoUnit.h"
#import "UIImage+Color.h"
#import "CRFAddressViewController.h"

@interface CRFWeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id <WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end


@implementation CRFWeakScriptMessageDelegate

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

@interface CRFWebMessageModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL showIcon;
@property (nonatomic, copy) NSString *button;

@end

@implementation CRFWebMessageModel

@end


@interface CRFStaticWebViewViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler,CRFLoginViewControllerDelegate>

@property (nonatomic, strong) CRFSharedView *sharedView;

@property (nonatomic, strong) CRFWeakScriptMessageDelegate *scriptMessageDelegagte;

@property (nonatomic, strong) NSMutableArray *shareUrlArray;
@property (nonatomic, strong) NSDictionary *shareItem;
@property (nonatomic , assign) BOOL  isLoginRefresh;
@end

@implementation CRFStaticWebViewViewController

-(NSMutableArray *)shareUrlArray{
    if (!_shareUrlArray) {
        _shareUrlArray = [[NSMutableArray alloc]init];
    }
    return _shareUrlArray;
}
- (CRFSharedView *)sharedView {
    if (!_sharedView) {
        _sharedView = [[CRFSharedView alloc] init];
    }
    return _sharedView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.webTitle;
    [self prepareAudio];
    [self loadWebView];
    [self autoLayoutSizeContentView:self.webView.scrollView];
    if (self.webType == WebFull) {
        if (self.backViewStyle == WebViewBackViewStyle_Black) {
            [self customNavigationBackForBlack];
        } else if (self.backViewStyle == WebViewBackViewStyle_White){
            [self customNavigationBackForWhite];
        }
    } else {
        if (self.backViewStyle == WebViewBackViewStyle_None) {
            self.navigationItem.leftBarButtonItem = nil;
        } else if (self.backViewStyle == WebViewBackViewStyle_White){
            [self backBarbuttonForWhite];
            [self setBarWhiteTextColor];
        } else{
            [self backBarbuttonForBlack];
        }
    }
    if (self.rightStyle == WebViewRightStyle_Shared) {
        [self crfSetRightBarItem];
    }
}

- (void)crfSetRightBarItem {
    UIImage *image = [UIImage imageNamed:@"shared_icon"];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(shared)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)shared {
    weakSelf(self)
    //    if ([CRFRefreshUserInfoHandler defaultHandler].investingHtml.length <= 0) {
    [[CRFRefreshUserInfoHandler defaultHandler] getInvestingDatas:^(BOOL success, id response) {
        strongSelf(weakSelf);
        NSLog(success? @"get Investing html success":@"get Investing html failed");
        if (success) {
            [strongSelf sharedSomething];
        }
    }];
    //    } else {
    //        [self sharedSomething];
    //    }
}

- (void)sharedSomething{
    self.sharedView.sharedProduct = NO;
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString *sharedDescription = [CRFRefreshUserInfoHandler defaultHandler].invitingContent;
    messageObject.text = sharedDescription;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[CRFRefreshUserInfoHandler defaultHandler].invitingTitle descr:sharedDescription thumImage:[UIImage imageNamed:@"shared_red_activity"]];
    //设置网页地址
    shareObject.webpageUrl = [CRFRefreshUserInfoHandler defaultHandler].investingHtml;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [self.sharedView show:messageObject];
}
-(void)getH5Shared{
    if (self.shareItem.allKeys) {
        [self htmlShared:self.shareItem];
    }else{
        NSString *js = [NSString stringWithFormat:@"clickShareIcon()"];
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable res, NSError * _Nullable error) {
            NSLog(error?@"调用JS失败":@"调用JS成功");
        }];
    }
}
//为h5提供显示分享按钮
-(void)setH5IsShare:(BOOL)isShared{
    if (isShared) {
        UIImage *image = self.statusBarIsWhite?[UIImage imageNamed:@"h5_shared"]:[UIImage imageNamed:@"shared_icon"];
        image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(getH5Shared)];
        self.navigationItem.rightBarButtonItem = right;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
-(void)htmlShared:(NSDictionary *)params{
    self.sharedView.sharedProduct = NO;
    NSArray *allkeys = params.allKeys;
    NSString *title=nil;
    NSString *content=nil;
    NSString *shareUrl=nil;
    NSString *iconUrl=nil;
    NSString *singleImgUrl=nil;
    if ([allkeys containsObject:@"shareUrl"]) {
        shareUrl =params[@"shareUrl"];
    }
    if ([allkeys containsObject:@"content"]) {
        content = params[@"content"];
    }
    if ([allkeys containsObject:@"title"]) {
        title = params[@"title"];
    }
    if ([allkeys containsObject:@"iconUrl"]) {
        iconUrl = params[@"iconUrl"];
    }
    if ([allkeys containsObject:@"singleImgUrl"]) {
        singleImgUrl = params[@"singleImgUrl"];
    }
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = content;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:iconUrl.length?iconUrl: [UIImage imageNamed:@"shared_red_activity"]];
    
    //创建图片内容对象
    UMShareImageObject *shareImgObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareImgObject.thumbImage = iconUrl.length?iconUrl: [UIImage imageNamed:@"shared_red_activity"];
    
    [shareImgObject setShareImage:singleImgUrl.length?singleImgUrl: [UIImage imageNamed:@"shared_red_activity"]];
    //设置网页地址
    shareObject.webpageUrl = shareUrl;
    //分享消息对象设置分享内容对象
    if (!singleImgUrl.length) {
        self.sharedView.titles = @[@"微信好友",@"微信朋友圈",@"QQ好友"];
        messageObject.shareObject = shareImgObject;
        
    }else{
        self.sharedView.titles = @[@"微信好友",@"微信朋友圈",@"QQ好友",@"短信",@"复制链接"];
        messageObject.shareObject = shareObject;
        
    }
    
    [self.sharedView show:messageObject];
}
- (BOOL)fd_interactivePopDisabled {
    if (self.popGestureDisable) {
        return YES;
    }
    return NO;
}

- (void)back {
    if (self.backType == WebViewClose) {
        [self setDefautBarColor];
        [super back];
        return;
    }
    if ([[self.webView.URL absoluteString] containsString:@"global_invite"]) {
        [self setDefautBarColor];
        [super back];
        return;
    }
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    [self setDefautBarColor];
    [super back];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[CRFAppCache shared] clearWebViewCache];
    [self.webView stopLoading];
    [self pausePlay];
}

- (void)prepareAudio {
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    [session setActive:YES error:&error];
    DLog(@"begin set session is %@",error);
}

- (void)pausePlay {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    DLog(@"clear error: %@",error);
}

- (BOOL)fd_prefersNavigationBarHidden {
    if (self.webType == WebFull) {
        return YES;
    }
    return NO;
}

- (WKWebView *)webView {
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
        _scriptMessageDelegagte = [[CRFWeakScriptMessageDelegate alloc] initWithDelegate:self];
        [config.userContentController addScriptMessageHandler:self.scriptMessageDelegagte name:@"AppModel"];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
    }
    return _webView;
}

/**
 禁止长安弹出框
 
 @return WKUserScript
 */
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

- (void)loadWebView {
    if (_webType == WebNav) {
        self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight- kNavHeight);
    } else {
        self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    DLog(@"webView url is %@",self.urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    if (!self.webView.superview) {
        [self.view addSubview:self.webView];
    }
    [self.webView loadRequest:request];
    [CRFLoadingView loading];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = [change[@"new"] doubleValue];
        if (progress >= 1.0) {
            if (self.webView.scrollView.mj_header) {
                [self.webView.scrollView.mj_header endRefreshing];
            }
            [CRFLoadingView dismiss];
        }
        return;
    }
    if ([keyPath isEqualToString:@"title"]) {
        [self setSyatemTitle:self.webView.title];
    }
    if (self.rightStyle == WebViewRightStyle_Shared) {
        if ([self.webView canGoBack]) {
            self.navigationItem.rightBarButtonItem = nil;
        } else {
            [self crfSetRightBarItem];
        }
    }else{
        if ([[self.webView.URL absoluteString] containsString:@"global_index.html"]||[[self.webView.URL absoluteString] containsString:@"global_invite"]){
            [self setH5IsShare:YES];
        }else{
            BOOL isShowShare = [self.shareUrlArray containsObject:[self.webView.URL absoluteString]];
            [self setH5IsShare:isShowShare];
        }
    }
}

#pragma mark = WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DLog(@"finished");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    DLog(@"didReceiveScriptMessage");
    NSDictionary *dict = message.body;
    if ([dict[@"body"] isEqualToString:@"getPacketAction"] || [dict[@"body"] isEqualToString:@"goLogin"]) {
        [self pushToLogin];
    } else if ([dict[@"body"] isEqualToString:@"normalAlert"]) {
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[dict[@"params"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        CRFWebMessageModel *model = [CRFWebMessageModel yy_modelWithJSON:params];
        [self normalAlert:model];
    } else if ([dict[@"body"] isEqualToString:@"errorAlert"]) {
        [self errorAlert:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"goToProductDetail"]) {
        [self goToProductDetail:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"tabBarSelected"]) {
        [self tabBarSelected:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"gotoNativeController"]) {
        [self gotoNativeController:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"showToast"]) {
        [self showToast:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"callNativeRefreshToken"]) {
        [self callNativeRefreshToken:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"finishCurrentPage"]) {
        [self finishCurrentPage];
    } else if ([dict[@"body"] isEqualToString:@"getParams"]) {
        [self getParams:dict[@"params"]];
    } else if ([dict[@"body"] isEqualToString:@"getAssignParams"]) {
        [self getAssignParams:dict[@"params"] callback:dict[@"callback"]];
    }
    else if ([dict[@"body"] isEqualToString:@"share"]) {
        [self htmlShared:dict[@"params"]];
    }else if ([dict[@"body"] isEqualToString:@"saveImage"]){
        [self htmlSaveImage:dict[@"params"]];
    }else if ([dict[@"body"] isEqualToString:@"onEvent"]){
        [self htmlUmeng:dict[@"params"]];
    }
    else if ([dict[@"body"] isEqualToString:@"goBack"]){
        [self back];
    }else if ([dict[@"body"] isEqualToString:@"resetRiskLevel"]){
        CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
        userInfo.riskLevel = dict[@"params"];
        [CRFSettingData setCurrentAccountInfo:userInfo];
    }else if ([dict[@"body"] isEqualToString:@"controlStatusBar"]){
        [self aboutNavgationItem:dict[@"params"]];
    }
}
-(void)aboutNavgationItem:(NSDictionary*)params{
    NSArray *allkeys = params.allKeys;
    if ([allkeys containsObject:@"isShare"]) {
        self.shareItem = params[@"isShare"];
    }
    if (self.shareItem.allKeys) {
        [self.shareUrlArray addObject:self.webView.URL.absoluteString];
        BOOL isShowShare = [self.shareUrlArray containsObject:[self.webView.URL absoluteString]];
        [self setH5IsShare:isShowShare];
    }
}
-(void)htmlUmeng:(NSDictionary*)params{
    NSString *eventId = nil;
    NSString *eventName = nil;
    NSArray *allkeys = params.allKeys;
    if ([allkeys containsObject:@"eventId"]) {
        eventId = params[@"eventId"];
    }
    if ([allkeys containsObject:@"eventName"]) {
        eventId = params[@"eventContent"];
    }
    [CRFAPPCountManager setEventID:eventId EventName:eventName];
}
-(void)htmlSaveImage:(NSDictionary *)params{
    NSArray *allkeys = params.allKeys;
    NSString *urlString;
    if ([allkeys containsObject:@"saveImageUrl"]) {
        urlString = params[@"saveImageUrl"];
    }
    [CRFAlertUtils actionSheetWithItems:@[@"保存图片"] container:self cancelTitle:@"取消" completeHandler:^(NSInteger index) {
        [CRFPhotoUnit saveImage:urlString];
    } cancelHandler:nil];
}
-(void)loginSuccess{
    _isLoginRefresh = YES;
    [self getParams:@"getAssignParams"];
    
}
-(void)reloadNavBarColor{
    [self setBlackBarColor];
    [self backBarbuttonForWhite];
    [self setBarWhiteTextColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    [CRFLoadingView loading];
    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 404) {
        self.requestStatus = Status_Not_Found;
        weakSelf(self);
        [self setRequestStatusOperationHandler:^{
            strongSelf(weakSelf);
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler (WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    DLog(@" current URL :%@",navigationAction.request.URL.absoluteString);
    //    if (self.isLoginRefresh) {
    //        NSString *urlStr = [[navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"] firstObject];
    //        self.urlString =[NSString stringWithFormat:@"%@?%@",urlStr,kH5NeedHeaderInfo];
    //        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    //
    //        DLog(@" self  URLstring :%@",self.urlString);
    //
    //        [webView loadRequest:request];
    //
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //        return;
    //    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//
//}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [CRFAlertUtils showAlertTitle:message message:nil container:self cancelTitle:nil confirmTitle:@"我知道了" cancelHandler:nil confirmHandler:nil];
    completionHandler();
}

- (void)pushToLogin{
    CRFLoginViewController *loginController = [CRFLoginViewController new];
    loginController.hidesBottomBarWhenPushed = YES;
    loginController.popType = PopFrom;
    if (self.haveDelegate) {
        loginController.delegate = self;
    }
    weakSelf(self);
    [loginController setReloadWebCall:^{
        [weakSelf reloadWeb];
    }];
    [self.navigationController pushViewController:loginController animated:YES];
}
-(void)reloadWeb{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AppModel"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"URL"];
    self.webView = nil;
    
    NSString *urlStr = [self.urlString componentsSeparatedByString:@"?"].firstObject;
    self.urlString = [NSString stringWithFormat:@"%@?%@",urlStr,kH5NeedHeaderInfo];
    [self loadWebView];
    
}
- (void)showToast:(NSString *)message {
    [CRFUtils showMessage:message];
}

- (void)normalAlert:(CRFWebMessageModel *)model {
    if (model.showIcon) {
        if (model.title && model.message) {
            [CRFAlertUtils showAlertTitle:model.title message:model.message imagedName:@"receive_success" container:self cancelTitle:nil confirmTitle:model.button cancelHandler:nil confirmHandler:nil];
        } else {
            NSString *message = model.title?model.title:model.message;
            [CRFAlertUtils showAlertTitle:message imagedName:@"receive_success" container:self cancelTitle:nil confirmTitle:model.button cancelHandler:nil confirmHandler:nil];
        }
    } else {
        [CRFAlertUtils showAlertTitle:model.title?model.title:model.message message:model.title?model.message:nil container:self cancelTitle:nil confirmTitle:model.button cancelHandler:nil confirmHandler:nil];
    }
}

- (void)errorAlert:(NSString *)message {
    [CRFControllerManager receivePushMessage:message confirmTitle:@"重新登录"];
}

- (void)goToProductDetail:(NSString *)productNo {
    CRFProductDetailViewController *controller = [CRFProductDetailViewController new];
    controller.productNo = productNo;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tabBarSelected:(NSString *)index {
    if (index.integerValue > self.tabBarController.viewControllers.count) {
        return;
    }
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = [index integerValue];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)finishCurrentPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getParams:(NSString *)callback {
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:kUserInfo.accessToken forKey:kAccessTokenKey];
    [param setValue:[CRFUserDefaultManager getDeviceUUID] forKey:@"deviceno"];
    [param setValue:[NSString getAppId] forKey:@"packageName"];
    [param setValue:[CRFAppManager defaultManager].clientInfo.os forKey:@"mobileOs"];
    [param setValue:kUserInfo.customerUid forKey:@"customerUid"];
    [param setValue:[CRFAppManager defaultManager].clientInfo.versionCode forKey:@"version_code"];
    [param setValue:kUuid forKey:@"uuid"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *js = [NSString stringWithFormat:@"%@('%@')", callback,[jsonString formatJsonStirng]];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        NSLog(error?@"调用JS失败":@"调用JS成功");
    }];
}

- (void)getAssignParams:(NSString *)params callback:(NSString *)callback {
    NSDictionary *assignParams = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSArray *allkeys = assignParams.allKeys;
    NSMutableDictionary *H5Params = [NSMutableDictionary new];
    if ([allkeys containsObject:kAccessTokenKey]) {
        [H5Params setValue:kUserInfo.accessToken forKey:kAccessTokenKey];
    }
    if ([allkeys containsObject:@"deviceno"]) {
        [H5Params setValue:[CRFUserDefaultManager getDeviceUUID] forKey:@"deviceno"];
    }
    if ([allkeys containsObject:@"packageName"]) {
        [H5Params setValue:[NSString getAppId] forKey:@"packageName"];
    }
    //    if ([allkeys containsObject:@"packageName"]) {
    //        [H5Params setValue:[NSString getAppId] forKey:@"deviceno"];
    //    }
    if ([allkeys containsObject:@"mobileOs"]) {
        [H5Params setValue:[CRFAppManager defaultManager].clientInfo.os forKey:@"mobileOs"];
    }
    if ([allkeys containsObject:@"customerUid"]) {
        [H5Params setValue:kUserInfo.customerUid forKey:@"customerUid"];
    }
    if ([allkeys containsObject:@"version_code"]) {
        [H5Params setValue:[CRFAppManager defaultManager].clientInfo.versionCode forKey:@"version_code"];
    }
    if ([allkeys containsObject:@"uuid"]) {
        [H5Params setValue:kUuid forKey:@"uuid"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:H5Params options:NSJSONWritingPrettyPrinted error:nil];
    
    if (!jsonData) {
        [self callJS:nil callback:callback];
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self callJS:[jsonString formatJsonStirng] callback:callback];
}

- (void)callJS:(NSString *)params callback:(NSString *)callback {
    NSString *js = [NSString stringWithFormat:@"%@('%@')", callback,params];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        NSLog(error?@"调用JS失败":@"调用JS成功");
    }];
}
/*
 跳转controller。我的投资0、充值页面1、消息中心下的消息2、消息中心下的系统公告3、登录4 收货地址5
 */
- (void)gotoNativeController:(NSString *)route {
    NSInteger index = route.integerValue;
    UIViewController *viewController = nil;
    switch (index) {
        case 0: {
            viewController = [CRFMyInvestViewController new];
            ((CRFMyInvestViewController *)viewController).selectedIndex = 1;
        }
            break;
        case 1: {
            viewController = [CRFRechargeContainerViewController new];
        }
            break;
        case 2: {
            viewController = [CRFMessageScrollViewController new];
        }
            break;
        case 3: {
            viewController = [CRFMessageScrollViewController new];
            ((CRFMessageScrollViewController *)viewController).selectedIndex = 1;
        }
            break;
        case 4: {
            viewController = [CRFLoginViewController new];
            ((CRFLoginViewController *)viewController).popType = PopDefault;
        }
            break;
        case 5: {
            viewController = [CRFAddressViewController new];
        }
            break;
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)callNativeRefreshToken:(NSString *)callBack {
    weakSelf(self);
    [CRFRefreshTokenTool refreshToken:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            strongSelf(weakSelf);
            NSString *js = [NSString stringWithFormat:@"%@('%@')", callBack,kUserInfo.accessToken];
            [strongSelf.webView evaluateJavaScript:js completionHandler:^(id _Nullable res, NSError * _Nullable error) {
                NSLog(error?@"调用JS失败":@"调用JS成功");
            }];
        } else {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)dealloc {
    @try {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AppModel"];
        [self.webView removeObserver:self forKeyPath:@"title"];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"URL"];
        
    } @catch (NSException *exception) {
        DLog(@"exception is %@",exception);
    } @finally {
        
    }
    _webView = nil;
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
    [CRFLoadingView dismiss];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.statusBarIsWhite) {
        return UIStatusBarStyleLightContent;
    }else{
        return UIStatusBarStyleDefault;
    }
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
