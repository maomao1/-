//
//  CRFBasicViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "UIImage+Color.h"
#import "CRFStringUtils.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFHomeConfigHendler.h"

@interface CRFBasicViewController () 

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *operaLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@end

@implementation CRFBasicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self isKindOfClass:[CRFStaticWebViewViewController class]]) {
        [self authAuthorizedSignatoryView];
    }
}

- (CRFSupervisionInfoView *)signatoryView{
    if (!_signatoryView) {
        _signatoryView = [[CRFSupervisionInfoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _signatoryView.crf_delegate = self;
    }
    return _signatoryView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [self backBarbuttonForBlack];
    [self config];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setBarTextColor];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(resourceDidUpdate) name:kReloadResourceNotificationName];
}

- (void)resourceDidUpdate {
    
}

- (void)authAuthorizedSignatoryView {
    if (![[CRFHomeConfigHendler defaultHandler].homeDataDicM.allKeys containsObject:kPotocolAuthKey]) {
        return;
    }
    if ([CRFAppManager defaultManager].login && kUserInfo.accountStatus.integerValue == 2 && kUserInfo.protocolValidation.integerValue == 1) {
        if ([self containAuthView]) {
                return;
        }
        [self.signatoryView showInView:[UIApplication sharedApplication].delegate.window];
        [self.signatoryView crfSetContent];
        
    }
}

- (BOOL)containAuthView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[CRFSupervisionInfoView class]]) {
            return YES;
        }
    }
    return NO;
}
- (void)setDefautBarColor {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGBValue(0x333333)];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"nav_line"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(CGFLOAT_MIN, CGFLOAT_MIN) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGBValue(0x333333), NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    self.view.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
}
- (void)setBlackBarColor {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor blackColor]]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(CGFLOAT_MIN, CGFLOAT_MIN) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    self.view.backgroundColor = [UIColor blackColor];
}
#pragma  mark *******统计页面开始与结束**********
// 进入页面，
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationItem.title) {
        NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
        //    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
        [[CRFAPPCountManager sharedManager]crf_pageViewEnter:cName];
    }
}

#pragma mark --protocol
- (void)crf_pushPotocol:(NSString *)urlStr {
    CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
    webViewController.urlString = urlStr;
    webViewController.backType = WebViewClose;
    webViewController.hidesBottomBarWhenPushed = YES;
    webViewController.popGestureDisable = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)crf_agreeAuthPotocol {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kAuthProtocolPath),kUserInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf.signatoryView dismiss];
        [strongSelf refreshUserInfo];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)refreshUserInfo {
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
        NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
        if (!success) {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    }];
}

// 退出页面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationItem.title) {
        NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
        [[CRFAPPCountManager sharedManager] crf_pageViewEnd:cName];
    }
//    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

//导航栏左边按钮
- (void)backBarbuttonForBlack{
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    UIBarButtonItem * leftBarbtn = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarbtn;
}

- (void)backBarbuttonForWhite {
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIBarButtonItem * leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarbtn;
}

- (void)setBarTextColor {
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:18],
    NSForegroundColorAttributeName:kTextDefaultColor}];
}
- (void)setBarWhiteTextColor {
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (void)customNavigationBackForWhite {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_white"]];
    [self.view addSubview:backImageView];
    backImageView.contentMode = UIViewContentModeCenter;
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavigationbarHeight);
        make.width.mas_equalTo(45);
    }];
}

- (void)customNavigationBackForBlack {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    [self.view addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    [backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    backImageView.contentMode = UIViewContentModeCenter;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavigationbarHeight);
        make.width.mas_equalTo(45);
    }];
}

