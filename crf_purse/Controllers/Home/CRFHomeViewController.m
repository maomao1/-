//
//  CRFHomeViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeViewController.h"
#import "CRFBannerView.h"
#import "CRFHomeTableViewCell.h"
#import "CRFHomeFooterView.h"
#import "CRFHomeAdvertisementView.h"
#import "CRFDIYHeader.h"
#import "CRFLoginViewController.h"
#import "CRFRegisterViewController.h"
#import "CRFHomeConfigHendler.h"
#import "CRFSettingData.h"
#import "CRFProfileViewController.h"
#import "CRFMessageScrollViewController.h"
#import "CRFIMViewController.h"
#import "CRFMessageDetailViewController.h"
#import "CRFInvestListCell.h"
#import "CRFNewUserProductTableViewCell.h"
#import "CRFHomeViewController+Interface.h"
#import "CRFSectionFooterView.h"
#import "CRFSectionHeaderView.h"
#import "CRFProductDetailViewController.h"
#import "CRFGestureManager.h"
#import "CRFExplanOperateViewController.h"
#import "CRFControllerManager.h"

static NSString *const kHomeCellIdentifier = @"home";
static NSString *const kNewUerCellIdentifier = @"new_user";
static CGFloat const kToolImageViewHeight = 100;
static CGFloat const kGragingMargen = 75;

@interface CRFHomeViewController () <UITableViewDelegate, UITableViewDataSource, BannerViewDelegate,HomeAdvertisementViewDelegate>

@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIImageView *toolImageView;
@property (nonatomic, strong) CRFBannerMoreView *moreView;
@property (nonatomic, strong) CRFBannerView *bannerView;
@property (nonatomic, strong) CRFHomeFooterView *footerView;
@property (nonatomic, assign) BOOL isADShow;///<广告试图
@property (nonatomic, strong) CRFHomeAdvertisementView *advertiseView;

@end

@implementation CRFHomeViewController

- (CRFHomeProductFactory *)productFactory {
    if (!_productFactory) {
        _productFactory = [CRFHomeProductFactory new];
    }
    return _productFactory;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.footerView.mainScrollView = self.recommendTabView;
    [CRFGestureManager upgradeVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.moreButton.selected) {
        [self more:self.moreButton];
    }
    if (self.changeUserHeaderImage) {
        self.changeUserHeaderImage();
    }
    NSString* cName = @"首页";
    [self addHomeDefaultView];
    [[CRFAPPCountManager sharedManager] crf_pageViewEnter:cName];
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

- (void)freshHeader {
    _refreshTopHeader = [[CRFRefreshHeader alloc] initWithBindingScrollView:self.recommendTabView];
    _refreshTopHeader.refreshType = Unlogin;
    [self.view addSubview:self.refreshTopHeader];
    [self.refreshTopHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(130);
    }];
    [self.view bringSubviewToFront:self.recommendTabView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.moreButton.selected) {
        [self more:self.moreButton];
    }
    if (CGRectGetHeight(scrollView.frame) + scrollView.contentOffset.y > scrollView.contentSize.height + kGragingMargen) {
        CGPoint point = scrollView.contentOffset;
        point.y = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame) + kGragingMargen;
        [scrollView setContentOffset:point];
    }
    if (scrollView.contentOffset.y > 0) {
        self.headerView.hiddenLine = NO;
    } else {
        self.headerView.hiddenLine = YES;
    }
}

- (void)tap {
    if (self.moreButton.selected) {
        [self more:self.moreButton];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];

    [self getExplanData];
    _isADShow = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initializeView {
    _recommendTabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _recommendTabView.delegate = self;
    _recommendTabView.dataSource = self;
    _productArray = [[NSMutableArray alloc]init];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    gesture.cancelsTouchesInView = NO;
    [self.recommendTabView addGestureRecognizer:gesture];
     self.recommendTabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recommendTabView];
    [self.recommendTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.bottom.equalTo(self.view).with.offset(100);
    }];
    [self freshHeader];
    [self configViewheader];
    [self addDefaultUser];
    [self addMore];
    [self configMoreView];
    [self registerTableViewHeader];
    [self registerTableViewFooter];
    [self refreshHeader];
    [self configToolImageView];
    [self setHomeDefaultDatas];
}

- (void)setHomeDefaultDatas {
    if ([CRFHomeConfigHendler defaultHandler].localizedHomeDatas.allKeys.count > 0) {
        [self assignmentHome:[CRFHomeConfigHendler defaultHandler].localizedHomeDatas];
    } else {
        self.requestStatus = Status_Home_Net_Error;
        [self.view bringSubviewToFront:self.headerView];
        [self.view bringSubviewToFront:self.avatarImageView];
    }
}

