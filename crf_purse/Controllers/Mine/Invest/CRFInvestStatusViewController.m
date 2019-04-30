//
//  CRFInvestStatusViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestStatusViewController.h"
#import "CRFInvestStatusTableViewCell.h"
#import "UITableViewCell+Access.h"
#import "CRFStringUtils.h"
#import "CRFInvestTrendsViewController.h"
#import "CRFInvestUserViewController.h"
#import "CRFCreditorViewController.h"
#import "CRFOrderDetailViewController.h"
#import "CRFQAView.h"
#import "CRFSelTargetViewController.h"
#import "CRFSelContractViewController.h"
#import "CRFRedeemView.h"
#import "CRFInvestOperaStatusViewController.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFMyInvestViewController.h"
#import "CRFInvestOutRecordViewController.h"
#import "CRFShiftInInvestmentView.h"
#import "CRFCouponVC.h"
#import "CRFComplianceBillViewController.h"
#import "CRFNCPClaimViewController.h"
#import "CRFAlertUtils.h"
#import "UIImage+Color.h"
#import "CRFQueryRedeemInfo.h"
#import "CRFInvestStatusBottomView.h"
#import "CRFAppointmentForwardViewController.h"
#import "CRFAppointmentForwardInfoViewController.h"
#import "CRFMyInvestViewController.h"
#import "CRFCommonResultViewController.h"

#import "CRFFooterSwitchView.h"
#import "CRFShowSwitchAlert.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFShowSwitchAlert.h"
#import "CRFExclusiveModel.h"
#import "CRFActionSheetView.h"
#import "CRFHomeConfigHendler.h"
#import "CRFInvestStatusReturnMoneyController.h"
@interface CRFInvestStatusViewController () <UITableViewDelegate, UITableViewDataSource, CRFRedeemViewDelegate, CRFShiftInInvestmentViewDelegate,CRFInvestStatusTableViewCellDelegate> {
    CGFloat sectionHeight;
    NSString *headerString;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CRFInvestStatusBottomView *bottomView;
@property (nonatomic, strong) NSArray <NSString *>*datas;
@property (nonatomic, strong) NSArray <UIImage *>*images;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *profitHelpView;

@property (nonatomic, strong) NSArray <CRFCouponModel*> *couponArray;
@property (nonatomic, strong) CRFShowSwitchAlert *alertView;
@property (nonatomic ,strong)NSArray  *helpSource;
@property (nonatomic, strong) CRFExclusiveModel  *helpItem;

@property (nonatomic, strong) CRFActionSheetView *actionView;
/**
 出资协议
 */
@property (nonatomic, strong) NSArray <CRFProtocol *>*protocols;
/**
 产品详情
 */
@property (nonatomic, strong) CRFProductDetail *productDetail;

/**
 顶部帮助说明
 */
@property (nonatomic, strong) CRFQAView *qaView;

/**
 转投view
 */
@property (nonatomic, strong) CRFShiftInInvestmentView *investmentView;

/**
 退出view
 */
@property (nonatomic, strong) CRFRedeemView *redeemView;

@property (nonatomic, strong) CRFFooterSwitchView *footerView;
@end

@implementation CRFInvestStatusViewController

- (void)back {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"CRFMyInvestViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}
-(NSArray *)helpSource{
    if (!_helpSource) {
        _helpSource = [[NSArray alloc]init];
    }
    return _helpSource;
}
-(CRFActionSheetView*)actionView{
    if (!_actionView) {
        NSArray *items = @[@"自动续投",@"债转退出"];
        _actionView = [[CRFActionSheetView alloc]initWithCancelStr:@"取消" otherButtonTitles:items attachTitle:nil];
    }
    return _actionView;
}
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _helpView.title = @"到期处理方式说明";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth , 0)];
//        [_helpView drawContent:@"若用户开启到期自动续投功能，原出借计划到期后将自动转投至利率为4.80~5.20%的出借计划，此出借计划可免费申请退出，也可转投其他符合条件的出借计划。"];
        [_helpView drawContent:_helpItem.content.length?_helpItem.content:@"出借计划到期后将有两种处理方式：\n1.自动续投：原计划到期后将自动加入至期望年化收益率为4.80%~5.20%的出借计划。\n2.债转退出：原计划到期后，您可以通过债权转让的方式进行退出，信而富平台将协助您办理债权转让事宜，具体债转时间由市场决定。"];
    }
    return _helpView;
}
- (CRFAppointmentForwardHelpView *)profitHelpView {
    if (!_profitHelpView) {
        _profitHelpView = [CRFAppointmentForwardHelpView new];
        _profitHelpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _profitHelpView.title = @"到期预期收益";
        [_profitHelpView setDissmissPoint:CGPointMake(kScreenWidth , 0)];
        [_profitHelpView drawContent:@"该数字为基于历史表现，本金和收益循环复投一年的测算数据，不视为承诺收益。实际收益以最终结算支付为准。"];
    }
    return _profitHelpView;
}
- (CRFInvestStatusBottomView *)bottomView {
    if (!_bottomView) {
        CRFProductStatus productStatus = CRFProductStatusCanRedeemAndShiftInInvestment;
        if (![CRFUtils complianceProduct:self.product.investSource] && self.product.investStatus.integerValue == 2 && self.product.proType.integerValue != 3) {
        } else if ([self productAppointmentForward]) {//可预约转投
            productStatus = CRFProductStatusAppointmentInShiftInInvestment;
        } else if ([self alerdyAppointmentForward]) {//查看预约转投详情
            productStatus = CRFProductStatusViewAppointmentInShiftInInvestmentInfo;
        } else if ([self autoInvestment]) {//自动退出、转投
            productStatus = CRFProductStatusAutoInvest;
            //转投中
        } else if (self.productDetail.forwardType.integerValue == 2 && self.productDetail.investStatus.integerValue == 6) {
            //查看转投详情
            productStatus = CRFProductStatusViewAutoInvestInfo;
        }
        weakSelf(self);
        _bottomView = [[CRFInvestStatusBottomView alloc] initWithProductStatus:productStatus eventHandler:^(CRFProductStatus status, NSInteger index) {
            strongSelf(weakSelf);
            if (status == 0) {
                if (index == 0) {
                    [strongSelf redeem];
                } else {
                    [strongSelf forward];
                }
            } else if (status == 1) {
                [strongSelf appointmentForward];
            } else if (status == 2) {
                [strongSelf viewAppointmentForwardInfo];
            } else if (status == 3) {
                //自动转投
                if (index == 0) {
                    [strongSelf applyLogout];
                } else {
                    [strongSelf autoInvest];
                }
            } else if (status == 4) {
                //查看自动转投详情
                [strongSelf viewLogoutInfo];
            }
        }];
    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.scrollEnabled = YES;
        [self autoLayoutSizeContentView:_tableView];
    }
    return _tableView;
}

