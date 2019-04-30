//
//  CRFExplanOperateViewController.m
//  crf_purse
//
//  Created by maomao on 2018/3/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFExplanOperateViewController.h"
#import "CRFExclusivePlanListViewController.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFAppointmentForwardTableViewCell.h"
#import "CRFExcluPlanCell.h"
#import "CRFHomeConfigHendler.h"
#import "IQKeyboardManager.h"
#import "UITableView+Custom.h"
#import "CRFRechargeViewController.h"
#import "CRFControllerManager.h"
#import "CRFMessageVerifyViewController.h"
#import "CRFShowSwitchAlert.h"
#import "CRFAlertUtils.h"
#import "CRFRechargeContainerViewController.h"
#import "CRFStringUtils.h"
#import "CRFEvaluatingViewController.h"
typedef struct Item {
    NSInteger item;
    BOOL selected;
}Item;
static NSString *const tableCellIdentifer = @"appointmentTableViewCell";
@interface CRFExplanOperateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView     *mainTableView;
@property (nonatomic ,strong) UILabel         *titleLabel;
@property (nonatomic, strong) NSArray <NSArray <NSString *> *>*eventNames;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSArray <NSString *> *imageNames;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (nonatomic, assign) Item styleItem;
@property (nonatomic, assign) Item timeItem;
@end

@implementation CRFExplanOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"特供计划"];
    [self initDataSource];
    [self createUI];
//    [self helpEvent];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // Do any additional setup after loading the view.
}

-(void)initDataSource{
    NSArray <CRFAppHomeModel *>*list = [CRFHomeConfigHendler defaultHandler].productTitleList;
    _eventNames = @[@[[NSString stringWithFormat:@"%@%@",list[1].name,list[1].content],[NSString stringWithFormat:@"%@%@",list[2].name,list[2].content],[NSString stringWithFormat:@"%@%@",list[3].name,list[3].content]],@[@"按月付息",@"到期付息"]];
//    _eventNames = @[@[@"短期计划（<=180天）",@"中期计划（180天~360天）",@"长期计划（>360天）"],@[@"按月付息",@"到期付息"]];
    _imageNames = @[@"forward_filter_icon_duration",@"forward_filter_icon_ settlement",@"icon_Expected loan amount"];
    _titles = @[@"期望出借期限",@"期望结算方式",@"期望出借金额"];
    [CRFControllerManager refreshTotalAssert];
    
}
-(void)createUI{
    [self setSystemRightBarButtonWithImageNamed:@"common_nav_icon_help" target:self selector:@selector(helpEvent)];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
}

