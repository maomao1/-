//
//  CRFOrderDetailViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFOrderDetailViewController.h"
#import "CRFOrderDetailTableViewCell.h"
#import "CRFStringUtils.h"
#import "CRFOrderCollectionViewCell.h"
#import "CRFInvestBill.h"
#import "CRFDatePickerView.h"
#import "UIView+Default.h"

@interface CRFOrderDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>{
    NSArray <CRFInvestBill *>*bills;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) CRFDatePickerView *pickerView;

@end

@implementation CRFOrderDetailViewController

- (NSArray *)dates {
    if (!_dates) {
        NSMutableArray *array = [NSMutableArray new];
        for (CRFInvestBill *bill in bills) {
            [array addObject:bill.cycleDate];
        }
        _dates = array;
    }
    return _dates;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - kNavHeight);
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
    // Do any additional setup after loading the view from its nib.
    [self rightBarButton];
    [self requestDatas];
    [self conNavTitle];
    [self addPicker];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CRFOrderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"orderCollectionCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)rightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
     [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName,UIColorFromRGBValue(0x666666),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

- (void)more {
    [self.pickerView show];
}

- (void)requestDatas {
    NSString *url = nil;
    NSDictionary *param = nil;
    if (![self.product.investSource isEqualToString:@"FTS"]) {
        url = [NSString stringWithFormat:APIFormat(kInvestOffLineBillPath),kUuid];
        param = @{@"investId":self.product.investId,@"source":self.product.source};
    } else {
        url = [NSString stringWithFormat:APIFormat(kInvestBillPath),kUuid];
        param = @{@"investId":self.product.investId};
    }
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:url paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf showContentLabel];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponse:(id)response {
        bills = [NSArray yy_modelArrayWithClass:[CRFInvestBill class] json:response[@"data"][@"billList"]];
        self.pickerView.dates = self.dates;
        if (bills.count <= 0) {
            [self showContentLabel];
        }
   [self.collectionView reloadData];
//    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:bills.count - 1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)showContentLabel {
    [self.view showDefaultText:@"暂无账单！"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName,UIColorFromRGBValue(0xCCCCCC),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

- (void)conNavTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 40)];
    _titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = _titleLabel;
    NSString *string = [NSString stringWithFormat:@"出借账单\n（出借编号：%@）",self.product.investNo];
    [self.titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:3 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"出借账单"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string rangeOfString:[NSString stringWithFormat:@"（出借编号：%@）",self.product.investNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return bills.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"orderCollectionCell" forIndexPath:indexPath];
    cell.source = [self.product.investSource isEqualToString:@"FTS"]?1:2;
    cell.bill = bills[indexPath.item];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPicker {
    _pickerView = [[CRFDatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 233)];
    [self.pickerView addView];
    weakSelf(self);
    [self.pickerView setDidSelectedHandler:^(NSInteger index){
        strongSelf(weakSelf);
        [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
}


@end
