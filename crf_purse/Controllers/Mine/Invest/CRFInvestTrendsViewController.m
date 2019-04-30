//
//  CRFInvestTrendsViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestTrendsViewController.h"
#import "CRFInvestEvent.h"
#import "CRFInvestDynamicTableViewCell.h"

@interface CRFInvestTrendsViewController () <UITableViewDelegate, UITableViewDataSource>{
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPoint;

@property (nonatomic, strong) NSMutableArray <CRFInvestEvent *>*events;


@end

@implementation CRFInvestTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"出借动态";
    self.events = [NSMutableArray new];
    [self.events addObject:[CRFInvestEvent new]];
    [self requestDatas];
    self.type = [self.product.investStatus integerValue] - 1;
    [self configTableView];
}

- (void)configTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollEnabled = NO;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    footer.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footer;
}

- (void)requestDatas {
    NSString *url = nil;
    if ([self.product.investSource isEqualToString:@"FTS"]) {
        url = [NSString stringWithFormat:APIFormat(kFTSProductDynamicPath),[CRFAppManager defaultManager].userInfo.customerUid];
    } else if ([CRFUtils complianceProduct:self.product.investSource]) {
        url = [NSString stringWithFormat:APIFormat(kNCPProductDynamicPath),kUuid];
    } else {
        url = [NSString stringWithFormat:APIFormat(kInvestOfflineDynamicPath),[CRFAppManager defaultManager].userInfo.customerUid];
    }
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:url paragrams:@{@"investNo":self.product.investNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseResponse:(id)response {
    DLog(@"response is %@",response);
    NSArray *array = [NSArray yy_modelArrayWithClass:[CRFInvestEvent class] json:response[kDataKey][@"dynamiclist"]];
    if (array.count <= 0) {
        [self.tableView reloadData];
        return;
    }
    [self.events addObjectsFromArray:array];
    self.currentPoint = self.events.count - 1;
    CRFInvestEvent *lastEvent = [array lastObject];
    for (int i = 0; i < lastEvent.preStatusInfo.count; i ++) {
        CRFInvestEvent *ev = [CRFInvestEvent new];
        ev.realStatusInfo = lastEvent.preStatusInfo[i];
        [self.events addObject:ev];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CRFInvestDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleIdentifier"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestDynamicTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.type = self.type;
        cell.product = self.product;
        return cell;
    } else {
        CRFInvestDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicIdentifier"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestDynamicTableViewCell" owner:nil options:nil] firstObject];
        }
        if (indexPath.row <= self.currentPoint) {
            cell.borderFont = YES;
        } else {
            cell.borderFont = NO;
        }
        cell.event = self.events[indexPath.row];
        if (self.events.count == 2) {
            cell.hideTopLine = YES;
            cell.hideBottomLine = YES;
        } else {
            if (indexPath.row == 1) {
                cell.hideTopLine = YES;
            }
            if (indexPath.row == self.events.count - 1) {
                cell.hideBottomLine = YES;
            }
        }
        if (indexPath.row == self.currentPoint) {
            cell.currentPoint = YES;
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

@end
