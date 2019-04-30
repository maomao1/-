//
//  CRFDepositAccountViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDepositAccountViewController.h"
#import "CRFDepositAccountHeaderView.h"
#import "CRFDepositAccountTableViewCell.h"
#import "UITableViewCell+Access.h"

@interface CRFDepositAccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CRFDepositAccountHeaderView *depositAccountHeaderView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <NSArray <NSString *>*>*titles;

@property (nonatomic, strong) NSArray <NSArray <NSString *>*>*datas;

@end

@implementation CRFDepositAccountViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomTitle:@"存管账户"];
    [super customNavigationBackForBlack];
    self.titles = @[@[@"预留手机号",@"姓名",@"身份证",@"银行卡"],@[@"找回／修改交易密码"]];
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    self.datas = @[@[[userInfo formatMobilePhone],[userInfo formatUserName],userInfo.openAccountIdno,userInfo.openBankCardNo],@[@""]];
    [self initializeView];
}

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 57;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavHeight);
    }];
    CRFAccountInfo *accountInfo = [CRFAppManager defaultManager].accountInfo;
    _depositAccountHeaderView = [[CRFDepositAccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85) availableBalance:accountInfo.availableBalance collectedBalance:accountInfo.freezeBalance];
    self.tableView.tableHeaderView = self.depositAccountHeaderView;
    [self autoLayoutSizeContentView:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"depositAccountCell";
    CRFDepositAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CRFDepositAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 2 || indexPath.row == 1) {
        cell.customAccessoryView = YES;
    } else {
        cell.hasAccessoryView = YES;
    }
    if (indexPath.row == self.titles[indexPath.section].count - 1) {
        cell.hiddenLine = YES;
    } else {
        cell.hiddenLine = NO;
    }
    cell.titleLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.detailLabel.text = self.datas[indexPath.section][indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