- (void)back {
    if (![self isMemberOfClass:[CRFBasicViewController class]]) {
        if (self.parentViewController.childViewControllers.count>1) {
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

-(void)setAppCountManager{
    //业务需要 子类需重写（需在FucEvent.plist 文件 对应类配置方法）
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _statusView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    }
    return _statusView;
}

- (void)config {
    _statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.statusView addSubview:_statusImageView];
    [self.view addSubview:self.statusView];
    CGFloat margen = 160.0f;
    if (self.fd_prefersNavigationBarHidden) {
        margen = margen + kNavHeight;
    }
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusView).with.offset(margen * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(135, 100));
        make.centerX.equalTo(self.statusView.mas_centerX);
    }];
    _statusLabel = [UILabel new];
    [self.statusView addSubview:_statusLabel];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.text = @"哎呀，网络不给力";
    _statusLabel.font = [UIFont systemFontOfSize:15.0];
    _statusLabel.textColor = UIColorFromRGBValue(0x666666);
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.statusView);
        make.top.equalTo(_statusImageView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(15);
    }];
    _operaLabel = [UILabel new];
    _operaLabel.userInteractionEnabled = YES;
    [_operaLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshHandler)]];
    [self.statusView addSubview:_operaLabel];
    _operaLabel.textAlignment = NSTextAlignmentCenter;
    _operaLabel.text = @"点击刷新";
    _operaLabel.font = [UIFont systemFontOfSize:14.0];
    _operaLabel.textColor = UIColorFromRGBValue(0x4A90E2);
    [_operaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.statusView);
        make.top.equalTo(_statusLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(12);
    }];
    self.statusView.hidden = YES;
}

- (void)setRequestStatus:(RequestStatus)requestStatus {
    _requestStatus = requestStatus;
    if (_requestStatus == Status_Normal) {
        self.statusView.hidden = YES;
    } else if (_requestStatus == Status_Off_Line) {
        self.statusView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"error_network"];
        self.statusLabel.text = @"哎呀，网络不给力";
        self.operaLabel.text = @"点击刷新";
        [self.view bringSubviewToFront:self.statusView];
    } else if (_requestStatus == Status_Not_Found) {
        self.statusView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"error_not_found"];
        self.statusLabel.text = @"您访问的页面找不到了";
        self.operaLabel.text = @"返回上一页";
         [self.view bringSubviewToFront:self.statusView];
    } else if (_requestStatus == Status_Coupon_None) {
        self.statusView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"coupon_none"];
        self.statusLabel.text = @"暂无可用的优惠红包";
        [self.operaLabel setAttributedText:[CRFStringUtils setAttributedString:@"请关注平台活动获取更多优惠红包" lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:kLinkTextColor} range1:[@"请关注平台活动获取更多优惠红包" rangeOfString:@"平台活动"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[@"请关注平台活动获取更多优惠红包" rangeOfString:@"请关注"] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range3:[@"请关注平台活动获取更多优惠红包" rangeOfString:@"获取更多优惠红包"] attributes4:nil range4:NSRangeZero]];
        [self.view bringSubviewToFront:self.statusView];
    } else if (_requestStatus == Status_Home_Net_Error) {
        self.statusView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"home_network_error"];
        self.statusLabel.text = @"网络暂时开小差啦！";
        self.operaLabel.text = @"请稍后再试试吧～";
        _operaLabel.textColor = UIColorFromRGBValue(0x999999);
        [self.view bringSubviewToFront:self.statusView];
    } else if (_requestStatus == Status_AppointForward_None) {
        self.statusView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"mine_no_invest"];
        self.statusLabel.text = @"没有符合条件的转投计划";
        self.operaLabel.text = @"请重新选择转投意向";
        _operaLabel.textColor = UIColorFromRGBValue(0x999999);
        [self.view bringSubviewToFront:self.statusView];
    } else if (_requestStatus == Status_ExclusivePlan_None) {
        self.statusView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"mine_no_invest"];
        self.statusLabel.text = @"没有符合条件的出借计划";
        self.operaLabel.text = @"请重新选择出借意向";
        _operaLabel.textColor = UIColorFromRGBValue(0x999999);
        [self.view bringSubviewToFront:self.statusView];
    }
}

- (void)addRequestNotificationStatus:(RequestStatus)status handler:(void (^)(void))handler {
    self.requestStatusOperationHandler = handler;
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] networkIsVisible:^(BOOL visible) {
        strongSelf(weakSelf);
        if (visible) {
            strongSelf.statusView.hidden = YES;
            if (![CRFStandardNetworkManager defaultManager].reachabilityAvailable.available) {
                return ;
            }
            if (handler) {
                handler();
            }
        } else {
             strongSelf.requestStatus = status;
            if (strongSelf.viewBringSubViewToFrondHandler) {
                strongSelf.viewBringSubViewToFrondHandler();
            }
        }
    }];
}

- (void)refreshHandler {
    if (self.requestStatusOperationHandler) {
        self.requestStatusOperationHandler();
    }
}
- (void)dealloc {
    [CRFLoadingView dismiss];
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}
@end
