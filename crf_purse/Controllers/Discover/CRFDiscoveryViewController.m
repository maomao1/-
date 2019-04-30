//
//  CRFDiscoveryViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDiscoveryViewController.h"
#import "CRFDiscoverCell.h"
#import "CRFDiscoverListCollectionViewCell.h"
#import "CRFCollectionHeader.h"
#import "CRFDiscoverListViewController.h"
#import "CRFCouponVC.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFIMViewController.h"
#import "CRFTimeUtil.h"
#import "CRFLoginViewController.h"
#import "CRFSignViewController.h"
#import "CRFMoreViewController.h"
#import "CRFControllerManager.h"
#import "CRFDiscoveryHeader.h"
#import "NSArray+Crash.h"
#import "CRFDiscoveryViewController.h"
#define  Collection_header_Id  @"CRFDiscoveryViewController_collection_header_Identifier"
#define  Collection_footer_Id  @"CRFDiscoveryViewController_collection_footer_Identifier"
@interface CRFDiscoveryViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,CRFCollectionHeaderDelegate>
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) NSMutableArray   *topSource;
@property (nonatomic,strong) NSMutableArray   *newsSource;
@property (nonatomic, strong) CRFDiscoveryHeader *headerView;
@property (nonatomic,strong) UIView  *bgView;
@end

@implementation CRFDiscoveryViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)addHeader {
    self.headerView = [[CRFDiscoveryHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    [self.view addSubview:self.headerView];
    weakSelf(self);
    self.headerView.pushNextHandle = ^ {
        strongSelf(weakSelf);
#ifdef WALLET
        if ([CRFAppManager defaultManager].majiabaoFlag) {
             [strongSelf.navigationController pushViewController:[CRFMoreViewController new] animated:YES];
        }
#else
         [strongSelf btnClick];
#endif
       
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addHeader];
    self.headerView.title = NSLocalizedString(@"title_discovery", nil);
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDatas];
    weakSelf(self);
    [self addRequestNotificationStatus:Status_Off_Line handler:^{
        strongSelf(weakSelf);
        [strongSelf requestDatas];
    }];
    [self setViewBringSubViewToFrondHandler:^{
        strongSelf(weakSelf);
        [strongSelf.view bringSubviewToFront:strongSelf.headerView];
    }];
}

- (void)requestDatas {
    
    
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:APIFormat(kDiscoveryTopPath) success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parserMenusResponseSuccess:response];
        [strongSelf requestNews];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf requestNews];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)requestNews {
    NSString *url = [CRFAppManager defaultManager].majiabaoFlag ? kMJDiscoveryPath : kDiscoveryTrendsPath;
    weakSelf(self);
    NSDictionary *dict = [CRFAppManager defaultManager].majiabaoFlag ? @{kPageSizeKey:@"10",kMjStatus:@(1)} : @{kPageSizeKey:@"10"};
    [[CRFStandardNetworkManager defaultManager] get:APIFormat(url) paragrams:dict success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parserNewsResponseSuccess:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
         [strongSelf.mainCollectionView reloadData];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parserMenusResponseSuccess:(id)response {
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        NSArray *menus = [CRFResponseFactory handlerDiscoveryTopMenus:response];
        if (menus) {
            [self.topSource removeAllObjects];
            [self.topSource addObjectsFromArray:menus];
//            [self.mainCollectionView reloadData];
//            [UIView animateWithDuration:.0f animations:^{
//                [self.view layoutIfNeeded];
//            }];
//            [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            [UIView performWithoutAnimation:^{
                //刷新界面
                [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }];
        }
    } else {
//        [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }];
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (void)parserNewsResponseSuccess:(id)response {
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        NSArray *news = [CRFResponseFactory handlerNewsWithResult:response];
        if (news) {
            [self.newsSource removeAllObjects];
            [self.newsSource addObjectsFromArray:news];
        }
//        [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }];
//        [self.mainCollectionView reloadData];
//        [UIView animateWithDuration:.0f animations:^{
//            [self.view layoutIfNeeded];
//        }];
    } else {
//        [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        [UIView performWithoutAnimation:^{
            //刷新界面
            [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }];
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (void)btnClick {
    CRFIMViewController *controller = [CRFIMViewController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark == CRFCollectionHeaderDelegate
- (void)crf_pushList{
    CRFDiscoverListViewController *listVc = [CRFDiscoverListViewController new];
    listVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark == UICollectionViewDelegate UICollectionViewDataSource=
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.topSource.count;
    }else{
        return self.newsSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            return [self configMuneCellWithCollectionView:collectionView indexPath:indexPath];
    } else {
        return [self configNewCellWithCollectionView:collectionView indexPath:indexPath];
    }
}

- (CRFDiscoverCell *)configMuneCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    CRFDiscoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFDiscoverCellID forIndexPath:indexPath];
    CRFAppHomeModel *model = [self.topSource objectAtIndex:indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"discovery_top_default"]];
    return cell;
}

