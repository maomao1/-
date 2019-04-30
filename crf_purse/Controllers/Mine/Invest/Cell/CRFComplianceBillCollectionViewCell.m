//
//  CRFComplianceBillCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFComplianceBillCollectionViewCell.h"
#import "CRFComplianceBillTableViewCell.h"
#import "CRFComplianceBillHeaderView.h"

@interface CRFComplianceBillCollectionViewCell() <UITableViewDelegate, UITableViewDataSource> {
    NSArray <NSString *>*titles;
    NSArray <NSString *>*datas;
}
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) CRFComplianceBillHeaderView *billHeaderView;

@end



@implementation CRFComplianceBillCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.tableView.separatorColor = UIColorFromRGBValue(0xf6f6f6);
    self.tableView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [self tableViewHeaderView];
}

- (void)setBill:(CRFComplianceBill *)bill {
    _bill = bill;
    self.billHeaderView.bill = _bill;
}

- (void)setHistoryBill:(CRFComplianceHistoryBill *)historyBill {
    _historyBill = historyBill;
    titles = @[@"账单周期",@"出借本金增减",@"本月预期收益",@"本月预支收益",@"累计预期收益",@"累计预支收益"];
    double value = ([_historyBill.endingAmount calculateWithHighPrecision].doubleValue - [_historyBill.beginningAmount calculateWithHighPrecision].doubleValue) / 100;
    NSString *valueString = nil;
    if (value > 0) {
       valueString = [[NSString stringWithFormat:@"+%.2f",value] formatBeginMoney];
    } else if (value < 0) {
       valueString = [[NSString stringWithFormat:@"-%.2f",value] formatBeginMoney];
    } else {
       valueString = [[NSString stringWithFormat:@"%.0f",value] formatBeginMoney];
    }
    datas = @[_historyBill.cycleDate,valueString, [_historyBill.payableBenefit formatBeginMoney], [_historyBill.prepayBenefit formatBeginMoney], [_historyBill.payableBenefitTotal formatBeginMoney], [_historyBill.prepayBenefitTotal formatBeginMoney]];
    [self.tableView reloadData];
}

- (void)setCurrrentBill:(CRFComplianceCurrentBill *)currrentBill {
    _currrentBill = currrentBill;
    titles = @[@"账单周期",@"本期应付本金",@"本期实付本金",@"累计应付收益",@"累计预支收益",@"本期实付收益",@"实际年化收益率（复利）"];
    datas = @[_currrentBill.cycleDate,[_currrentBill.payablePrincipal formatBeginMoney], [_currrentBill.actualPayPrincipal formatBeginMoney], [_currrentBill.payableBenefitTotal formatBeginMoney], [_currrentBill.prepayBenefitTotal formatBeginMoney], [_currrentBill.actualPayBenefit formatBeginMoney], _currrentBill.actualAnnualizedYieldDouble];
    [self.tableView reloadData];
}

- (void)tableViewHeaderView {
    _billHeaderView = [[CRFComplianceBillHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 86)];
    self.tableView.tableHeaderView = _billHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFComplianceBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCell"];
    if (!cell) {
        cell = [[CRFComplianceBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"billCell"];
    }
    cell.hasAttributed = (indexPath.row == 0);
    [cell configTitle:titles[indexPath.row] value:datas[indexPath.row]];
    return cell;
}

@end
