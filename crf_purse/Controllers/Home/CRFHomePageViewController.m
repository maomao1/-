//
//  CRFHomePageViewController.m
//  crf_purse
//
//  Created by mystarains on 2019/1/4.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomePageViewController.h"
#import "CRFHomeHeaderView.h"
#import "CRFHomeConfigHendler.h"
#import "CRFHomePageViewController+Interface.h"
#import "CRFNovicesExclusiveTableViewCell.h"
#import "CRFHomeAdvertisementView.h"
#import "CRFRegisterViewController.h"
#import "CRFHomeInvestTableViewCell.h"
#import "CRFGestureManager.h"
#import "CRFHomeNavView.h"
#import "CRFHomeBottomView.h"
#import "CRFDIYHeader.h"
#import "CRFEvaluateAlertView.h"
#import "CRFExplanOperateViewController.h"
#import "CRFDepositoryManagementAlertView.h"
#import "AppDelegate+Service.h"

static CGFloat const kToolImageViewHeight = 100;

@interface CRFHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,HomeAdvertisementViewDelegate,CRFHomeHeaderViewDelegate>

@property (nonatomic, strong) CRFHomeNavView *navView;//导航
@property (nonatomic, strong) CRFHomeHeaderView *tableViewHeaderView;//顶部试图
@property (nonatomic, strong) CRFHomeBottomView *bottomView;//底部视图
@property (nonatomic, assign) BOOL isADShow;///<广告试图
@property (nonatomic, strong) CRFHomeAdvertisementView *advertiseView;//广告视图
@property (nonatomic, strong) UIImageView *toolImageView;//悬浮窗
@property (nonatomic, strong) CRFEvaluateAlertView *evaluateAlertView;//风险评测弹窗
@property (nonatomic, strong) CRFDepositoryManagementAlertView *depositoryManagementAlertView;//注册成功开户弹窗
@property (nonatomic,assign) double offset;
@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;

@end

@implementation CRFHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [CRFGestureManager upgradeVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString* cName = @"首页";
    [self addHomeDefaultView];
    [[CRFAPPCountManager sharedManager] crf_pageViewEnter:cName];

    [self.navView changeViewAlpha:(self.offset/100.f)];
    
    if ([CRFAppManager defaultManager].login) {
        if ([CRFAppManager defaultManager].accountStatus) {
            self.refreshTopHeader.accountInfo = [CRFAppManager defaultManager].accountInfo;
            [self getUserAssetsTotal];
        } else {
            self.refreshTopHeader.refreshType = Unlogin;
        }
    } else {
        self.refreshTopHeader.refreshType = Unlogin;
    }
    
}

// 退出页面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recommendTabView.mj_header endRefreshing];
    NSString* cName = @"首页";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnd:cName];
}

- (void)initializeView {
    _isADShow = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.recommendTabView];
    [self.view addSubview:self.navView];
    self.recommendTabView.tableHeaderView = self.tableViewHeaderView;
    self.recommendTabView.tableFooterView = self.bottomView;
    [self.recommendTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    //配置悬浮窗
    [self configToolImageView];
    
    [self setHomeDefaultDatas];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if ([_recommendTabView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _recommendTabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    
    [self setHomeHandler];
    //下拉背后视图
    [self freshHeader];
    //下拉刷新
    [self refreshHeader];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self channelDrainage:[CRFHomeConfigHendler defaultHandler].homeDataDicM];
    });
    
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(registerSuccessNoti:) name:kRegisterSuccessNotificationName];
    
}

- (void)registerSuccessNoti:(NSNotification *)noti{
    
    self.registerSuccess = YES;
}

- (void)refreshHeader {
    weakSelf(self);
    CRFDIYHeader *header = [CRFDIYHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        [weakSelf requestDatas];
        if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].accountStatus) {
            [strongSelf getUserAssetsTotal];
        }
    }];
    header.backgroundColor = [UIColor clearColor];
    self.recommendTabView.mj_header = header;
    [header setScrollViewContentOffSizeHandle:^(NSDictionary *chang){
        strongSelf(weakSelf);
        [strongSelf.refreshTopHeader observerScrollView:chang];
    }];
}

- (void)freshHeader {
    _refreshTopHeader = [[CRFRefreshHeader alloc] initWithBindingScrollView:self.recommendTabView];
    _refreshTopHeader.refreshType = Unlogin;
    [self.view addSubview:self.refreshTopHeader];
    [self.view sendSubviewToBack:self.refreshTopHeader];
    [self.refreshTopHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(130);
    }];
}

