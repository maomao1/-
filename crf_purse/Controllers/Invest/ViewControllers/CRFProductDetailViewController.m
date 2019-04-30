//
//  CRFProductDetailViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2018/2/6.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFProductDetailViewController.h"
#import "CRFOperateView.h"
#import "CRFSharedView.h"
#import "CRFControllerManager.h"
#import "CRFRelateAccountViewController.h"
#import "CRFCreateAccountViewController.h"
#import "CRFAlertUtils.h"
#import "MJRefresh.h"
#import "CRFHomeConfigHendler.h"
#import "CRFInvestConfirmView.h"
#import "CRFOperateView.h"
#import "CRFDownButton.h"
#import "CRFRechargeViewController.h"
#import "CRFCommonResultViewController.h"
#import "CRFCouponVC.h"
#import "CRFEvaluationView.h"
#import "NSDictionary+Sign.h"
#import "CRFMyInvestViewController.h"
#import "CRFAppointmentForwardPopView.h"
#import "CRFInvestStatusViewController.h"
#import "CRFExclusivePopView.h"
#import "CRFMessageVerifyViewController.h"
#import "CRFShowSwitchAlert.h"
#import "CRFRechargeContainerViewController.h"
@interface CRFProductDetailViewController () <CRFPopViewDelegate>

/**
 产品详情model
 */
@property (nonatomic, strong) CRFProductModel *productModel;

/**
 分享弹窗
 */
@property (nonatomic, strong) CRFSharedView *sharedView;

/**
 预约转投操作框
 */
@property (nonatomic, strong) CRFAppointmentForwardPopView *popView;

/**
 优惠券
 */
@property (nonatomic, strong) NSArray <CRFCouponModel *>*coupons;

/**
 出资金额
 */
@property (nonatomic, copy) NSString *investAmount;

/**
 当前停留是否在测评页
 */
@property (nonatomic, assign) BOOL evaluating;

/**
 出资协议
 */
@property (nonatomic, strong) NSArray <CRFProtocol *>*protocols;

/**
 出资确认框
 */
@property (nonatomic, strong) CRFInvestConfirmView *confirmView;

/**
 出资修改弹窗
 */
@property (nonatomic, strong) CRFOperateView *operationView;

/**
 出资按钮
 */
@property (nonatomic, strong) CRFDownButton *investBtn;

/**
 选中的优惠券
 */
@property (nonatomic, strong) CRFCouponModel *selectedCoupon;

/**
 测评弹窗
 */
@property (nonatomic, strong) CRFEvaluationView *evaluationView;

/**
 专属定制出资弹框
 */
@property (nonatomic, strong) CRFExclusivePopView *exclusivePopView;


/*
获取已出资额度
*/
@property (nonatomic, copy) NSString *limitQutao;
/**
 出借限额框
 */
@property (nonatomic, strong) CRFInvestConfirmView *limitTipsView;
/**
 出借限额框
 */
@property (nonatomic, strong) NSArray *limitRiskArrary;
@end

@implementation CRFProductDetailViewController

- (NSString *)getProductType {
    return self.productModel.productType;
}

- (void)viewDidLoad {
    [self loadUrl];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavHeight);
    }];
    [self customNavigationBackForBlack];
    [self setNavigationRightBarItem];
    [self getProductData];
    [self getUserLimitQuota];
    [self getRiskLimitData];
    if ([self getProductType].integerValue != 4) {
         [self getCouponData];
    }
    
    [self addRefreshHeader];
    [self initializeView];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super back];
    }
}

- (void)addRefreshHeader {
    weakSelf(self);
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        [strongSelf.webView reload];
    } ];
}

- (void)initializeView {
    _investBtn = [CRFDownButton new];
    _investBtn.crf_acceptEventInterval = 0.5f;
    _investBtn.titleLabel.textColor = [UIColor whiteColor];
    [_investBtn addTarget:self action:@selector(investEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_investBtn];
    [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
#ifdef WALLET
        if ([CRFAppManager defaultManager].majiabaoFlag) {
                  make.height.mas_equalTo(54);
        } else {
                  make.height.mas_equalTo(48);
        }
#else
          make.height.mas_equalTo(48);
#endif
      
        make.bottom.equalTo(self.view);
    }];
}

