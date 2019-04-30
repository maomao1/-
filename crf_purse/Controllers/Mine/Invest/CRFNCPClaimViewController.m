//
//  CRFCreditorViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNCPClaimViewController.h"
#import "CRFStringUtils.h"
#import "CRFInvestUserViewController.h"
#import "CRFNCPClaimSectionView.h"
#import "CRFNCPClaimTableViewCell.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFClaimer.h"
#import "CRFUpdateClaim.h"
#import "MJRefresh.h"
#import "CRFAlertUtils.h"
#import "CRFBorrowerSupplementaryInfoView.h"

@interface CRFNCPClaimViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CRFUpdateClaim *investInfo;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL refreshHeader;
@property (nonatomic, assign) BOOL refreshFooter;
@property (nonatomic, strong) NSMutableArray <CRFClaimer *>*datas;
@property (nonatomic, strong) CRFBorrowerSupplementaryInfoView *helpView;

@end

@implementation CRFNCPClaimViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNumber = 1;
    [self initializeView];
    [self configHeaderView];
    [self addLayer];
    [self conNavTitle];
    [self configDatas];
    [self addRefreshHeader];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [CRFUtils isIPhoneXAll] ? - 34 : 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
#endif
}

- (NSMutableArray<CRFClaimer *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = UIColorFromRGBValue(0xf6f6f6);
    self.tableView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
}

- (CRFUpdateClaim *)investInfo {
    if (!_investInfo) {
        _investInfo = [CRFUpdateClaim new];
    }
    return _investInfo;
}

- (CRFBorrowerSupplementaryInfoView *)helpView {
    if (!_helpView) {
        _helpView = [[[NSBundle mainBundle] loadNibNamed:@"CRFBorrowerSupplementaryInfoView" owner:nil options:nil] lastObject];
//        _helpView.alpha = 0;
        _helpView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    }
    return _helpView;
}

- (void)conNavTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 40)];
    _titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = _titleLabel;
    NSString *string = [NSString stringWithFormat:@"债权明细\n（出借编号：%@）",self.product.investNo];
    [self.titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:3 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"债权明细"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string rangeOfString:[NSString stringWithFormat:@"（出借编号：%@）",self.product.investNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)configDatas {
     [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestNCPDebtPath),kUuid] paragrams:@{@"investNo":self.product.investNo,kPageNumberKey:@(self.pageNumber),kPageSizeKey:@(20)} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [CRFLoadingView dismiss];
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            if (strongSelf.refreshHeader) {
                [strongSelf.datas removeAllObjects];
                strongSelf.refreshHeader = NO;
            }
            strongSelf.refreshFooter = NO;
            strongSelf.investInfo = [CRFUpdateClaim yy_modelWithJSON:response[@"data"]];
            NSArray *pageDatas = [NSArray yy_modelArrayWithClass:[CRFClaimer class] json:response[@"data"][@"rightsList"]];
          [strongSelf.datas addObjectsFromArray:pageDatas];
            if (pageDatas.count >= 20) {
                [strongSelf addRefreshFooter];
            }
            [strongSelf setContent];
            [strongSelf.tableView reloadData];
        } else {
            if (strongSelf.refreshFooter) {
                strongSelf.pageNumber --;
            }
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (strongSelf.refreshFooter) {
            strongSelf.pageNumber --;
        }
         [CRFLoadingView dismiss];
         [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)FindDisclosureeWithClaimer:(CRFClaimer *)claimer{
    weakSelf(self);
//    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kFindDisclosureePath) paragrams:@{@"crfUid":[NSString stringWithFormat:@"%@",claimer.crfUid],@"loanContractNo":[NSString stringWithFormat:@"%@",claimer.loanContractNo]} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
//        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponse:(id)response {
    DLog(@"%@ response is %@",NSStringFromClass([self class]), response);
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        CRFBorrowerInfoModel *borrowerInfoModel = [CRFBorrowerInfoModel yy_modelWithJSON:response[kDataKey]];
        [self showDetailWithBorrowerInfoModel:borrowerInfoModel];
    } else {
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (void)addRefreshHeader {
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.refreshHeader = YES;
        strongSelf.pageNumber = 1;
        [strongSelf configDatas];
    }];
}

- (void)addRefreshFooter {
    weakSelf(self);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.refreshFooter = YES;
        strongSelf.pageNumber ++;
        [strongSelf configDatas];
    }];
}

