//
//  CRFSelTargetViewController.m
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSelTargetViewController.h"
#import "CRFTargetTableViewCell.h"
#import "CRFTargetModel.h"
#import "UIView+Default.h"

@interface CRFSelTargetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) NSArray *dataArr;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation CRFSelTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"title_transfer_target", nil);
    [self requestDatas];
    self.dataArr = [[NSMutableArray alloc] init];
    [self customeUI];
}

- (NSString *)investment {
    if (!_investment) {
        _investment = @"";
    }
    return _investment;
}

- (void)requestDatas {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetTransferPath),kUuid] paragrams:@{@"investAmount":[NSString stringWithFormat:@"%.0f",[[self.investment getOriginString] doubleValue] * 100]} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        strongSelf.dataArr = [NSArray yy_modelArrayWithClass:[CRFProductModel class] json:response[@"data"][@"lsProduct"]];
        if (strongSelf.dataArr.count == 0) {
            [strongSelf showContentView];
        } else {
            [strongSelf.tableView reloadData];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        strongSelf(weakSelf);
         [strongSelf showContentView];
    }];
}

- (void)showContentView {
    self.tableView.hidden = YES;
    [self.view showDefaultText:@"对不起，暂无符合条件的投资计划。"];
}

- (void)customeUI {
    self.tableHeight.constant = kScreenHeight - kNavHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"CRFTargetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self autoLayoutSizeContentView:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFTargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath != self.selectedIndexPath) {
        [cell resetUI];
    }
    [cell fillCellWithModek:self.dataArr[indexPath.section]];
    weakSelf(self);
    [cell setDidSelectedHandler:^(CRFTargetTableViewCell *selectedCell){
        strongSelf(weakSelf);
        strongSelf.selectedIndexPath = [strongSelf.tableView indexPathForCell:selectedCell];
        [strongSelf.tableView reloadData];
        if (strongSelf.didSelectedProduct) {
            strongSelf.didSelectedProduct(strongSelf.dataArr[indexPath.section]);
        }
        [CRFUtils delayAfert:.5 handle:^{
             [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFTargetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedIndexPath = indexPath;
    cell.selectBtn.selected = !cell.selectBtn.selected;
    [self.tableView reloadData];
    if (self.didSelectedProduct) {
        self.didSelectedProduct(self.dataArr[indexPath.section]);
    }
    [CRFUtils delayAfert:.5 handle:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
