//
//  CRFNewUserProductTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNewUserProductTableViewCell.h"
#import "CRFHomeTableViewCell.h"
#import "CRFInvestListCell.h"

@interface CRFNewUserProductTableViewCell() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CRFNewUserProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    UIImageView *bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_user_product"]];
    [self addSubview:bgimageView];
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(120);
    }];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = kCellLineSeparatorColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *model = self.products[indexPath.row];
    if (self.selectedProductHandler) {
        self.selectedProductHandler(model);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *model = self.products[indexPath.row];
    if ([self complianceProduct:model]) {
       CRFInvestListCell *cell = (CRFInvestListCell *)[self configComplianceCell:indexPath tableView:tableView];
         cell.newBie = YES;
        cell.productModel = model;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        CRFHomeTableViewCell *cell = (CRFHomeTableViewCell *)[self configOldCell:indexPath tableView:tableView];
        cell.tipText = model.tipsStart;
        cell.productType = Old_Product;
        cell.products = @[model];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void)setProducts:(NSArray<CRFProductModel *> *)products {
    _products = products;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *model = self.products[indexPath.row];
    if ([self complianceProduct:model]) {
        return 89;
    }
    if (model.tipsStart && model.tipsStart.length > 0) {
        return 90;
    }
    return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:15.0];
    label.text = @"新手专享";
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(kSpace);
        make.top.bottom.right.equalTo(headerView);
    }];
    return headerView;
}

- (UITableViewCell *)configComplianceCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CRFInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"complianceCell"];
    if (!cell) {
        cell = [[CRFInvestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"complianceCell"];
    }
    return cell;
}

- (UITableViewCell *)configOldCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    CRFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (!cell) {
       cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFHomeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

/**
 是否为合规产品

 @return value
 */
- (BOOL)complianceProduct:(CRFProductModel *)product {
    return !([product.productType integerValue] == 3);
}

@end