- (void)setHomeDefaultDatas {
    if ([CRFHomeConfigHendler defaultHandler].localizedHomeDatas.allKeys.count > 0) {
        [self assignmentHome:[CRFHomeConfigHendler defaultHandler].localizedHomeDatas];
    } else {
        self.requestStatus = Status_Home_Net_Error;
    }
}
-(void)channelDrainage:(NSDictionary*)dict{
    CRFAppHomeModel *model = [[dict objectForKey:kCheckSwitch_key] firstObject];
    if ([model.iconUrl isEqualToString:@"0"]) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) channelDrainageCallBack];
    }
}
- (void)refreshMessageCount:(NSString *)count{
    self.navView.messageCount = count;
}

- (void)assignmentHome:(NSDictionary *)dict {
    //配置悬浮框
    [self controlToolImageView:dict];
    //配置 header
    self.tableViewHeaderView.homeHeaderViewDic = dict;
    //配置信息披露底部视图
    self.bottomView.homeHeaderViewDic = dict;
    
    if (self.registerSuccess) {
        //用户第一次注册成功，引导开户弹窗
        CRFAppHomeModel *newUserModel = [[dict objectForKey:newUser_key] firstObject];
        if ([newUserModel.urlKey isEqualToString:kOpenAccountKey]) {
             self.registerSuccess = NO;
            self.depositoryManagementAlertView.contentUrl = newUserModel.content;
            [self.depositoryManagementAlertView show];
        }
    }
    
    if ([[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 0 && [CRFAppManager defaultManager].userInfo.customerStatus.integerValue == 2) {
        //customerStatus (投资状态) 2 已投资 riskConfirm && riskLevel <风险评估等级[1、稳健性 2、成熟性 3 激进性]
         [self.evaluateAlertView show];
    }else{
        //弹出广告
        [self popAderView:dict];
    }

}
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

#pragma mark -----  悬浮窗  -----
- (void)configToolImageView {
    _toolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - kToolImageViewHeight, kScreenHeight - kTabBarHeight - 30 - kToolImageViewHeight, kToolImageViewHeight, kToolImageViewHeight)];
    self.toolImageView.image = [UIImage imageNamed:@"home_tool"];
    self.toolImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.toolImageView];
    [self.toolImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
    [self.toolImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
}

- (void)controlToolImageView:(NSDictionary *)dict{
    
    CRFAppHomeModel *model = [[dict objectForKey:suspension_key] firstObject];
    if (model) {
        self.toolImageView.hidden = NO;
        [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"home_tool"]];
    } else {
        self.toolImageView.hidden = YES;
    }
    
}

- (void)tapGesture {
    CRFAppHomeModel *model = [[[CRFHomeConfigHendler defaultHandler].homeDataDicM objectForKey:suspension_key] firstObject];
    [self pushWebDetailWithUrlString:[NSString stringWithFormat:@"%@?%@",model.jumpUrl,kH5NeedHeaderInfo] canGoBack:YES rightStyle:WebViewRightStyle_None];
}

/**
 浮窗运动轨迹
 
 @param pan gesture
 */
- (void)panGesture:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    if (pan.view.center.x + kToolImageViewHeight / 2 > kScreenWidth || pan.view.center.x < kToolImageViewHeight / 2) {
        CGPoint centerPoint = pan.view.center;
        if (centerPoint.x < kToolImageViewHeight / 2.0) {
            centerPoint.x = kToolImageViewHeight / 2.0;
        } else {
            centerPoint.x = kScreenWidth - kToolImageViewHeight / 2.0;
        }
        pan.view.center = centerPoint;
    }
    if (pan.view.center.y + kToolImageViewHeight / 2 > kScreenHeight -  kTabBarHeight || pan.view.center.y < kToolImageViewHeight / 2.0) {
        CGPoint centerPoint = pan.view.center;
        if (centerPoint.y < kToolImageViewHeight / 2.0) {
            centerPoint.y = kToolImageViewHeight / 2.0;
        } else {
            centerPoint.y = kScreenHeight - kTabBarHeight - kToolImageViewHeight / 2.0;
        }
        pan.view.center = centerPoint;
    }
    [pan setTranslation:CGPointZero inView:self.view];
}