-(void)helpEvent{
    [self.helpView show:[UIApplication sharedApplication].delegate.window];
}
-(void)checkUser{
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
            [super back];
        } confirmHandler:^{
            [self gotoEvaluation];
        }];
        return;
    }
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
-(void)showVerifyInfo{
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    UIViewController *controller = nil;
    switch ([userInfo.accountSigned integerValue]) {
        case 1:{//1：已授权，2：未授权，3：信息异常，4，修改卡未授权 5
            CRFRechargeContainerViewController *rechargeVC = [CRFRechargeContainerViewController new];
            rechargeVC.popType = PopFrom_recharge;
            [self.navigationController pushViewController:rechargeVC animated:YES];
            
        }
            break;
        case 6:{//不验签
            CRFRechargeContainerViewController *rechargeVC = [CRFRechargeContainerViewController new];
            rechargeVC.popType = PopFrom_recharge;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case 2:{
            controller = [CRFMessageVerifyViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:{
            CRFShowSwitchAlert *alertView =[[CRFShowSwitchAlert alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) AlertTitle:@"存管信息有误" content:@"尊敬的用户：\n您的第三方银行存管账户信息已失效，请按照下面的提示进行操作，感谢您的配合。\n1)如果您当前的注册手机号与银行预留手机号不一致，请前往银行网点或联系信而富客服400-178-9898进行修改。\n2)如果是姓名、身份证号或银行卡其中任何一项存在问题，请联系信而富客服400-178-9898进行存管账户注销；注销后重新开户即可。\n感谢您的理解与支持~" dismissHandler:nil confirmHandler:^{
                
            }];
            [alertView showInView:[UIApplication sharedApplication].delegate.window];
        }
            break;
        case 4:{
            [CRFAlertUtils showAlertTitle:@"温馨提示" contentLeftMessage:@"您已更改银行卡信息，请您进行短信验证操作，验证通过便可立即正常使用。" container:self cancelTitle:@"下次再说" confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                CRFMessageVerifyViewController *verifyVc = [[CRFMessageVerifyViewController alloc]init];
                verifyVc.ResultType = CloseResult;
                [self.navigationController pushViewController:verifyVc animated:YES];
            }];
        }
            break;
        case 5:{
            [CRFAlertUtils showAlertTitle:@"温馨提示" contentLeftMessage:@"您已成功修改存管账户信息，请您进行短信验证操作，验证通过便可正常充值。" container:self cancelTitle:@"下次再说" confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                CRFMessageVerifyViewController *verifyVc = [[CRFMessageVerifyViewController alloc]init];
                verifyVc.hidesBottomBarWhenPushed = YES;
                verifyVc.ResultType = CloseResult;
                [self.navigationController pushViewController:verifyVc animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
    
}
-(void)pushRecharge{
    [self showVerifyInfo];
//    CRFRechargeViewController *rechargeVC = [CRFRechargeViewController new];
//    rechargeVC.popType = PopFrom_recharge;
//    [self.navigationController pushViewController:rechargeVC animated:YES];
}
-(void)setscanExcluplanEvent:(NSString*)amount{
    
    if (!self.timeItem.selected) {
        [CRFUtils showMessage:@"请选择期望出借期限"];
        return ;
    }
    if (!self.styleItem.selected) {
        [CRFUtils showMessage:@"请选择期望结算方式"];
        return ;
    }
    if (!amount||amount.length == 0) {
        [CRFUtils showMessage:@"请输入出借金额"];
        return;
    }else{
        if ([amount longLongValue]<self.exclusiveItem.lowestAmount.longLongValue) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"起投金额为%@元",self.exclusiveItem.lowestAmount]];
            return;
        }
        if ([amount longLongValue]  % self.exclusiveItem.investUnit.longLongValue  != 0) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"出借金额必须为【%@】的整倍数",[self.exclusiveItem.investUnit formatBeginMoney]]];
            return;
        }
    }
    CRFExclusivePlanListViewController *listVC = [CRFExclusivePlanListViewController new];
    listVC.exclusiveAmount = amount;
    if (self.styleItem.item == 1) {
        listVC.destProType    = 2;
    }
    if (self.styleItem.item == 2) {
        listVC.destProType = 1;
    }
    listVC.investDeadLine = self.timeItem.item ;
    [self.navigationController pushViewController:listVC animated:YES];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==2) {
        CRFExcluPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFExcluPlanCellId forIndexPath:indexPath];
        cell.title = self.titles[indexPath.row];
        cell.iconNamed = self.imageNames[indexPath.row];
        cell.excModel = self.exclusiveItem;
        weakSelf(self)
        cell.scanCallBack = ^(NSString* amount,NSInteger btnStatus){
            if (btnStatus == buttonRecharge) {
                [weakSelf pushRecharge];
            }else{
                [weakSelf setscanExcluplanEvent:amount];
            }
            
        };
        return cell;
    }
    CRFAppointmentForwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifer forIndexPath:indexPath];
    cell.title = self.titles[indexPath.row];
    cell.indexPath = indexPath;
    cell.iconNamed = self.imageNames[indexPath.row];
    cell.eventNames = self.eventNames[indexPath.row];
    weakSelf(self);
    [cell setItemDidSelectedHandler:^(NSIndexPath *indexPath, NSInteger item, BOOL selected){
        strongSelf(weakSelf);
        Item item1 = {item,selected};
        if (indexPath.row == 0) {
            strongSelf.timeItem = item1;
        } else if (indexPath.row == 1){
            strongSelf.styleItem = item1;
        } 
    }];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_mainTableView setTextEidt:YES];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[CRFAppointmentForwardTableViewCell class] forCellReuseIdentifier:tableCellIdentifer];
        [_mainTableView registerClass:[CRFExcluPlanCell class] forCellReuseIdentifier:CRFExcluPlanCellId];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.estimatedRowHeight = 20;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.estimatedRowHeight = 20;
        [self autoLayoutSizeContentView:_mainTableView];
    }
    return _mainTableView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = UIColorFromRGBValue(0x666666);
        _titleLabel.text = @"将根据您的出借意向为您筛选特供计划：";
    }
    return _titleLabel;
}
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _helpView.title = @"特供计划";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth - 40, kStatusBarHeight + kNavigationbarHeight / 2.0)];
        [_helpView drawContent:self.exclusiveItem.content];
    }
    return _helpView;
}

@end
