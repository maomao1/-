//
//  CRFNewInvestListViewController.m
//  crf_purse
//
//  Created by maomao on 2018/7/3.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFNewInvestListViewController.h"
#import "CRFProductDetailViewController.h"
#import "CRFExplanOperateViewController.h"
#import "CRFEvaluatingViewController.h"
#import "CRFRelateAccountViewController.h"
#import "CRFCreateAccountViewController.h"

#import "CRFControllerManager.h"
#import "CRFAlertUtils.h"
#import "CRFStringUtils.h"
#import "CRFNewInvestListCell.h"
#import "CRFExclusiveModel.h"
#import "MJRefresh.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFTagView.h"
@interface CRFNewInvestListViewController ()<UITableViewDelegate,UITableViewDataSource,CRFTagViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;//导航栏配置图片（后台）
@property  (nonatomic , strong) UIImageView * exclusiveImageView;
@property  (nonatomic , strong) UITableView *mainTableView;
@property (nonatomic, strong) CRFExclusiveModel  *exclusiveItem;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (nonatomic ,strong)UILabel         *noProductLabel;
@property (nonatomic ,strong)UILabel         *btnLine;
@property (nonatomic ,strong)UILabel         *bottomLine;

@property (nonatomic ,strong) UIButton       *leftBtn;
@property (nonatomic ,strong) UIButton       *rightBtn;
@property (nonatomic ,strong) CRFTagView     *verbTagView;
@property (nonatomic ,strong) CRFTagView     *timeTagView;
@property (nonatomic ,strong) CRFTagFrame    *verbTagFrame;
@property (nonatomic ,strong) CRFTagFrame    *timeTagFrame;
//
@property (nonatomic ,strong) NSArray *allProductList;
@property (nonatomic ,strong) NSArray *shortProductList;
@property (nonatomic ,strong) NSArray *midProductList;
@property (nonatomic ,strong) NSArray *longProductList;
@property (nonatomic ,assign) NSInteger productTimeType;/// 0 全部 1短 2中 3长
@property (nonatomic ,strong) NSArray *resultList;
@property (nonatomic ,assign) BOOL   monthSelected;
@property (nonatomic ,assign) BOOL   bedueSelected;
@property (nonatomic ,assign) BOOL   profitIsAsc;
@end

@implementation CRFNewInvestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initDataSource];
    [self getExplanData];
}

