//
//  CRFMessageVC.m
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNoticeViewController.h"
#import "CRFMessageCell.h"
#import "CRFMessageDetailVC.h"
#import "CRFMineViewController.h"
@interface CRFNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong) UITableView *mainTab;
@property(nonatomic , strong) NSMutableArray *dataSource;
@property(nonatomic , assign) NSInteger      unReadCount;
@end

@implementation CRFNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatasource];
    [self setContentUI];
    [self crfGetData];
    // Do any additional setup after loading the view.
}
-(void)initDatasource{
    self.dataSource = [[NSMutableArray alloc]init];
}
-(void)setContentUI{
    _mainTab =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    _mainTab.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.mainTab];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.rowHeight = 71;
    [self.mainTab setSeparatorColor:kCellLineSeparatorColor];
    self.mainTab.backgroundColor = [UIColor clearColor];
    
    [self.mainTab registerClass:[CRFMessageCell class] forCellReuseIdentifier:CRFMessageCell_Identifier];
    self.mainTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
-(void)setMessageCount:(NSMutableArray*)array{
    for (CRFMessageModel *model in array) {
        if ([model.isRead isEqualToString:@"1"]) {
            _unReadCount ++;
        }
    }
    if (self.refreshCountBlock) {
        self.refreshCountBlock(_unReadCount);
    }
}
-(void)crfGetData{
    if (self.type) {
        [[CRFNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"%@/2",APIFormat(kHomeAnnouncement)] tag:1 delegate:self paragram:nil headers:nil];
    }else{
        [[CRFNetworkManager sharedInstance] POST:[NSString stringWithFormat:APIFormat(kGetMessagePath),[CRFAppManager defaultManager].userInfo.customerUid] tag:0 delegate:self paragram:@{} headers:@{kAccessTokenKey:[CRFAppManager defaultManager].userInfo.accessToken}];
    }
}
-(void)AFNHttpResponseSuccess:(id)response tag:(NSUInteger)tag{
    if (tag == 0) {
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            self.dataSource = (NSMutableArray*)[CRFResponseFactory getMessageList:response];
            [self setMessageCount:self.dataSource];
            [self.mainTab reloadData];
        } else {
            [CRFUtils showMessage:response[kMessageKey] onView:self.view];
        }
    }else{
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            self.dataSource = (NSMutableArray*)[CRFResponseFactory handleDataForResult:response WithClass:[CRFActivity class]];
            [self.mainTab reloadData];
        } else {
            [CRFUtils showMessage:response[kMessageKey] onView:self.view];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFMessageCell_Identifier];
    id model = self.dataSource[indexPath.row];
    [cell crfSetContent:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataSource[indexPath.row];
    CRFMessageModel *item;
    CRFActivity *actItem;
    CRFMessageDetailVC *detailVc = [CRFMessageDetailVC new];
    if ([model isKindOfClass:[CRFMessageModel class]]) {
        item = model;
        item.isRead = @"2";
        _unReadCount--;
        detailVc.detailModel =model;
        if (self.refreshCountBlock) {
            self.refreshCountBlock(_unReadCount);
        }
    }else{
        actItem = model;
        detailVc.activiModel = actItem;
    }
    detailVc.mesType   = self.type?SYSTEM_Detail:MESSAGE_Detail;
    [self.navigationController pushViewController:detailVc animated:YES];
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
    [self.mainTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
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
