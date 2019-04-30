//
//  CRFQuickRechargeViewController.m
//  crf_purse
//
//  Created by maomao on 2018/8/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFQuickRechargeViewController.h"
#import "CRFRechargeDetailCell.h"
#import "CRFSettingData.h"

@interface CRFQuickRechargeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property  (nonatomic ,strong) UITableView  *mainTable;
@property  (nonatomic ,strong) NSArray *dataSource;
@end

@implementation CRFQuickRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"转账充值详情"];
    [self setContent];
    self.dataSource = @[@"充值码:",@"充值金额:",@"生成时间:",
                        @"入账户名:",@"入账银行:",@"入账卡号:",@"支行信息:"];
}
-(void)setRechargeModel:(CRFNewRechargeModel *)rechargeModel{
    _rechargeModel = rechargeModel;
    _rechargeModel.uuid = [CRFAppManager defaultManager].userInfo.customerUid;
    [CRFSettingData setRechargeInfo:_rechargeModel];
}
-(void)setContent{
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFRechargeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFRechargeDetailCellId];
    [cell crfSetContent:self.rechargeModel AndTitle:self.dataSource[indexPath.row]];
    return cell;
}
-(UITableView *)mainTable{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        [_mainTable setSeparatorColor:kCellLineSeparatorColor];
        [_mainTable registerClass:[CRFRechargeDetailCell class] forCellReuseIdentifier:CRFRechargeDetailCellId];
        _mainTable.backgroundColor = [UIColor clearColor];
        _mainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mainTable.estimatedRowHeight = 50;
        _mainTable.rowHeight = UITableViewAutomaticDimension;
        _mainTable.estimatedRowHeight = 50;
        [self autoLayoutSizeContentView:_mainTable];
    }
    return _mainTable;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
