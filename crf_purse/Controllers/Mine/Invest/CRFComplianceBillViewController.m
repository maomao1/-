//
//  CRFComplianceBillViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFComplianceBillViewController.h"
#import "CRFStringUtils.h"
#import "CRFInvestBill.h"
#import "CRFDatePickerView.h"
#import "UIView+Default.h"
#import "CRFComplianceBillCollectionViewCell.h"
#import "CRFComplianceBillFooterReusableView.h"
#import "CRFComplianceBill.h"


@interface CRFComplianceBillScrollViewTableViewCell:UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CRFComplianceBill *bill;

@property (nonatomic, strong) NSArray *bills;

@property (nonatomic, copy) void (^(updateTableViewHeight))(BOOL currentBill);

@end

@implementation CRFComplianceBillScrollViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeZero;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CRFComplianceBillCollectionViewCell class] forCellWithReuseIdentifier:@"complianceBillCell"];
    }
    return _collectionView;
}

- (void)initializeView {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setBills:(NSArray *)bills {
    if (_bills) {
        return;
    }
    _bills = bills;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bills.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFComplianceBillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"complianceBillCell" forIndexPath:indexPath];
    cell.bill = self.bill;
    if (self.bill.finalBillInfo && indexPath.item == 0) {
        cell.currrentBill = self.bills[indexPath.item];
    } else {
        cell.historyBill = self.bills[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bill.finalBillInfo && indexPath.item == 0) {
        if (self.bills.count != 1 && [UIDevice currentDevice].systemVersion.floatValue > 9.0) {
            if (self.updateTableViewHeight) {
                self.updateTableViewHeight(YES);
            }
        } else if (self.bills.count == 1){
            if (self.updateTableViewHeight) {
                self.updateTableViewHeight(YES);
            }
        }
        return CGSizeMake(kScreenWidth, 51 * 7 + 86);
    }
    return CGSizeMake(kScreenWidth, 51 * 6 + 86);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    if (self.bill.finalBillInfo && index == 0) {
        if (self.updateTableViewHeight) {
            self.updateTableViewHeight(YES);
        }
    } else {
        if (self.updateTableViewHeight) {
            self.updateTableViewHeight(NO);
        }
    }
}

@end

@interface CRFComplianceBillViewController () <UITableViewDelegate, UITableViewDataSource>{
    NSArray *bills;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) CRFDatePickerView *pickerView;

@property (nonatomic, strong) CRFComplianceBill *bill;

@property (nonatomic, strong) CRFComplianceBillFooterReusableView *footerView;

@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation CRFComplianceBillViewController

- (NSArray *)dates {
    if (!_dates) {
        NSMutableArray *array = [NSMutableArray new];
        for (CRFComplianceCurrentBill *bill in bills) {
            [array addObject:bill.cycleDate];
        }
        _dates = array;
    }
    return _dates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self rightBarButton];
    [self addPicker];
    [self initializeView];
    [self requestDatas];
    [self conNavTitle];
}

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    _tableView.bounces = NO;
    _tableView.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _footerView = [[CRFComplianceBillFooterReusableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.tableView.tableFooterView = _footerView;
    self.tableView.rowHeight = 51 * 6 + 86;
}

- (void)rightBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 62, 24);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 12.0;
    [button addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"更多账单" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button setTitleColor:UIColorFromRGBValue(0xCCCCCC) forState:UIControlStateDisabled];
    button.layer.borderWidth = .5f;
    button.layer.borderColor = UIColorFromRGBValue(0x666666).CGColor;
    self.moreButton = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
}

- (void)more {
    [self.pickerView show];
}

- (void)requestDatas {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestNCPBillPath),kUuid] paragrams:@{@"investNo":self.product.investNo} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [strongSelf showContentLabel];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponse:(id)response {
    DLog(@"%@ response is %@",NSStringFromClass([self class]), response);
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        _bill = [CRFComplianceBill yy_modelWithJSON:response[kDataKey]];
        bills = _bill.totalBills;
        self.pickerView.dates = self.dates;
        if (bills.count <= 0) {
            [self showContentLabel];
        } else {
            self.tableView.hidden = NO;
            [self.footerView setContent];
        }
    } else {
        [self showContentLabel];
        [CRFUtils showMessage:response[kMessageKey]];
    }
    [self.tableView reloadData];
}

- (void)showContentLabel {
    [self.view showDefaultText:@"暂无账单！"];
    self.tableView.hidden = YES;
    self.moreButton.enabled = NO;
    self.moreButton.layer.borderColor = UIColorFromRGBValue(0xCCCCCC).CGColor;
}

- (void)conNavTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 40)];
    _titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = _titleLabel;
    NSString *string = [NSString stringWithFormat:@"出借账单\n（出借编号：%@）",self.product.investNo];
    
    [self.titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:3 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"出借账单"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0 * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string rangeOfString:[NSString stringWithFormat:@"（出借编号：%@）",self.product.investNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
}


#pragma mark --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFComplianceBillScrollViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CRFComplianceBillScrollViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.bill = _bill;
    cell.bills = bills;
    weakSelf(self);
    [cell setUpdateTableViewHeight:^(BOOL update){
        strongSelf(weakSelf);
        strongSelf.tableView.rowHeight = 51 * (update? 7 : 6) + 86;
        [strongSelf.tableView reloadData];
        if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
            [UIView animateWithDuration:.15 animations:^{
                [strongSelf.view layoutIfNeeded];
            }];
        }
        
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
        [[strongSelf billCollectionView] scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
}

- (UICollectionView *)billCollectionView {
    CRFComplianceBillScrollViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.collectionView;
}


@end