- (CRFRedeemView *)redeemView {
    if (!_redeemView) {
        _redeemView = [[[NSBundle mainBundle] loadNibNamed:@"CRFRedeemView" owner:nil options:nil] lastObject];
        _redeemView.delegate = self;
    }
    return _redeemView;
}

- (CRFShiftInInvestmentView *)investmentView {
    if (!_investmentView) {
        _investmentView = [CRFShiftInInvestmentView new];
        _investmentView.investmentDelegate = self;
        _investmentView.accountAmount = self.product.accountAmount;
    }
    return _investmentView;
}

- (CRFQAView *)qaView {
    if (!_qaView) {
        _qaView = [[[NSBundle mainBundle] loadNibNamed:@"CRFQAView" owner:nil options:nil] lastObject];
        _qaView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
    return _qaView;
}
-(CRFFooterSwitchView *)footerView{
    if (!_footerView) {
        _footerView = [[CRFFooterSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    return _footerView;
}
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self conNavTitle];
    [self initializeView];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self getProductInfo];
    [self configProtocol];
    [self getXTTips];
}

- (void)factoryDataSource {
    if (self.productDetail.investStatus.integerValue == 2 || self.productDetail.investStatus.integerValue == 3 || self.productDetail.investStatus.integerValue == 5 || self.productDetail.investStatus.integerValue == 6) {
        self.type = 1;
    } else if (self.productDetail.investStatus.integerValue == 4 || self.productDetail.investStatus.integerValue == 7 || self.productDetail.investStatus.integerValue == 10 || self.productDetail.investStatus.integerValue == 12 || self.productDetail.investStatus.integerValue == 31) {
        self.type = 2;
    } else if (self.productDetail.investStatus.integerValue == 1 || self.productDetail.investStatus.integerValue == 11) {
        self.type = 0;
    }
    NSArray <NSArray *>* list = [CRFDataSourceFactory factoryInvestDetailDataSource:[self.productDetail.source integerValue] productType:[self.productDetail.proType integerValue] status:self.type];
    self.datas = list.firstObject;
    self.images = list.lastObject;
}

- (void)initializeView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(kNavHeight);
    }];
    weakSelf(self);
    self.refreshProductInfo = ^{
        strongSelf(weakSelf);
        [strongSelf getProductInfo];
        for (UIViewController *controller in strongSelf.navigationController.viewControllers) {
            if ([controller isKindOfClass:[CRFMyInvestViewController class]]) {
                CRFMyInvestViewController *vc = (CRFMyInvestViewController *)controller;
                if (vc.refreshProduct) {
                    vc.refreshProduct();
                }
                break;
            }
        }
    };
    if (self.type == 1) {
        if (![CRFUtils complianceProduct:self.product.investSource]) {
            if (self.product.investStatus.integerValue == 2 && self.product.proType.integerValue != 3) {
                [self.view addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.height.mas_equalTo(50);
                }];
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).with.offset(-50);
                }];
                if (self.product.proType.integerValue == 4 || self.product.remainDays.integerValue == 0) {
                    [self.bottomView setEnable:YES];
                    [self.investmentView addInView:self.view];
                    [self.redeemView addView:self.view];
                    [self getCouponsList];
                } else {
                    [self.bottomView setEnable:NO];
                }
            }
        }
    }
}

