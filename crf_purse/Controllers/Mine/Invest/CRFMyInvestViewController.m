//
//  CRFMyInvestViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMyInvestViewController.h"
#import "CRFSegmentHead.h"
#import "CRFInvestCollectionViewCell.h"
#import "CRFMyInvestProduct.h"
#import "CRFInvestStatusViewController.h"
#import "CRFAppointmentForwardHelpView.h"


@interface CRFMyInvestViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CRFSegmentHead *segmentHead;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*indexArray;

@property (nonatomic, assign) BOOL refreshProducts;

@end

@implementation CRFMyInvestViewController

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleOnlyContent;
        [_helpView drawContent:@"根据历史数据计算得出，不作为最终收益的依据"];
    }
    return _helpView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - kNavHeight - 44);
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的投资";
    _indexArray = [NSMutableArray arrayWithObjects:@(0),@(0),@(0), nil];
    [self configHeader];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CRFInvestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"investCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(44);
    }];
            weakSelf(self);
    [self addRequestNotificationStatus:Status_Off_Line handler:^{
        strongSelf(weakSelf);
        [strongSelf.collectionView reloadData];
    }];
    
    self.refreshProduct = ^ {
        strongSelf(weakSelf);
        strongSelf.selectedIndex = 0;
        strongSelf.refreshProducts = YES;
        [strongSelf.collectionView reloadData];
    };
    [CRFUtils delayAfert:.01 handle:^{
        strongSelf(weakSelf);
         [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:strongSelf.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.flag) {
        
        self.flag = YES;
    }
}

- (void)configHeader {
    weakSelf(self);
    NSArray *titles = @[@"出借中(0)",@"退出中(0)",@"已结束(0)"];
    self.segmentHead = [[CRFSegmentHead alloc]initCommonInvestWithFrame:CGRectMake(0, 0, kScreenWidth, 44) titles:titles clickCallback:^(NSInteger index) {
        [CRFAPPCountManager setEventID:@"MYINVEST_TAPSELECTED_EVENT" EventName:titles[index]];//埋点
        weakSelf.selectedIndex = index;
        [weakSelf.collectionView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
    }];
    [self.view addSubview:self.segmentHead];
    self.segmentHead.defaultIndex = self.selectedIndex;
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithWhite:.0 alpha:.1];
    [self.segmentHead addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.segmentHead);
        make.height.mas_equalTo(1);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.segmentHead.defaultIndex = scrollView.contentOffset.x / kScreenWidth;
    self.selectedIndex = self.segmentHead.defaultIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.segmentHead scrollToContentsInSizeWithFloat:scrollView.contentOffset.x / kScreenWidth];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFInvestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"investCell" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.type = HasHeader;
    } else {
        cell.type = HasHeader;
    }
    cell.needRefresh = self.refreshProducts;
    cell.indexPath = indexPath;
    NSNumber *num = self.indexArray[indexPath.item];
    cell.sortIndex = [num integerValue];
    weakSelf(self);
    [cell setBlackSpaceHandler:^(NSIndexPath *indexPath){
        strongSelf(weakSelf);
        strongSelf.tabBarController.selectedIndex = 1;
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    [cell setInvestChooseHandler:^(NSInteger section, CRFMyInvestProduct *product){
        [CRFAPPCountManager setEventID:@"MYINVEST_PRODUCT_CLICK_EVENT" EventName:product.productName];//埋点
        strongSelf(weakSelf);
        CRFInvestStatusViewController *controller = [CRFInvestStatusViewController  new];
        controller.type = section;
        controller.product =  product;
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    [cell setGetInvestListAmount:^(NSInteger unBearingCount, NSInteger bearingCount, NSInteger finishedCount){
        strongSelf(weakSelf);
        strongSelf.segmentHead.commonTitles = @[[NSString stringWithFormat:@"出借中(%ld)",unBearingCount],[NSString stringWithFormat:@"退出中(%ld)",bearingCount],[NSString stringWithFormat:@"已结束(%ld)",finishedCount]];
    }];
    [cell setHelpHandler:^{
        strongSelf(weakSelf);
        [strongSelf.helpView show:strongSelf.navigationController.view];
    }];
    [cell setUpdateLayout:^{
        strongSelf(weakSelf);
        [UIView animateWithDuration:.1f animations:^{
            [strongSelf.view layoutIfNeeded];
        }];
    }];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
