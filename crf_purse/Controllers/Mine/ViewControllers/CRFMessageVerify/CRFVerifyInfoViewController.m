//
//  CRFVerifyInfoViewController.m
//  crf_purse
//
//  Created by maomao on 2018/6/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFVerifyInfoViewController.h"
#import "CRFInfoTableViewCell.h"
#import "CRFUserInfo.h"
#import "CRFLogoView.h"
static NSString *const tableHeaderId = @"infoTableViewHeaderIdentify";
@interface CRFVerifyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *infoTableView;
@property (nonatomic ,strong)NSArray<NSArray*> *dataSource;
@property (nonatomic ,strong) NSArray <NSArray*>*infoArr;
@end

@implementation CRFVerifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证存管账户信息";
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.infoTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.infoTableView.scrollIndicatorInsets = self.infoTableView.contentInset;
    }
#endif
    [self getDatas];
    [self setTabfooterView];
    
}
-(void)getDatas{
    self.dataSource = @[@[@"真实姓名",@"身份证号"],
                        @[@"银行卡号",@"银行名称",@"开户行所在地",@"银行预留手机号"]];
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    self.infoArr = @[@[userInfo.userName,userInfo.idNo],
                     @[userInfo.openBankCardNo,[userInfo.bankCode getBankCode].bankName,@"北京",[userInfo formatMobilePhone]]];
}
-(void)verifyAccountInfo{
    DLog(@"点击了验证存管账户");
}
-(void)setTabfooterView{
    UIView *tabFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 154)];
    tabFooter.backgroundColor = [UIColor clearColor];
    UIButton *verBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verBtn.crf_acceptEventInterval = 0.5;
    [tabFooter addSubview:verBtn];
    [verBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.height.mas_equalTo(kRegisterButtonHeight);
    }];
    verBtn.layer.masksToBounds = YES;
    verBtn.layer.cornerRadius = 5.0f;
    verBtn.backgroundColor =UIColorFromRGBValue(0xfb4d3a);
    verBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [verBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verBtn setTitle:@"验证" forState:UIControlStateNormal];
    [verBtn addTarget:self action:@selector(verifyAccountInfo) forControlEvents:UIControlEventTouchUpInside];
    CRFLogoView *logoView = [CRFLogoView new];
    [tabFooter addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tabFooter);
        make.top.equalTo(verBtn.mas_bottom).with.offset(70);
        make.height.mas_equalTo(18);
    }];
    
    self.infoTableView.tableFooterView = tabFooter;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFInfoTabCellId];
    cell.mainLabelStr = self.dataSource[indexPath.section][indexPath.row];
    cell.nameLabelStr = self.infoArr[indexPath.section][indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section ==1) {
        return 44;
    }
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    NSArray *titleArr = @[@"实名认证：",@"绑定银行卡"];
    if (section == 0 ||section == 1) {
        UILabel *titleLabel =[[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = UIColorFromRGBValue(0x999999);
        titleLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.right.mas_equalTo(-kSpace);
            make.top.bottom.mas_equalTo(0);
        }];
        titleLabel.text = [titleArr objectAtIndex:section];
    }
    return headerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.infoTableView) {
        CGFloat sectionHeaderHeight = 44;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
    }
}

-(UITableView *)infoTableView{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_infoTableView registerClass:[CRFInfoTableViewCell class] forCellReuseIdentifier:CRFInfoTabCellId];
//        [_infoTableView registerClass:[UIView class] forHeaderFooterViewReuseIdentifier:tableHeaderId];
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.rowHeight = 56;
        _infoTableView.backgroundColor = [UIColor clearColor];
    }
    return _infoTableView;
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