- (void)assignmentHome:(NSDictionary *)dict {
    [self refreshBanner:dict];
    [self setFooterView];
    [UIView animateWithDuration:.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)refreshBanner:(NSDictionary *)dict {
    CRFAppHomeModel *model = [[dict objectForKey:suspension_key] firstObject];
    if (model) {
        self.toolImageView.hidden = NO;
        [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"home_tool"]];
    } else {
        self.toolImageView.hidden = YES;
    }
    [self popAderView:dict];
    [self refreshHomeData:dict];
}

- (void)refreshHomeData:(NSDictionary *)dict {
    _bannerView.banners = [dict objectForKey:banner_key];
    if ([dict.allKeys containsObject:kProductExclusivePlanKey]) {
        _bannerView.functions = [dict objectForKey:kProductExclusivePlanKey];
    } else {
        _bannerView.functions = [dict objectForKey:topMenu_key];
    }
    
    NSArray *activities = [dict objectForKey:kUserActivityKey];
    self.bannerView.type = activities.count > 0? Activity:None;
    if (activities.count > 0) {
        self.bannerView.activities = activities;
    }
    CRFAppHomeModel *model = [[dict objectForKey:newUser_key] objectAtIndex:0];
    if ([model.urlKey isEqualToString:kRegisterUserKey]) {
        _bannerView.bannerTpye = User_Logout;
        _bannerView.frame = CGRectMake(0, 0, kScreenWidth, self.bannerView.type == None?kUnloginNoActivityHeaderHeight: kUnloginHeaderHeight);
    } else if ([model.urlKey isEqualToString:kOpenAccountKey]) {
        _bannerView.bannerTpye = Account_Bank_None;
        _bannerView.frame = CGRectMake(0, 0, kScreenWidth, self.bannerView.type == None?kUnloginNoActivityHeaderHeight: kUnloginHeaderHeight);
    } else if ([model.urlKey isEqualToString:kInvestmentKey]){
        _bannerView.bannerTpye = Invest_None;
        _bannerView.frame = CGRectMake(0, 0, kScreenWidth, self.bannerView.type == None?kUnloginNoActivityHeaderHeight: kUnloginHeaderHeight);
    }
    if (!model) {
        _bannerView.bannerTpye = User_Default;
        _bannerView.frame = CGRectMake(0, 0, kScreenWidth, self.bannerView.type == None?kOldUserNoActivityInvestHeaderHeight: kOldUserInvestHeaderHeight);
        if ([CRFAppManager defaultManager].login) {
             self.refreshTopHeader.refreshType = UserLogin;
        }
    }
    _bannerView.homeModel = model;
    _bannerView.helpModel = [[dict objectForKey:newUserHelp_key] objectAtIndex:0];
    _footerView.menuArray    = [dict objectForKey:bottomList_key];
    _footerView.platformArray = [dict objectForKey:home_platform_data_key];
    if (dict.allKeys.count <= 0) {
        _bannerView.frame = CGRectZero;
        self.recommendTabView.backgroundColor = [UIColor whiteColor];
        [self addHomeDefaultView];
    } else {
        self.recommendTabView.backgroundColor = [UIColor clearColor];
    }
    self.recommendTabView.tableHeaderView = self.bannerView;
    [self setFooterView];
}

- (void)configViewheader {
    _headerView = [[CRFCustomHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    _headerView.titleLabel.text = NSLocalizedString(@"title_home", nil);
    [self.view addSubview:self.headerView];
}

- (void)addMore {
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setImage:[UIImage imageNamed:@"add_more"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"add_more"] forState:UIControlStateSelected];
    _moreButton.hidden = YES;
    _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -10);
    _moreButton.imageView.contentMode = UIViewContentModeTopRight;
    _moreButton.crf_acceptEventInterval = 0.5;
    [_moreButton addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreButton];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kStatusBarHeight + 11);
        make.right.equalTo(self.view).with.offset(-kSpace);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
}

- (void)more:(UIButton *)button {
    button.selected = !button.selected;
    [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.right.equalTo(self.view).with.offset(-kSpace);
        make.size.mas_equalTo(button.selected? CGSizeMake(138 , 135 ):CGSizeZero);
    }];
}

- (void)configMoreView {
    _moreView = [[CRFBannerMoreView alloc] init];
    weakSelf(self);
    [_moreView setViewDidSeledted:^(NSIndexPath *indexPath){
        strongSelf(weakSelf);
        [strongSelf more:strongSelf.moreButton];
        UIViewController *controller = nil;
        switch (indexPath.row) {
            case 0: {
                controller = [CRFIMViewController new];
            }
                break;
            case 1: {
                controller = [UIViewController new];
            }
                break;
            case 2: {
                if ([CRFAppManager defaultManager].login) {
                    controller = [CRFMessageScrollViewController new];
                } else {
                    controller = [CRFLoginViewController new];
                }
            }
                break;
                
            default:
                break;
        }
        if (controller) {
            controller.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:controller animated:YES];
        }
    }];
    [self.view addSubview:self.moreView];
    [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.right.equalTo(self.view).with.offset(-kSpace);
        make.size.mas_equalTo(CGSizeZero);
    }];
}

