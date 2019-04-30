//
//  CRFAppointmentForwardViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardViewController.h"
#import "CRFInvestStatusTableViewCell.h"
#import "CRFAppointmentForwardTableViewCell.h"
#import "CRFAppointmentForwardFooterView.h"
#import "CRFStringUtils.h"
#import <YYImage/YYAnimatedImageView.h>
#import "CRFAppointmentForwardHelpView.h"
#import "CRFHomeConfigHendler.h"
#import "CRFAppointmentForwardListViewController.h"

typedef struct Item {
    NSInteger item;
    BOOL selected;
}Item;

@interface CRFAppointmentForwardViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSArray <NSString *> *>*eventNames;

@property (nonatomic, strong) NSArray <NSString *> *titles;

@property (nonatomic, strong) NSArray <NSString *> *imageNames;

@property (nonatomic, assign) Item styleItem;

@property (nonatomic, assign) Item timeItem;

@property (nonatomic, assign) Item endItem;

@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;

@property (nonatomic, strong) CRFAppointmentForwardHelpView *amountExplainView;

@end

@implementation CRFAppointmentForwardViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.forwardType == CRFForwardProductTypeAutoInvest) {
        [self setCustomLineTitle:@"转投"];
    } else {
        [self setCustomLineTitle:@"预约转投"];
        [self setCustomRightBarButtonWithImageNamed:@"common_nav_icon_help" target:self selector:@selector(help)];
    }
    
    [super customNavigationBackForBlack];
    
    [self initializeView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 20;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self autoLayoutSizeContentView:_tableView];
    }
    return _tableView;
}

- (CRFAppointmentForwardHelpView *)amountExplainView {
    if (!_amountExplainView) {
        _amountExplainView = [CRFAppointmentForwardHelpView new];
        _amountExplainView.title = @"转投金额说明";
        _amountExplainView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        //        [_helpView setDissmissPoint:CGPointMake(kScreenWidth - 40, kStatusBarHeight + kNavigationbarHeight / 2.0)];
        [_amountExplainView drawContent:@"实际转投金额以计划到期后结算账单的显示为准。"];
    }
    return _amountExplainView;
}

- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.title = @"预约转投说明";
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth - 40, kStatusBarHeight + kNavigationbarHeight / 2.0)];
        [_helpView drawContent:@"预约转投可让您的出借计划到期结算后，直接转投到新的出借计划中。可减少您的资金闲置时间。\n预约当日不能取消，次日起至当前计划到期日前1天可随时取消预约。"];
    }
    return _helpView;
}

- (void)initializeView {
    NSArray <CRFAppHomeModel *>*list = [CRFHomeConfigHendler defaultHandler].productTitleList;
    if (self.forwardType == CRFForwardProductTypeAutoInvest) {
        Item item = {1,YES};
        self.styleItem = item;
        _eventNames = @[@[[NSString stringWithFormat:@"%@%@",list[1].name,list[1].content],[NSString stringWithFormat:@"%@%@",list[2].name,list[2].content],[NSString stringWithFormat:@"%@%@",list[3].name,list[3].content]],@[@"按月付息",@"到期付息"]];
        _imageNames = @[@"forward_filter_icon_duration",@"forward_filter_icon_ settlement"];
        _titles = @[@"期望出借期限",@"期望结算方式"];
    } else {
        if (self.productDetail.proType.integerValue == 1) {
            NSString *content = @"本息转投";
            NSString *content1 = @"本金转投";
            NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:kTextDefaultColor}];
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"forward_filter_icon_introduction"]];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.frame = CGRectMake(0, 0, 30, 30);
            NSMutableAttributedString *attributed1 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
            [contentString appendAttributedString:attributed1];
            NSMutableAttributedString *contentString1 = [[NSMutableAttributedString alloc] initWithString:content1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:kTextDefaultColor}];
            _eventNames = @[@[contentString,contentString1],@[[NSString stringWithFormat:@"%@%@",list[1].name,list[1].content],[NSString stringWithFormat:@"%@%@",list[2].name,list[2].content],[NSString stringWithFormat:@"%@%@",list[3].name,list[3].content]],@[@"按月付息",@"到期付息"]];
            _imageNames = @[@"forward_filter_icon_method",@"forward_filter_icon_duration",@"forward_filter_icon_ settlement"];
            _titles = @[@"转投方式",@"期望出借期限",@"期望结算方式"];
        } else {
            Item item = {2,YES};
            self.styleItem = item;
            _eventNames = @[@[@"本金转投"],@[[NSString stringWithFormat:@"%@%@",list[1].name,list[1].content],[NSString stringWithFormat:@"%@%@",list[2].name,list[2].content],[NSString stringWithFormat:@"%@%@",list[3].name,list[3].content]],@[@"按月付息",@"到期付息"]];
            _imageNames = @[@"forward_filter_icon_method",@"forward_filter_icon_duration",@"forward_filter_icon_ settlement"];
            _titles = @[@"转投方式",@"期望出借期限",@"期望结算方式"];
        }
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(kNavHeight));
    }];
    [self configTableViewFooter];
}