- (CRFDiscoverListCollectionViewCell *)configNewCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    CRFDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFDiscoverListCellId forIndexPath:indexPath];
    CRFNewModel *model = self.newsSource[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"diccovery_new_default"]];
    [cell setTitleStr:model.title];
    cell.timeLabel.text = [CRFTimeUtil formatLongTime:[model.publicTime longLongValue] pattern:@"yyyy-MM-dd"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlString = nil;
     CRFStaticWebViewViewController *webViewController = nil;
    id model;
    if (indexPath.section == 0) {
        model = [self.topSource objectAtIndex:indexPath.item];
    }else{
        model = [self.newsSource objectAtIndex:indexPath.item];
    }
//    id model = [[self.dataSource objectAtIndexCheck:indexPath.section] objectAtIndexCheck:indexPath.item];
    if ([model isKindOfClass:[CRFAppHomeModel class]]) {
        if (![CRFAppManager defaultManager].login) {
            [CRFControllerManager pushLoginViewControllerFrom:self popType:PopDefault];
            return;
        }
        CRFAppHomeModel *menu = model;
        urlString = menu.jumpUrl;
        if ([urlString isEmpty]) {
            return;
        }
         urlString = [NSString stringWithFormat:@"%@?%@",urlString,kH5NeedHeaderInfo];
        if ([urlString containsString:@"InvitingFriend"]) {
            webViewController = [CRFStaticWebViewViewController new];
            webViewController.rightStyle = WebViewRightStyle_Shared;
              [CRFAPPCountManager setEventID:@"DISCOVER_MENU_EVENT" EventName:menu.name];
        } else if ([urlString containsString:@"sign"]) {
            webViewController = [CRFSignViewController new];
            webViewController.backViewStyle = WebViewBackViewStyle_None;
            webViewController.webType = WebFull;
            [CRFAPPCountManager setEventID:@"DISCOVER_MENU_EVENT" EventName:menu.name];
        } else {
            webViewController = [CRFStaticWebViewViewController new];
            [CRFAPPCountManager setEventID:@"DISCOVER_MENU_EVENT" EventName:menu.name];
        }
    } else if ([model isKindOfClass:[CRFNewModel class]]) {
        CRFNewModel *new = model;
         webViewController = [CRFStaticWebViewViewController new];
        urlString = new.jumpUrl;
         [CRFAPPCountManager setEventID:@"DISCOVER_NEWS_EVENT" EventName:new.title];
    }
    if (webViewController) {
        webViewController.hidesBottomBarWhenPushed = YES;
        webViewController.urlString = urlString;
        webViewController.backType = WebViewGoBack;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            CRFCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_header_Id forIndexPath:indexPath];
            headerView.crf_delegate = self;
            return headerView;
        }
    } else {
//        if ([[[self.dataSource firstObject] firstObject] isKindOfClass:[CRFNewModel class]]) {
//            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//                CRFCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_header_Id forIndexPath:indexPath];
//                headerView.crf_delegate = self;
//                return headerView;
//            }
//        }
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Collection_footer_Id forIndexPath:indexPath];
            footer.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
            return footer;
        }
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(kScreenWidth, 45);
    }
//    if ([[[self.dataSource firstObject] firstObject] isKindOfClass:[CRFNewModel class]]) {
//        return CGSizeMake(kScreenWidth, 45);
//    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 8);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 15, 10, 15);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        self.headerView.hiddenLine = NO;
    } else {
        self.headerView.hiddenLine = YES;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if ([[[self.dataSource firstObject] firstObject] isKindOfClass:[CRFNewModel class]]) {
//            return CGSizeMake(kScreenWidth, 100);
//        }
        CGFloat width = (kScreenWidth-35)/2.0;
        return CGSizeMake(width, width / 2.3);
    } else {
        return CGSizeMake(kScreenWidth, 100);
    }
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"CRFDiscoverCell" bundle:nil] forCellWithReuseIdentifier:CRFDiscoverCellID];
        [_mainCollectionView registerClass:[CRFDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:CRFDiscoverListCellId];
        [_mainCollectionView registerClass:[CRFCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_header_Id];
        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Collection_footer_Id];
    }
    return _mainCollectionView;
}

- (NSMutableArray *)topSource {
    if (!_topSource) {
        _topSource = [[NSMutableArray alloc]init];
    }
    return _topSource;
}
- (NSMutableArray *)newsSource {
    if (!_newsSource) {
        _newsSource = [[NSMutableArray alloc]init];
    }
    return _newsSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