- (void)reloadInvestBtn {
    if (![self.productModel.type isEqualToString:@"4"]) {
        if ([self.productModel.isFull isEqualToString:@"1"] || ([self.productModel.planAmount calculateWithHighPrecision].doubleValue > .0  && [[self.productModel.planAmount calculateWithHighPrecision] isEqualToString:[self.productModel.finishAmount calculateWithHighPrecision]])) {
            self.investBtn.buttonStatus = CRFDownButtonStatusDisable;
            self.investBtn.enabled = NO;
            return;
        }
        self.investBtn.timeInvter = [self.productModel.saleTime longLongValue];
        [self.investBtn crf_StartCountDown];
    }
    self.investBtn.newcomer = self.productModel.isNewBie.integerValue == 1;
    self.investBtn.enabled = YES;
    if (self.productModel.isFull.boolValue) {
        self.investBtn.buttonStatus = CRFDownButtonStatusDisable;
    }
    if (self.productStyle == CRFProductStyleAppointmentForward) {
        self.investBtn.buttonStatus = CRFDownButtonStatusAppointmentForward;
    }
    if (self.productStyle == CRFProductStyleExclusive) {
        self.investBtn.buttonStatus = CRFDownButtonStatusExclusive;
    }
    if (self.productStyle == CRFProductStyleAutoInvest) {
        self.investBtn.buttonStatus = CRFDownButtonStatusAutoInvest;
    }
}

- (void)loadUrl {
    NSString *url = nil;
#ifdef WALLET
    if ([CRFUtils normalUser]) {
        url = [NSString stringWithFormat:kInvsetDetailH5,self.productNo];
    } else {
        url = [NSString stringWithFormat:kMJInvsetDetailH5,self.productNo];
    }
#else
    url = [NSString stringWithFormat:kInvsetDetailH5,self.productNo];
#endif
    self.urlString = [NSString stringWithFormat:@"%@&%@",url,kH5NeedHeaderInfo];
//    self.urlString =[NSString stringWithFormat:@"http://10.194.11.232:8020/invests/views/invests_detail.html?contractPrefix=XFYY2020041520200415001&%@",kH5NeedHeaderInfo];


}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString* cName = @"投资产品详情";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnter:cName];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = @"投资产品详情";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnd:cName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUserInfo];
    [self getUserLimitQuota];
    [self getRiskLimitData];
    
}
-(void)updateLimitQutao:(NSString*)limit{
    self.limitQutao = limit;
}
#pragma mark -- Data
- (void)refreshUserInfo {
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    if ([CRFAppManager defaultManager].login && userInfo.accountStatus.integerValue == 2 ) {
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            NSLog(success?@"获取用户信息成功":@"获取用户信息失败");
            if (!success) {
                [CRFUtils showMessage:response[kMessageKey]];
            }
        }];
    }
}

- (void)getProductData {
    weakSelf(self);
    if (!self.productNo.length) {
        return;
    }
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kInvestProductDetailUrlPath),self.productNo] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.productModel = [CRFProductModel yy_modelWithJSON:response[kDataKey]];
        [strongSelf setNavigationTitle:strongSelf.productModel];
        [strongSelf configProtocol];
        [strongSelf reloadInvestBtn];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)invest {
    NSString * promoteCodeStr = nil;
#ifdef WALLET
    promoteCodeStr = @"ios-2";
#else
    promoteCodeStr = @"ios-1";
#endif
    NSMutableDictionary*param = [[NSMutableDictionary alloc]init];
    if (self.selectedCoupon) {
        [param setValue:self.selectedCoupon.giftDetailId forKey:@"giftDetailId"];
    }
    [param setValue:[NSString stringWithFormat:@"%.f",_investAmount.doubleValue*100] forKey:@"amount"];
    [param setValue:@"3" forKey:@"source"];
    [param setValue:@"0" forKey:@"isTransfer"];
    [param setValue:promoteCodeStr forKey:@"promoteCode"];
    [param setValue:self.productModel.contractPrefix forKey:@"planNo"];
    NSInteger channel = 3;
    if (self.productStyle == CRFProductStyleExclusive) {
        channel = 2;
    }
    [param setValue:@(channel) forKey:@"investChannel"];
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(KInvestMoneyPath),kUuid] paragrams:[param signature] success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
        [CRFControllerManager refreshHomeUserAssert];
        [CRFControllerManager refreshMine];
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            [CRFAPPCountManager setEventID:@"INVEST_VIEW_INVEST_EVENT" EventName:[NSString stringWithFormat:@"马上加入成功:%@",self.productModel.contractPrefix]];
            [CRFUtils delayAfert:1.5 handle:^{
                strongSelf(weakSelf);
                CRFCommonResultViewController *successViewController = [CRFCommonResultViewController new];
                successViewController.commonResult = CRFCommonResultSuccess;
                successViewController.result = @"恭喜您投资成功！";
                successViewController.title = @"投资成功";
                successViewController.commonButtonTitle = @"查看详情";
                [successViewController setCommonButtonHandler:^(NSInteger index, CRFCommonResultViewController *resultController){
                    CRFMyInvestViewController *investlistViewConytroller = [CRFMyInvestViewController new];
                    investlistViewConytroller.selectedIndex = 0;
                    [resultController.navigationController pushViewController:investlistViewConytroller animated:YES];
                }];
                [successViewController setPopHandler:^(CRFCommonResultViewController *resultController){
                    if (resultController.tabBarController.selectedIndex != 1) {
                        resultController.tabBarController.selectedIndex = 1;
                    }
                    [resultController.navigationController popToRootViewControllerAnimated:YES];
                }];
                [strongSelf.navigationController pushViewController:successViewController animated:YES];
            }];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFAPPCountManager setFailedEventID:@"invest_failed" reason:response[kMessageKey] productNo:self.productModel.contractPrefix];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

