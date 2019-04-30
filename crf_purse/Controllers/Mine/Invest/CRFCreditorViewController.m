//
//  CRFCreditorViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCreditorViewController.h"
#import "CRFStringUtils.h"
#import "CRFCreditorTableViewCell.h"
#import "CRFInvestUserViewController.h"
#import "CRFUpdateInvestModel.h"


@interface CRFCreditorViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray <CRFCreditor *>*datas;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CRFUpdateInvestModel *investInfo;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, assign) BOOL update;

@end

@implementation CRFCreditorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
     [self configHeaderView];
    if (![self.product.investSource isEqualToString:@"FTS"]) {
        self.update = YES;
        [self addLayer];
    }
    [self conNavTitle];
    [self configDatas];
   
}

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (CRFUpdateInvestModel *)investInfo {
    if (!_investInfo) {
        _investInfo = [CRFUpdateInvestModel new];
    }
    return _investInfo;
}

- (void)conNavTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 40)];
    _titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = _titleLabel;
    NSString *string = [NSString stringWithFormat:@"债权明细\n（出借编号：%@）",self.product.investNo];
    [self.titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:3 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"债权明细"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string rangeOfString:[NSString stringWithFormat:@"（出借编号：%@）",self.product.investNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)configDatas {
    NSString *urlString = nil;
    NSDictionary *paragram = nil;
    if ([self.product.investSource isEqualToString:@"FTS"]) {
        urlString = [NSString stringWithFormat:APIFormat(kInvestftsdebtPath),kUuid];
        paragram = @{@"investId":self.product.investId};
    } else {
        urlString = [NSString stringWithFormat:APIFormat(kInvestOffLinedebtPath),kUuid];
        paragram = @{@"investId":self.product.investId,@"source":self.product.source};
    }
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:urlString paragrams:paragram success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf parseResponseSuccess:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponseSuccess:(id)response {
        self.investInfo = [CRFUpdateInvestModel yy_modelWithJSON:response[@"data"]];
         datas = [NSArray yy_modelArrayWithClass:[CRFCreditor class] json:response[@"data"][@"debtList"]];
        [self setContent];
        [self.tableView reloadData];
}

- (void)configHeaderView {
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 202)];
    bgview.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 194)];
    view.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:view];
    self.tableView.tableHeaderView = bgview;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.mas_equalTo(52);
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.left.equalTo(topView).with.offset(kSpace);
        make.right.equalTo(topView).with.offset(-kSpace);
    }];
    NSString *string = @"借款协议请前往信而富官网查看下载\n经信而富公司推荐，您通过借贷和（或）债权受让的方式出借资金，获取了如下债权：";
    [titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, string.length) attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    if ([self.product.investSource isEqualToString:@"FTS"]) {
        bgview.frame = CGRectMake(0, 0, kScreenWidth, 50);
        view.frame = CGRectMake(0, 0, kScreenWidth, 50);
    } else {
    UILabel *listLabel = [UILabel new];
    listLabel.text = @"债权列表";
    listLabel.textAlignment = NSTextAlignmentCenter;
    listLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    [view addSubview:listLabel];
    [listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).with.offset(70);
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
        make.top.equalTo(view).offset(137);
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
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.bottom.equalTo(view.mas_bottom).with.offset(-18);
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(25);
        make.width.mas_equalTo(kScreenWidth / 2.0);
    }];
    [self setContent];
    }
}

- (void)setContent {
     _timeLabel.text = [NSString stringWithFormat:@"（更新时间：%@）",self.investInfo.debtMakeDate];
    NSString *string1 = [NSString stringWithFormat:@"%@元\n期末债权资金合计",self.investInfo.debtAmount];
    [_leftLabel setAttributedText:[CRFStringUtils setAttributedString:string1 lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string1 rangeOfString:[NSString stringWithFormat:@"%@元",self.investInfo.debtAmount]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string1 rangeOfString:@"期末债权资金合计"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [_leftLabel setTextAlignment:NSTextAlignmentCenter];
    NSString *string2 = [NSString stringWithFormat:@"%@元\n期末闲置资金合计",self.investInfo.idleAmount];
    [_rightLabel setAttributedText:[CRFStringUtils setAttributedString:string2 lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string2 rangeOfString:[NSString stringWithFormat:@"%@元",self.investInfo.idleAmount]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string2 rangeOfString:@"期末闲置资金合计"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [_rightLabel setTextAlignment:NSTextAlignmentCenter];
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
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFCreditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CRFCreditorTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.source = [self.product.investSource isEqualToString:@"FTS"]?1:2;
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.creditor = datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, 0.5)];
    [view addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:.0 alpha:.1];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 * kWidthRatio, 0, 50, 50)];
    firstLabel.text = @"借款人";
    firstLabel.font = [UIFont systemFontOfSize:13.0];
    firstLabel.textColor = UIColorFromRGBValue(0x999999);
    [view addSubview:firstLabel];
    CGFloat margen = 20;
    if (kScreenWidth == 320) {
        margen = 20;
    }
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLabel.frame) + margen * kWidthRatio, 0, 105, 50)];
    secondLabel.text = @"匹配债权金额(元)";
    secondLabel.font = [UIFont systemFontOfSize:13.0];
    secondLabel.textColor = UIColorFromRGBValue(0x999999);
    [view addSubview:secondLabel];
    if ([self.product.investSource isEqualToString:@"FTS"]) {
        secondLabel.frame = CGRectMake(kScreenWidth - 50 - 130, 0, 130, 50);
        secondLabel.textAlignment = NSTextAlignmentRight;
    } else {
        CGFloat labelSpace = .0f;
        if (kScreenWidth == 320) {
            labelSpace = 25;
        } else {
            labelSpace = 37;
        }
    UILabel *thiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 93 * kWidthRatio - labelSpace, 0, 29, 50)];
    thiredLabel.text = @"共借";
        thiredLabel.textAlignment = NSTextAlignmentRight;
    thiredLabel.font = [UIFont systemFontOfSize:13.0];
    thiredLabel.textColor = UIColorFromRGBValue(0x999999);
    [view addSubview:thiredLabel];
        CGFloat labelSpace1 = .0f;
        if (kScreenWidth == 320) {
            labelSpace1 = 25;
        } else {
            labelSpace1 = 30;
        }
    UILabel *lalstLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - labelSpace1 - 42 * kWidthRatio, 0, 29, 50)];
    lalstLabel.text = @"待还";
        lalstLabel.textAlignment = NSTextAlignmentRight;
    lalstLabel.font = [UIFont systemFontOfSize:13.0];
    lalstLabel.textColor = UIColorFromRGBValue(0x999999);
    [view addSubview:lalstLabel];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CRFInvestUserViewController *controller = [CRFInvestUserViewController new];
    controller.source = [self.product.investSource isEqualToString:@"FTS"]?1:2;
    controller.creditor = datas[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
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