- (void)addAppointmentForwardView {
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
    /*
     已结束的产品 底部按钮不显示
     */
    if (!(self.productDetail.investStatus.integerValue == 4||self.productDetail.investStatus.integerValue == 7||self.productDetail.investStatus.integerValue == 10||self.productDetail.investStatus.integerValue == 12||self.productDetail.investStatus.integerValue == 31)) {
        if ([self productAppointmentForward] || [self alerdyAppointmentForward] || [self autoInvestment] || self.productDetail.investStatus.integerValue == 6) {
            [self.view addSubview:self.bottomView];
//            [self setRightButtonDisplay:YES];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.mas_equalTo(50);
            }];
        }
    }
    
}

- (void)setCustomRightButton {
    if ([CRFUtils complianceProduct:self.product.investSource] && self.productDetail.investStatus.integerValue == 2 && (self.productDetail.isrede.integerValue == 2)) {
        if (self.productDetail.isApplyForward == 2) {
            [self setRightButtonDisplay:YES];
        }
        if ([self alerdyAppointmentForward]) {
            return;
        }
        [self setCustomRightBarButtonWithImageNamed:@"more" target:self selector:@selector(showAdvanceRedeemPopView)];
    }
}

- (void)showAdvanceRedeemPopView {
    weakSelf(self);
    [CRFAlertUtils actionSheetWithItems:@[@"申请债转退出"] container:self cancelTitle:@"关闭" completeHandler:^(NSInteger index) {
        strongSelf(weakSelf);
        [strongSelf checkAdvanceRedeemInfo];
    } cancelHandler:nil];
}
-(void)setTablViewFooterSwitch{
    self.footerView.protocolArr = self.protocols;
    CGFloat height = self.footerView.LinkHeight;
    self.footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    if ([self.productDetail.investStatus isEqualToString:@"2"]) {
        if ([self.productDetail.isCancelZdxt isEqualToString:@"3"]||self.productDetail.isApplyForward == 2||self.productDetail.proType.integerValue ==4) {
            self.tableView.tableFooterView = nil;
        }else{
            self.tableView.tableFooterView =self.footerView;
            if ([self.productDetail.isCancelZdxt isEqualToString:@"1"]) {
                [self.footerView updateLabelTitleString:@"自动续投"];
            }else if ([self.productDetail.isCancelZdxt isEqualToString:@"2"]) {
                [self.footerView updateLabelTitleString:@"债转退出"];
            }
            
            weakSelf(self);
            [self.footerView setHelpBlock:^{
                [weakSelf showHelpView];
            }];
            [self.footerView setSwitchBlock:^{
                [weakSelf setSwitchApply];
            }];
            [self.footerView setPushBlock:^(NSString *url) {
                [weakSelf crf_pushPotocol:url];
            }];
        }
    }else{
        self.tableView.tableFooterView = nil;
    }
//    self.tableView.tableFooterView =self.footerView;
//    [self.footerView updateLabelTitleString:@"自动续投"];
//    weakSelf(self);
//    [self.footerView setHelpBlock:^{
//        [weakSelf showHelpView];
//    }];
//    [self.footerView setSwitchBlock:^{
//        [weakSelf setSwitchApply];
//    }];
//    [self.footerView setPushBlock:^(NSString *url) {
//        [weakSelf crf_pushPotocol:url];
//    }];
}
//-(void)setAlertBtnTitle{
//    if ([self.productDetail.isCancelZdxt isEqualToString:@"1"]) {
//        [self.alertView changeButtonTitle:@"关闭到期自动续投" Content:_helpItem.content_open.length?_helpItem.content_open:@"目前已开启到期自动续投，原计划到期后将自动续投至利率为4.80~5.20%的出借计划。"];
//    }else if([self.productDetail.isCancelZdxt isEqualToString:@"2"]){
//        [self.alertView changeButtonTitle:@"开启到期自动续投" Content:_helpItem.content_close.length?_helpItem.content_close:@"目前已关闭到期自动续投，原计划到期后将不会续投至利率为4.80~5.20%的出借计划。"];
//    }
//}
-(void)showHelpView{
    [_helpView drawContent:_helpItem.content.length?_helpItem.content:@"出借计划到期后将有两种处理方式：\n1.自动续投：原计划到期后将自动加入至期望年化收益率为4.80%~5.20%的出借计划。\n2.债转退出：原计划到期后，您可以通过债权转让的方式进行退出，信而富平台将协助您办理债权转让事宜，具体债转时间由市场决定。"];
    [self.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:nil];
}
-(void)setSwitchApply{
//    _alertView =[[CRFShowSwitchAlert alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) AlertTitle:@"温馨提示" content:@"" dismissHandler:^{
//
//    } confirmHandler:^{
//        [weakSelf sendApplySwitch];
//    }];
//    [self setAlertBtnTitle];
//    [_alertView showInView:[UIApplication sharedApplication].delegate.window];
    
    [self.actionView show_leActionView];
    if ([self.productDetail.isCancelZdxt isEqualToString:@"1"]) {
        [self.actionView changeImageIndex:1 ShowImage:YES];
    }else if ([self.productDetail.isCancelZdxt isEqualToString:@"2"]) {
        [self.actionView changeImageIndex:2 ShowImage:YES];
    }

    weakSelf(self);
    _actionView.selectButtonAtIndex = ^(NSInteger index){
        [weakSelf setImageIndex:index];
    };
}
-(void)setImageIndex:(NSInteger)index{
    NSString *content;
    weakSelf(self);
    if (self.productDetail.isCancelZdxt.integerValue != index) {
        if (index == 1) {
            content = _helpItem.content_open.length?_helpItem.content_open:@"您将选择“自动续投”的到期处理方式,原计划到期后将自动加入至期望年化收益率为4.80%~5.20%的出借计划。";
            [CRFAlertUtils showAlertMidMessage:[CRFStringUtils setAttributedString:content lineSpace:5 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[content rangeOfString:@"“自动续投”"] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero attributes5:nil range5:NSRangeZero attributes6:nil range6:NSRangeZero] container:self cancelTitle:@"取消" confirmTitle:@"确认" cancelHandler:^{
                
            } confirmHandler:^{
                strongSelf(weakSelf);
                [strongSelf sendApplySwitch];
            }];
            
        }else if (index == 2){
            content = _helpItem.content_close.length?_helpItem.content_close:@"您将选择“债转退出”的到期处理方式，原计划到期后，您可以通过债权转让的方式进行退出，退出时间由市场决定。";
            [CRFAlertUtils showAlertMidMessage:[CRFStringUtils setAttributedString:content lineSpace:5 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[content rangeOfString:@"“债转退出”"] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero attributes5:nil range5:NSRangeZero attributes6:nil range6:NSRangeZero] container:self cancelTitle:@"取消" confirmTitle:@"确认" cancelHandler:^{
                
            } confirmHandler:^{
                strongSelf(weakSelf);
                [strongSelf sendApplySwitch];
            }];
        }
    }
    
}
-(void)setIsCancelZdxtValue{
    if ([self.productDetail.isCancelZdxt isEqualToString:@"1"]) {
        self.productDetail.isCancelZdxt = @"2";
        [self.actionView changeImageIndex:2 ShowImage:YES];
        [self.actionView changeImageIndex:1 ShowImage:NO];
    }else if([self.productDetail.isCancelZdxt isEqualToString:@"2"]){
        self.productDetail.isCancelZdxt = @"1";
        [self.actionView changeImageIndex:1 ShowImage:YES];
        [self.actionView changeImageIndex:2 ShowImage:NO];
    }
//    [self setAlertBtnTitle];
    [self setTablViewFooterSwitch];
}
-(void)sendApplySwitch{
    [CRFLoadingView loading];
    weakSelf(self);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.productDetail.investNo forKey:@"investNo"];
    [param setValue:[self.productDetail.isCancelZdxt isEqualToString:@"1"]?@"cancel":@"apply" forKey:@"type"];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestContinutionPath),kUuid] paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [weakSelf setIsCancelZdxtValue];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)checkAdvanceRedeemInfo {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kQueryRedeemInfoPath),kUuid] paragrams:@{@"investNo":self.productDetail.investNo} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        CRFQueryRedeemInfo *redeemInfo = [CRFQueryRedeemInfo yy_modelWithJSON:response[kDataKey]];
        [strongSelf advanceLogout:redeemInfo];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)advanceLogout:(CRFQueryRedeemInfo *)info {
    NSString *string = [NSString stringWithFormat:@"尊敬的客户：\n您出借的%@（编号：%@）截止到今（%@），总资产为%@元。申请债转退出成功后将收取总资产%@服务费。债权转让成功前，您仍持有债权并继续计算收益。",self.productDetail.productName,self.productDetail.investNo,info.deadLine,info.totalAssets,info.serviceCharge];
    weakSelf(self);
    [CRFAlertUtils showAlertMessage:[CRFStringUtils setAttributedString:string lineSpace:5 attributes1:@{NSForegroundColorAttributeName:kTextDefaultColor} range1:[string rangeOfString:self.productDetail.productName] attributes2:@{NSForegroundColorAttributeName:kTextDefaultColor} range2:[string rangeOfString:self.productDetail.investNo] attributes3:@{NSForegroundColorAttributeName:kTextDefaultColor} range3:[string rangeOfString:info.deadLine] attributes4:@{NSForegroundColorAttributeName:kTextDefaultColor} range4:[string rangeOfString:info.totalAssets] attributes5:@{NSForegroundColorAttributeName:kButtonNormalBackgroundColor} range5:[string rangeOfString:info.serviceCharge] attributes6:@{NSForegroundColorAttributeName:kTextDefaultColor} range6:[string rangeOfString:info.actualAmount]] container:self cancelTitle:@"取消" confirmTitle:@"确认债转" cancelHandler:^{
        NSLog(@"cancel logout");
    } confirmHandler:^{
        strongSelf(weakSelf);
        [strongSelf productLogout];
    }];
}
-(void)parseDataArray:(NSArray*)dataArray{
    if (dataArray.count) {
        CRFAppHomeModel *model = dataArray[0];
        CRFExclusiveModel *exculsiveModel =[CRFExclusiveModel yy_modelWithDictionary:[CRFUtils dictionaryWithJsonString:model.content]];
        _helpItem = exculsiveModel;
        _helpItem.title = _helpItem.title.length?_helpItem.title:@"到期处理方式说明";
        [_helpView drawContent:_helpItem.content];
    }
}
-(void)getXTTips{
    weakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kHomePageArea_key,@"remain_tips"] ;
    [[CRFStandardNetworkManager defaultManager] get:url success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.helpSource = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:@"remain_tips"];
        [strongSelf parseDataArray:strongSelf.helpSource];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        
    }];
}
- (void)productLogout {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kAdvanceRedeemPath),kUuid] paragrams:@{@"investNo":self.productDetail.investNo,@"redeemType":self.productDetail.isAbleFlexibleredeem.integerValue == 2 ? @"1" : @"2"} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        strongSelf(weakSelf);
        [CRFUtils delayAfert:1.5 handle:^{
            if (strongSelf.productDetail.isAbleFlexibleredeem.integerValue == 2) {
                [strongSelf applyLogoutFeadback];
            } else {
                for (UIViewController *vc in strongSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CRFMyInvestViewController class]]) {
                        CRFMyInvestViewController *myViewController = (CRFMyInvestViewController *)vc;
                        if (myViewController.refreshProduct) {
                            myViewController.refreshProduct();
                        }
                    }
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
/**
 获取协议
 */
- (void)configProtocol {
    
    NSString *productKey = kRule_invest_protocal;
    self.protocols = [CRFHomeConfigHendler defaultHandler].investRuleProtocols;
    if (self.protocols.count <= 0) {
        [self reloadProtocolListWithKey:productKey];
    }
}
- (void)reloadProtocolListWithKey:(NSString *)key {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kHomePageArea_key,kRule_invest_protocal] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.protocols = [CRFResponseFactory handleProtocolForResult:response ForKey:key];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)getProductInfo {
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestProductDetailPath),kUuid] paragrams:@{@"investId":self.product.investId,@"investSource":self.product.investSource,@"status":self.product.investStatus,@"source":self.product.source,@"investNo":self.product.investNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        NSLog(@"response is %@",response);
        //[@"investDetail"]
        strongSelf.productDetail = [CRFProductDetail yy_modelWithJSON:response[kDataKey][@"investDetail"]];
        if (strongSelf.type == 1 && ![CRFUtils complianceProduct:self.product.investSource] && strongSelf.product.investStatus.integerValue == 2 && strongSelf.product.proType.integerValue != 3 && (strongSelf.product.proType.integerValue == 4 || strongSelf.product.remainDays.integerValue == 0)) {
            strongSelf.redeemView.accountAmount = strongSelf.productDetail.investAmount;
        }
        [strongSelf factoryDataSource];
//        [strongSelf setCustomRightButton];
        [strongSelf addAppointmentForwardView];
        [strongSelf setTablViewFooterSwitch];
        [strongSelf.tableView reloadData];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
/**
 获取用户优惠券
 */
- (void)getCouponsList{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetUserGiftPath),kUuid] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        strongSelf.couponArray = [CRFResponseFactory handleCouponData:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

/**
 退出view弹起
 */
- (void)redeem {
    [self.redeemView show];
}

/**
 转投view弹起
 */
- (void)forward {
    [self.investmentView show];
}

/**
 选择优惠券
 */
- (void)selectedCoupon {
    CRFCouponVC *couponVC = [CRFCouponVC new];
    couponVC.planNo = self.investmentView.selctedProduct.contractPrefix;
    couponVC.investAmount = self.product.accountAmount;
    couponVC.selectedCoupon = self.investmentView.selectedCoupon;
    weakSelf(self);
    [couponVC setCouponDidSelectedHandler:^(CRFCouponModel *coupon){
        strongSelf(weakSelf);
        strongSelf.investmentView.selectedCoupon = coupon;
    }];
    [self.navigationController pushViewController:couponVC animated:YES];
}

/**
 自动选择最优优惠券
 */
-(void)recommendCoupon:(CRFProductModel*)productInfo{
    if (self.couponArray.count) {
        CRFCouponModel *coupon;
        if (![productInfo.type isEqualToString:@"4"]) {
            coupon  = [CRFUtils selectedBestWithArray:self.couponArray ForMoney:self.product.accountAmount AndFreezid:productInfo.freezePeriod.integerValue days:360 type:self.productDetail.proType.integerValue == 1];
        } else {
            coupon  = [CRFUtils selectedBestWithArray:self.couponArray ForMoney:self.product.accountAmount AndFreezid:(productInfo.remainDays.integerValue - 1) days:365 type:self.productDetail.proType.integerValue == 1];
        }
        self.investmentView.selectedCoupon = coupon;
    }
}
/**
 选择转投产品
 */
- (void)chooseProduct {
    [self chooseMoreProduct];
}
/**
 转投
 */
- (void)shiftInInvestment {
    NSString *amount = [NSString stringWithFormat:@"%.0f",[[self.product.accountAmount getOriginString] doubleValue] * 100];
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kTrandferProductPath),kUuid] paragrams:@{@"amount":amount,@"mobilePhone":[CRFAppManager defaultManager].userInfo.phoneNo,@"investId":self.product.investId,@"planNo":self.investmentView.selctedProduct.contractPrefix,@"giftDetailId":self.investmentView.selectedCoupon? self.investmentView.selectedCoupon.giftDetailId:@"",@"source":self.product.source,@"verifyCode":self.investmentView.verifyCode} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf pustResultController:Opera_Transform];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

