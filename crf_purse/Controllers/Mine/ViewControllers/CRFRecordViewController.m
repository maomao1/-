//
//  CRFRecordViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRecordViewController.h"
#import "CRFSegmentHead.h"
#import "CRFMessageTableViewCell.h"
@interface CRFRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) UITableView *mainTab;
@property(nonatomic , strong) NSMutableArray *dataSource;
@property(nonatomic , strong) NSMutableArray *rechargeArray;///<充值数组
@property (nonatomic, strong) NSMutableArray *withdrawArray;///<提现数组
@property (nonatomic,strong) CRFSegmentHead  *segmentHead;
@end

@implementation CRFRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"转账记录"];
    [self initDatasource];
    [self setContentUI];
    [self setContentTabHeader];
    [self crfGetData];
}

- (void)initDatasource {
    self.dataSource = [[NSMutableArray alloc] init];
    self.rechargeArray = [[NSMutableArray alloc] init];
    self.withdrawArray = [[NSMutableArray alloc] init];
}

- (void)setContentTabHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [header setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = UIColorFromRGBValue(0x999999);
    titleLabel.text = NSLocalizedString(@"label_look_up_record", nil);
    titleLabel.frame = CGRectMake(kSpace, 0, kScreenWidth-2*kSpace, 43);
    [header addSubview:titleLabel];
    self.mainTab.tableHeaderView = header;
}

- (void)setContentUI {
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.mainTab];
    weakSelf(self);
    self.segmentHead = [[CRFSegmentHead alloc] initCommonWithFrame:CGRectMake(0, 0, kScreenWidth, 40) titles:@[NSLocalizedString(@"title_recharge", nil),NSLocalizedString(@"title_roll_out", nil)] clickCallback:^(NSInteger index) {
        if (index ==weakSelf.selectedIndex) {
            return;
        }
        weakSelf.selectedIndex = index;
        [weakSelf.mainTab reloadData];
    }];
    self.segmentHead.defaultIndex = self.selectedIndex;
    [self.view addSubview:self.segmentHead];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.rowHeight = 76;
    [self.mainTab setSeparatorColor:kCellLineSeparatorColor];
    self.mainTab.backgroundColor = [UIColor clearColor];
    [self.mainTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentHead.mas_bottom).with.mas_offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.mainTab registerClass:[CRFMessageTableViewCell class] forCellReuseIdentifier:CRFRecordCell_Identifier];
    self.mainTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)handleDataArray {
    for (CRFCashRecordModel *model in self.dataSource) {
        if ([model.jyType isEqualToString:@"1"]) {
            [self.rechargeArray addObject:model];
        }else{
            [self.withdrawArray addObject:model];
        }
    }
    [self.mainTab reloadData];
}

- (void)crfGetData {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kAccountRecordListPath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
    }];
}

- (void)parseResponse:(id)response {
    [CRFLoadingView dismiss];
        self.dataSource = (NSMutableArray*)[CRFResponseFactory getCashRecord:response];
        [self handleDataArray];
        [self.mainTab reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedIndex == 0) {
        return self.rechargeArray.count;
    }
    return self.withdrawArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFRecordCell_Identifier];
    CRFCashRecordModel *model;
    if (self.selectedIndex == 0) {
        model = self.rechargeArray[indexPath.row];
    }else{
        model = self.withdrawArray[indexPath.row];
    }
    [cell crfSetRecordCellContent:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