-(void)initView{
    self.navigationItem.leftBarButtonItem = nil;
    [self createNavItem];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(updateTitleContent) name:kReloadResourceNotificationName];
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"invest_title_image"]) {
        self.imageView.image = [CRFUtils loadImageResource:@"invest_title_image"];
        self.navigationItem.titleView = self.imageView;
    } else {
        self.navigationItem.title = NSLocalizedString(@"title_invest", nil);
    }
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80*kWidthRatio)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:self.exclusiveImageView];
    [self.mainTableView addSubview:self.noProductLabel];
    [self.view addSubview:self.mainTableView];
    
    [self.exclusiveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).with.mas_offset(kSpace);
        make.left.equalTo(headerView.mas_left).with.mas_offset(kSpace);
        make.right.equalTo(headerView.mas_right).with.mas_offset(-kSpace);
        make.height.equalTo(self.exclusiveImageView.mas_width).multipliedBy(50/345.f);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).with.mas_offset(8);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [_noProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mainTableView);
    }];
    MJRefreshNormalHeader  *refresh_header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    refresh_header.lastUpdatedTimeLabel.textColor = UIColorFromRGBValue(0x999999);
    self.mainTableView.mj_header = refresh_header;
    self.mainTableView.tableHeaderView = headerView;
}
-(void)createNavItem{
//    self.leftBtn.bounds = CGRectMake(15, 0, 80, 44);
//    self.rightBtn.bounds = CGRectMake(kScreenWidth -80-15, 0, 80, 44);
//    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:(UIView*)self.leftBtn];
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:(UIView*)self.rightBtn];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.btnLine];
    [self.view addSubview:self.bottomLine];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 44));
        make.top.mas_equalTo(self.view);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 44));
        make.top.equalTo(self.leftBtn.mas_top);
        make.right.equalTo(self.view);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.leftBtn.mas_bottom).with.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.btnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.leftBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
}
-(void)initDataSource{
    self.productTimeType = 0;
    self.monthSelected = NO;
    self.bedueSelected = NO;
    self.profitIsAsc   = NO;
    [self crfGetProductListDataWithType:self.productTimeType isFromNet:YES];
}
-(void)setNavBtnSelected:(BOOL)isSelected{
    self.leftBtn.selected = NO;
    self.rightBtn.selected = NO;
}
-(void)crfLeftEvent:(UIButton*)btn{
    weakSelf(self);
    if (self.timeTagView.isShow) {
        self.rightBtn.selected = NO;
        
        [self.timeTagView crfDismissView:^{
            [weakSelf setNavBtnSelected:NO];
        }];
        return;
    }
    if (self.verbTagView.isShow) {
        self.leftBtn.selected = NO;
        [self.verbTagView crfDismissView:^{
            [weakSelf setNavBtnSelected:NO];
        }];
    }
    else{
        self.leftBtn.selected = YES;
        [self.verbTagView crfShowInView:[UIApplication sharedApplication].delegate.window];
    }
}
-(void)crfRightEvent:(UIButton*)btn{
    weakSelf(self);
    if (self.verbTagView.isShow) {
        self.leftBtn.selected = NO;
        [self.verbTagView crfDismissView:^{
            [weakSelf setNavBtnSelected:NO];
        }];
        return;
    }
    if (!self.timeTagView.isShow) {
        self.rightBtn.selected = YES;
        [self.timeTagView crfShowInView:[UIApplication sharedApplication].delegate.window];
    }else{
        self.rightBtn.selected = NO;
        [self.timeTagView crfDismissView:^{
            [weakSelf setNavBtnSelected:NO];
        }];
    }
}
-(void)exclusiveplanTap{
    weakSelf(self);
    [self.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:^{
        [weakSelf exclusiveLogic];
    }];
}
-(void)exclusiveLogic{
    if (![CRFAppManager defaultManager].login) {
        [CRFControllerManager pushLoginViewControllerFrom:self popType:PopFrom];
        return;
    }
    if (![CRFAppManager defaultManager].accountStatus) {
        [self checkAccountStatus];
        return;
    }
    //判断用户投资风险承受能力测评。非进取型用户弹窗提示无法进入
    if ([[CRFAppManager defaultManager].userInfo.riskLevel isEmpty]) {
        [CRFAlertUtils showAlertLeftTitle:@"尊敬的客户:" AttributedMessage:[CRFStringUtils changedLineSpaceWithTotalString:@"您需完成《投资风险承受能力测评》" lineSpace:3] container:self cancelTitle:@"取消" confirmTitle:@"去测评" cancelHandler:^{
            
        } confirmHandler:^{
            [self gotoEvaluation];
        }];
        return;
    }
    if ([[CRFAppManager defaultManager].userInfo.riskLevel integerValue] != 3 ){
        NSString *messageStr ;
        if ([CRFAppManager defaultManager].userInfo.riskLevel.integerValue ==1) {
            messageStr = @"保守型";
        }
        if ([CRFAppManager defaultManager].userInfo.riskLevel.integerValue ==2) {
            messageStr = @"平衡型";
        }
        [CRFAlertUtils showAlertLeftTitle:@"尊敬的客户:" AttributedMessage:[CRFStringUtils changedLineSpaceWithTotalString:[NSString stringWithFormat:@"此计划为进取型用户专享,您的《投资风险承受能力测评》结果为%@,暂无法进入",messageStr] lineSpace:3] container:self cancelTitle:@"取消" confirmTitle:@"重新测评" cancelHandler:^{
            
        } confirmHandler:^{
            [self gotoEvaluation];
        }];
        return;
    }
    CRFExplanOperateViewController *explanOperateVC = [[CRFExplanOperateViewController alloc]init];
    explanOperateVC.exclusiveItem = self.exclusiveItem;
    explanOperateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:explanOperateVC animated:YES];
}
- (void)gotoEvaluation {
    CRFEvaluatingViewController *evaluaVC = [CRFEvaluatingViewController new];
    evaluaVC.urlString = [NSString stringWithFormat:@"%@?%@",kInvestTestH5,kH5NeedHeaderInfo];
    evaluaVC.hidesBottomBarWhenPushed = YES;
    [evaluaVC setBackHandler:^{
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            if (!success) {
                [CRFUtils showMessage:response[kMessageKey]];
            }
            NSLog(success?@"刷新信息成功":@"刷新信息失败");
        }];
    }];
    [self.navigationController pushViewController:evaluaVC animated:YES];
}
- (void)checkAccountStatus {
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        UIViewController *controller = nil;
        if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
            controller = [CRFRelateAccountViewController new];
            [controller setValue:[CRFAppManager defaultManager].userInfo.phoneNo forKey:@"relatePhone"];
        } else {
            controller = [CRFCreateAccountViewController new];
        }
        controller.hidesBottomBarWhenPushed=YES;
        [strongSelf.navigationController pushViewController:controller animated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)crfGetProductListDataWithType:(NSInteger)type isFromNet:(BOOL)isNet {
    if (!isNet) {
        switch (self.productTimeType) {
            case 0: {
                self.resultList = self.allProductList;
            }
                break;
            case 1: {
                self.resultList = self.shortProductList;
            }
                break;
            case 2: {
                self.resultList = self.midProductList;
            }
                break;
            case 3: {
                self.resultList = self.longProductList;
            }
                break;
            default:
                break;
        }
        [self filterArraySortIsAsc:self.profitIsAsc];
        [self filterProductIsMonthSelected:self.monthSelected AndBedueSelected:self.bedueSelected];
        [self.mainTableView reloadData];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setValue:@(type) forKey:@"productListType"];
    [para setValue:@(10000) forKey:kPageSizeKey];
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kInvestNewProductListPath) paragrams:para success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [strongSelf.mainTableView.mj_header endRefreshing];
        [CRFLoadingView dismiss];
        if([response[kResult] isEqualToString:kSuccessResultStatus]){
            switch (strongSelf.productTimeType) {
                case 0: {
                    strongSelf.allProductList = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFProductModel class] ForKey:@"productList"];
                }
                    break;
                case 1: {
                    strongSelf.shortProductList = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFProductModel class] ForKey:@"productList"];
                }
                    break;
                case 2: {
                    strongSelf.midProductList = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFProductModel class] ForKey:@"productList"];
                }
                    break;
                case 3: {
                    strongSelf.longProductList = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFProductModel class] ForKey:@"productList"];
                }
                    break;
                default:
                    break;
            }
            [strongSelf filterArraySortIsAsc:self.profitIsAsc];
            [strongSelf filterProductIsMonthSelected:self.monthSelected AndBedueSelected:self.bedueSelected];
            [strongSelf.mainTableView reloadData];
        } else {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [self.mainTableView.mj_header endRefreshing];
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)filterArraySortIsAsc:(BOOL)isAsc{
    self.allProductList    = [self crfSequenceArray:self.allProductList IsAsc:isAsc];
    self.shortProductList  = [self crfSequenceArray:self.shortProductList IsAsc:isAsc];
    self.midProductList    = [self crfSequenceArray:self.midProductList IsAsc:isAsc];
    self.longProductList   = [self crfSequenceArray:self.longProductList IsAsc:isAsc];
    switch (self.productTimeType) {
        case 0: {
            self.resultList = self.allProductList;
        }
            break;
        case 1: {
            self.resultList = self.shortProductList;
        }
            break;
        case 2: {
            self.resultList = self.midProductList;
        }
            break;
        case 3: {
            self.resultList = self.longProductList;
        }
            break;
        default:
            break;
    }
    [self.mainTableView reloadData];
}
-(NSArray*)crfSequenceArray:(NSArray*)array IsAsc:(BOOL)isAsc{
    if (array.count) {
        array = [array sortedArrayUsingComparator:^NSComparisonResult(CRFProductModel *model1, CRFProductModel *model2) {
            if (model1.newBieSort.integerValue < model2.newBieSort.integerValue ) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else if (model1.newBieSort.integerValue > model2.newBieSort.integerValue ) {
                return (NSComparisonResult)NSOrderedDescending;
            }
//            else if (model1.newBieSort.integerValue == model2.newBieSort.integerValue ) {
//                return (NSComparisonResult)NSOrderedSame;
//            }
            
            else if ( ((model1.recommendedState.integerValue == 1)&&(model2.recommendedState.integerValue != 1))) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else if (((model1.recommendedState.integerValue != 1) && (model2.recommendedState.integerValue == 1))) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if([model1.yInterestRate floatValue] > [model2.yInterestRate floatValue]){
                return isAsc ? (NSComparisonResult)NSOrderedDescending : (NSComparisonResult)NSOrderedAscending;
            }
            else if ([model1.yInterestRate floatValue] < [model2.yInterestRate floatValue]) {
                return isAsc ? (NSComparisonResult)NSOrderedAscending :(NSComparisonResult)NSOrderedDescending;
            }
            else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
    }
    return array;
}
-(void)filterProductIsMonthSelected:(BOOL)isSelected AndBedueSelected:(BOOL)dueSelected{
    self.monthSelected = isSelected;
    self.bedueSelected = dueSelected;
    switch (self.productTimeType) {
        case 0: {
            self.resultList = self.allProductList;
        }
            break;
        case 1: {
            self.resultList = self.shortProductList;
        }
            break;
        case 2: {
            self.resultList = self.midProductList;
        }
            break;
        case 3: {
            self.resultList = self.longProductList;
        }
            break;
        default:
            break;
    }
    if (isSelected||dueSelected) {
        NSMutableArray *array1 = [NSMutableArray new];
        for (int i = 0; i<self.allProductList.count; i++) {
            CRFProductModel *model = [self.allProductList objectAtIndex:i];
            if (isSelected?![model.productType isEqualToString:@"2"]:[model.productType isEqualToString:@"2"]) {
                [array1 addObject:model];
            }
        }
        NSMutableArray *array2= [NSMutableArray new];
        for (int i = 0; i<self.shortProductList.count; i++) {
            CRFProductModel *model = [self.shortProductList objectAtIndex:i];
            if (isSelected?![model.productType isEqualToString:@"2"]:[model.productType isEqualToString:@"2"]) {
                [array2 addObject:model];
            }
        }
        NSMutableArray *array3= [NSMutableArray new];
        for (int i = 0; i<self.midProductList.count; i++) {
            CRFProductModel *model = [self.midProductList objectAtIndex:i];
            if (isSelected?![model.productType isEqualToString:@"2"]:[model.productType isEqualToString:@"2"]) {
                [array3 addObject:model];
            }
        }
        NSMutableArray *array4= [NSMutableArray new];
        for (int i = 0; i<self.longProductList.count; i++) {
            CRFProductModel *model = [self.longProductList objectAtIndex:i];
            if (isSelected?![model.productType isEqualToString:@"2"]:[model.productType isEqualToString:@"2"]) {
                [array4 addObject:model];
            }
        }
        switch (self.productTimeType) {
            case 0: {
                self.resultList = array1;
            }
                break;
            case 1: {
                self.resultList = array2;
            }
                break;
            case 2: {
                self.resultList = array3;
            }
                break;
            case 3: {
                self.resultList = array4;
            }
                break;
            default:
                break;
        }
    }
    [self.mainTableView reloadData];
}
- (void)updateTitleContent {
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"invest_title_image"]) {
        self.imageView.image = [CRFUtils loadImageResource:@"invest_title_image"];
        self.navigationItem.titleView = self.imageView;
    }
}
-(void)refreshData{
    [self getExplanData];
    [self crfGetProductListDataWithType:self.productTimeType isFromNet:YES];
}
-(void)getExplanData{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),exclusive_key] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        NSArray *dataArray = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:exclusive_key];
        [strongSelf parseDataArray:dataArray];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)parseDataArray:(NSArray*)dataArray{
    if (dataArray.count) {
        CRFAppHomeModel *model = dataArray[0];
        CRFExclusiveModel *exculsiveModel =[CRFExclusiveModel yy_modelWithDictionary:[CRFUtils dictionaryWithJsonString:model.content]];
        _exclusiveItem = exculsiveModel;
        [_helpView drawContent:exculsiveModel.content];
    }
}
#pragma === TagViewDelegate ==
-(void)crfhitShadowView{
    [self setNavBtnSelected:NO];
}
-(void)crfTagViewIndex:(NSInteger)index tagView:(UIView *)crftagview{
    if (crftagview == self.verbTagView) {
        switch (index) {
            case 0:
            {
                self.profitIsAsc = NO;
                self.monthSelected =NO;
                self.bedueSelected = NO;
            }
                break;
            case 1:
            {
                self.profitIsAsc = YES;
                self.monthSelected =NO;
                self.bedueSelected = NO;
            }
                break;
            case 2:
            {
                self.profitIsAsc = NO;
                self.monthSelected =NO;
                self.bedueSelected = NO;
            }
                break;
            case 3:
            {
                self.profitIsAsc = NO;
                self.monthSelected =YES;
                self.bedueSelected = NO;
            }
                break;
            case 4:
            {
                self.profitIsAsc = NO;
                self.monthSelected =NO;
                self.bedueSelected = YES;
            }
                break;
            default:
                break;
        }
        weakSelf(self);
        [self.verbTagView crfDismissView:^{
            [weakSelf setNavBtnSelected:NO];
        }];
        [self filterArraySortIsAsc:self.profitIsAsc];
        [self filterProductIsMonthSelected:self.monthSelected AndBedueSelected:self.bedueSelected];
        [self.mainTableView reloadData];
    }
    else{
        self.productTimeType = index;
        BOOL isFromNet = NO;
        switch (index) {
            case 0: {
                if (!self.allProductList) {
                    isFromNet = YES;
                }
            }
                break;
            case 1: {
                if (!self.shortProductList) {
                    isFromNet = YES;
                }
            }
                break;
            case 2: {
                if (!self.midProductList) {
                    isFromNet = YES;
                }
            }
                break;
            case 3: {
                if (!self.longProductList) {
                    isFromNet = YES;
                }
            }
                break;
                
            default:
                break;
        }
        [CRFAPPCountManager setEventID:@"INVEST_LIST_TERM_EVENT" EventName:[self.timeTagFrame.tagsArray objectAtIndex:index]];
        [self crfGetProductListDataWithType:self.productTimeType isFromNet:isFromNet];
        weakSelf(self);
        [self.timeTagView crfDismissView:^{
            [weakSelf setNavBtnSelected:NO];
        }];
    }
    
}
#pragma mark == tableViewDelegate ==
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.resultList.count) {
        _noProductLabel.hidden = YES;
    } else {
        _noProductLabel.hidden = NO;
    }
    return self.resultList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductModel *productInfo = [self.resultList objectAtIndex:indexPath.section];
    CRFNewInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFNewInvestListCellId];
    cell.productModel = productInfo;
    if ([productInfo isEqual:[self.resultList lastObject]]) {
        cell.lineLabel.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *productInfo = [self.resultList objectAtIndex:indexPath.section];
    DLog(@"点击选中 %@",productInfo.productName);
    [CRFAPPCountManager setEventID:@"INVEST_PRODUCT_EVENT" EventName:productInfo.contractPrefix];//埋点
    CRFProductDetailViewController *investDetailVC = [CRFProductDetailViewController new];
    investDetailVC.productNo = productInfo.contractPrefix;
    investDetailVC.hidesBottomBarWhenPushed = YES;
    if (productInfo.contractPrefix.length) {
        [self.navigationController pushViewController:investDetailVC animated:YES];
    }}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        [_mainTableView registerClass:[CRFNewInvestListCell class] forCellReuseIdentifier:CRFNewInvestListCellId];