- (void)addDefaultUser {
    _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_header"]];
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 15.0f;
    [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfo:)]];
    [self.view addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight + 7);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    if ([CRFAppManager defaultManager].login) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:[UIImage imageNamed:@"login_default_avatar"]];
    }
    [self setHomeHandler];
}

- (void)userInfo:(UITapGestureRecognizer *)tap {
    UIViewController *controller = nil;
    if (![CRFAppManager defaultManager].login) {
        controller= [CRFLoginViewController new];
    } else {
        controller = [CRFProfileViewController new];
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

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
}

- (void)registerTableViewFooter {
    self.footerView = [[CRFHomeFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [CRFAppManager defaultManager].majiabaoFlag ? (50 + 26 + 85 + kTopSpace / 2.0) : (75 * kWidthRatio + 80 + 26 + 85 + kTopSpace / 2.0))];
    self.footerView.mainScrollView = self.recommendTabView;
    __weak typeof(self) weakSelf = self;
    [_footerView reloadFooterImg];
    [_footerView setAboutCallback:^{
        CRFAppHomeModel *model = [[[CRFHomeConfigHendler defaultHandler].homeDataDicM objectForKey:home_about_crfchina_key] objectAtIndex:0];
        NSString *urlstring    = model.jumpUrl;
        [weakSelf pushWebDetailWithUrlString:urlstring canGoBack:NO rightStyle:WebViewRightStyle_None];
    }];
    [_footerView setItemDidSelected:^(CRFAppHomeModel *model){
        [CRFAPPCountManager setEventID:@"HOME_BOTTOM_MENU_EVENT" EventName:model.name];
        [weakSelf pushWebDetailWithUrlString:model.jumpUrl canGoBack:NO rightStyle:WebViewRightStyle_None];
    }];
    self.recommendTabView.tableFooterView = _footerView;
}

- (void)configToolImageView {
    _toolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - kToolImageViewHeight, kScreenHeight - kTabBarHeight - 30 - kToolImageViewHeight, kToolImageViewHeight, kToolImageViewHeight)];
    self.toolImageView.image = [UIImage imageNamed:@"home_tool"];
    self.toolImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.toolImageView];
    [self.toolImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
    [self.toolImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
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

- (void)refreshHeader {
    weakSelf(self);
    CRFDIYHeader *header = [CRFDIYHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        [strongSelf requestDatas];
        if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].accountStatus) {
            [strongSelf getUserAssetsTotal];
        }
    }];
    self.recommendTabView.mj_header = header;
    [header setScrollViewContentOffSizeHandle:^(NSDictionary *chang){
        strongSelf(weakSelf);
        [strongSelf.refreshTopHeader observerScrollView:chang];
    }];
    [header setDragingPullScreenPercent:^(CGFloat percent){
        strongSelf(weakSelf);
        [CRFUtils getMainQueue:^{
            strongSelf.headerView.alpha = (1-percent);
        }];
    }];
}

- (void)registerTableViewHeader {
    _bannerView = [[CRFBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kUnloginHeaderHeight)];
    _bannerView.bannerDelegate = self;
    self.recommendTabView.tableHeaderView = _bannerView;
    [self.recommendTabView setSeparatorColor:[UIColor colorWithWhite:.0f alpha:0.1]];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.productFactory numberOfProducts:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.productFactory hasNewProduct]) {
            return [self configNewUserProducts:indexPath tableView:tableView];
        }
        return [self configOldUserProducts:indexPath tableView:tableView];
    }
    return [self configOldUserProducts:indexPath tableView:tableView];
}

