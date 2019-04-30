//
//  CRFInvestOutRecordViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestOutRecordViewController.h"
#import "CRFStringUtils.h"
#import "CRFRedeemRecord.h"
#import "CRFRedeemAccount.h"
#import "CRFInvestHelpView.h"
#import "CRFInvestRecordTableViewCell.h"
#import "UIView+Default.h"

@interface CRFInvestOutRecordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitPromptLabel;
@property (nonatomic, strong) CRFRedeemAccount *redeemAccount;
@property (nonatomic, strong) CRFInvestHelpView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (nonatomic, strong) NSArray <CRFRedeemRecord *> *records;


@end

@implementation CRFInvestOutRecordViewController

//- (BOOL)fd_interactivePopDisabled {
//    return YES;
//}

- (CRFInvestHelpView *)helpView {
    if (!_helpView) {
        _helpView = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestHelpView" owner:nil options:nil] lastObject];
        _helpView.alpha = 0;
        _helpView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    }
    return _helpView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self conNavTitle];
    self.tableView.bounces = NO;
    self.helpLabel.userInteractionEnabled = YES;
    [self.helpLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(help)]];
    [self requestDatas];
    self.profitPromptLabel.userInteractionEnabled = YES;
    [self.profitPromptLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(help)]];
    self.tableView.estimatedRowHeight = 75;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)help {
    [self.helpView show];
}

- (void)requestDatas {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kProductLogoutPath),kUuid] paragrams:@{@"investId":self.product.investId,@"source":self.product.source} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf showContentView];
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponse:(id)response {
    [CRFLoadingView dismiss];
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        self.redeemAccount = [CRFRedeemAccount yy_modelWithJSON:response[kDataKey][@"detail"]];
        self.records = [NSArray yy_modelArrayWithClass:[CRFRedeemRecord class] json:response[kDataKey][@"detail"][@"resultList"]];
        if (self.records.count <= 0) {
            [self showContentView];
            return;
        }
        [self setContent];
        [self.tableView reloadData];
    }
}

- (void)showContentView {
    self.topView.hidden = YES;
    self.tableView.hidden = YES;
    [self.view showDefaultText:@"暂无退出记录。"];
}

- (void)conNavTitle {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, 40)];
    titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = titleLabel;
    NSString *string = [NSString stringWithFormat:@"退出记录\n（出借编号：%@）",self.product.investNo];
    [titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:3 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"退出记录"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[string rangeOfString:[NSString stringWithFormat:@"（出借编号：%@）",self.product.investNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)setContent {
    NSString *string1 = [NSString stringWithFormat:@"%@元",self.redeemAccount.totalCapital];
    NSString *string2 = [NSString stringWithFormat:@"%@元",self.redeemAccount.totalProfit];
    [self.leftLabel setAttributedText:[CRFStringUtils setAttributedString:string1 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string1 rangeOfString:self.redeemAccount.totalCapital] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[string1 rangeOfString:@"元"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.rightLabel setAttributedText:[CRFStringUtils setAttributedString:string2 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string2 rangeOfString:self.redeemAccount.totalProfit] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[string2 rangeOfString:@"元"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
}

#pragma UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFInvestRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestRecordTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CRFRedeemRecord *record = self.records[indexPath.section];
    cell.redeemRecord = record;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.records.count;
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
