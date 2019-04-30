//
//  CRFManagerDeviceVC.m
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDeviceManagerViewController.h"
//model
#import "CRFBindDevicesModel.h"
#import "CRFManagerDeviceTableViewCell.h"
@interface CRFDeviceManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation CRFDeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"设备管理"];
    [self initializeView];
    [self initDataSource];
    [self crfGetData];
    weakSelf(self);
    [self addRequestNotificationStatus:Status_Off_Line handler:^{
        strongSelf(weakSelf);
        [strongSelf crfGetData];
    }];
}

- (void)initializeView {
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
    self.contentTableView.backgroundColor = [UIColor clearColor];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self autoLayoutSizeContentView:self.contentTableView];
    [self.contentTableView registerClass:[CRFManagerDeviceTableViewCell class] forCellReuseIdentifier:CRFManagerDeviceCell_ID];
    self.contentTableView.rowHeight = 65;
    [self setTabHeaderStyle];
    self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)initDataSource{
    self.dataSource = [[NSMutableArray alloc]init];
}

- (void)setTabHeaderStyle{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *title  = [[UILabel alloc]init];
    [headerView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(13);
    }];
    title.textColor = UIColorFromRGBValue(0x999999);
    title.font = [UIFont systemFontOfSize:14.0f];
    title.text = NSLocalizedString(@"label_login_device_recent", nil);
    self.contentTableView.tableHeaderView = headerView;
}

- (void)crfGetData{
    weakSelf(self)
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetDevicesInfoPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        strongSelf.dataSource = (NSMutableArray*)[CRFResponseFactory handleProductDataForResult:response WithClass:[CRFBindDevicesModel class] ForKey:@"lsDevice"];
        [strongSelf.contentTableView reloadData];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFManagerDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFManagerDeviceCell_ID];
    cell.backgroundColor = [UIColor whiteColor];
    CRFBindDevicesModel *model = self.dataSource[indexPath.row];
    [cell crfSetContent:model];
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
