//
//  CRFInvestViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJHomeViewController.h"
#import "MJRefresh.h"
#import "CRFViewUtils.h"
#import "CRFSegmentHead.h"
#import "UUMarqueeView.h"
#import "CRFFilterView.h"
//model
#import "CRFAppCache.h"
#import "CRFInvestRecordModel.h"
#import "WMMJProductTableViewCell.h"
#import "SDCycleScrollView.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFProductDetailViewController.h"
#import "WMNCPTableViewCell.h"
//
@interface WMMJHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UUMarqueeViewDelegate, SDCycleScrollViewDelegate> {
    UILabel  *_noProductLabel;
    
}
@property (nonatomic ,strong) UITableView     *mainTableView;
@property (nonatomic ,strong) UUMarqueeView   *activityView;
@property (nonatomic ,strong) NSMutableArray  *activityTitles;
@property (nonatomic ,strong)UILabel         *noProductLabel;
//
@property (nonatomic ,strong) NSArray *allProductList;
@property (nonatomic ,strong) NSString *payBtnTitle;
@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end
@implementation WMMJHomeViewController

- (SDCycleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"majiabao_banner_default.jpg"]];
        _scrollView.localizationImageNamesGroup = @[[UIImage imageNamed:@"mj_may_banner.jpg"],[UIImage imageNamed:@"majiabao_banner_2.jpg"],[UIImage imageNamed:@"majiabao_banner_3.jpg"]];
    }
    return _scrollView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *url = nil;
    if (index == 0) {
        url = @"https://financeapp-static.crfchina.com/webp2p_static/invests/views/activity/april.html";
    } else if (index == 1) {
        url = @"https://financeapp-static.crfchina.com/webp2p_static/invests/views/banner/ten/activity-nov.html";
    }
    url = [NSString stringWithFormat:@"%@?%@",url,kH5NeedHeaderInfo];
    CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
    webViewController.urlString = url;
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"信而富钱包";
    [self initDataSource];
    [self createUI];
}

-(void)initDataSource{
    [self crfGetData];
    [self crfGetRecordData];
}
- (void)createUI {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.activityView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.noProductLabel];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(180 * kWidthRatio);
    }];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.mas_offset(kSpace);
        make.right.equalTo(self.view).with.mas_offset(-kSpace);
        make.top.equalTo(self.scrollView.mas_bottom).with.mas_offset(0);
        make.height.mas_equalTo(33);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activityView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [_noProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mainTableView);
    }];
}
-(void)refreshData{
    [self crfGetRecordData];
    [self crfGetData];
}
-(void)crfGetData{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setValue:@(0) forKey:@"productListType"];
    [para setValue:@(10000) forKey:kPageSizeKey];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kInvestNewProductListPath) paragrams:para success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
         self.allProductList = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFProductModel class] ForKey:@"productList"];
        if (self.allProductList.count > 0) {
            self.noProductLabel.hidden = YES;
        }
        [self sortProducts];
        [strongSelf.mainTableView reloadData];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
         [strongSelf.mainTableView.mj_header endRefreshing];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)crfGetRecordData{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:APIFormat(kInvestRecordPath) success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.activityTitles =(NSMutableArray*)[CRFResponseFactory handleProductDataForResult:response WithClass:[CRFInvestRecordModel class] ForKey:@"lsirr"];
        [CRFAppCache setInvestRecordList:strongSelf.activityTitles];
        if (strongSelf.activityTitles.count) {
            [strongSelf.activityView start];
            [strongSelf.activityView reloadData];
        } else {
            [strongSelf.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)sortProducts {
    NSArray *products = [NSArray arrayWithArray:self.allProductList];
    self.allProductList = [[products sortedArrayUsingComparator:^NSComparisonResult(CRFProductModel *model1, CRFProductModel *model2) {
        //recommendedState 推荐。isNewBie 新手
        if (model1.newBieSort.integerValue < model2.newBieSort.integerValue ) {
            return (NSComparisonResult)NSOrderedAscending;
        }else if (model1.newBieSort.integerValue > model2.newBieSort.integerValue ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if ((model1.isNewBie.integerValue != 1 && model2.isNewBie.integerValue == 1)){
            return (NSComparisonResult)NSOrderedDescending;
        } else if ( ((model1.recommendedState.integerValue == 1)&&(model2.recommendedState.integerValue != 1))) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (((model1.recommendedState.integerValue != 1) && (model2.recommendedState.integerValue == 1))) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if([model1.yInterestRate floatValue] > [model2.yInterestRate floatValue]){
            return  (NSComparisonResult)NSOrderedDescending;
        } else if ([model1.yInterestRate floatValue] < [model2.yInterestRate floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }] mutableCopy];
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.allProductList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductModel * productInfo = [self.allProductList objectAtIndex:indexPath.section];
    WMNCPTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:WMNCPInvestListCellId];
    cell.productModel = productInfo;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *productInfo = [self.allProductList objectAtIndex:indexPath.section];
    DLog(@"点击选中 %@",productInfo.productName);
    [CRFAPPCountManager setEventID:@"INVEST_PRODUCT_EVENT" EventName:productInfo.contractPrefix];//埋点
    CRFProductDetailViewController *investDetailVC = [CRFProductDetailViewController new];
    investDetailVC.productNo = productInfo.contractPrefix;
    investDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:investDetailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
#pragma mark --UUMarqueeViewDelegate
- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    
}

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (NSArray*)dataSourceArrayForMarqueeView:(UUMarqueeView*)marqueeView {
    return self.activityTitles;
}
- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    itemView.backgroundColor = [UIColor clearColor];
    UILabel *phoneNumLabel = [UILabel new];
    UILabel *nameLabel     = [UILabel new];
    UILabel *timeLabel     = [UILabel new];
    UILabel *moneyLabel    = [UILabel new];
    [itemView addSubview:phoneNumLabel];
    [itemView addSubview:nameLabel];
    [itemView addSubview:moneyLabel];
    [itemView addSubview:timeLabel];
    
    phoneNumLabel.tag = 1001;
    phoneNumLabel.font = [UIFont systemFontOfSize:13.0];
    phoneNumLabel.textColor = UIColorFromRGBValue(0x999999);
    phoneNumLabel.textAlignment = NSTextAlignmentLeft;
    
    nameLabel.tag = 1002;
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    nameLabel.textColor = UIColorFromRGBValue(0x999999);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    moneyLabel.tag = 1003;
    moneyLabel.font = [UIFont systemFontOfSize:13.0];
    moneyLabel.textColor = UIColorFromRGBValue(0x999999);
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    
    timeLabel.tag = 1004;
    timeLabel.font = [UIFont systemFontOfSize:13.0];
    timeLabel.textColor = UIColorFromRGBValue(0x999999);
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(itemView);
        make.left.equalTo(itemView);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneNumLabel.mas_centerY);
        make.left.equalTo(phoneNumLabel.mas_right).with.mas_offset(10);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneNumLabel.mas_centerY);
        make.right.equalTo(itemView);
    }];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneNumLabel.mas_centerY);
        make.left.equalTo(nameLabel.mas_right).with.mas_offset(10);
        make.right.lessThanOrEqualTo(timeLabel.mas_left).with.mas_offset(-10);
    }];
}