/**
 打开协议链接
 
 @param url url
 */
- (void)openInvestProtocol:(NSURL *)url {
    CRFStaticWebViewViewController *controller = [CRFStaticWebViewViewController new];
    controller.urlString = url.absoluteString;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 更新layout
 
 @param duration 动画时间
 */
- (void)updateViewLayoutWithAnimationDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 转投操作
 
 @param code void
 */
- (void)ransom:(NSString *)code {
    NSString *amount = [NSString stringWithFormat:@"%.0f",[[self.productDetail.investAmount getOriginString] doubleValue] * 100];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kProductRedemptionPath),kUuid] paragrams:@{kMobilePhone:[CRFAppManager defaultManager].userInfo.phoneNo,kVerifyCode:code,@"investId":self.product.investId,@"source":self.product.source,@"productName":self.productDetail.productName,@"ransomAmount":amount} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf pustResultController:Opera_Logout];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

/**
 选择转投产品
 */
- (void)chooseMoreProduct {
    CRFSelTargetViewController *controller = [CRFSelTargetViewController new];
    controller.investment = self.product.accountAmount;
    weakSelf(self);
    [controller setDidSelectedProduct:^(CRFProductModel *product){
        strongSelf(weakSelf);
        strongSelf.investmentView.selctedProduct = product;
        [strongSelf recommendCoupon:product];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)conNavTitle {
    NSString *string = [NSString stringWithFormat:@"%@\n（出借编号：%@）",self.product.productName,self.product.investNo];
    [self setCustomAttributedTitle:string lineSpace:3 attributedContent:self.product.productName attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} subContent:[NSString stringWithFormat:@"（出借编号：%@）",self.product.investNo] subAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)}];
    [super customNavigationBackForBlack];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasDynamic]) {
        if (section == 2) {
            return self.datas.count;
        }
        return self.productDetail ? 1 : 0;
    } else {
        if (section == 1) {
            return  self.datas.count;
        }
        return self.productDetail ? 1 : 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![self hasDynamic]) {
        return self.productDetail ? 2 : 0;
    }
    return self.productDetail ? 3 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return kTopSpace / 2.0;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self hasDynamic]) {
        if (section == 0 || section == 1) {
            return CGFLOAT_MIN;
        }
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }
    }
    return kTopSpace / 2.0;
}

