//
//  CRFHomeInvestTableViewCell.m
//  crf_purse
//
//  Created by mystarains on 2019/1/9.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomeInvestTableViewCell.h"
#import "CRFHomeInvestListCell.h"
#import "UIView+CRFController.h"
#import "CRFProductDetailViewController.h"

@interface CRFHomeInvestTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopMargin;

@end

@implementation CRFHomeInvestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self.tableView registerClass:[CRFHomeInvestListCell class] forCellReuseIdentifier:@"CRFHomeInvestListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)setProductFactory:(CRFHomeProductFactory *)productFactory{
    _productFactory = productFactory;
    
    self.tableViewTopMargin.constant = productFactory.hasNewProduct ? 18*3 : 0;

    [self.tableView reloadData];
}

- (IBAction)moreAction:(UIButton *)sender {
    
    if (self.showMoreBlock) {
        self.showMoreBlock();
    }
    
}

#pragma mark -----  UITableViewDelegate & UITableViewDataSource -----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.productFactory.recommendProduct.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CRFHomeInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRFHomeInvestListCell"];
    
    cell.productModel = self.productFactory.recommendProduct[indexPath.section];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductModel *productModel = self.productFactory.recommendProduct[indexPath.section];
    CRFProductDetailViewController *vc = [CRFProductDetailViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.productNo = productModel.contractPrefix;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = 120;
    
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