//        _mainTableView.rowHeight = 86;
        _mainTableView.estimatedRowHeight = 50;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        [self autoLayoutSizeContentView:_mainTableView];
    }
    return _mainTableView;
}
-(UIImageView *)exclusiveImageView{
    if (!_exclusiveImageView) {
        _exclusiveImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_exclusiveLogo"]];
        _exclusiveImageView.contentMode = UIViewContentModeScaleAspectFill;
        _exclusiveImageView.userInteractionEnabled = YES;
        [_exclusiveImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exclusiveplanTap)]];
    }
    return _exclusiveImageView;
}
-(NSArray *)resultList{
    if (!_resultList) {
        _resultList = [[NSArray alloc]init];
    }
    return _resultList;
}
- (UILabel *)noProductLabel {
    if (!_noProductLabel) {
        _noProductLabel = [[UILabel alloc] init];
        _noProductLabel.text = @"暂时没有新计划，敬请关注";
        _noProductLabel.backgroundColor = [UIColor clearColor];
        _noProductLabel.textAlignment = NSTextAlignmentCenter;
        _noProductLabel.font = [UIFont systemFontOfSize:12.0];
        _noProductLabel.textColor = UIColorFromRGBValue(0x999999);
    }
    return _noProductLabel;
}
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainCancelBtn;
        _helpView.title = @"特供计划";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth, 0)];
        [_helpView drawContent:_exclusiveItem?_exclusiveItem.content:@"特供计划是信而富为不同风险偏好的出借人推出的出借工具。可根据您的出借意向，为您筛选符合您风险偏好的出借计划。目前仅对“进取型”风险偏好的用户开放。"];
    }
    return _helpView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, kNavigationbarHeight)];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}
