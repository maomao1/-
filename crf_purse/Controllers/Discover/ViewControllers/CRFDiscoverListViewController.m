//
//  CRFDiscoverListViewController.m
//  crf_purse
//
//  Created by maomao on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDiscoverListViewController.h"
#import "CRFDiscoverListCollectionViewCell.h"
#import "MJRefresh.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFTimeUtil.h"

@interface CRFDiscoverListViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource> {
    BOOL flag;
}
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, assign) BOOL refreshHeader;
@property (nonatomic, assign) BOOL refreshFooter;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation CRFDiscoverListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        [self setSyatemTitle:@"行业动态"];
    } else {
        [self setSyatemTitle:@"信而富动态"];
    }
    self.pageNumber = 1;
    [self.view addSubview:self.mainCollectionView];
    [self requestDatas];
    [self addRefreshHeader];
    weakSelf(self);
    [self addRequestNotificationStatus:Status_Off_Line handler:^{
        strongSelf(weakSelf);
        [strongSelf requestDatas];
    }];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, [CRFUtils isIPhoneXAll] ? - 34 : 0, 0);
        self.mainCollectionView.scrollIndicatorInsets = self.mainCollectionView.contentInset;
    }
#endif
}

- (void)addRefreshHeader {
    weakSelf(self);
    self.mainCollectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.refreshHeader = YES;
        strongSelf.pageNumber = 1;
        [strongSelf.dataSource removeAllObjects];
        [strongSelf requestDatas];
    }];
}

- (void)addRefreshFooter {
    weakSelf(self);
    self.mainCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.refreshFooter = YES;
        strongSelf.pageNumber ++;
        [strongSelf requestDatas];
    }];
}

- (void)requestDatas {
    weakSelf(self);
    NSString *url = nil;
    NSDictionary *body = nil;
#ifdef WALLET
    if (![CRFUtils normalUser]) {
        url = APIFormat(kMJDiscoveryPath);
        body = @{kPageNumberKey:@(self.pageNumber),kPageSizeKey:@"10",kMjStatus:@(1)};
    } else {
        url = APIFormat(kDiscoveryTrendsPath);
        body = @{kPageNumberKey:@(self.pageNumber),kPageSizeKey:@"10"};
    }
#else
    url = APIFormat(kDiscoveryTrendsPath);
    body = @{kPageNumberKey:@(self.pageNumber),kPageSizeKey:@"10"};
#endif
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] get:url paragrams:body success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf endRefresh];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)endRefresh {
    if (self.refreshFooter) {
        [self.mainCollectionView.mj_footer endRefreshing];
        self.refreshFooter = NO;
    }
    if (self.refreshHeader) {
        [self.mainCollectionView.mj_header endRefreshing];
        self.refreshHeader = NO;
    }
}

- (void)parseResponse:(id)response{
    [self endRefresh];
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
       NSArray <CRFNewModel *>*models = [CRFResponseFactory handlerNewsWithResult:response];
        [self.dataSource addObjectsFromArray:models];
        [self.mainCollectionView reloadData];
        if (models.count >= 10 && !flag) {
            flag = YES;
            [self addRefreshFooter];
        }
    } else {
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

#pragma mark -- UICollectionViewDelegate UICollectionViewDataSource-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFDiscoverListCellId forIndexPath:indexPath];
    CRFNewModel *model = self.dataSource[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"diccovery_new_default"]];
    
    cell.timeLabel.text = [CRFTimeUtil formatLongTime:[model.publicTime longLongValue] pattern:@"yyyy-MM-dd"];
    [cell setTitleStr:model.title];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight) collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.itemSize = CGSizeMake(kScreenWidth, 100);
        
//        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
//        _mainCollectionView.alwaysBounceVertical = YES;
        [_mainCollectionView registerClass:[CRFDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:CRFDiscoverListCellId];
        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseIdentifier"];
    }
    return _mainCollectionView;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
        headerView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
        return headerView;
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
        return CGSizeMake(kScreenWidth, 8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFNewModel *model = [self.dataSource objectAtIndex:indexPath.item];
    CRFStaticWebViewViewController *viewController = [CRFStaticWebViewViewController new];
    viewController.urlString = model.jumpUrl;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
@end
