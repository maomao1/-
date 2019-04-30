//
//  CRFInvestListViewController.m
//  crf_purse
//
//  Created by maomao on 2017/11/8.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//
#import "CRFInvestListViewController.h"
#import "CRFLoginViewController.h"
#import "CRFProductDetailViewController.h"
#import "CRFExplanOperateViewController.h"
#import "CRFExclusivePlanListViewController.h"
#import "CRFRelateAccountViewController.h"
#import "CRFCreateAccountViewController.h"
#import "CRFEvaluatingViewController.h"
#import "MJRefresh.h"
#import "CRFViewUtils.h"
#import "CRFInvestHead.h"
#import "UUMarqueeView.h"
#import "CRFInvestFilterView.h"
#import "CRFInvestListCell.h"
#import "CRFInvestProductCell.h"
#import "CRFAppCache.h"
#import "CRFInvestRecordModel.h"
#import "CRFAlertUtils.h"
#import "CRFControllerManager.h"
#import "CRFStringUtils.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFExclusiveModel.h"
#define SEGMENTHEIGHT    54
@interface CRFInvestListViewController ()<UITableViewDelegate,UITableViewDataSource,CRFInvestHeadCellDelegate,UUMarqueeViewDelegate,CRFInvestFilterViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic ,strong) UITableView     *mainTableView;
@property (nonatomic ,strong) UUMarqueeView   *activityView;
@property (nonatomic ,strong) NSMutableArray  *activityTitles;
@property (nonatomic ,strong)CRFInvestHead   *investHeadView;
@property (nonatomic ,strong)CRFInvestFilterView*investFilterView;
@property (nonatomic ,strong)UILabel         *noProductLabel;
@property (nonatomic ,strong) UIImageView  *exclusiveImageView;
@property (nonatomic ,strong) UIView       *tableViewFooter;
@property (nonatomic ,strong) UIScrollView  *mainScrollView;
@property (nonatomic ,strong) UIView        *containerView;
//
@property (nonatomic ,strong)NSArray  *dataSource;

@property (nonatomic ,strong) NSArray *allProductList;
@property (nonatomic ,strong) NSArray *shortProductList;
@property (nonatomic ,strong) NSArray *midProductList;
@property (nonatomic ,strong) NSArray *longProductList;
//@property (nonatomic ,assign) BOOL   isRefresh;
@property (nonatomic ,assign) NSInteger productType;/// 0 全部 1短 2中 3长
@property (nonatomic ,strong) NSString *filterType;
@property (nonatomic ,strong) NSArray *resultList;

@property (nonatomic ,assign) BOOL   monthSelected;
@property (nonatomic ,assign) BOOL   bedueSelected;
@property (nonatomic ,strong) NSString *payBtnTitle;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;

@property (nonatomic, strong) CRFExclusiveModel  *exclusiveItem;
@end

@implementation CRFInvestListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self crfGetRecordData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initDataSource];
    [self getExplanData];
}

-(void)initDataSource{
    self.productType = 0;
    self.filterType = @"Profit_dec";
    self.payBtnTitle = @"";
    _monthSelected = NO;
    _bedueSelected = NO;
    [self crfGetProductListDataWithType:self.productType isFromNet:YES];
}
-(void)createUI{
    self.navigationItem.leftBarButtonItem = nil;
    [self setCustomRightBarBorderButtonWithTitle:@"特供计划" fontSize:12.0 target:self selector:@selector(rightBarEvent) titleColor:UIColorFromRGBValue(0xfb4d3a)];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(updateTitleContent) name:kReloadResourceNotificationName];
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"invest_title_image"]) {
        self.imageView.image = [CRFUtils loadImageResource:@"invest_title_image"];
        self.navigationItem.titleView = self.imageView;
    } else {
        self.navigationItem.title = NSLocalizedString(@"title_invest", nil);
    }
    [self.view addSubview:self.containerView];
