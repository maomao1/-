//
//  CRFInvestUserViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestUserViewController.h"
#import "UITableViewCell+Access.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFAlertUtils.h"

@interface CRFInvestUserViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *titles;
    NSArray *datas;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CRFInvestUserViewController

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [UIView new];
     self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"借款人明细";
    [self initializeView];
    if (self.source == 1) {
        titles = @[@"借款服务协议编号",@"借款人姓名",@"借款人身份证",@"匹配债权金额",@"借款协议"];
        datas = @[self.creditor.rightNo,self.creditor.loanerName,self.creditor.loanerIdNo,self.creditor.rightAmount,@""];
    } else {
        titles = @[@"借款服务协议编号",@"借款人姓名",@"借款人身份证",@"借款人职业",@"借款用途",@"匹配债权金额",@"借款期数（月）",@"剩余还款期数（月）"];
        datas = @[self.creditor.borrowerContractNo,self.creditor.borrowerName,self.creditor.borrowerIdNumber,self.creditor.borrowerProfession,self.creditor.detailUse,[self.creditor formatDueinCapital],[self.creditor formatPayTerm],[self.creditor formatDueinTerm],@""];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.textColor = UIColorFromRGBValue(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0 || indexPath.row == 4) {
        cell.detailTextLabel.textColor = UIColorFromRGBValue(0x999999);
    } else {
        cell.detailTextLabel.textColor = UIColorFromRGBValue(0x333333);
    }
    cell.textLabel.text = titles[indexPath.row];
    cell.detailTextLabel.text = datas[indexPath.row];
    if (indexPath.row == datas.count - 1) {
        cell.hasAccessoryView = YES;
    } else {
        cell.hasAccessoryView = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.source != 1) {
        return;
    }
    if (indexPath.row == datas.count - 1) {
        if (self.creditor.protocols.count <= 0) {
            [CRFUtils showMessage:@"暂无协议"];
            return;
        }
        if (self.creditor.protocols.count > 1) {
            [self showAlert];
            return;
        }
        CRFStaticWebViewViewController *webView = [CRFStaticWebViewViewController new];
        webView.urlString = [self.creditor.protocols firstObject].htmlUrl;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)showAlert {
    NSMutableArray <NSString *>*protocolNames = [NSMutableArray new];
    for (CRFAgreementDto *dto in self.creditor.protocols) {
        [protocolNames addObject:dto.protocolName];
    }
    weakSelf(self);
    [CRFAlertUtils actionSheetWithTitle:nil message:nil container:self cancelTitle:@"关闭" items:protocolNames completeHandler:^(NSInteger index) {
        strongSelf(weakSelf);
        CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
        webViewController.urlString = strongSelf.creditor.protocols[index].htmlUrl;
        [strongSelf.navigationController pushViewController:webViewController animated:YES];
    } cancelHandler:nil];
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