//获取风险出借额度
-(void)getUserLimitQuota{
    if ([CRFAppManager defaultManager].login) {
        weakSelf(self);
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kUserLimitQuota),kUuid] success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [strongSelf updateLimitQutao:response[kDataKey]];
            self.limitQutao = response[kDataKey];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
//            [CRFUtils showMessage:response[kMessageKey]];
         }];
    }
}
-(void)getRiskLimitData{
    if ([CRFAppManager defaultManager].login) {
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kRiskLimitArea_key,@"risk_limit_cash"] success:^(CRFNetworkCompleteType errorType, id response) {
            NSArray *array = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:@"risk_limit_cash"];
            if (array.count) {
                self.limitRiskArrary = array;
            }
        } failed:^(CRFNetworkCompleteType errorType, id response) {
        }];
    }
}
- (void)getCouponData {
    if ([CRFAppManager defaultManager].login) {
        weakSelf(self);
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetUserGiftPath),kUuid] success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            strongSelf.coupons = [CRFResponseFactory handleCouponData:response];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
//            [CRFUtils showMessage:response[kMessageKey]];
        }];
    }
}

/**
 获取出资协议
 
 @param key 不同类型产品对应不同的key
 */
- (void)reloadProtocolListWithKey:(NSString *)key {
    weakSelf(self);
//    [NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),key]
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kHomePageArea_key,kRule_invest_protocal] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.protocols = [CRFResponseFactory handleProtocolForResult:response ForKey:key];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)checkAccountStatus {
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        UIViewController *controller = nil;
        if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
            controller = [CRFRelateAccountViewController new];
            [controller setValue:[CRFAppManager defaultManager].userInfo.phoneNo forKey:@"relatePhone"];
        } else {
            controller = [CRFCreateAccountViewController new];
        }
        [strongSelf.navigationController pushViewController:controller animated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)appointmentForwardComfirm {
    [CRFLoadingView loading];
    NSString *time = [NSString stringWithFormat:@"%lld",[CRFTimeUtil formatDateString:self.appointmentForwardParams[@"closeDate"] pattern:@"yyyy-MM-dd"]];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kAppointmentForwardPath),kUuid] paragrams:@{@"planNo" : self.appointmentForwardParams[@"planNo"] ? self.appointmentForwardParams[@"planNo"] : @"", @"couponsId":self.selectedCoupon.giftDetailId ? self.selectedCoupon.giftDetailId : @"0",@"destProType": [self getProductType].integerValue == 4 ? @(4) : self.appointmentForwardParams[@"destProType"],@"destPlanNo":self.productModel.contractPrefix,@"investDeadLine":self.appointmentForwardParams[@"investDeadLine"],@"investSource":@(3),@"investWay":self.appointmentForwardParams[@"investWay"],@"sourceInvestNo":self.appointmentForwardParams[@"sourceInvestNo"],@"subscribeChannel":self.productStyle == CRFProductStyleAutoInvest ? @(4) : @(1),@"destProType":self.productModel.productType,@"sourceCloseTime":time} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        strongSelf(weakSelf);
        [CRFUtils delayAfert:1.5 handle:^{
            CRFCommonResultViewController *successViewController = [CRFCommonResultViewController new];
            successViewController.commonResult = CRFCommonResultSuccess;
            successViewController.result = strongSelf.productStyle == CRFProductStyleAutoInvest ? @"恭喜您转投成功！" : @"恭喜您预约成功！";
            successViewController.title = strongSelf.productStyle == CRFProductStyleAutoInvest ? @"转投成功" : @"预约转投反馈";
            if (strongSelf.productStyle == CRFProductStyleAutoInvest) {
                successViewController.reason = @"预计次日完成（以实际完成时间为准）";
            }
            successViewController.commonButtonTitle = strongSelf.productStyle == CRFProductStyleAutoInvest ? @"查看详情" : @"确定";
            [successViewController setCommonButtonHandler:^(NSInteger index, CRFCommonResultViewController *resultController){
                [strongSelf popDetailControllerFrom:resultController];
            }];
            [successViewController setPopHandler:^(CRFCommonResultViewController *resultController){
                [strongSelf popDetailControllerFrom:resultController];
            }];
            [strongSelf.navigationController pushViewController:successViewController animated:YES];
        }];
        NSLog(@"===");
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        NSLog(@"===");
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)autoInvest {
    [self appointmentForwardComfirm];
}