//    [self.mainScrollView addSubview:self.containerView];
    [self.view addSubview:self.exclusiveImageView];
    [self.containerView addSubview:self.investHeadView];
    [self.containerView addSubview:self.activityView];
    [self.containerView addSubview:self.investFilterView];
    
    [self.mainTableView addSubview:self.noProductLabel];
    [self.view addSubview:self.mainTableView];
    
    [self.exclusiveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 148*kWidthRatio));
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.mas_offset(-148*kWidthRatio-20);
//        make.top.equalTo(self.view.mas_top).with.mas_offset(-148*kWidthRatio);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        //        make.top.left.bottom.and.right.equalTo(self.mainScrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(KHeadViewHeight+80);
    }];
    [self.investHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
//        make.left.right.equalTo(self.containerView);
//        make.top.equalTo(self.exclusiveImageView.mas_bottom);
        make.height.mas_equalTo(KHeadViewHeight);
    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.top.equalTo(self.investHeadView.mas_bottom);
        make.height.mas_equalTo(36);
    }];
    [self.investFilterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.activityView.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).with.mas_offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    [_noProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mainTableView);
    }];
    MJRefreshNormalHeader  *refresh_header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    refresh_header.lastUpdatedTimeLabel.textColor = UIColorFromRGBValue(0x999999);
    self.mainTableView.mj_header = refresh_header;
    self.mainTableView.tableFooterView = self.tableViewFooter;
    
}

- (void)updateTitleContent {
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"invest_title_image"]) {
        self.imageView.image = [CRFUtils loadImageResource:@"invest_title_image"];
        self.navigationItem.titleView = self.imageView;
    }
}

- (void)refreshData {
    [self crfGetProductListDataWithType:self.productType isFromNet:YES];
}
-(void)getExplanData{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),exclusive_key] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.dataSource = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:exclusive_key];
        [strongSelf parseDataArray:strongSelf.dataSource];
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
- (void)crfGetRecordData {
    [[CRFStandardNetworkManager defaultManager] get:APIFormat(kInvestRecordPath) success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        if([response[kResult] isEqualToString:kSuccessResultStatus]) {
            self.activityTitles =(NSMutableArray*)[CRFResponseFactory handleProductDataForResult:response WithClass:[CRFInvestRecordModel class] ForKey:@"lsirr"];
            if (self.activityTitles.count) {
                [self.activityView start];
                [self.activityView reloadData];
            } else {
                [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(44+KHeadViewHeight);
                }];
                
                [_investFilterView crfTopLineHidden:NO];
            }
        } else {
            [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44+KHeadViewHeight);
            }];
            [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.containerView.mas_bottom);
            }];
            [_investFilterView crfTopLineHidden:NO];
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44+KHeadViewHeight);
        }];
        [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.containerView.mas_bottom);
            }];
        [_investFilterView crfTopLineHidden:NO];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)crfGetProductListDataWithType:(NSInteger)type isFromNet:(BOOL)isNet {
    if (!isNet) {
        switch (self.productType) {
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
        [self filterProductWithType:self.filterType];
        [self filterProductPayType:self.payBtnTitle IsMonthSelected:self.monthSelected AndBedueSelected:self.bedueSelected];
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
            switch (strongSelf.productType) {
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
            [strongSelf filterProductWithType:strongSelf.filterType];
            [strongSelf filterProductPayType:strongSelf.payBtnTitle IsMonthSelected:strongSelf.monthSelected AndBedueSelected:strongSelf.bedueSelected];
            [CRFAppManager defaultManager].nowTime = [response[kDataKey][@"nowTime"]longLongValue];
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
-(void)rightBarEvent{
    [self exclusiveplanTap];
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
-(void)exclusiveplanTap{
    weakSelf(self);
    [self.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:^{
        [weakSelf exclusiveLogic];
    }];
    
    
}

- (void)makeExclusiveplan:(UIButton *)btn {
    [self exclusiveplanTap];
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
-(void)panExclusivePlan:(UIPanGestureRecognizer*)gester{
    CGPoint translatedPoint = [gester translationInView:self.view];
     CGFloat firstY = 0;
//    [gester setTranslation:CGPointZero inView:gester.view];
    if ([gester state] == UIGestureRecognizerStateBegan) {
        firstY = gester.view.center.y;
    }
    if ([gester state] == UIGestureRecognizerStateChanged) {
        CGFloat y = firstY +translatedPoint.y;
        CGFloat exclusiveImgY  = CGRectGetMinY(self.exclusiveImageView.frame);
            if (y<0) {
                if (exclusiveImgY <= -148*kWidthRatio) {
                    return;
                }
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).with.mas_offset(148*kWidthRatio+y);
                }];
                [self.exclusiveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.mas_offset(y);
                }];
            }else{
                if (exclusiveImgY >=0) {
                    return;
                }
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).with.mas_offset(y);
                }];
                [self.exclusiveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.mas_offset(y-148*kWidthRatio);
                }];
            }        
    }
    if ([gester state] == UIGestureRecognizerStateEnded) {
        CGFloat y = gester.view.center.y;
        CGFloat exclusiveImgY  = CGRectGetMinY(self.exclusiveImageView.frame);
        DLog(@"end:  %f %f",y ,exclusiveImgY);
        if (exclusiveImgY>-74*kWidthRatio) {
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).with.mas_offset(148*kWidthRatio);
                }];
                [self.exclusiveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.mas_offset(0);
                }];
                [self.view layoutIfNeeded];
            } completion:nil];
            
        }else{
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).with.mas_offset(0);
                }];
                [self.exclusiveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.mas_offset(-148*kWidthRatio-20);
                }];
                [self.view layoutIfNeeded];
            } completion:nil];
        }
        
