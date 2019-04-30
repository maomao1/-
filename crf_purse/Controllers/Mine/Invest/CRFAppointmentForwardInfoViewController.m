//
//  CRFAppointmentForwardInfoViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardInfoViewController.h"
#import "CRFRechargeTableViewCell.h"
#import "CRFAlertUtils.h"
#import "CRFAppointmentForwardInfo.h"
#import "CRFInvestStatusViewController.h"
#import "UIImage+Color.h"

@interface CRFAppointmentForwardInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSString *> *titles;

@property (nonatomic, copy) NSArray <NSString *> *values;

@property (nonatomic, strong) CRFAppointmentForwardInfo *info;

@end

@implementation CRFAppointmentForwardInfoViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.bounces = NO;
        _tableView.rowHeight = 50;
        [self autoLayoutSizeContentView:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.forwardType == CRFForwardProductTypeAppointmentForward) {
            [self setSyatemTitle:@"预约转投计划详情"];
    } else {
            [self setSyatemTitle:@"转投计划详情"];
    }
     [self getViewDetail];
//    [self initializeView];
}

- (void)getViewDetail {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppointmentForwardDetailPath),kUuid] paragrams:@{@"sourceInvestNo":self.investNo} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        strongSelf.info = [CRFAppointmentForwardInfo yy_modelWithJSON:response[kDataKey]];
        [strongSelf initializeView];
        [strongSelf.tableView reloadData];
        if (strongSelf.forwardType == CRFForwardProductTypeAppointmentForward) {
             [strongSelf configCancelButton];
        } else {
            [strongSelf configBackButton];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)initializeView {
        self.values = @[self.info.productName,self.info.startInvestTime,(self.info.productType.integerValue == 4 ? nil : self.info.closeTime),[self.info rangeOfYInterstRate],(self.info.productType.integerValue == 4 ? nil : self.info.giftName),self.info.investWay];
    _titles = @[@"出借计划名称：",@"开始投资日期：",(self.info.productType.integerValue == 4 ? nil : @"计划到期日期："),@"期望年化收益率：",(self.info.productType.integerValue == 4 ? nil : @"使用返现/加息红包："),@"转投方式："];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFRechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[CRFRechargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.titleLabel.textColor = kTextEnableColor;
    cell.textField.text = self.values[indexPath.row];
    cell.titleLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textField.font = [UIFont systemFontOfSize:14.0];
    cell.edit = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setBackgroundImage:[UIImage imageWithColor:kRegisterButtonBackgroundColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kSpace));
        make.right.equalTo(@(-kSpace));
        make.top.equalTo(@(310 + kNavHeight + 30));
        make.height.mas_equalTo(kButtonHeight);
    }];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configCancelButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setTitle:@"取消预约" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(-70 * kWidthRatio));
        make.height.mas_equalTo(20);
    }];
    [button addTarget:self action:@selector(cancelAppointmentForward) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelAppointmentForward {
    weakSelf(self);
    [CRFAlertUtils showAlertTitle:@"预约转投可减少资金闲置时间，是否确认取消？" message:nil container:self cancelTitle:@"取消预约" confirmTitle:@"维持预约" cancelHandler:^{
        strongSelf(weakSelf);
        [strongSelf cancel];
    } confirmHandler:nil];
}

- (void)cancel {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kCancelAppointmentForwardPath),kUuid] paragrams:@{@"sourceInvestNo":self.investNo} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        for (UIViewController *controller in strongSelf.navigationController.viewControllers) {
            if ([controller isKindOfClass:[CRFInvestStatusViewController class]]) {
                CRFInvestStatusViewController *vc = (CRFInvestStatusViewController *)controller;
                if (vc.refreshProductInfo) {
                    vc.refreshProductInfo();
                }
                break;
            }
        }
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [CRFAlertUtils showAlertTitle:response[kMessageKey] message:nil container:strongSelf cancelTitle:nil confirmTitle:@"确定" cancelHandler:nil confirmHandler:nil];
    }];
}

@end
