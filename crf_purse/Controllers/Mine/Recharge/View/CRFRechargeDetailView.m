//
//  CRFRechargeDetailView.m
//  crf_purse
//
//  Created by maomao on 2018/8/20.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRechargeDetailView.h"
#import "CRFRechargeDetailCell.h"
#define  RechargeViewHeight  350
@interface CRFRechargeDetailView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTable;
@property (nonatomic , strong) NSArray     *dataSource;
@end
@implementation CRFRechargeDetailView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = @[@"充值码:",@"充值金额:",@"生成时间:",
                            @"入账户名:",@"入账银行:",@"入账卡号:",@"支行信息:"];
        [self addSubview:self.mainTable];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.tag = 1233;
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setTitle:@"关闭" forState:UIControlStateSelected];
        [closeBtn setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
        [closeBtn setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateSelected];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [closeBtn addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.frame = CGRectMake(0, kScreenHeight-46, kScreenWidth/2, 46);
        closeBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:closeBtn];
        
        UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        readBtn.tag = 1234;
        [readBtn setTitle:@"我已充值" forState:UIControlStateNormal];
        [readBtn setTitle:@"我已充值" forState:UIControlStateSelected];
        [readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        readBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [readBtn addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
        readBtn.frame = CGRectMake(kScreenWidth/2, kScreenHeight-46, kScreenWidth/2, 46);
        readBtn.backgroundColor = kBtnAbleBgColor;
        [self addSubview:readBtn];
    }
    return self;
}
-(void)setRechargeInfo:(CRFNewRechargeModel *)rechargeInfo{
    _rechargeInfo = rechargeInfo;
    [self.mainTable reloadData];
}
-(void)closeEvent:(UIButton*)btn{
    if (btn.tag == 1234) {
        [CRFSettingData setRechargeInfo:nil];
    }
    weakSelf(self);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        weakSelf.mainTable.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFRechargeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFRechargeDetailCellId];
    [cell crfSetContent:self.rechargeInfo AndTitle:self.dataSource[indexPath.row]];
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *title = [UILabel new];
    title.textColor = UIColorFromRGBValue(0x333333);
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:title];
    title.frame = CGRectMake(30, 15, kScreenWidth-60, 16);
    title.text = @"转账充值详情";
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 46;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    weakSelf(self);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        weakSelf.mainTable.frame = CGRectMake(0, kScreenHeight-RechargeViewHeight, kScreenWidth, RechargeViewHeight -46);
    } completion:nil];
}
- (UITableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.backgroundColor = [UIColor whiteColor];
        [_mainTable setSeparatorColor:[UIColor clearColor]];
        [_mainTable registerClass:[CRFRechargeDetailCell class] forCellReuseIdentifier:CRFRechargeDetailCellId];
        _mainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mainTable.estimatedRowHeight = 50;
        _mainTable.rowHeight = UITableViewAutomaticDimension;
        _mainTable.estimatedRowHeight = 50;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedSectionFooterHeight = 0;
    }
    return _mainTable;
}
@end