/**
 绘制出资动态的cell
 
 @param tableView tableView
 @param indexPath indexPath
 @return value
 */
- (CRFInvestStatusTableViewCell *)configDynamicCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    CRFInvestStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestDynamicCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestStatusTableViewCell" owner:nil options:nil] objectAtIndex:1];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    weakSelf(self);
    [cell setInvestDynamicHelpHandler:^{
        strongSelf(weakSelf);
        [strongSelf.qaView show];
    }];
    if ([self needAutoInvestAccessViewNone]) {
        cell.autoInvestDynamicInfo = self.productDetail ? self.productDetail : self.product;
        [cell setAccessoryViewNone];
    } else {
        if (self.productDetail) {
            self.product.exitDate = self.productDetail.exitDate;
        }
        cell.dynamicType = self.type;
        cell.originProduct = self.product;
         cell.product = self.productDetail;
         [cell setAccessoryImageView];
    }
    return cell;
}

/**
 绘制出资信息的cell
 
 @param tableView tableView
 @param indexPath indexPath
 @return cell
 */
- (CRFInvestStatusTableViewCell *)configInvestInfoCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    if ([self needAutoInvestAccessViewNone]) {
        CRFInvestStatusTableViewCell *autoInvestCell = [tableView dequeueReusableCellWithIdentifier:@"autoInvest"];
        if (!autoInvestCell) {
            autoInvestCell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestStatusTableViewCell" owner:nil options:nil] objectAtIndex:3];
        }
        autoInvestCell.autoInvestProduct = self.productDetail;
        return autoInvestCell;
    }
    CRFInvestStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.type == 2 ? @"endInvestCell" : @"headerCell"];
    if (!cell) {
        if (self.type == 2) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestStatusTableViewCell" owner:nil options:nil] lastObject];
        } else {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestStatusTableViewCell" owner:nil options:nil] firstObject];
        }
    }
    cell.delegate = self;
    cell.originProduct = self.product;
    cell.type = self.type;
    cell.days = [self.product getBearingDays];
    cell.waitDays = [self.product.queueDays integerValue];
    if (self.type == 2) {
        cell.endInvestProduct = self.productDetail;
    } else {
        cell.product = self.productDetail;
    }
    cell.hasAccessoryView = NO;
    return cell;
}

