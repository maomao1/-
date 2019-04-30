//
//  CRFSelContractViewController.m
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSelContractViewController.h"
#import "CRFContractTableViewCell.h"
#import "CRFContractModel.h"

@interface CRFSelContractViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation CRFSelContractViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    [self customeUI];
}
- (IBAction)clickButton:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            [self judgeSelAllBtnStatus:sender];
            break;
            
        default:
            break;
    }
}
- (void)judgeSelAllBtnStatus:(UIButton *)send
{
    send.selected = !send.selected;
    if (send.selected) {
        [send setImage:[UIImage imageNamed:@"operate_potcol_selected"] forState:UIControlStateNormal];
    }
    else
    {
        [send setImage:[UIImage imageNamed:@"operate_potcol_unselected"] forState:UIControlStateNormal];
    }
    [self replaceData:send.selected];
    [self.tabView reloadData];
}
- (void)replaceData:(BOOL)status
{
    for (CRFContractModel *model in self.dataArr) {
        model.status = status;
    }
}
- (void)customeUI
{
    self.dataArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        CRFContractModel *model = [[CRFContractModel alloc] init];
        model.title = @"现金贷共盈计划12MA";
        model.day = @"100天";
        model.percent = @"13.58%";
        model.time = @"2017-08-18起借";
        model.loanMoney = @"170000";
        model.switchMoney = @"171520";
        model.num = @"出借编号：XJDGY1M201704150045";
        model.imageName1 = @"operate_potcol_unselected";
        model.imageName2 = @"operate_potcol_selected";
        model.status = NO;
        
        [self.dataArr addObject:model];
    }
    //此处应对手机的屏幕尺寸做判断进行self.tabView的高度的调整（未做判断）
    switch (self.dataArr.count) {
        case 0:
        case 1:
            self.tableHeight.constant = 135;
            break;
        case 2:
            self.tableHeight.constant = 135 * 2 ;
            break;
        case 3:
            self.tableHeight.constant = 135 * 3 ;
            break;
        case 4:
        default:
            self.tableHeight.constant = 135 * 4;
            break;
    }
    [self.tabView registerNib:[UINib nibWithNibName:@"CRFContractTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRFContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CRFContractModel *model = self.dataArr[indexPath.row];
    cell.tab = self.tabView;
    [cell fillCellWithMoel:model];
    return cell;
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
