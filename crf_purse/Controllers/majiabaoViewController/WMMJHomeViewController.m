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
//
@interface WMMJHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UUMarqueeViewDelegate,CRFFilterViewDelegate, SDCycleScrollViewDelegate> {
    __block NSInteger  _seletedFilterIndex;
    __block CRFProductListType *_productListType;
    UILabel  *_noProductLabel;
    
}
@property (nonatomic ,strong) UITableView     *mainTableView;
//@property (nonatomic ,strong) UIView          *filterViewBg;
@property (nonatomic ,strong) NSArray         *filterTitles;//初始化产品标题栏数据
@property (nonatomic ,strong) NSMutableArray  *refreshFilterTitles;//更新产品标题
@property (nonatomic ,strong) NSArray         *filterArray;//接口原始数据
@property (nonatomic ,strong) NSMutableArray  *dealFilterArray;//去掉原始数据中 返回的产品组为0的数据
@property (nonatomic ,strong) UUMarqueeView   *activityView;
@property (nonatomic ,strong) NSMutableArray  *activityTitles;
@property (nonatomic ,strong) NSMutableArray   *detailCollectionArray;///<


@property (nonatomic, strong) SDCycleScrollView *scrollView;
@end
@implementation WMMJHomeViewController

- (SDCycleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"majiabao_banner_default.jpg"]];
        _scrollView.localizationImageNamesGroup = @[[UIImage imageNamed:@"majiabao_banner_1.jpg"],[UIImage imageNamed:@"majiabao_banner_2.jpg"]];
    }
    return _scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"信而富钱包";
    [self initDataSource];
    [self createUI];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *url = nil;
    if (index == 0) {
        url = @"https://financeapp-static.crfchina.com/webp2p_static/invests/views/banner/upgradeBenefits.html";
    } else {
        url = @"https://financeapp-static.crfchina.com/webp2p_static/invests/views/banner/ten/activity-nov.html";
    }
    url = [NSString stringWithFormat:@"%@?%@",url,kH5NeedHeaderInfo];
    CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
    webViewController.urlString = url;
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)initDataSource{
    _refreshFilterTitles = [[NSMutableArray alloc]init];
    _dealFilterArray = [[NSMutableArray alloc]init];
    _productListType = [[CRFProductListType alloc]init];
    _detailCollectionArray =[[NSMutableArray alloc]init];
    _seletedFilterIndex = 0;
    [self crfGetData];
    [self crfGetRecordData];
}
-(void)createUI{
    //
    _noProductLabel = [[UILabel alloc]init];
    _noProductLabel.text = @"暂时没有新计划，敬请关注";
    _noProductLabel.backgroundColor = [UIColor clearColor];
    _noProductLabel.textAlignment = NSTextAlignmentCenter;
    _noProductLabel.font = [UIFont systemFontOfSize:12.0];
    _noProductLabel.textColor = UIColorFromRGBValue(0x999999);
    //
    _activityView = [[UUMarqueeView alloc] initWithFrame:CGRectZero];
    _activityView.backgroundColor = [UIColor clearColor];
    _activityView.delegate = self;
    _activityView.timeIntervalPerScroll = 3.0f;
    _activityView.timeDurationPerScroll = 1.0f;
    _activityView.touchEnabled = YES;
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorColor:kCellLineSeparatorColor];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    MJRefreshNormalHeader  *refresh_header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    refresh_header.lastUpdatedTimeLabel.textColor = UIColorFromRGBValue(0x999999);
    self.mainTableView.mj_header = refresh_header;
    
    [self.mainTableView registerClass:[WMMJProductTableViewCell class] forCellReuseIdentifier:WMInvestProductCellId];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellId"];
    [self.mainTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footerIdentifiter"];
    [self.view addSubview:self.scrollView];
    [self.mainTableView addSubview:_noProductLabel];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:_activityView];
    
    self.mainTableView.rowHeight = 83;
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
        make.top.equalTo(self.activityView.mas_bottom).with.mas_offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kUserInfo.accessToken forKey:kAccessTokenKey];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kInvestProductListPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
         [strongSelf.mainTableView.mj_header endRefreshing];
        strongSelf.filterArray = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFProductType class] ForKey:@"lsProductType"];
        [CRFAppManager defaultManager].nowTime = [response[kDataKey][@"nowTime"] longLongValue];
        [strongSelf dealListForProductTypeList];
        if (_seletedFilterIndex != 0) {
            _productListType.selectedType = YES;
            CRFProductType *productTypeList =self.dealFilterArray[_seletedFilterIndex - 1];
            _productListType.resultList = productTypeList.totalProductList;
        }else{
            _productListType.selectedType = NO;
        }
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
            if (_seletedFilterIndex != 0) {
                _productListType.selectedType = YES;
            }else{
                _productListType.selectedType = NO;
            }
        }else{
            if (_seletedFilterIndex != 0) {
                _productListType.selectedType = YES;
            }else{
                _productListType.selectedType = NO;
            }
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

-(void)dealListForProductTypeList{
    if (self.dealFilterArray.count) {
        [self.dealFilterArray removeAllObjects];
    }
    NSMutableArray *array = [NSMutableArray arrayWithObject:@"全部"];
    for (int i = 0; i <self.filterArray.count; i++) {
        CRFProductType *productType = self.filterArray[i];
        //        if (productType.lsProductList.count) {
        [self.dealFilterArray addObject:productType];
        [array addObject:productType.productTypeName];
        //        }
    }
    _refreshFilterTitles = array;
    _productListType.oldList =[NSMutableArray arrayWithArray:self.dealFilterArray] ;
}


#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dealFilterArray.count == 0) {
        _noProductLabel.hidden = NO;
        return 0;
    }
    if (_productListType.selectedType) {
        self.detailCollectionArray =_productListType.resultList;
        _noProductLabel.hidden = _productListType.resultList.count;
        return 1;
    }
    if (_productListType.selectedIndex) {
        self.detailCollectionArray = [_productListType selectedArrayForIndex:_productListType.selectedIndex];
        BOOL isHidden = NO;
        for (NSArray *array in self.detailCollectionArray) {
            if(array.count>0){
                isHidden = YES;
            }
        }
        _noProductLabel.hidden = isHidden;
        return self.detailCollectionArray.count;
    }
    _noProductLabel.hidden = self.dealFilterArray.count;
    return self.dealFilterArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_productListType.selectedType) {
        return _productListType.resultList.count;
    }
    if (_productListType.selectedIndex)
    {
        NSArray *array = [[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:section];
        return array.count;
        
    }
    
    CRFProductType * productType = self.dealFilterArray[section];
    if (productType.isOpen) {
        return productType.finishProductList.count+productType.unfinishProductList.count;
    }
    return productType.unfinishProductList.count>0?productType.unfinishProductList.count:1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMJProductTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:WMInvestProductCellId];
    if (_productListType.selectedType) {
        CRFProductType *productTypeList =self.dealFilterArray[_seletedFilterIndex - 1];
        _productListType.resultList = productTypeList.totalProductList;
        cell.product = [_productListType.ascList objectAtIndex:indexPath.row];
        
    }else{
        if (_productListType.selectedIndex) {
            NSMutableArray * array = [[_productListType selectedArrayForIndex:_productListType.selectedIndex] copy];
            CRFProductModel *model = array[indexPath.section][indexPath.row];
            cell.product = model;
        }else{
            CRFProductType *productType = self.dealFilterArray[indexPath.section];
            if (productType.isOpen) {
                if (indexPath.row<productType.unfinishProductList.count) {
                    cell.product = productType.unfinishProductList[indexPath.row];
                }else{
                    cell.product = productType.finishProductList[indexPath.row-productType.unfinishProductList.count];
                }
            }else{
                if (productType.unfinishProductList.count) {
                    cell.product = productType.unfinishProductList[indexPath.row];
                }else{
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
                    cell.textLabel.text = @"暂时没有新计划，敬请关注";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                    cell.textLabel.textColor = UIColorFromRGBValue(0x999999);
                    return cell;
                }
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductType *productType = self.dealFilterArray[indexPath.section];
    CRFProductModel *model;
    if (_productListType.selectedType) {
        CRFProductType *productTypeList =self.dealFilterArray[_seletedFilterIndex - 1];
        _productListType.resultList = productTypeList.totalProductList;
        model = [_productListType.ascList objectAtIndex:indexPath.row];
    }else{
        if (_productListType.selectedIndex) {
            NSArray *array = [[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:indexPath.section];
            model = [array objectAtIndex:indexPath.row];
        }else{
            if (productType.isOpen) {
                if (indexPath.row<productType.unfinishProductList.count) {
                    model = productType.unfinishProductList[indexPath.row];
                }else{
                    model = productType.finishProductList[indexPath.row-productType.unfinishProductList.count];
                }
            }else{
                if (productType.unfinishProductList.count ==0||!productType.unfinishProductList) {
                    
                }else{
                    model = productType.unfinishProductList[indexPath.row];
                }
                
                
            }
        }
    }
    if (model) {
        DLog(@"点击选中 %@",model.productName);
        [CRFAPPCountManager setEventID:@"INVEST_PRODUCT_EVENT" EventName:model.productName];//埋点
        CRFProductDetailViewController *investDetailVC = [CRFProductDetailViewController new];
        investDetailVC.productNo = model.contractPrefix;
        investDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:investDetailVC animated:YES];
    }else{
        DLog(@"点击选中  暂时没有新计划，敬请关注");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductType *productType = self.dealFilterArray[indexPath.section];
    CRFProductModel *model;
    if (_productListType.selectedType) {
        CRFProductType *productTypeList =self.dealFilterArray[_seletedFilterIndex - 1];
        _productListType.resultList = productTypeList.totalProductList;
        model = [_productListType.ascList objectAtIndex:indexPath.row];
    }else{
        if (_productListType.selectedIndex) {
            NSArray *array = [[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:indexPath.section];
            model = [array objectAtIndex:indexPath.row];
        }else{
            if (productType.isOpen) {
                if (indexPath.row<productType.unfinishProductList.count) {
                    model = productType.unfinishProductList[indexPath.row];
                }else{
                    model = productType.finishProductList[indexPath.row-productType.unfinishProductList.count];
                }
            }else{
                if (productType.unfinishProductList.count ==0) {
                    return 40;
                }
                model = productType.unfinishProductList[indexPath.row];
                
            }
        }
    }
    if (model.tipsStart && model.tipsStart.length > 0) {
        return 90;
    }
    return 83;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_productListType.selectedType) {
        return 0.01;
    }
    if (_productListType.selectedIndex) {
        NSArray *array = [[[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:section] copy];
        return array.count?45:0.01;
    }
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_productListType.selectedType) {
        return 0.01;
    }
    if (_productListType.selectedIndex) {
        //        NSArray *array = [[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:section];
        return 8;
    }
    CRFProductType * productType = self.dealFilterArray[section];
    if (productType.finishProductList.count == 0) {
        return 8;
    }
    return 53;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    UILabel *titleLabel = [[UILabel alloc]init];
    [sectionHeader addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionHeader.mas_left).with.mas_offset(kSpace);
        make.right.equalTo(sectionHeader.mas_right).with.mas_offset(-kSpace);
        make.centerY.equalTo(sectionHeader.mas_centerY);
    }];
    CRFProductType *productType = _dealFilterArray[section];
    titleLabel.text = productType.productTypeName;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = UIColorFromRGBValue(0x333333);
    sectionHeader.backgroundColor = [UIColor whiteColor];
    if (_productListType.selectedType) {
        return nil;
    }
    if (_productListType.selectedIndex) {
        NSArray *array = [[[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:section] copy];
        return array.count?sectionHeader:nil;
    }
    return sectionHeader;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 53)];
    bgView.backgroundColor = [UIColor clearColor];
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    [bgView addSubview:sectionHeader];
    CRFProductType * productType = self.dealFilterArray[section];
    UIButton *moreBtn = [CRFViewUtils buttonWithFont:[UIFont systemFontOfSize:13.0] norTitleColor:[UIColor lightGrayColor] norImg:@"arrow_down" titleEdgeInset:UIEdgeInsetsMake(0, 0, 0, 40) imgEdgeInsets:UIEdgeInsetsMake(2, 200, 0, 0)];
    if (productType.isOpen) {
        [moreBtn setTitle:@"收起已售完的计划" forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    }else{
        [moreBtn setTitle:@"查看已售完的计划" forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    }
    moreBtn.tag = 1001+section;
    [sectionHeader addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(scanMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sectionHeader);
        make.height.mas_equalTo(20);
        make.center.equalTo(sectionHeader);
    }];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    if (productType.finishProductList.count == 0||_productListType.selectedIndex) {
        UIView *padingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 8)];
        padingView.backgroundColor = [UIColor clearColor];
        return padingView;
    }
    //    if (_productListType.selectedIndex) {
    ////        NSArray *array = [[_productListType selectedArrayForIndex:_productListType.selectedIndex] objectAtIndex:section];
    //        return bgView;
    //    }
    return bgView;
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
#pragma mark   CRFFilterViewDelegate
-(void)filterResult:(UIButton *)btn{
    if (btn.selected) {
        _productListType.selectedIndex = btn.tag;
    }else{
        _productListType.selectedIndex = 0;
    }
    [self.mainTableView reloadData];
}
-(void)scanMoreClick:(UIButton *)btn{
    CRFProductType * productType = self.dealFilterArray[btn.tag -1001];
    //收起其他展开的
    for (int i = 0; i<self.dealFilterArray.count; i++) {
        CRFProductType *model = self.dealFilterArray[i];
        if (model.isOpen&&i != btn.tag-1001) {
            model.isOpen = NO;
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    productType.isOpen  =! productType.isOpen;
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag-1001] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSArray *)filterTitles{
    if (!_filterTitles) {
        _filterTitles = @[@"全部",@"幸富共盈",@"幸富连盈",@"幸富月盈"];
    }
    return _filterTitles;
}
-(NSMutableArray *)activityTitles{
    if (!_activityTitles) {
        _activityTitles =[CRFAppCache getInvestRecord];
    }
    return _activityTitles;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