//       [gester setTranslation:CGPointZero inView:gester.view];
    }
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
#pragma mark ===ViewDelegate=====
- (void)crfSelectedIndex:(NSInteger)index {
    self.productType = index;
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
    [self crfGetProductListDataWithType:self.productType isFromNet:isFromNet];
}
-(NSArray*)crfSequenceArray:(NSArray*)array IsAsc:(BOOL)isAsc IsProfit:(BOOL)isProfit{
    if (array.count) {
        array = [array sortedArrayUsingComparator:^NSComparisonResult(CRFProductModel *model1, CRFProductModel *model2) {
            if (isProfit) {
                //recommendedState 推荐。isNewBie 新手
                if ((model1.isNewBie.integerValue == 1 && model2.isNewBie.integerValue != 1)) {
                    return (NSComparisonResult)NSOrderedAscending;
                }else if((model1.isNewBie.integerValue != 1 && model2.isNewBie.integerValue == 1)){
                    return (NSComparisonResult)NSOrderedDescending;
                }
               else if ( ((model1.recommendedState.integerValue == 1)&&(model2.recommendedState.integerValue != 1))) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else if (((model1.recommendedState.integerValue != 1) && (model2.recommendedState.integerValue == 1))) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if([model1.yInterestRate floatValue] > [model2.yInterestRate floatValue]){
                    return isAsc ? (NSComparisonResult)NSOrderedDescending : (NSComparisonResult)NSOrderedAscending;
                } else if ([model1.yInterestRate floatValue] < [model2.yInterestRate floatValue]) {
                    return isAsc ? (NSComparisonResult)NSOrderedAscending :(NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedSame;
                }
            } else {
                if ((model1.isNewBie.integerValue == 1 && model2.isNewBie.integerValue != 1)) {
                    return (NSComparisonResult)NSOrderedAscending;
                }else if((model1.isNewBie.integerValue != 1 && model2.isNewBie.integerValue == 1)){
                    return (NSComparisonResult)NSOrderedDescending;
                } else
                if (((model1.recommendedState.integerValue == 1) && (model2.recommendedState.integerValue != 1))) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else if (((model1.recommendedState.integerValue != 1) && (model2.recommendedState.integerValue == 1))) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if([model1.remainDays floatValue] > [model2.remainDays floatValue]){
                    return isAsc ? (NSComparisonResult)NSOrderedDescending : (NSComparisonResult)NSOrderedAscending;
                } else if ([model1.remainDays floatValue] < [model2.remainDays floatValue]){
                    return isAsc ? (NSComparisonResult)NSOrderedAscending : (NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedSame;
                }
            }
        }];
    }
    return array;
}

- (void)filterArrayTypeIsAsc:(BOOL)isAsc AndProfit:(BOOL)isProfit {
    self.allProductList   = [self crfSequenceArray:self.allProductList   IsAsc:isAsc IsProfit:isProfit];
    self.shortProductList = [self crfSequenceArray:self.shortProductList IsAsc:isAsc IsProfit:isProfit];
    self.midProductList   = [self crfSequenceArray:self.midProductList   IsAsc:isAsc IsProfit:isProfit];
    self.longProductList  = [self crfSequenceArray:self.longProductList  IsAsc:isAsc IsProfit:isProfit];
    switch (self.productType) {
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

- (void)filterProductWithType:(NSString *)type {
    self.filterType = type;
    if ([type isEqualToString:@"Profit_asc"]) {//收益率 低 到 高
        [self filterArrayTypeIsAsc:YES AndProfit:YES];
    } else if ([type isEqualToString:@"Profit_dec"]){//收益率 高 到 低
        [self filterArrayTypeIsAsc:NO AndProfit:YES];
    } else if ([type isEqualToString:@"Remain_asc"]){//剩余天数 升序
        [self filterArrayTypeIsAsc:YES AndProfit:NO];
    } else if ([type isEqualToString:@"Remain_dec"]){//剩余天数 降序
        [self filterArrayTypeIsAsc:NO AndProfit:NO];
    }
    [self filterProductPayType:self.payBtnTitle IsMonthSelected:self.monthSelected AndBedueSelected:self.bedueSelected];
}

- (void)filterProductPayType:(NSString *)type IsMonthSelected:(BOOL)isSelected AndBedueSelected:(BOOL)dueSelected {
    self.payBtnTitle = type;
    self.monthSelected = isSelected;
    self.bedueSelected = dueSelected;
        switch (self.productType) {
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
    if ([type isEqualToString:@"按月付息"]) {
        if (isSelected) {
            NSMutableArray *array1 = [NSMutableArray new];
            for (int i = 0; i<self.allProductList.count; i++) {
                CRFProductModel *model = [self.allProductList objectAtIndex:i];
                if ([model.productType isEqualToString:@"2"]) {
                    [array1 addObject:model];
                }
            }
            NSMutableArray *array2= [NSMutableArray new];
            for (int i = 0; i<self.shortProductList.count; i++) {
                CRFProductModel *model = [self.shortProductList objectAtIndex:i];
                if ([model.productType isEqualToString:@"2"]) {
                    [array2 addObject:model];
                }
            }
            NSMutableArray *array3= [NSMutableArray new];
            for (int i = 0; i<self.midProductList.count; i++) {
                CRFProductModel *model = [self.midProductList objectAtIndex:i];
                if ([model.productType isEqualToString:@"2"]) {
                    [array3 addObject:model];
                }
            }
            NSMutableArray *array4= [NSMutableArray new];
            for (int i = 0; i<self.longProductList.count; i++) {
                CRFProductModel *model = [self.longProductList objectAtIndex:i];
                if ([model.productType isEqualToString:@"2"]) {
                    [array4 addObject:model];
                }
            }
            switch (self.productType) {
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
    } else if ([type isEqualToString:@"到期付息"]) {
        if (dueSelected) {
            NSMutableArray *array1 = [NSMutableArray new];
            for (int i = 0; i < self.allProductList.count; i ++) {
                CRFProductModel *model = [self.allProductList objectAtIndex:i];
                if (![model.productType isEqualToString:@"2"]) {
                    [array1 addObject:model];
                }
            }
            NSMutableArray *array2 = [NSMutableArray new];
            for (int i = 0; i < self.shortProductList.count; i ++) {
                CRFProductModel *model = [self.shortProductList objectAtIndex:i];
                if (![model.productType isEqualToString:@"2"]) {
                    [array2 addObject:model];
                }
            }
            NSMutableArray *array3= [NSMutableArray new];
            for (int i = 0; i < self.midProductList.count; i++) {
                CRFProductModel *model = [self.midProductList objectAtIndex:i];
                if (![model.productType isEqualToString:@"2"]) {
                    [array3 addObject:model];
                }
            }
            NSMutableArray *array4= [NSMutableArray new];
            for (int i = 0; i < self.longProductList.count; i ++) {
                CRFProductModel *model = [self.longProductList objectAtIndex:i];
                if (![model.productType isEqualToString:@"2"]) {
                    [array4 addObject:model];
                }
            }
            switch (self.productType) {
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
    } else {
        [self.mainTableView reloadData];
    }
}
#pragma mark Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.resultList.count) {
        _noProductLabel.hidden = YES;
    } else {
        _noProductLabel.hidden = NO;
    }
    return self.resultList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFProductModel *productInfo = [self.resultList objectAtIndex:indexPath.row];
    if ([productInfo.type isEqualToString:@"4"]) {
        CRFInvestListCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFInvestListCellId];
        cell.productModel = productInfo;
        return cell;
    } else {
        CRFInvestProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFInvestProductCellId];
        cell.product = productInfo;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel *productInfo = [self.resultList objectAtIndex:indexPath.row];
    DLog(@"点击选中 %@",productInfo.productName);
    [CRFAPPCountManager setEventID:@"INVEST_PRODUCT_EVENT" EventName:productInfo.productName];//埋点
    CRFProductDetailViewController *investDetailVC = [CRFProductDetailViewController new];
    investDetailVC.productNo = productInfo.contractPrefix;
    investDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:investDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFProductModel * productInfo = [self.resultList objectAtIndex:indexPath.row];
    if (![productInfo.type isEqualToString:@"4"]) {
        if ([productInfo.productType isEqualToString:@"3"]) {
            if (productInfo.tipsStart && productInfo.tipsStart.length > 0) {
                return 90;
            }else{
                return 83;
            }
        }
        return 83;
    }
    return 86;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainTableView) {
        if (!self.activityTitles.count) {
            return;
        }
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        DLog(@"contentsize is %f",contentOffsetY);
        if(scrollView.contentSize.height<kScreenHeight-KHeadViewHeight-44-36){
            [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(36);
            }];
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KHeadViewHeight+80);
            }];
            [_investFilterView crfTopLineHidden:YES];
            return;
        }
        if (self.activityTitles.count) {
            if (contentOffsetY>0&&contentOffsetY<37) {
                DLog(@"scrollview contentoffset :%f",contentOffsetY);
                [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(KHeadViewHeight+44);
                }];
                [_investFilterView crfTopLineHidden:NO];
            }else if(contentOffsetY>36){
                [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(KHeadViewHeight+44);
                }];
                
                [_investFilterView crfTopLineHidden:NO];
            }else{
                [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(36);
                }];
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(KHeadViewHeight+80);
                }];
                [_investFilterView crfTopLineHidden:YES];
            }
            [UIView animateWithDuration:0.1 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
    else {
        
    }
    
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
#pragma mark === Setter getter===
- (CRFInvestHead *)investHeadView {
    if(!_investHeadView){
        _investHeadView = [[CRFInvestHead alloc] init];
        _investHeadView.backgroundColor = [UIColor whiteColor];
        _investHeadView.delegate = self;
       
    }
    return _investHeadView;
}
- (UUMarqueeView *)activityView {
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

- (CRFInvestFilterView *)investFilterView {
    if (!_investFilterView) {
        _investFilterView = [[CRFInvestFilterView alloc]init];
        _investFilterView.filterDelegate = self;
        [_investFilterView crfTopLineHidden:YES];
        
    }
    return _investFilterView;
}
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-kTabBarHeight)];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mainScrollView;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor clearColor];
        [_containerView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panExclusivePlan:)]];
    }
    return _containerView;
}
-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView setSeparatorColor:kCellLineSeparatorColor];
        [_mainTableView registerClass:[CRFInvestListCell class] forCellReuseIdentifier:CRFInvestListCellId];
        [_mainTableView registerClass:[CRFInvestProductCell class] forCellReuseIdentifier:CRFInvestProductCellId];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.rowHeight = 86;
    }
    return _mainTableView;
}