- (CRFNewUserProductTableViewCell *)configNewUserProducts:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CRFNewUserProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewUerCellIdentifier];
    if (!cell) {
        cell = [[CRFNewUserProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewUerCellIdentifier];
    }
    cell.products = [self.productArray objectAtIndexCheck:0];
    weakSelf(self);
    [cell setSelectedProductHandler:^(CRFProductModel *product){
        strongSelf(weakSelf);
        CRFProductDetailViewController *vc = [CRFProductDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.productNo = product.contractPrefix;
        [strongSelf.navigationController pushViewController:vc animated:YES];
        [CRFAPPCountManager setEventID:@"HOME_NEWFIRE_PRODUCT_EVENT" EventName:product.contractPrefix];
    }];
    return cell;
}

- (UITableViewCell *)configOldUserProducts:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CRFProductModel *model = nil;
    NSArray *pros = [self.productArray objectAtIndexCheck:indexPath.section];
    if (pros) {
        model = [pros objectAtIndexCheck:indexPath.row];
    }
    if ([self.productFactory complianceProduct:indexPath]) {
        CRFInvestListCell *complianceCell = [tableView dequeueReusableCellWithIdentifier:@"complianceCell"];
        if (!complianceCell) {
            complianceCell = [[CRFInvestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"complianceCell"];
        }
        complianceCell.productModel = model;
        return complianceCell;
    }
    CRFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFHomeTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.supportGesture = NO;
    cell.tipText = model.tipsStart;
    cell.productType = Old_Product;
    if (model) {
        cell.products = @[model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.productFactory sectionProductHeaderHeight:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.productFactory hasNewProduct]) {
            return [[CRFSectionHeaderView alloc] initWithSectionStyle:CRFSectionHeaderStyleTopMargen];
        }
        return [[CRFSectionHeaderView alloc] initWithSectionStyle:CRFSectionHeaderStyleTopMargenAndContent];
    }
    return [[CRFSectionHeaderView alloc] initWithSectionStyle:CRFSectionHeaderStyleContent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.productFactory productHeight:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.productFactory sectionProductFooterHeight:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && [self.productFactory hasNewProduct]) {
        return [[CRFSectionFooterView alloc] initWithStyle:CRFSectionStyleNovice];
    }
    CRFSectionFooterView *sectionFooterView = [[CRFSectionFooterView alloc] initWithStyle:CRFSectionStyleOld];
    weakSelf(self);
    [sectionFooterView setTapHandler:^{
        strongSelf(weakSelf);
        [strongSelf lookupMore];
    }];
    return sectionFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _productArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *model = [self.productArray[indexPath.section] objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_productArray.count == 1 && indexPath.section == 0) {
        [CRFAPPCountManager setEventID:@"HOME_NEWFIRE_PRODUCT_EVENT" EventName:model.contractPrefix];
    }else{
        [CRFAPPCountManager setEventID:@"HOME_OLDUSER_PRODUCT_EVENT" EventName:model.contractPrefix];
    }
    CRFProductDetailViewController *vc = [CRFProductDetailViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.productNo = model.contractPrefix;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

#pragma mark BannerViewDelegate
- (void)bannerDidSelected:(NSString *)linkUrl {
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        return;
    }
    linkUrl = [NSString stringWithFormat:@"%@?%@",linkUrl,kH5NeedHeaderInfo];
    DLog(@"banner 被电击了 %@",linkUrl);
    [self pushWebDetailWithUrlString:linkUrl canGoBack:YES rightStyle:WebViewRightStyle_None];
}

- (void)activityDidSelected:(CRFActivity *)item {
    if (![item.contentUrl isEmpty]) {
        [self pushWebDetailWithUrlString:item.contentUrl canGoBack:NO rightStyle:WebViewRightStyle_None];
        return;
    }
    CRFMessageDetailViewController *detailVc = [CRFMessageDetailViewController new];
    detailVc.activiModel = item;
    detailVc.mesType = SYSTEM_Detail;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)functionDidSelected:(NSIndexPath *)indexPath url:(NSString *)urlString {
    DLog(@"功能按钮被电击了");
    if (!urlString || [urlString isEmpty]) {
//        if (![CRFAppManager defaultManager].login) {
//            [CRFControllerManager pushLoginViewControllerFrom:self popType:PopFrom];
//            return;
//        }
//        if (![CRFAppManager defaultManager].accountStatus) {
//            [self checkUserAccountStatus];
//            return;
//        }
//        CRFExplanOperateViewController *explanVc = [CRFExplanOperateViewController new];
//        explanVc.exclusiveItem = self.exclusiveItem;
//        explanVc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:explanVc animated:YES];
        weakSelf(self);
        [self.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:^{
            [weakSelf validateExplanCondition];
        }];
        return;
    }
//    [self pushWebDetailWithUrlString:urlString canGoBack:NO rightStyle:WebViewRightStyle_None];
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

- (void)userHelp:(CRFAppHomeModel*)helpItem{
    NSString * urlString = helpItem.jumpUrl;
    DLog(@"======%@",urlString);
    [self pushWebDetailWithUrlString:urlString canGoBack:NO rightStyle:WebViewRightStyle_None];
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

- (void)lookupMore {
    self.tabBarController.selectedIndex = 1;
}

- (void)setFooterView {
    self.footerView.mainScrollView = self.recommendTabView;
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
@end
