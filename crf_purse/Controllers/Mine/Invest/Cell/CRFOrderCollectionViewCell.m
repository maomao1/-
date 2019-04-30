//
//  CRFOrderCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFOrderCollectionViewCell.h"
#import "CRFOrderDetailTableViewCell.h"

@interface CRFOrderCollectionViewCell() <UITableViewDelegate, UITableViewDataSource> {
    NSArray <NSString *>*titles;
    NSArray <NSString *>*datas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UILabel *sectionHeaderLabel;
@property (nonatomic, strong) UILabel *sectionFooterLabel;


@end

@implementation CRFOrderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.scrollEnabled = NO;
    // Initialization code
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self tableViewHeaderView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 46, 0, 0);
}

- (void)setSource:(NSUInteger)source {
    _source = source;
    [self configDatas];
}
- (void)configDatas {
    if (self.source == 1) {
        titles = @[@"当期年化收益率",@"当期收益"];
        datas = @[@"到期结算后确定",@"到期结算后确定"];
    } else {
    titles = @[@"当期新增",@"当期退出",@"当期年化收益率",@"当期实际收益"];
    datas = @[@"0元",@"0元",@"0.00%",@"0.00元"];
}
}

- (void)setBill:(CRFInvestBill *)bill {
    _bill = bill;
    if (self.source == 1) {
        datas = @[[NSString stringWithFormat:@"%@%%",_bill.annualisedReturnRate],[NSString stringWithFormat:@"%@元",_bill.investProfit],[NSString stringWithFormat:@"%@元",_bill.endingProfitSum]];
    } else {
        datas = @[[NSString stringWithFormat:@"%@元",_bill.investCapital],[NSString stringWithFormat:@"%@元",_bill.redeemCapital],[NSString stringWithFormat:@"%@%%",_bill.interest],[NSString stringWithFormat:@"%@元",_bill.debtProfit]];
    }
    _headerLabel.text = [NSString stringWithFormat:@"账单周期：%@",_bill.cycleDate];
    [self setSectionTitles];
    [self.tableView reloadData];
}

- (void)tableViewHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    headerView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.textColor = UIColorFromRGBValue(0x999999);
    
    _headerLabel.font = [UIFont systemFontOfSize:13.0];
    [headerView addSubview:_headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    self.tableView.tableHeaderView = headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFOrderDetailTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.label.text = titles[indexPath.row];
    cell.subLabel.text = datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    UIView *topLine = [UIView new];
    [view addSubview:topLine];
    topLine.backgroundColor = [UIColor colorWithWhite:.0f alpha:.1];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.mas_equalTo(.5f);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invest_begin"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(kSpace);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.text = @"期末金额";
    label.textColor = UIColorFromRGBValue(0x666666);
    label.font = [UIFont systemFontOfSize:15.0];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(250);
    }];
    _sectionFooterLabel = [UILabel new];
    [view addSubview:_sectionFooterLabel];
    _sectionFooterLabel.text = @"到期结算后确定";
    _sectionFooterLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    _sectionFooterLabel.font = [CRFUtils fontWithSize:15.0];
    _sectionFooterLabel.textAlignment = NSTextAlignmentRight;
    [_sectionFooterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(-kSpace);
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(150);
    }];
    UIView *line = [UIView new];
    [view addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:.0f alpha:.1];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.mas_equalTo(.5f);
    }];
    if (self.source == 2) {
        self.sectionFooterLabel.text = [NSString stringWithFormat:@"%@元",self.bill.endAmount];
        label.text = @"期末金额";
    } else {
        label.text = @"当期本金收益合计";
        self.sectionFooterLabel.text = [NSString stringWithFormat:@"%@元",_bill.endingProfitSum];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invest_end"]];
    [view addSubview:imageView];
    UIView *line = [UIView new];
    [view addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:.0f alpha:.1];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.mas_equalTo(.5f);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(kSpace);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.text = @"期初金额";
    label.textColor = UIColorFromRGBValue(0x666666);
    label.font = [UIFont systemFontOfSize:15.0];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(150);
    }];
    _sectionHeaderLabel = [UILabel new];
    [view addSubview:_sectionHeaderLabel];
    _sectionHeaderLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    _sectionHeaderLabel.font = [CRFUtils fontWithSize:15.0];
    _sectionHeaderLabel.textAlignment = NSTextAlignmentRight;
    [_sectionHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(-kSpace);
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(120);
    }];
    if (self.source == 2) {
        self.sectionHeaderLabel.text = [NSString stringWithFormat:@"%@元",self.bill.startDebtAmount];
        label.text = @"期初金额";
    } else {
        self.sectionHeaderLabel.text = [NSString stringWithFormat:@"%@元",self.bill.investAmount];
        label.text = @"原始本金";
    }
    return view;
}

- (void)setSectionTitles {
    if (self.source == 2) {
        self.sectionHeaderLabel.text = [NSString stringWithFormat:@"%@元",self.bill.startDebtAmount];
        self.sectionFooterLabel.text = [NSString stringWithFormat:@"%@元",self.bill.endAmount];

    } else {
        self.sectionFooterLabel.text = [NSString stringWithFormat:@"%@元",_bill.endingProfitSum];
        self.sectionHeaderLabel.text = [NSString stringWithFormat:@"%@元",self.bill.investAmount];
    }
}


@end
