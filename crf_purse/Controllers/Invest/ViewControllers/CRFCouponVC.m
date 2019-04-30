//
//  CRFCouponVC.m
//  crf_purse
//
//  Created by maomao on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCouponVC.h"
#import "CRFCouponCell.h"

@interface CRFCouponVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, strong) NSIndexPath *selectedIndex;


@end

@implementation CRFCouponVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:NSLocalizedString(@"title_coupon", nil)];
    [self.view addSubview:self.mainCollectionView];
    [self getDatas];
}

- (void)getDatas {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kCouponPath),kUuid] paragrams:@{@"investAmount":[[self.investAmount getOriginString] calculateWithHighPrecision],@"planNo":self.planNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parserResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        strongSelf.requestStatus = Status_Coupon_None;
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parserResponse:(id)response {
    [CRFLoadingView dismiss];
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        self.coupons = [CRFResponseFactory handleCouponData:response];
        if (self.coupons.count <= 0) {
            self.mainCollectionView.hidden = YES;
            self.requestStatus = Status_Coupon_None;
        } else {
            
            [self.mainCollectionView reloadData];
        }
    } else {
        self.requestStatus = Status_Coupon_None;
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (void)setCoupons:(NSArray<CRFCouponModel *> *)coupons {
    _coupons = coupons;
    [self.mainCollectionView reloadData];
}

#pragma mark == UICollectionViewDelegate UICollectionViewDataSource=
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.coupons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CRFCouponCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFCouponCell_Id forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.coupon = self.coupons[indexPath.item];
    if ([cell.coupon.giftDetailId isEqualToString:self.selectedCoupon.giftDetailId]) {
        [cell selected];
    }else{
        [cell resetUI];
    }
    weakSelf(self);
    [cell setCouponDidSelectedHandler:^ (CRFCouponCell *cell){
        strongSelf(weakSelf);
        if (cell.couponSelected) {
            strongSelf.selectedIndex = [strongSelf.mainCollectionView indexPathForCell:cell];
        } else {
            strongSelf.selectedIndex = nil;
        }
        [strongSelf.mainCollectionView reloadData];
        if (strongSelf.couponDidSelectedHandler) {
            if (strongSelf.selectedIndex) {
                 strongSelf.couponDidSelectedHandler(strongSelf.coupons[strongSelf.selectedIndex.item]);
            } else {
                strongSelf.couponDidSelectedHandler(nil);
            }
        }
//        if (cell.couponSelected) {
            [CRFUtils delayAfert:.5 handle:^{
                [strongSelf back];
            }];
//        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kSpace, 8, kScreenWidth-2*kSpace, kScreenHeight-kNavHeight-8) collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.itemSize = CGSizeMake(kScreenWidth-2*kSpace, 88);
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        
        [_mainCollectionView registerClass:[CRFCouponCell class] forCellWithReuseIdentifier:CRFCouponCell_Id];
    }
    return _mainCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
