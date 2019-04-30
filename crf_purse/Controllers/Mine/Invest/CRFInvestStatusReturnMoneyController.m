//
//  CRFInvestStatusReturnMoneyController.m
//  crf_purse
//
//  Created by maomao on 2019/4/24.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import "CRFInvestStatusReturnMoneyController.h"
#import "CRFReturnMoneyCell.h"
#import "CRFReturnMoneyHeaderView.h"
#import "MJRefresh.h"
@interface CRFInvestStatusReturnMoneyController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) UITableView *mainTab;
@property(nonatomic , strong) NSMutableArray *dataSource;
@property(nonatomic , assign) NSInteger    pageNum;
@property (nonatomic, strong) CRFReceiveCashModel *cashModel;
@property (nonatomic, strong) UIView         *recordBgView;

@end

@implementation CRFInvestStatusReturnMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}
-(void)initializeView{
    self.pageNum = 1;
    [self setSyatemTitle:@"分月回款明细"];
    [self.view addSubview:self.mainTab];
    [self.mainTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getCashDetailData];
    [self addRefreshHeader];
    [self addRefreshFooter];
}
-(void)addRefreshHeader{
    weakSelf(self);
    self.mainTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.pageNum = 1;
        [strongSelf getCashDetailData];
    }];
}
-(void)endRefresh{
    [self.mainTab.mj_header endRefreshing];
    [self.mainTab.mj_footer endRefreshing];
}
-(void)addRefreshFooter{
    weakSelf(self);
    self.mainTab.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.pageNum++;
        [strongSelf getCashDetailData];
    }];
}
-(void)getCashDetailData{
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kReceiveCashDetailPath),kUuid,self.product.investNo,@(20),@(self.pageNum)] success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [strongSelf endRefresh];
        strongSelf.cashModel = [CRFResponseFactory handleDataWithDic:response[kDataKey] forClass:[CRFReceiveCashModel class]];
        NSArray *array = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFReceiveCashDetail class] ForKey:@"detail"];
        if (strongSelf.pageNum == 1) {
            if (array.count) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
            }
        }else{
            [self.dataSource addObjectsFromArray:array];
        }
        [strongSelf setTabFooter];
        [strongSelf.mainTab reloadData];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [strongSelf endRefresh];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)setTabFooter{
    if (self.dataSource.count == 0) {
        _recordBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, kScreenWidth, kScreenHeight-140-kNavHeight)];
        _recordBgView.backgroundColor =UIColorFromRGBValue(0xf6f6f6);
        UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"receive_cash_bg"]];
        bgImg.contentMode = UIViewContentModeCenter;
        UILabel     *recordLabel = [[UILabel alloc]init];
        recordLabel.text = @"暂无回款记录";
        recordLabel.textColor = kTextEnableColor;
        recordLabel.font = [UIFont systemFontOfSize:14];
        [_recordBgView addSubview:recordLabel];
        [_recordBgView addSubview:bgImg];
        
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_recordBgView.mas_centerX);
            make.bottom.equalTo(_recordBgView.mas_centerY).with.mas_equalTo(10);
        }];
        [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgImg.mas_centerX);
            make.top.equalTo(bgImg.mas_bottom).with.mas_offset(16);
        }];
        self.mainTab.tableFooterView = _recordBgView;
    }else{
        self.mainTab.tableFooterView = nil;
    }
}
#pragma mark == tableViewDelegate ==
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFReturnMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CrfReturnMoneyCellId forIndexPath:indexPath];
    CRFReceiveCashDetail *detailModel = [self.dataSource objectAtIndex:indexPath.row];
    cell.cashModel = detailModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        CRFReturnMoneyHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CRFReturnMoneyHeaderViewId];
        headerView.cashModel = self.cashModel;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ?140 : CGFLOAT_MIN;
}
-(UITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_mainTab  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        _mainTab.estimatedRowHeight = 50;
        _mainTab.estimatedSectionHeaderHeight = 0;
        _mainTab.rowHeight = UITableViewAutomaticDimension;
        [_mainTab registerClass:[CRFReturnMoneyCell class] forCellReuseIdentifier:CrfReturnMoneyCellId];
        [_mainTab registerClass:[CRFReturnMoneyHeaderView class] forHeaderFooterViewReuseIdentifier:CRFReturnMoneyHeaderViewId];
        [self autoLayoutSizeContentView:_mainTab];
    }
    return _mainTab;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
@end