- (void)configHeaderView {
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    bgview.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 52, kScreenWidth, 140)];
    view.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:view];
    self.tableView.tableHeaderView = bgview;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [bgview addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgview);
        make.height.mas_equalTo(70);
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.left.equalTo(topView.mas_left).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
    }];
    NSString *string = @"借款协议请前往信而富官网查看下载\n经信而富公司推荐，您通过借贷和（或）债权受让的方式出借资金，获取了如下债权：";
    [titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, string.length) attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    UILabel *listLabel = [UILabel new];
    listLabel.text = @"债权列表";
    listLabel.textAlignment = NSTextAlignmentCenter;
    listLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    [view addSubview:listLabel];
    [listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).with.offset(18);
        make.height.mas_equalTo(24);
    }];
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    [view addSubview:_timeLabel];
    _timeLabel.textColor = UIColorFromRGBValue(0x999999);
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(listLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(12);
    }];
    UILabel *line = [UILabel new];
    [view addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.1];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view).offset(85);
        make.size.mas_equalTo(CGSizeMake(1, 36));
    }];
    _leftLabel = [UILabel new];
    _leftLabel.numberOfLines = 0;
    [view addSubview:_leftLabel];
    _rightLabel = [UILabel new];
    [view addSubview:_rightLabel];
    _rightLabel.numberOfLines = 0;
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.bottom.equalTo(view.mas_bottom).with.offset(-18);
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(25);
        make.width.mas_equalTo(kScreenWidth / 2.0);
    }];
    CGFloat width = kScreenWidth / 2.0;
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.bottom.equalTo(view.mas_bottom).with.offset(-18);
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(25);
        make.width.mas_equalTo(width);
    }];
    [self setContent];
}

- (void)setContent {
    _timeLabel.text = [NSString stringWithFormat:@"（更新时间：%@）",self.investInfo.nowDay];
    NSString *string1 = [NSString stringWithFormat:@"%@\n初始出借金额(元)",[self.investInfo.investInfo.investAmount formatBeginMoney]];
    [_leftLabel setAttributedText:[CRFStringUtils setAttributedString:string1 lineSpace:5 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string1 rangeOfString:[self.investInfo.investInfo.investAmount formatBeginMoney]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string1 rangeOfString:@"初始出借金额(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [_leftLabel setTextAlignment:NSTextAlignmentCenter];
    NSString *string2 = [NSString stringWithFormat:@"%@\n当前出借中金额(元)",[self.investInfo.investInfo.loanAmount formatBeginMoney]];
    [_rightLabel setAttributedText:[CRFStringUtils setAttributedString:string2 lineSpace:5 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string2 rangeOfString:[self.investInfo.investInfo.loanAmount formatBeginMoney]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string2 rangeOfString:@"当前出借中金额(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [_rightLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view layoutIfNeeded];
}

- (void)addLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGBValue(0xEEEEEE).CGColor, (__bridge id)UIColorFromRGBValue(0xFF6A5A).CGColor];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(86 * kWidthRatio, 82, 55* kWidthRatio, 1);
    [self.tableView.tableHeaderView.layer addSublayer:gradientLayer];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.colors = @[(__bridge id)UIColorFromRGBValue(0xFF6A5A).CGColor, (__bridge id)UIColorFromRGBValue(0xEEEEEE).CGColor];
    gradientLayer1.locations = @[@0.5, @1.0];
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(1.0, 0);
    gradientLayer1.frame = CGRectMake(235 * kWidthRatio, 82, 55 * kWidthRatio, 1);
    [self.tableView.tableHeaderView.layer addSublayer:gradientLayer1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFNCPClaimTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CRFNCPClaimTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.indexPath = indexPath;
    cell.claimer = _datas[indexPath.row];
    weakSelf(self);
    [cell setLookupProtocolContent:^(NSIndexPath *indexPath){
        strongSelf(weakSelf);
        CRFClaimer *claimer = _datas[indexPath.row];
        if (claimer.protocols.count <= 0) {
        [CRFUtils showMessage:@"暂无协议"];
        return ;
        }
        if (claimer.protocols.count > 1) {
            [strongSelf showAlert:claimer];
            return;
        }
        CRFStaticWebViewViewController *controller = [CRFStaticWebViewViewController new];
        controller.urlString = [claimer.protocols firstObject].htmlUrl;
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    [cell setShowClaimerDetail:^(NSIndexPath *indexPath){
        strongSelf(weakSelf);
        CRFClaimer *claimer = _datas[indexPath.row];
        [strongSelf FindDisclosureeWithClaimer:claimer];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CRFNCPClaimSectionView *view = [[CRFNCPClaimSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    [view addSubview:line];
    line.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    return view;
}

- (void)showDetailWithBorrowerInfoModel:(CRFBorrowerInfoModel*)borrowerInfoModel{
    [self.helpView setContentWithBorrowerInfoModel:borrowerInfoModel];
    [self.helpView showAlert];
}

- (void)showAlert:(CRFClaimer *)claimer {
    NSMutableArray <NSString *>*protocolNames = [NSMutableArray new];
    for (CRFAgreementDto *dto in claimer.protocols) {
        [protocolNames addObject:dto.protocolName];
    }
    weakSelf(self);
    [CRFAlertUtils actionSheetWithTitle:nil message:nil container:self cancelTitle:@"关闭" items:protocolNames completeHandler:^(NSInteger index) {
        if ([claimer.protocols[index].htmlUrl isEmpty]) {
            return ;
        }
        strongSelf(weakSelf);
        CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
        webViewController.urlString = claimer.protocols[index].htmlUrl;
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

