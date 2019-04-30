//
//  CRFAppointmentForwardListViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/23.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardListViewController.h"
#import "CRFInvestListCell.h"
#import "CRFProductDetailViewController.h"

@interface CRFAppointmentForwardListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <NSArray <CRFAppintmentForwardProductModel *>*>  *products;

@property (nonatomic, assign) BOOL hasRemainProduct;

@end

@implementation CRFAppointmentForwardListViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = kCellLineSeparatorColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 83;
        [self autoLayoutSizeContentView:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"可转投计划列表"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadDatas];
}

- (void)loadDatas {
    [CRFLoadingView loading];
    weakSelf(self);
    NSString *urlString = nil;
    if (self.forwardType == CRFForwardProductTypeAutoInvest) {
        urlString = [NSString stringWithFormat:APIFormat(kGetAppointmentForwardPath),kUuid];
    } else {
        urlString = [NSString stringWithFormat:APIFormat(kAppointmentContainAssignProductPath),kUuid];
    }
//    urlString = [urlString stringByReplacingOccurrencesOfString:@"https://financeapp-static-uat.crfchina.com" withString:@"http://10.194.11.227:8070"];
    [[CRFStandardNetworkManager defaultManager] post:urlString paragrams:@{@"destProType":@(self.appointmentEndItem == 1 ? 2 : 1),@"investWay":@(self.appointmentStyle == 1 ? 2 : 1),@"investDeadLine":@(self.appointmentTimeItem),@"sourceInvestNo":self.productInfo.investNo,@"subscribeChannel":self.forwardType == CRFForwardProductTypeAppointmentForward ? @(1) : @(4),@"sourceCloseTime":self.productInfo.closeDate,@"planNo":self.productInfo.planNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        NSDictionary *dict = response[kDataKey];
        if (strongSelf.forwardType == CRFForwardProductTypeAutoInvest) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[CRFAppintmentForwardProductModel class] json:dict];
            if (list.count > 0) {
                [strongSelf.products addObject:list];
            }
        } else {
            NSArray *normalList = [NSArray yy_modelArrayWithClass:[CRFAppintmentForwardProductModel class] json:dict[@"normalProductList"]];
            NSArray *remainProductList = [NSArray yy_modelArrayWithClass:[CRFAppintmentForwardProductModel class] json:dict[@"remainProductList"]];
            if (remainProductList.count  > 0) {
                 [strongSelf.products addObject:remainProductList];
            }
            if (normalList.count > 0) {
                 [strongSelf.products addObject:normalList];
            }
            strongSelf.hasRemainProduct = !(remainProductList.count == 0);
        }
        [strongSelf setDefaultView];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        strongSelf(weakSelf);
        [strongSelf setDefaultView];
    }];
}

- (void)setDefaultView {
    if (self.products.count > 0) {
        [self.tableView reloadData];
        if (self.forwardType == CRFForwardProductTypeAppointmentForward) {
            if (self.products.count == 1 && self.hasRemainProduct) {
                [self tableViewFooter];
            }
        }
        return;
    }
    self.requestStatus = Status_AppointForward_None;
}

#pragma mark --UITableViewDelegate, UITableViewDataSorce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (!cell) {
        cell = [[CRFInvestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
    }
    if (indexPath.section == 0 && self.hasRemainProduct) {
        cell.appointmentAssignProductInfo = self.products[indexPath.section][indexPath.row];
    } else {
        cell.exclusiveProductInfo = self.products[indexPath.section][indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
//    UILabel *label = [UILabel new];
//    [sectionView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(sectionView);
//        make.left.equalTo(sectionView).with.offset(kSpace);
//    }];
//    label.textColor = kCellTitleTextColor;
//    label.font = [UIFont systemFontOfSize:12.0];
//    if (self.forwardType == CRFForwardProductTypeAppointmentForward) {
//        if (section == 0 && self.hasRemainProduct) {
//            label.textColor = kGraglientEndColor;
//            label.text = @"T+0天可申请退出，手续费0%：";
//        } else {
//            label.textColor = kCellTitleTextColor;
//            label.text = @"T+90天可申请退出，手续费5%：";
//        }
//    } else {
//        label.text = @"请选择转投计划：";
//    }
    
    if (self.forwardType == CRFForwardProductTypeAppointmentForward) {
        //        if (section == 0 && self.hasRemainProduct) {
        //            label.textColor = kGraglientEndColor;
        //            label.text = @"T+0天可申请退出，手续费0%：";
        //        } else {
        //            label.textColor = kCellTitleTextColor;
        //            label.text = @"T+90天可申请退出，手续费5%：";
        //        }
        return nil;
    } else {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        UILabel *label = [UILabel new];
        [sectionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(sectionView);
            make.left.equalTo(sectionView).with.offset(kSpace);
        }];
        label.textColor = kCellTitleTextColor;
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"请选择转投计划：";
        return sectionView;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.forwardType == CRFForwardProductTypeAppointmentForward) {
        return CGFLOAT_MIN;
    }
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.products.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CRFAppintmentForwardProductModel *model = self.products[indexPath.section][indexPath.row];
    CRFProductDetailViewController *controller = [CRFProductDetailViewController new];
    /*
     （key:investDeadLine(出借期限 <长中短>),investWay(转投类型<本金or本息>),sourceInvestNo(原出资编号),investAmount(转投金额),closeDate(原出资的结束时间)）
     */
    controller.productNo = model.contractPrefix;
    controller.appointmentForwardParams = @{@"investDeadLine":@(self.appointmentTimeItem),@"investWay":@(self.appointmentStyle == 1 ? 2 : 1),@"sourceInvestNo":self.productInfo.investNo,@"investAmount":self.investAmount,@"closeDate":self.productInfo.closeDate,@"planNo":self.planNo};
    controller.productStyle = self.forwardType == CRFForwardProductTypeAutoInvest ? CRFProductStyleAutoInvest : CRFProductStyleAppointmentForward;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 244)];
    self.tableView.tableFooterView = footerView;
    UIView *subHeaderView = [UIView new];
    subHeaderView.backgroundColor = kBackgroundColor;
    [footerView addSubview:subHeaderView];
    [subHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 12));
    }];
//    UILabel *label = [UILabel new];
//    [subHeaderView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(subHeaderView);
//        make.left.equalTo(subHeaderView).with.offset(kSpace);
//    }];
//    label.textColor = kCellTitleTextColor;
//    label.font = [UIFont systemFontOfSize:12.0];
//    label.text = @"T+90天可申请退出，手续费5%";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_no_invest"]];
    [footerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subHeaderView.mas_bottom).with.offset(40);
        make.centerX.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(135, 100));
    }];
    UILabel *exLabel = [UILabel new];
    [footerView addSubview:exLabel];
    [exLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView);
        make.top.equalTo(footerView.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 14));
    }];
    exLabel.text = @"没有符合条件的转投计划";
    exLabel.font = [UIFont systemFontOfSize:14];
    exLabel.textColor = kCellTitleTextColor;
    exLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSMutableArray<NSArray<CRFAppintmentForwardProductModel *> *> *)products {
    if (!_products) {
        _products = [NSMutableArray new];
    }
    return _products;
}

@end
