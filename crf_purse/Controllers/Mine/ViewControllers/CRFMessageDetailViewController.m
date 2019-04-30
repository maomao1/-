//
//  CRFMessageDetailVC.m
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMessageDetailViewController.h"
#import "CRFDetailTableViewCell.h"
@interface CRFMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *mainTab;

@end

@implementation CRFMessageDetailViewController
- (UITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTab.backgroundColor = [UIColor clearColor];
        _mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTab.delegate = self;
        _mainTab.dataSource =self;
    }
    return _mainTab;
}
- (void)upNavTitle{
    switch (self.mesType) {
        case MESSAGE_Detail:
            [self setSyatemTitle:@"消息"];
            break;
        case SYSTEM_Detail:
            [self setSyatemTitle:@"系统公告"];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self upNavTitle];
    [self crfGetData];
    [self.view addSubview:self.mainTab];
    [self.mainTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    self.mainTab.estimatedRowHeight = 90;
    self.mainTab.estimatedSectionHeaderHeight = 0;
    self.mainTab.rowHeight = UITableViewAutomaticDimension;
    [self autoLayoutSizeContentView:self.mainTab];
    
    if (self.batchNo && self.batchNo.length) {
        [self getMessageDetail];
    }
}

- (void)getMessageDetail{
    
    if (self.mesType == MESSAGE_Detail){//消息详情
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kMessageDetailPath),[CRFAppManager defaultManager].userInfo.customerUid,self.batchNo] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            self.detailModel = [CRFMessageModel yy_modelWithDictionary:response[@"data"]];
            [self.mainTab reloadData];
            
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
        }];
    } else if (self.mesType == SYSTEM_Detail){//系统公告
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kFindAnnouncementDetailPath),self.batchNo] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            self.activiModel = [CRFActivity yy_modelWithDictionary:response[@"data"]];
            [self.mainTab reloadData];
            
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
        }];
    }
}

/**
 标记消息已读状态
 */
- (void)crfGetData {
    if (self.mesType == MESSAGE_Detail && [self.detailModel.isRead integerValue] == 1) {
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kSetMessageStatusPath),self.detailModel.mes_id] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
            DLog(@"read message success, response is %@",response);
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            DLog(@"read message failed !")
            [CRFUtils showMessage:response[kMessageKey]];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.detailModel||self.activiModel) ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFDetailTableViewCell *cell = [CRFDetailTableViewCell crfReuseIdentifier:tableView];
    [cell crfSetContent:self.mesType?self.activiModel:self.detailModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace/2;
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