- (NSMutableArray *)activityTitles {
    if (!_activityTitles) {
        _activityTitles =[CRFAppCache getInvestRecord];
    }
    return _activityTitles;
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
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, kNavigationbarHeight)];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}
-(UIImageView *)exclusiveImageView{
    if (!_exclusiveImageView) {
        _exclusiveImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exclusive_banner"]];
//        _exclusiveImageView.contentMode = UIViewContentModeCenter;
        _exclusiveImageView.userInteractionEnabled = YES;
        [_exclusiveImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exclusiveplanTap)]];
    }
    return _exclusiveImageView;
}
-(UIView *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 114)];
        UIButton *exclusiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exclusiveBtn.layer.masksToBounds = YES;
        exclusiveBtn.layer.cornerRadius  = 16;
        exclusiveBtn.layer.borderColor = UIColorFromRGBValue(0xee5250).CGColor;
        exclusiveBtn.layer.borderWidth = 1.f;
        [exclusiveBtn addTarget:self action:@selector(makeExclusiveplan:) forControlEvents:UIControlEventTouchUpInside];
        [exclusiveBtn setTitle:@"定制我的特供计划" forState:UIControlStateNormal];
        [exclusiveBtn setTitleColor:UIColorFromRGBValue(0xee5250) forState:UIControlStateNormal];
        exclusiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        exclusiveBtn.frame = CGRectMake((kScreenWidth-144)/2, 40, 144, 32);
        [_tableViewFooter addSubview:exclusiveBtn];
        
    }
    return _tableViewFooter;
}
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _helpView.title = @"特供计划";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth - 40, kStatusBarHeight + kNavigationbarHeight / 2.0)];
        [_helpView drawContent:_exclusiveItem?_exclusiveItem.content:@"特供计划是信而富为不同风险偏好的出借人推出的出借工具。可根据您的出借意向，为您筛选符合您风险偏好的出借计划。目前仅对“进取型”风险偏好的用户开放。"];
    }
    return _helpView;
}
-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