#pragma mark --UITableViewDelegate, UITableViewDataSorce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CRFInvestStatusTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:(self.forwardType == CRFForwardProductTypeAutoInvest ?@"autoInvest" : @"productInfo")];
        if (!infoCell) {
            infoCell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestStatusTableViewCell" owner:nil options:nil] objectAtIndex:(self.forwardType == CRFForwardProductTypeAutoInvest ? 3 : 0)];
        }
        if (self.forwardType == CRFForwardProductTypeAutoInvest) {
            infoCell.autoInvestProduct = self.productDetail;
        } else {
            infoCell.type = 1;
            infoCell.isAppointmentForward = YES;
            infoCell.originProduct = self.product;
            infoCell.product = self.productDetail;
        }
        infoCell.hasAccessoryView = NO;
        return infoCell;
    }
    CRFAppointmentForwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentForwardCell"];
    if (!cell) {
        cell = [[CRFAppointmentForwardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentForwardCell"];
    }
    cell.indexPath = indexPath;
    cell.title = self.titles[indexPath.row];
    cell.iconNamed = self.imageNames[indexPath.row];
    if (indexPath.row == 0) {
        if (self.forwardType == CRFForwardProductTypeAutoInvest) {
            cell.eventNames = self.eventNames[indexPath.row];
            cell.selectedItem = self.timeItem.item;
        } else {
            if (self.productDetail.proType.integerValue == 1) {
                cell.attributedEventNames = (NSArray <NSAttributedString *> *)self.eventNames[indexPath.row];
                cell.itemDisable = YES;
            } else {
                cell.itemDisable = NO;
                cell.eventNames = self.eventNames[indexPath.row];
            }
            cell.selectedItem = self.styleItem.item;
        }
    } else {
        cell.itemDisable = YES;
        cell.eventNames = self.eventNames[indexPath.row];
        if (indexPath.row == 1) {
            if (self.forwardType == CRFForwardProductTypeAppointmentForward) {
                cell.selectedItem = self.endItem.item;
            } else {
                cell.selectedItem = self.timeItem.item;
            }
        } else {
            cell.selectedItem = self.endItem.item;
        }
    }
    /*
     帮助
     */
    weakSelf(self);
    [cell setExplainHandler:^{
        strongSelf(weakSelf);
        [strongSelf.amountExplainView show:self.view];
    }];
    [cell setItemDidSelectedHandler:^(NSIndexPath *indexPath, NSInteger item, BOOL selected){
        strongSelf(weakSelf);
        Item item1 = {item,selected};
        if (indexPath.row == 0) {
            if (strongSelf.forwardType == CRFForwardProductTypeAutoInvest) {
                strongSelf.timeItem = item1;
            } else {
                strongSelf.styleItem = item1;
            }
        } else if (indexPath.row == 1){
            if (strongSelf.forwardType == CRFForwardProductTypeAutoInvest) {
                strongSelf.endItem = item1;
            } else {
                strongSelf.timeItem = item1;
            }
        } else {
            strongSelf.endItem = item1;
        }
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    UILabel *label = [UILabel new];
    [sectionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(sectionView);
        make.left.equalTo(sectionView).with.offset(kSpace);
    }];
    label.textColor = kCellTitleTextColor;
    label.font = [UIFont systemFontOfSize:13.0];
    if (self.forwardType == CRFForwardProductTypeAutoInvest) {
        label.text = section == 0 ? @"当前出借记录：": @"转投意向：";
    } else {
        label.text = section == 0 ? @"当前出借记录：": @"转投目标筛选：";
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.eventNames.count;
}

- (void)configTableViewFooter {
    CRFAppointmentForwardFooterView *footerView = [[CRFAppointmentForwardFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 123)];
    self.tableView.tableFooterView = footerView;
    weakSelf(self);
    [footerView setEventHandler:^{
        strongSelf(weakSelf);
        if (!self.styleItem.selected) {
            [CRFUtils showMessage:@"请选择转投方式"];
            return ;
        }
        if (!self.timeItem.selected) {
            [CRFUtils showMessage:@"请选择期望出借期限"];
            return ;
        }
        if (!self.endItem.selected) {
            [CRFUtils showMessage:@"请选择期望结算方式"];
            return;
        }
        CRFAppointmentForwardListViewController *controller = [CRFAppointmentForwardListViewController new];
        controller.investAmount = strongSelf.styleItem.item == 1 ? strongSelf.interestAmount : strongSelf.principalAmount;
        controller.productInfo = strongSelf.productDetail;
        controller.appointmentStyle = strongSelf.styleItem.item;
        controller.appointmentTimeItem = strongSelf.timeItem.item;
        controller.appointmentEndItem = strongSelf.endItem.item;
        controller.forwardType = self.forwardType;
        controller.planNo = self.productDetail.planNo;
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)help {
    [self.helpView show:self.view];
}

@end