/**
 绘制通用的cell
 
 @param tableView tableView
 @param indexPath indexpath
 @return cell
 */
- (CRFInvestStatusTableViewCell *)configSystemCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    CRFInvestStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (!cell) {
        //systemCell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInvestStatusTableViewCell" owner:nil options:nil] objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == self.datas.count - 1) {
            cell.hideBottomLine = YES;
        }
    }
    cell.hasAccessoryView = YES;
    cell.iconImageView.image = self.images[indexPath.row];
    cell.contentLabel.text = self.datas[indexPath.row];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasDynamic]) {
        if (indexPath.section == 0) {
            return [self configDynamicCell:tableView indexPath:indexPath];
        } else if (indexPath.section == 1) {
            return [self configInvestInfoCell:tableView indexPath:indexPath];
        } else {
            return [self configSystemCell:tableView indexPath:indexPath];
        }
    } else {
        if (indexPath.section == 0) {
            return [self configInvestInfoCell:tableView indexPath:indexPath];
        } else {
            return [self configSystemCell:tableView indexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasDynamic]) {
        if (indexPath.section == 0) {
            [self lookupStatus];
        } else if (indexPath.section == 2) {
            [self pushNextControllerWithIndexPath:indexPath];
        }
    } else {
        if (indexPath.section == 1) {
            [self pushNextControllerWithIndexPath:indexPath];
        }
    }
}
#pragma ========== CRFInvestStatusTableViewCellDelegate Method
-(void)showProfitExplainViewIsEnd:(BOOL)isEnd{
    self.profitHelpView.title = isEnd?@"累计收益":@"到期预期收益";
    [_profitHelpView drawContent:isEnd?@"该出借计划的最终结算收益。":@"该数字为基于历史表现，本金和收益循环复投一年的测算数据，不视为承诺收益。实际收益以最终结算支付为准。"];

    [self.profitHelpView show:[UIApplication sharedApplication].delegate.window dismissHandler:nil];
}