-(UILabel *)btnLine{
    if (!_btnLine) {
        _btnLine = [[UILabel alloc]init];
        _btnLine.backgroundColor = kCellLineSeparatorColor;
    }
    return _btnLine;
}
-(UILabel *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc]init];
        _bottomLine.backgroundColor = [UIColor clearColor];
    }
    return _bottomLine;
}
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftBtn setTitle:@"综合排序" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(crfLeftEvent:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.backgroundColor = [UIColor whiteColor];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_rightBtn setTitle:@"期限" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(crfRightEvent:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.backgroundColor = [UIColor whiteColor];

    }
    return _rightBtn;
}
-(CRFTagFrame *)verbTagFrame{
    if (!_verbTagFrame) {
        NSArray *array = @[@"不限",@"收益率 ↑",@"收益率 ↓",@"到期付息",@"按月付息"];
        _verbTagFrame = [[CRFTagFrame alloc]init];
        _verbTagFrame.tagsArray = array;
    }
    return _verbTagFrame;
}
-(CRFTagFrame *)timeTagFrame{
    if (!_timeTagFrame) {
        NSArray *array = @[@"不限",@"短期",@"中期",@"长期"];
        _timeTagFrame = [[CRFTagFrame alloc]init];
        _timeTagFrame.tagsArray = array;
    }
    return _timeTagFrame;
}
-(CRFTagView *)verbTagView{
    if (!_verbTagView) {
        _verbTagView = [[CRFTagView alloc]initWithFrame:CGRectZero];
        _verbTagView.backgroundColor = [UIColor whiteColor];
        _verbTagView.clickbool = YES;
        _verbTagView.tagsFrame = self.verbTagFrame;
        _verbTagView.clickStart = 0;
        _verbTagView.clickString = [self.verbTagFrame.tagsArray objectAtIndex:0];
        _verbTagView.delegate = self;
    }
    return _verbTagView;
}
-(CRFTagView *)timeTagView{
    if (!_timeTagView) {
        _timeTagView = [[CRFTagView alloc]initWithFrame:CGRectZero];
        _timeTagView.backgroundColor = [UIColor whiteColor];
        _timeTagView.clickbool = YES;
        _timeTagView.tagsFrame = self.timeTagFrame;
        _timeTagView.clickStart = 0;
        _timeTagView.clickString = [self.verbTagFrame.tagsArray objectAtIndex:0];
        _timeTagView.delegate = self;
    }
    return _timeTagView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
