//
//  CRFDebtListViewController.m
//  crf_purse
//
//  Created by maomao on 2018/9/21.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDebtListViewController.h"
#import "CRFNewInvestListCell.h"
#import "MJRefresh.h"
#import "CRFDebtDetailViewController.h"

@interface CRFDebtListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property  (nonatomic , strong) UITableView *mainTableView;
@property  (nonatomic , strong) NSMutableArray     *dataSource;
@property  (nonatomic , assign) NSInteger   pageNum;
@property  (nonatomic , assign) BOOL        hasMoreFlag;
@property (nonatomic ,strong)UILabel         *noProductLabel;

@end

@implementation CRFDebtListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self initConfigerView];
    [self getDataSourceFromNet];
    // Do any additional setup after loading the view.
}
-(void)initConfigerView{
    [self.mainTableView addSubview:self.noProductLabel];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.top.equalTo(self.view);
    }];
    [_noProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mainTableView);
    }];
    MJRefreshNormalHeader  *refresh_header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    refresh_header.lastUpdatedTimeLabel.textColor = UIColorFromRGBValue(0x999999);
    self.mainTableView.mj_header = refresh_header;
//    [self addRefreshFooter];
}
-(void)refreshData{
    _pageNum = 1;
    [self getDataSourceFromNet];
}
- (void)addRefreshFooter {
    weakSelf(self);
    self.mainTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.pageNum++;
        [strongSelf getDataSourceFromNet];
    }];
}
- (void)removeFooterView {
    [self.mainTableView.mj_footer removeFromSuperview];
}
- (void)endInvestRefresh {
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
}
-(void)getDataSourceFromNet{
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kDebtListPath) paragrams:@{@"pageIndex":@(self.pageNum),@"pageSize":@(300)} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
        [CRFLoadingView dismiss];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [self endInvestRefresh];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)parseResponse:(id)response{
    [self endInvestRefresh];
    NSArray *array = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFDebtModel class] ForKey:@"resultList"];
    if (self.pageNum == 1) {
        [self.dataSource removeAllObjects];
    }
    [self.dataSource addObjectsFromArray:array];
    if (self.dataSource.count >= 20&&!self.hasMoreFlag) {
        self.hasMoreFlag = YES;
//        [self addRefreshFooter];
    } else if (self.dataSource.count < 20) {
        [self removeFooterView];
        self.hasMoreFlag = NO;
    }
    [self.mainTableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataSource.count) {
        _noProductLabel.hidden = YES;
    } else {
        _noProductLabel.hidden = NO;
    }
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CRFProductModel *productInfo = [self.resultList objectAtIndex:indexPath.section];
    CRFDebtModel *debtModel = [self.dataSource objectAtIndex:indexPath.section];
    CRFNewInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFDebtListCellId];
    cell.debtModel = debtModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFDebtModel *debtModel = [self.dataSource objectAtIndex:indexPath.section];
    [CRFAPPCountManager setEventID:@"DEBT_PRODUCT_EVENT" EventName:debtModel.rightsNo];//埋点
    CRFDebtDetailViewController *debtDetail = [CRFDebtDetailViewController new];
    debtDetail.proDebtModel = debtModel;
    debtDetail.hidesBottomBarWhenPushed = YES;
    debtDetail.urlString =[NSString stringWithFormat:kDebtDetailH5,debtModel.transferingNo,debtModel.rightsNo];
    [self.navigationController pushViewController:debtDetail animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? 8 : CGFLOAT_MIN;
}
-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        [_mainTableView registerClass:[CRFNewInvestListCell class] forCellReuseIdentifier:CRFDebtListCellId];
        //        _mainTableView.rowHeight = 86;
        _mainTableView.estimatedRowHeight = 50;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        [self autoLayoutSizeContentView:_mainTableView];
    }
    return _mainTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (UILabel *)noProductLabel {
    if (!_noProductLabel) {
        _noProductLabel = [[UILabel alloc] init];
        _noProductLabel.text = @"暂时没有可转让的债权，敬请关注";
        _noProductLabel.backgroundColor = [UIColor clearColor];
        _noProductLabel.textAlignment = NSTextAlignmentCenter;
        _noProductLabel.font = [UIFont systemFontOfSize:12.0];
        _noProductLabel.textColor = UIColorFromRGBValue(0x999999);
    }
    return _noProductLabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