#pragma mark -----  广告视图  -----
- (void)popAderView:(NSDictionary *)dict {
    if (!self.isADShow) {
        return;
    }
    NSArray *imageArr = [dict objectForKey:popup_key];
    if (imageArr.count <= 0) {
        return;
    }
    _advertiseView = [[CRFHomeAdvertisementView alloc] initWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight) images:imageArr];
    _advertiseView.pushDelegate = self;
    [_advertiseView showAdView:self.view];
    self.isADShow = NO;
}

#pragma mark  ADViewDelegate
- (void)pushAdvertisementDetail:(NSString *)url {
    url = [NSString stringWithFormat:@"%@?%@",url,kH5NeedHeaderInfo];
    [self pushWebDetailWithUrlString:url canGoBack:YES rightStyle:WebViewRightStyle_None];
    self.isADShow = NO;
}

- (void)close {
    self.isADShow = NO;
}

#pragma mark CRFHomeHeaderViewDelegate
- (void)bannerDidSelected:(NSString *)linkUrl {
    
    linkUrl = [NSString stringWithFormat:@"%@?%@",linkUrl,kH5NeedHeaderInfo];
    DLog(@"banner 被点击了 %@",linkUrl);
    [self pushWebDetailWithUrlString:linkUrl canGoBack:YES rightStyle:WebViewRightStyle_None];
}

- (void)functionDidSelected:(NSIndexPath *)indexPath url:(NSString *)urlString {
    DLog(@"功能按钮被点击了");
    if (!urlString || [urlString isEmpty]) {
        weakSelf(self);
        [self.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:^{
            [weakSelf validateExplanCondition];
        }];
        return;
    }
    [self loginAfterFunctionDidSelected:urlString];
}

- (void)userToFinishFromRegister:(NSInteger)index {
    if (index == 0) {
        [CRFAPPCountManager setEventID:@"HOME_NEWFIRE_EVENT" EventName:@"立即注册"];
        CRFRegisterViewController *registerViewController = [[CRFRegisterViewController alloc] init];
        registerViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:registerViewController animated:YES];
    } else if (index == 1) {
        [self checkUserAccountStatus];
        [CRFAPPCountManager setEventID:@"HOME_NEWFIRE_EVENT" EventName:@"立即开户"];
    } else {
        [self lookupMore];
        [CRFAPPCountManager setEventID:@"HOME_NEWFIRE_EVENT" EventName:@"立即投资"];
    }
}

- (void)loginAfterFunctionDidSelected:(NSString *)linkUrl {
    linkUrl = [NSString stringWithFormat:@"%@?%@",linkUrl,kH5NeedHeaderInfo];
    if ([linkUrl containsString:@"InvitingFriend"]) {
        [self pushWebDetailWithUrlString:linkUrl canGoBack:YES rightStyle:WebViewRightStyle_Shared];
    } else {
        [self pushWebDetailWithUrlString:linkUrl canGoBack:YES rightStyle:WebViewRightStyle_None];
    }
}

- (void)lookupMore {
    self.tabBarController.selectedIndex = 1;
}

- (void)userHelp:(CRFAppHomeModel*)helpItem{
    NSString * urlString = helpItem.jumpUrl;
    DLog(@"======%@",urlString);
    [self pushWebDetailWithUrlString:urlString canGoBack:NO rightStyle:WebViewRightStyle_None];
}

#pragma mark -----  UITableViewDelegate & UITableViewDataSource -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.productFactory.numberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    weakSelf(self);
    
    if (indexPath.row == 0) {
        if (self.productFactory.hasOldProduct || self.productFactory.hasNewProduct) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CRFNovicesExclusiveTableViewCell"];
            ((CRFNovicesExclusiveTableViewCell *)cell).productFactory = self.productFactory;
            
            ((CRFNovicesExclusiveTableViewCell *)cell).showMoreBlock = ^{
                [weakSelf lookupMore];
            };
            
        }else if (self.productFactory.hasRecommendProduct){
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"CRFHomeInvestTableViewCell"];
            ((CRFHomeInvestTableViewCell *)cell).productFactory = self.productFactory;
            
            ((CRFHomeInvestTableViewCell *)cell).showMoreBlock = ^{
                [weakSelf lookupMore];
            };
            
        }
    }else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CRFHomeInvestTableViewCell"];
        ((CRFHomeInvestTableViewCell *)cell).productFactory = self.productFactory;
        weakSelf(self);
        ((CRFHomeInvestTableViewCell *)cell).showMoreBlock = ^{
            [weakSelf lookupMore];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight  = 0.0f;
    
    if (indexPath.row == 0) {
        if (self.productFactory.hasOldProduct || self.productFactory.hasNewProduct) {
            cellHeight = (kCollectionViewHeight + 17*3+18);
        }else if (self.productFactory.hasRecommendProduct){
            cellHeight = (self.productFactory.recommendProduct.count * (120 + 10)) + 18*3;
        }
    }else if(indexPath.row == 1){
        cellHeight = self.productFactory.hasNewProduct ?((self.productFactory.recommendProduct.count * (120 + 10)) + 18*3) : (self.productFactory.recommendProduct.count * (120 + 10));
    }
    return cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.navView changeViewAlpha:(scrollView.contentOffset.y/100.f)];
    self.offset = scrollView.contentOffset.y;
    
    UIStatusBarStyle statusBarStyle = self.offset < 100 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    
    if (statusBarStyle != self.statusBarStyle) {
        self.statusBarStyle = statusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}

