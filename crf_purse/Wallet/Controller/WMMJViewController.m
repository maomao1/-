//
//  WMDiscoveryViewController.m
//  WMWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJViewController.h"
#import "CRFDiscoverCell.h"
#import "CRFDiscoverListCollectionViewCell.h"
#import "CRFCollectionHeader.h"
#import "CRFDiscoverListViewController.h"
#import "CRFTimeUtil.h"
#import "CRFMoreViewController.h"
#import "CRFDiscoveryHeader.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFSignViewController.h"
#import "SDCycleScrollView.h"


@interface WMMJCollectionViewHeaderView:UICollectionReusableView <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *scrollView;

@property (nonatomic, copy) void (^(tapHandler))(NSInteger index);

@end

@implementation WMMJCollectionViewHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.tapHandler) {
        self.tapHandler(index);
    }
}

- (void)config {
    NSArray <UIImage *>*images = @[[UIImage imageNamed:@"majiabao_discovery_1"]];
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"discovery_top_default"]];
    _scrollView.localizationImageNamesGroup = images;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


@end;


#define  Collection_header_Id  @"WMDiscoveryViewController_collection_header_Identifier"
#define  Collection_footer_Id  @"WMDiscoveryViewController_collection_footer_Identifier"
@interface WMMJViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,CRFCollectionHeaderDelegate>
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) NSMutableArray   <CRFNewModel *>*dataSource;
@property (nonatomic, strong) CRFDiscoveryHeader *headerView;

@property (nonatomic, strong) NSArray <NSString *>*items;
@end

@implementation WMMJViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)addHeader {
    self.headerView = [[CRFDiscoveryHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    [self.view addSubview:self.headerView];
    weakSelf(self);
    self.headerView.pushNextHandle = ^ {
        strongSelf(weakSelf);
        if ([CRFAppManager defaultManager].majiabaoFlag) {
            CRFMoreViewController *moreVC = [CRFMoreViewController new];
            moreVC.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:moreVC animated:YES];
            return ;
        }
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addHeader];
    self.items = @[@"https://financeapp-static.crfchina.com/webp2p_static/invests/views/signIn/sign.html"];
    self.headerView.title = @"钱包资讯";
    [self.view addSubview:self.mainCollectionView];
    WMMJCollectionViewHeaderView *bannerView = [WMMJCollectionViewHeaderView new];
    [self.view addSubview:bannerView];
    weakSelf(self);
    [bannerView setTapHandler:^(NSInteger index){
        strongSelf(weakSelf);
        CRFStaticWebViewViewController *webViewController = nil;
        if (index == 0) {
            webViewController = [CRFSignViewController new];
            ((CRFSignViewController *)webViewController).webType = WebFull;
            ((CRFSignViewController *)webViewController).backViewStyle = WebViewBackViewStyle_None;
        } else {
         webViewController = [CRFStaticWebViewViewController new];
        }
       NSString *info = [NSString stringWithFormat:@"%@?%@",strongSelf.items[index],kH5NeedHeaderInfo];
        webViewController.urlString = info;
        webViewController.hidesBottomBarWhenPushed = YES;
        [strongSelf.navigationController pushViewController:webViewController animated:YES];
    }];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.height.mas_equalTo(170 * kWidthRatio);
    }];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavHeight + 170 * kWidthRatio);
        make.bottom.left.right.equalTo(self.view);
    }];
//    [self addRequestNotificationStatus:Status_Off_Line handler:^{
//        strongSelf(weakSelf);
//        [strongSelf requestNews];
//    }];
     [self requestNews];
    [self setViewBringSubViewToFrondHandler:^{
        strongSelf(weakSelf);
        [strongSelf.view bringSubviewToFront:strongSelf.headerView];
    }];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//}

- (void)requestNews {
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] get:APIFormat(kMJDiscoveryPath) paragrams:@{kPageSizeKey:@"10"} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        NSArray *news = [CRFResponseFactory handlerNewsWithResult:response];
        [strongSelf.dataSource addObjectsFromArray:news];
        [strongSelf.mainCollectionView reloadData];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

#pragma mark == WMCollectionHeaderDelegate
- (void)crf_pushList{
    CRFDiscoverListViewController *listVc = [CRFDiscoverListViewController new];
    listVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark == UICollectionViewDelegate UICollectionViewDataSource=
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self configNewCellWithCollectionView:collectionView indexPath:indexPath];
}

- (CRFDiscoverListCollectionViewCell *)configNewCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    CRFDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFDiscoverListCellId forIndexPath:indexPath];
    CRFNewModel *model = self.dataSource[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"diccovery_new_default"]];
    [cell setTitleStr:model.title];
    cell.timeLabel.text = [CRFTimeUtil formatLongTime:[model.publicTime longLongValue] pattern:@"yyyy-MM-dd"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
        CRFNewModel *model = [self.dataSource objectAtIndex:indexPath.item];
       NSString *urlString = model.jumpUrl;
        [CRFAPPCountManager setEventID:@"DISCOVER_NEWS_EVENT" EventName:model.title];
    webViewController.hidesBottomBarWhenPushed = YES;
    webViewController.urlString = urlString;
    webViewController.backType = WebViewGoBack;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            CRFCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_header_Id forIndexPath:indexPath];
            headerView.crf_delegate = self;
            return headerView;
        }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
        return CGSizeMake(kScreenWidth, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
        return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        self.headerView.hiddenLine = NO;
    } else {
        self.headerView.hiddenLine = YES;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        return CGSizeMake(kScreenWidth, 100);
}

- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"WMDiscoverCell" bundle:nil] forCellWithReuseIdentifier:CRFDiscoverCellID];
        [_mainCollectionView registerClass:[CRFDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:CRFDiscoverListCellId];
        [_mainCollectionView registerClass:[CRFCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Collection_header_Id];
    }
    return _mainCollectionView;
}

- (NSMutableArray<CRFNewModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