- (void)pushNextControllerWithIndexPath:(NSIndexPath *)indexPath {
    CRFBasicViewController *controller = nil;
    [CRFAPPCountManager getEventIdForKey:self.datas[indexPath.row]];
    if (indexPath.row == 0) {
        if (![self hasDynamic]) {
            controller = [CRFInvestOutRecordViewController new];
        } else {
            if (![CRFUtils normalUser]) {
                if ([CRFUtils complianceProduct:self.product.investSource]) {
                    controller = [CRFComplianceBillViewController new];
                } else {
                    controller = [CRFOrderDetailViewController new];
                }
            } else {
                
            if (self.product.protocols.count == 1) {
                controller = [CRFStaticWebViewViewController new];
                [controller setValue:[self.product.protocols firstObject].htmlUrl forKey:@"urlString"];
            } else if (self.product.protocols.count > 1) {
                [self showAlert];
            } else {
                [CRFUtils showMessage:@"请登录官网www.crfchina.com查看投资协议。"];
                return;
            }
            }
        }
    } else if (indexPath.row == 1) {
        if (![CRFUtils normalUser]) {
            if ([CRFUtils complianceProduct:self.product.investSource]) {
                controller = [CRFComplianceBillViewController new];
            } else {
                controller = [CRFOrderDetailViewController new];
            }
        } else {
        if ([CRFUtils complianceProduct:self.product.investSource]) {
            controller = [CRFComplianceBillViewController new];
        } else {
            controller = [CRFOrderDetailViewController new];
        }
        }
    } else if (indexPath.row == 2){
        if ([CRFUtils complianceProduct:self.product.investSource]) {
            controller = [CRFNCPClaimViewController new];
        } else {
            controller = [CRFCreditorViewController new];
        }
    }else{
        controller = [CRFInvestStatusReturnMoneyController new];
    }
    if (controller) {
        if (self.product && ![controller isKindOfClass:[CRFStaticWebViewViewController class]]) {
            [controller setValue:self.product forKey:@"product"];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)showAlert {
    NSMutableArray <NSString *>*protocolNames = [NSMutableArray new];
    for (CRFAgreementDto *dto in self.product.protocols) {
        [protocolNames addObject:dto.protocolName];
    }
    weakSelf(self);
    [CRFAlertUtils actionSheetWithTitle:nil message:nil container:self cancelTitle:@"关闭" items:protocolNames completeHandler:^(NSInteger index) {
        strongSelf(weakSelf);
        CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
        webViewController.urlString = strongSelf.product.protocols[index].htmlUrl;
        [strongSelf.navigationController pushViewController:webViewController animated:YES];
    } cancelHandler:nil];
}

/**
 查看动态
 */
- (void)lookupStatus {
    if (self.type == 0) {
        if ([self.product.proType integerValue] != 3 && ![CRFUtils complianceProduct:self.product.investSource]) {
            [self.qaView show];
            return;
        }
    }
    if ([self needAutoInvestAccessViewNone]) {
        return;
    }
    CRFInvestTrendsViewController *controller = [CRFInvestTrendsViewController new];
    self.product.exitDate = self.productDetail.exitDate;
    controller.product = self.product;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 是否需要有顶部文案
 
 @return value
 */
- (BOOL)hasDynamic {
    return !([self.product.source integerValue] == 2 && [self.product.proType integerValue] != 4);
}

- (void)pustResultController:(OperaStatus)state {
    CRFInvestOperaStatusViewController *controller = [CRFInvestOperaStatusViewController new];
    controller.product = self.product;
    controller.operaStatus = state;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 预约转投
 */
- (void)appointmentForward {
    weakSelf(self);
    [CRFAlertUtils showAppointmentForwardAlertMessage:[CRFStringUtils changedLineSpaceWithTotalString:@"预约转投可让您的出借计划到期结算后，直接转投到新的出借计划中。可减少您的资金闲置时间。\n预约当日不能取消，次日起至当前计划到期日前1天可随时取消预约。" lineSpace:4] container:self cancelTitle:@"取消" confirmTitle:@"预约" cancelHandler:nil confirmHandler:^{
        strongSelf(weakSelf);
        [strongSelf pushAppointmentForwardController];
    }];
}

/**
 申请退出
 */
- (void)applyLogout {
    weakSelf(self);
    [CRFAlertUtils showAlertTitle:@"信而富平台将协助您办理债权转让事宜，具体债转时间由市场决定。" message:nil container:self cancelTitle:@"取消" confirmTitle:@"退出" cancelHandler:nil confirmHandler:^{
        strongSelf(weakSelf);
        [strongSelf productLogout];
    }];
}

- (void)viewLogoutInfo {
    [self appointmentForwardInfoController:CRFForwardProductTypeAutoInvest];
}

/**
 自动续投
 */
- (void)autoInvest {
    [self forwardInvest:CRFForwardProductTypeAutoInvest];
}

- (void)pushAppointmentForwardController {
    [self forwardInvest:CRFForwardProductTypeAppointmentForward];
}

- (void)viewAppointmentForwardInfo {
    [self appointmentForwardInfoController:CRFForwardProductTypeAppointmentForward];
}

/**
 是否可以预约转投
 
 @return value YES 可以。NO 不可以
 */
- (BOOL)productAppointmentForward {
    //    return YES;
    if (![CRFUtils complianceProduct:self.product.investSource]) return NO;
    return self.productDetail.isAbleForward == 2 && self.productDetail.isApplyForward == 1;
}

/**
 是否可以查看转投详情
 
 @return YES 可以，NO 不可以
 */
- (BOOL)alerdyAppointmentForward {
    if (![CRFUtils complianceProduct:self.product.investSource]) return NO;
    return self.productDetail.isAbleForward == 1 && self.productDetail.isApplyForward == 2;
}

- (BOOL)autoInvestment {
    return self.productDetail.isAbleFlexibleForward.integerValue == 2;
}

- (void)appointmentForwardInfoController:(CRFForwardProductType)forwardType {
    CRFAppointmentForwardInfoViewController *controller = [CRFAppointmentForwardInfoViewController new];
    controller.investNo = self.productDetail.investNo;
    controller.forwardType = forwardType;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)forwardInvest:(CRFForwardProductType)forwardType {
    [CRFLoadingView disableLoading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kQueryAppointmentForwardAmountPath),kUuid] paragrams:@{@"sourceInvestNo":self.productDetail.investNo} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        CRFAppointmentForwardViewController *controller = [CRFAppointmentForwardViewController new];
        NSString *interest = [response[kDataKey] objectForKey:@"priinst"];
        double a = interest.doubleValue / 100;
        controller.interestAmount = [NSString stringWithFormat:@"%.2f",a];
        NSString *principal = [response[kDataKey] objectForKey:@"principal"];
        double b = principal.doubleValue / 100;
        controller.principalAmount = [NSString stringWithFormat:@"%.2f",b];
        controller.productDetail = strongSelf.productDetail;
        controller.product = strongSelf.product;
        controller.forwardType = forwardType;
        [strongSelf.navigationController pushViewController:controller animated:YES];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)applyLogoutFeadback {
    CRFCommonResultViewController *controller = [CRFCommonResultViewController new];
    controller.commonResult = CRFCommonResultSuccess;
    controller.title = @"受理成功";
    controller.result = @"退出申请受理成功！";
    controller.commonButtonTitle = @"查看详情";
    weakSelf(self);
    [controller setCommonButtonHandler:^(NSInteger index, CRFCommonResultViewController *resultController){
        strongSelf(weakSelf);
        [strongSelf popDetailControllerFrom:resultController];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)popDetailControllerFrom:(UIViewController *)controller {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CRFInvestStatusViewController class]]) {
            CRFInvestStatusViewController *detailController = (CRFInvestStatusViewController *)vc;
            if (detailController.refreshProductInfo) {
                detailController.refreshProductInfo();
            }
            [controller.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (BOOL)needAutoInvestAccessViewNone {
    return (self.productDetail.forwardType.integerValue == 2 && ([self autoInvestment] || self.productDetail.investStatus.integerValue == 6 || self.productDetail.investStatus.integerValue == 5 || self.productDetail.investStatus.integerValue == 3));
}

@end

