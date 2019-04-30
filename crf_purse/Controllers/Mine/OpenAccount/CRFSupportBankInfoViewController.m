//
//  CRFSupportBankInfoViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSupportBankInfoViewController.h"
#import "CRFMessageTableViewCell.h"
@interface CRFSupportBankInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) UITableView *mainTab;
@property(nonatomic , strong) NSMutableArray *dataSource;
@end

@implementation CRFSupportBankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:NSLocalizedString(@"title_support_bank_card_list", nil)];
    [self initDatasource];
    [self setContentUI];
    [self setContentTabHeader];
    [self crfGetData];
}
- (void)initDatasource{
    self.dataSource = [[NSMutableArray alloc]init];
}
- (void)setContentUI{
    self.mainTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.mainTab];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.rowHeight = 52;
    [self.mainTab setSeparatorColor:kCellLineSeparatorColor];
    self.mainTab.backgroundColor = [UIColor clearColor];
    [self.mainTab registerClass:[CRFMessageTableViewCell class] forCellReuseIdentifier:CRFBankCell_Identifier];
    self.mainTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)setContentTabHeader{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [header setBackgroundColor:[UIColor clearColor]];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textColor = UIColorFromRGBValue(0x999999);
    titleLabel.text = NSLocalizedString(@"label_support_bank_card_list", nil);
    NSMutableAttributedString *attribute =[[NSMutableAttributedString alloc]initWithString:titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f];
    [attribute setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:titleLabel.font} range:NSMakeRange(0, titleLabel.text.length)];
    [titleLabel setAttributedText:attribute];
    titleLabel.frame = CGRectMake(kSpace, 0, kScreenWidth-2*kSpace, 60);
    titleLabel.numberOfLines = 0;
    [header addSubview:titleLabel];
    self.mainTab.tableHeaderView = header;
}

- (void)crfGetData {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kSupportBanklistPath) paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponse:(id)response {
    [CRFLoadingView dismiss];
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        self.dataSource = (NSMutableArray*)[CRFResponseFactory getBankListForResult:response];
        [self.mainTab reloadData];
    } else {
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFBankCell_Identifier];
    CRFBankListModel *model = self.dataSource[indexPath.row];
    [cell crfSetBankCellContent:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    CGFloat itemWidth = (kScreenWidth )/4.4f;
    NSArray *titles = @[NSLocalizedString(@"label_support_bank", nil),NSLocalizedString(@"label_simple_order", nil),NSLocalizedString(@"label_day_order", nil),NSLocalizedString(@"label_month_order", nil)];
    for (int i = 0; i < 4; i ++) {
        UILabel *title = [[UILabel alloc]init];
        if (i < 1) {
            title.frame = CGRectMake(0, 0, itemWidth*1.4, CGRectGetHeight(sectionHeader.frame));
        } else {
            title.frame= CGRectMake(itemWidth*1.4+(i-1)*itemWidth, 0, itemWidth, CGRectGetHeight(sectionHeader.frame));
        }
        title.font = [UIFont systemFontOfSize:13.0*kWidthRatio];
        title.textColor = UIColorFromRGBValue(0x999999);
        title.text = titles[i];
        title.textAlignment = NSTextAlignmentCenter;
        [sectionHeader addSubview:title];
    }
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0? 43:0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