#pragma mark -----  seter && getter  -----
- (UITableView *)recommendTabView{
    if (!_recommendTabView) {
        _recommendTabView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _recommendTabView.backgroundColor = [UIColor clearColor];
        _recommendTabView.showsVerticalScrollIndicator = NO;
        _recommendTabView.delegate = self;
        _recommendTabView.dataSource = self;
        _recommendTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_recommendTabView registerNib:[UINib nibWithNibName:@"CRFNovicesExclusiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"CRFNovicesExclusiveTableViewCell"];
        [_recommendTabView registerNib:[UINib nibWithNibName:@"CRFHomeInvestTableViewCell" bundle:nil] forCellReuseIdentifier:@"CRFHomeInvestTableViewCell"];
    }
    return _recommendTabView;
}

- (CRFHomeHeaderView *)tableViewHeaderView{
    
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[CRFHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400.f)];
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        _tableViewHeaderView.delegate = self;
    }
    
    return _tableViewHeaderView;
}

- (CRFHomeProductFactory *)productFactory {
    if (!_productFactory) {
        _productFactory = [CRFHomeProductFactory new];
    }
    return _productFactory;
}

- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainCancelBtn;
        _helpView.title = @"特供计划";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth - 40, kStatusBarHeight + kNavigationbarHeight / 2.0)];
        [_helpView drawContent:_exclusiveItem?_exclusiveItem.content:@"特供计划是信而富为不同风险偏好的出借人推出的出借工具。可根据您的出借意向，为您筛选符合您风险偏好的出借计划。目前仅对“进取型”风险偏好的用户开放。"];
    }
    return _helpView;
}

- (CRFHomeNavView *)navView{
    
    if (!_navView) {
        _navView = [[CRFHomeNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    }
    
    return _navView;
}

-(CRFHomeBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CRFHomeBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ((20 + 18 + 17 + (kScreenWidth - 20*2)*20/67) + 35*2 +12))];
        weakSelf(self);
        _bottomView.showInformationBlock = ^(CRFAppHomeModel * _Nonnull model) {
            
            [CRFAPPCountManager setEventID:@"HOME_BOTTOM_MENU_EVENT" EventName:model.name];
            [weakSelf pushWebDetailWithUrlString:model.jumpUrl canGoBack:NO rightStyle:WebViewRightStyle_None];
        };
    }
    
    return _bottomView;
}

- (CRFEvaluateAlertView *)evaluateAlertView{
    
    if (!_evaluateAlertView) {
        _evaluateAlertView = [[[NSBundle mainBundle] loadNibNamed:@"CRFEvaluateAlertView" owner:self options:nil] lastObject];
        weakSelf(self);
        _evaluateAlertView.goToEvaluate = ^{
            [weakSelf gotoEvaluation];
        };
    }
    return _evaluateAlertView;
}

- (CRFDepositoryManagementAlertView *)depositoryManagementAlertView{
    if (!_depositoryManagementAlertView) {
        _depositoryManagementAlertView = [[[NSBundle mainBundle] loadNibNamed:@"CRFDepositoryManagementAlertView" owner:self options:nil] lastObject];
        weakSelf(self);
        _depositoryManagementAlertView.goToDepositoryManagement = ^{
            
            [weakSelf checkUserAccountStatus];
        };
    }
    return _depositoryManagementAlertView;
}


@end