- (void)popDetailControllerFrom:(UIViewController *)controller {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CRFInvestStatusViewController class]]) {
            CRFInvestStatusViewController *detailController = (CRFInvestStatusViewController *)vc;
            if (detailController.refreshProductInfo) {
                detailController.refreshProductInfo();
            }
            [controller.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark -- Lazy load
- (CRFSharedView *)sharedView {
    if (!_sharedView) {
        _sharedView = [[CRFSharedView alloc] init];
//        _sharedView.images = @[@"shared_frends",@"shared_frends_circle",@"shared_QQ",@"shared_sms"];
//        _sharedView.titles = @[@"微信好友",@"微信朋友圈",@"QQ好友",@"短信"];
    }
    return _sharedView;
}

- (CRFEvaluationView *)evaluationView {
    if (!_evaluationView) {
        _evaluationView = [CRFEvaluationView new];
        weakSelf(self);
        [_evaluationView setClickHandler:^(NSInteger index){
            strongSelf(weakSelf);
            if (index == 0) {
                return ;
            }
            CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
            NSString *urlString = [NSString stringWithFormat:@"%@?%@&contractPrefix=%@&limit=1",kRiskRevealH5,kH5NeedHeaderInfo,strongSelf.productModel.contractPrefix];
            webViewController.urlString = urlString;

            [strongSelf.navigationController pushViewController:webViewController animated:YES];
        }];
    }
    return _evaluationView;
}

- (CRFOperateView *)operationView {
    if (!_operationView) {
        _operationView = [[CRFOperateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49)];
        _operationView.couponsCount = 1;
        _operationView.crf_delegate = self;
        _operationView.productItem = self.productModel;
        _operationView.protocolArray = self.protocols;//合规出资协议
        _operationView.investAmount = self.investAmount;
    }
    return _operationView;
}

- (CRFAppointmentForwardPopView *)popView {
    if (!_popView) {
        _popView = [[CRFAppointmentForwardPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49)];
        _popView.forwardType = self.productStyle == CRFProductStyleAutoInvest ? CRFForwardProductTypeAutoInvest : CRFForwardProductTypeAppointmentForward;
         _popView.investAmount = self.appointmentForwardParams[@"investAmount"];
        _popView.couponsCount = ([self getProductType].integerValue == 4) ? 0 : 1;
        _popView.popViewDelegate = self;
        _popView.productItem = self.productModel;
        _popView.protocolArray = self.protocols;//合规出资协议
        _popView.item = [self.appointmentForwardParams[@"investWay"] integerValue];
       
    }
    return _popView;
}
- (CRFExclusivePopView *)exclusivePopView {
    if (!_exclusivePopView) {
        _exclusivePopView = [[CRFExclusivePopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49)];
        _exclusivePopView.couponsCount = 1;
        _exclusivePopView.popViewDelegate = self;
        _exclusivePopView.productItem = self.productModel;
        _exclusivePopView.protocolArray = self.protocols;//合规出资协议
    }
    return _exclusivePopView;
}
- (CRFInvestConfirmView *)confirmView {
    if (!_confirmView) {
        _confirmView = [[CRFInvestConfirmView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _confirmView;
}
- (CRFInvestConfirmView *)limitTipsView {
    if (!_limitTipsView) {
        _limitTipsView = [[CRFInvestConfirmView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _limitTipsView.btnTitles = @[@"知道了",@"重新测评"];
    }
    return _limitTipsView;
}
#pragma mark --Shared
- (void)setNavigationRightBarItem {
    if (self.productStyle != CRFProductStyleNormal) {
        return;
    }
    [self setCustomRightBarButtonWithImageNamed:@"shared_icon" target:self selector:@selector(shared)];
}

- (void)shared {
    if (!self.productModel) {
        return;
    }
    [CRFAPPCountManager setEventID:@"INVEST_DETAILS_SHARE_EVENT" EventName:self.productModel.contractPrefix];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString *titleName = [NSString stringWithFormat:@"%@【信而富理财】",self.productModel.productName];
    NSString *sharedDescription = [NSString stringWithFormat:@"本方案预期年化收益率%@%%，锁定期%@天，起投金额%@元，赶快投资赚取收益吧！",[self.productModel rangeOfYInterstRate],self.productModel.freezePeriod,self.productModel.lowestAmount];
    messageObject.text = sharedDescription;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleName descr:sharedDescription thumImage:[UIImage imageNamed:@"shared_thumImage"]];
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@&customerUid=%@",self.productModel.shareUrl,[CRFAppManager defaultManager].userInfo.customerUid];
    messageObject.shareObject = shareObject;
    [self.sharedView show:messageObject];
}

- (void)setNavigationTitle:(CRFProductModel *)model {
    if (!model) {
        return;
    }
    NSString *title = [NSString stringWithFormat:@"%@\n(编号：%@)",model.productName,model.contractPrefix];
    [self setCustomAttributedTitle:title lineSpace:3 attributedContent:model.productName attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} subContent:[NSString stringWithFormat:@"(编号：%@)",model.contractPrefix] subAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)}];
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] || [subView isKindOfClass:[UIButton class]]) {
            [self.view bringSubviewToFront:subView];
        }
    }
    
}