- (UUMarqueeView *)activityView{
    if(!_activityView){
        _activityView = [[UUMarqueeView alloc] initWithFrame:CGRectZero];
        _activityView.backgroundColor = [UIColor clearColor];
        _activityView.delegate = self;
        _activityView.timeIntervalPerScroll = 3.0f;
        _activityView.timeDurationPerScroll = 1.0f;
        _activityView.touchEnabled = YES;
    }
    return _activityView;
}

- (void)updateItemView:(UIView*)itemView withData:(CRFInvestRecordModel*)data forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *phoneNum    = [itemView  viewWithTag:1001];
    UILabel *nameLabel   = [itemView  viewWithTag:1002];
    UILabel *moneyLabel  = [itemView  viewWithTag:1003];
    UILabel *timeLabel   = [itemView  viewWithTag:1004];
    phoneNum.attributedText = [data setContentAttributedStringShow];
    nameLabel.text = data.productName;
    moneyLabel.text = [NSString stringWithFormat:@"出借%@元",data.lendAmount];
    timeLabel.text = data.timeShowStr;
}

-(NSMutableArray *)activityTitles{
    if (!_activityTitles) {
        _activityTitles =[CRFAppCache getInvestRecord];
    }
    return _activityTitles;
}

- (UITableView *)mainTableView {
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView setSeparatorColor:kCellLineSeparatorColor];
        [_mainTableView registerClass:[WMNCPTableViewCell class] forCellReuseIdentifier:WMNCPInvestListCellId];
        [_mainTableView registerClass:[WMMJProductTableViewCell class] forCellReuseIdentifier:WMInvestProductCellId];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.estimatedRowHeight = 50;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        [self autoLayoutSizeContentView:_mainTableView];
    }
    return _mainTableView;
}

- (UILabel*)noProductLabel {
    if (!_noProductLabel) {
        _noProductLabel = [[UILabel alloc]init];
        _noProductLabel.text = @"暂时没有新方案，敬请关注";
        _noProductLabel.backgroundColor = [UIColor clearColor];
        _noProductLabel.textAlignment = NSTextAlignmentCenter;
        _noProductLabel.font = [UIFont systemFontOfSize:12.0];
        _noProductLabel.textColor = UIColorFromRGBValue(0x999999);
    }
    return _noProductLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

