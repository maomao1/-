//
//  CRFExclusivePlanListViewController.m
//  crf_purse
//
//  Created by maomao on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFExclusivePlanListViewController.h"
#import "CRFInvestListCell.h"
#import "CRFProductDetailViewController.h"

@interface CRFExclusivePlanListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView     *mainTableView;
@property (nonatomic ,strong) NSArray         *dataSource;
@property (nonatomic ,strong) UILabel         *titleLabel;
@end

@implementation CRFExclusivePlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"特供计划列表"];
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
//        make.height.mas_equalTo(34);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self crfGetProductListData];
}
-(void)crfGetProductListData{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[NSString stringWithFormat:@"%ld",self.investDeadLine] forKey:@"investDeadLine"];
    [param setValue:[NSString stringWithFormat:@"%ld",self.destProType] forKey:@"destProType"];
//    [param setValue:@"qeeetqet341" forKey:@"sourceInvestNo"];
    [param setValue:[NSString stringWithFormat:@"%.f",self.exclusiveAmount.doubleValue*100] forKey:@"subscribeAmount"];
    [param setValue:@"2" forKey:@"subscribeChannel"];
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kExclusiveProductList),kUuid] paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
            strongSelf.dataSource = [CRFResponseFactory handleDataForResult:response WithClass:[CRFAppintmentForwardProductModel class]];
        [strongSelf setDefaultView];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFAppintmentForwardProductModel * productInfo = [self.dataSource objectAtIndex:indexPath.row];
    CRFInvestListCell  *cell = [tableView dequeueReusableCellWithIdentifier:CRFInvestListCellId];
    cell.exclusiveProductInfo = productInfo;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductModel * productInfo = [self.dataSource objectAtIndex:indexPath.row];
    if (![productInfo.type isEqualToString:@"4"]) {
        if ([productInfo.productType isEqualToString:@"3"]) {
            if (productInfo.tipsStart && productInfo.tipsStart.length > 0) {
                return 90;
            }else{
                return 83;
            }
        }
        return 83;
    }
    return 86;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductModel *productInfo = [self.dataSource objectAtIndex:indexPath.row];
    CRFProductDetailViewController *investDetailVC = [CRFProductDetailViewController new];
    investDetailVC.productNo = productInfo.contractPrefix;
    investDetailVC.productStyle = 2;
    investDetailVC.exclusiveAmount = self.exclusiveAmount;
    [self.navigationController pushViewController:investDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView setSeparatorColor:kCellLineSeparatorColor];
        [_mainTableView registerClass:[CRFInvestListCell class] forCellReuseIdentifier:CRFInvestListCellId];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.rowHeight = 86;
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self autoLayoutSizeContentView:_mainTableView];
    }
    return _mainTableView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGBValue(0x666666);
        _titleLabel.text = @"请选择特供计划：";
    }
    return _titleLabel;
}

- (void)setDefaultView {
    if (self.dataSource.count > 0) {
        [self.mainTableView reloadData];
        return;
    }
    self.requestStatus = Status_ExclusivePlan_None;
}
@end