#pragma mark -- WKWebView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([keyPath isEqualToString:@"title"]) {
        if ([self.webView canGoBack]) {
            [self setCustomLineTitle:self.webView.title];
            for (UIView *subView in self.view.subviews) {
                if ([subView isKindOfClass:[UIImageView class]] || [subView isKindOfClass:[UIButton class]]) {
                    [self.view bringSubviewToFront:subView];
                }
                [UIView animateWithDuration:.3f animations:^{
                    self.investBtn.hidden = YES;
                }];
            }
            [self setRightButtonDisplay:YES];
        } else {
            [self setNavigationTitle:self.productModel];
            [self setRightButtonDisplay:NO];
            [UIView animateWithDuration:.3f animations:^{
                self.investBtn.hidden = NO;
            }];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    if ([navigationResponse.response.URL.absoluteString containsString:@"webp2p_static/invests/views/evaluating/evaluating"]) {
        if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].accountStatus) {
            decisionHandler(WKNavigationResponsePolicyAllow);
            if ([navigationResponse.response.URL.absoluteString containsString:@"evaluating/evaluating_tm."]) {
                self.evaluating = YES;
            } else {
                self.evaluating = NO;
            }
            return;
        } else {
            self.evaluating = NO;
            decisionHandler(WKNavigationResponsePolicyCancel);
            if (![CRFAppManager defaultManager].login) {
                [CRFControllerManager pushLoginViewControllerFrom:self popType:PopDefault];
            } else if (![CRFAppManager defaultManager].accountStatus) {
                [self checkAccountStatus];
            }
        }
        return;
    }
    self.evaluating = NO;
    [super webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {
        if (webView.backForwardList.backList.count > 0) {
            WKBackForwardListItem *item = webView.backForwardList.currentItem;
            if ([item.URL.absoluteString containsString:@"views/evaluating/evaluating"]) {
                //弹窗
                if (self.evaluating) {
                    [CRFAlertUtils showAlertTitle:@"本次风险能力测评还未完成，退出后将不会保存当前进度，确定退出？" message:nil container:self cancelTitle:@"退出" confirmTitle:@"继续" cancelHandler:^{
                        [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
                        [CRFControllerManager refreshUserInfo];
                    } confirmHandler:nil];
                    decisionHandler(WKNavigationActionPolicyCancel);
                    return;
                } else {
                    [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
                }
            }
        }
    }
    [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

#pragma mark --config
/**
 获取协议
 */
- (void)configProtocol {
    NSInteger productType = self.productModel.type.integerValue;
    NSString *productKey = nil;
    if (productType != 4) {
        if (productType == 3) {
            productKey = kXjd_invest_protocal;
            self.protocols = [CRFHomeConfigHendler defaultHandler].investXjdProtocols;
        } else {
            productKey = kOffline_invest_protocal;
            self.protocols = [CRFHomeConfigHendler defaultHandler].investLifeProtocols;
        }
    } else {
        productKey = kRule_invest_protocal;
        self.protocols = [CRFHomeConfigHendler defaultHandler].investRuleProtocols;
    }
    if (self.protocols.count <= 0) {
        [self reloadProtocolListWithKey:productKey];
    }
}

#pragma mark -- button
- (void)investEvent {
    if (!self.investBtn.enabled) {
        return;
    }
    switch (self.investBtn.buttonStatus) {
        case CRFDownButtonStatusLogin: {//登录
            [CRFControllerManager pushLoginViewControllerFrom:self popType:PopFrom];
        }
            break;
        case CRFDownButtonStatusOpen: {//开户
            [self checkAccountStatus];
        }
            break;
        case CRFDownButtonStatusEvalue: {//测评
            [self.evaluationView show];
        }
            break;
        case CRFDownButtonStatusRecharge: {//充值
            [self showVerifyInfo];
        }
            break;
        case CRFDownButtonStatusInvest: {//出资
            self.investBtn.enabled = !(self.investBtn.buttonStatus == CRFDownButtonStatusDisable);
            if (self.operationView.isShow) {
                [self gotoInvest];
            } else {
                self.operationView.investAmount = self.investAmount;
                
                [self.operationView showInView:self.view];
                
                if (!self.selectedCoupon) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self autoSelectedCoupon:self.investAmount];
                    });
                }
                
                [CRFAPPCountManager setEventID:@"INVEST_VIEW_INVEST_EVENT" EventName:[NSString stringWithFormat:@"弹窗马上加入按钮:%@",self.productModel.contractPrefix]];
            }
        }
            break;
        case CRFDownButtonStatusDisable:
        case CRFDownButtonStatusWaitSale:{//不可用
            NSLog(@"nothing do it");
        }
            break;
        case CRFDownButtonStatusAppointmentForward: {
            self.investAmount = self.appointmentForwardParams[@"investAmount"];
            [self.popView showInView:self.view];
            self.investBtn.buttonStatus = CRFDownButtonStatusComfirm;
        }
            break;
        case CRFDownButtonStatusComfirm: {
            if (self.popView.isAgree) {
                [self appointmentForwardComfirm];
            } else {
                [CRFUtils showMessage:@"请勾选同意相关协议"];
            }
        }
            break;
        case CRFDownButtonStatusExclusive: {
            self.investAmount = self.exclusiveAmount;
            if (self.exclusivePopView.isShow) {
                [self gotoInvest];
            } else {
                self.exclusivePopView.exclusiveAmount = self.exclusiveAmount;
                [self.exclusivePopView showInView:self.view];
            }
        }
            break;
        case CRFDownButtonStatusAutoInvest: {
            if ([self.view.subviews containsObject:self.popView] || CGSizeEqualToSize(self.popView.frame.size, CGSizeZero)) {
                if (self.popView.isAgree) {
                     [self autoInvest];
                } else {
                    [CRFUtils showMessage:@"请勾选同意相关协议"];
                }
            } else {
                self.investAmount = self.appointmentForwardParams[@"investAmount"];
                [self.popView showInView:self.view];
            }
        }
            break;
        case CRFDownButtonStatusNewcomer: {
            [CRFUtils showMessage:@"很遗憾，您不是新手，该计划只限未投资过的用户投资哦！"];
        }
            break;
    }
}
-(void)showVerifyInfo{
    
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    UIViewController *controller = nil;
    switch ([userInfo.accountSigned integerValue]) {
        case 1:{//1：已授权，2：未授权，3：信息异常，4，修改卡未授权 5
            //            controller = [CRFRechargeViewController new];
            //            controller.hidesBottomBarWhenPushed = YES;
            //            controller.popType = PopFrom_recharge;
            //            [self.navigationController pushViewController:controller animated:YES];
            
            CRFRechargeContainerViewController *rechargeVC = [CRFRechargeContainerViewController new];
            rechargeVC.popType = PopFrom_recharge;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case 6:{//不验签
            CRFRechargeContainerViewController *rechargeVC = [CRFRechargeContainerViewController new];
            rechargeVC.popType = PopFrom_recharge;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case 2:{
            controller = [CRFMessageVerifyViewController new];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:{
            CRFShowSwitchAlert *alertView =[[CRFShowSwitchAlert alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) AlertTitle:@"存管信息有误" content:@"尊敬的用户：\n您的第三方银行存管账户信息已失效，请按照下面的提示进行操作，感谢您的配合。\n1)如果您当前的注册手机号与银行预留手机号不一致，请前往银行网点或联系信而富客服400-178-9898进行修改。\n2)如果是姓名、身份证号或银行卡其中任何一项存在问题，请联系信而富客服400-178-9898进行存管账户注销；注销后重新开户即可。\n感谢您的理解与支持~" dismissHandler:nil confirmHandler:^{
                
            }];
            [alertView showInView:[UIApplication sharedApplication].delegate.window];
        }
            break;
        case 4:{
            [CRFAlertUtils showAlertTitle:@"温馨提示" contentLeftMessage:@"您已更改银行卡信息，请您进行短信验证操作，验证通过便可立即正常使用。" container:self cancelTitle:@"下次再说" confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                CRFMessageVerifyViewController *verifyVc = [[CRFMessageVerifyViewController alloc]init];
                verifyVc.ResultType = CloseResult;
                [self.navigationController pushViewController:verifyVc animated:YES];
            }];
        }
            break;
        case 5:{
            [CRFAlertUtils showAlertTitle:@"温馨提示" contentLeftMessage:@"您已成功修改存管账户信息，请您进行短信验证操作，验证通过便可正常充值。" container:self cancelTitle:@"下次再说" confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                CRFMessageVerifyViewController *verifyVc = [[CRFMessageVerifyViewController alloc]init];
                verifyVc.hidesBottomBarWhenPushed = YES;
                verifyVc.ResultType = CloseResult;
                [self.navigationController pushViewController:verifyVc animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
    
}
/**
 出资
 */
- (void)gotoInvest{
    [CRFAPPCountManager setEventID:@"INVEST_VIEW_INVEST_EVENT" EventName:[NSString stringWithFormat:@"马上加入按钮:%@",self.productModel.contractPrefix]];
    if(self.investAmount && self.investAmount.doubleValue < self.productModel.lowestAmount.doubleValue) {
        [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额不能低于%@元",self.productModel.lowestAmount]];
        return;
    }
    if (self.productModel.isNewBie.integerValue == 1||self.productModel.highestAmount.doubleValue>0) {
        if (self.investAmount.doubleValue > self.productModel.highestAmount.doubleValue) {
            [CRFUtils showMessage:@"不能超过加入上限"];
            return;
        }
    }
    if(self.productModel.investunit.longLongValue < 0 ||self.productModel.investunit.longLongValue == 0){
        return;
    }
    if(self.investAmount && (self.investAmount.longLongValue % self.productModel.investunit.longLongValue !=0 )) {
        [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额必须为%@的整倍数",self.productModel.investunit]];
        return;
    }
    if (self.productStyle == CRFProductStyleNormal) {
        if (!self.operationView.isAgree) {
            [CRFUtils showMessage:@"请确认您已经阅读并同意协议"];
        }
    } else if(self.productStyle == CRFProductStyleExclusive){
        if (!self.exclusivePopView.isAgree) {
            [CRFUtils showMessage:@"请确认您已经阅读并同意协议"];
        }
    }
    if ([self isOutOfQuota]) {
        [self showLimitQuotaTips];
        return;
    }
    if (self.productStyle == CRFProductStyleNormal) {
        if (self.operationView.isAgree) {
            //调用出资
            [self getAuthenUserInfo];
        }
    } else if(self.productStyle == CRFProductStyleExclusive){
        if (self.exclusivePopView.isAgree) {
            //调用出资
            [self getAuthenUserInfo];
        }
    }
    
}
-(void)showLimitQuotaTips{
    [self.limitTipsView showInView:[UIApplication sharedApplication].delegate.window];
    weakSelf(self);
    [self.limitTipsView setRiskLimitContent];
    self.limitTipsView.confirmBlock = ^{
        strongSelf(weakSelf);
        [strongSelf gotoEvalution];
        [strongSelf.operationView dismiss];
        
    };
    self.limitTipsView.againChoseBlock = ^{
        NSLog(@"nothing do it");
    };
}
- (void)getAuthenUserInfo {
//    if (![self.productModel.type isEqualToString:@"4"]) {
//    } else {
        // 合规产品 弹窗样式
        [self.confirmView showInView:[UIApplication sharedApplication].delegate.window];
        [self.confirmView setContentWithModel:self.productModel AndInvestAmount:_investAmount];
        weakSelf(self);
        self.confirmView.confirmBlock = ^{
            strongSelf(weakSelf);
            [strongSelf invest];
        };
        self.confirmView.againChoseBlock = ^{
            NSLog(@"nothing do it");
        };
//    }
}
-(void)gotoEvalution{
    CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@&contractPrefix=%@&limit=1",kRiskAgainH5,kH5NeedHeaderInfo,self.productModel.contractPrefix];
    webViewController.urlString = urlString;
    weakSelf(self);
//    webViewController.evaluateRefresh = ^{
//        [weakSelf refreshUserInfo];
//    };
    [self.navigationController pushViewController:webViewController animated:YES];
}
- (void)setInvestStatus:(NSString *)investAmount {
    BOOL status = investAmount.doubleValue > [[CRFAppManager defaultManager].accountInfo.availableBalance getOriginString].doubleValue;
    if (status) {
        self.investBtn.buttonStatus = CRFDownButtonStatusRecharge;
    } else {
        if (self.productStyle == CRFProductStyleExclusive) {
            self.investBtn.buttonStatus = CRFDownButtonStatusExclusive;
        } else if (self.productStyle == CRFProductStyleNormal) {
            self.investBtn.buttonStatus = CRFDownButtonStatusInvest;
        }
        //        self.investBtn.buttonStatus = CRFDownButtonStatusInvest;
    }
}

#pragma mark----operationDelegate
- (void)autoSelectedCoupon:(NSString *)investAmount {
    if (self.coupons.count) {
        CRFCouponModel *coupon;
        if (![self.productModel.type isEqualToString:@"4"]) {
            coupon = [CRFUtils selectedBestWithArray:self.coupons ForMoney:investAmount AndFreezid:self.productModel.freezePeriod.integerValue days:360 type:self.productModel.productType.integerValue == 1];
        } else {
            coupon = [CRFUtils selectedBestWithArray:self.coupons ForMoney:investAmount AndFreezid:(self.productModel.remainDays.integerValue - 1) days:365 type:self.productModel.productType.integerValue == 1];
        }
        self.selectedCoupon = coupon;
        if (self.productStyle == CRFProductStyleNormal) {
            [self.operationView selectedCoupon:coupon.giftName];
        } else if (self.productStyle == CRFProductStyleExclusive) {
            [self.exclusivePopView selectedCoupon:coupon.giftName];
        } else {
            [self.popView selectedCoupon:coupon.giftName];
        }
    }
}

- (void)gotoCouponsViewController {
    CRFCouponVC *couponVC = [CRFCouponVC new];
    NSString *amount = self.investAmount;
    if (self.productStyle == CRFProductStyleAppointmentForward) {
        amount = self.appointmentForwardParams[@"investAmount"];
    }
    couponVC.investAmount = amount;
    couponVC.planNo = self.productModel.contractPrefix;
    couponVC.selectedCoupon = self.selectedCoupon;
    weakSelf(self);
    [couponVC setCouponDidSelectedHandler:^ (CRFCouponModel *coupon){
        strongSelf(weakSelf);
        strongSelf.selectedCoupon = coupon;
        if (strongSelf.productStyle == CRFProductStyleAppointmentForward || strongSelf.productStyle == CRFProductStyleAutoInvest) {
            [strongSelf.popView selectedCoupon:coupon.giftName];
        } else if (strongSelf.productStyle == CRFProductStyleExclusive) {
            [strongSelf.exclusivePopView selectedCoupon:coupon.giftName];
        } else {
            [strongSelf.operationView selectedCoupon:coupon.giftName];
        }
    }];
    [self.navigationController pushViewController:couponVC animated:YES];
}

- (void)amountValueDidChanged:(NSString *)changedAmount {
    self.investAmount = changedAmount;
    [self setInvestStatus:changedAmount];
}

- (void)reviewProtocol:(NSString *)urlString {
    CRFStaticWebViewViewController * protoclVc = [CRFStaticWebViewViewController new];
    protoclVc.urlString = urlString;
    [self.navigationController pushViewController:protoclVc animated:YES];
}

- (void)cancel {
    if (self.productStyle == CRFProductStyleNormal) {
        self.investBtn.buttonStatus = CRFDownButtonStatusInvest;
    } else if (self.productStyle == CRFProductStyleExclusive) {
        self.investBtn.buttonStatus = CRFDownButtonStatusExclusive;
    } else if (self.productStyle == CRFProductStyleAutoInvest) {
        self.investBtn.buttonStatus = CRFDownButtonStatusAutoInvest;
    } else {
        [UIView animateWithDuration:.3f animations:^{
            self.investBtn.buttonStatus = CRFDownButtonStatusAppointmentForward;
        }];
    }
}
-(BOOL)isOutOfQuota{
    long long totalAmount = self.investAmount.longLongValue + self.limitQutao.longLongValue;
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    if (self.limitRiskArrary.count) {
        CRFAppHomeModel *quotaItem = [self.limitRiskArrary objectAtIndex:(userInfo.riskLevel.integerValue-1)];
        if (!quotaItem.content.length) {
            return NO;
        }
        if (totalAmount > quotaItem.content.longLongValue) {
            return YES;
        }
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
