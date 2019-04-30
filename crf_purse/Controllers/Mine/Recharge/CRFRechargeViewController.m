//
//  CRFRechargeViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRechargeViewController.h"
#import "CRFStringUtils.h"
#import "CRFRecordViewController.h"
#import "CRFRechargeSuccessViewController.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFHomeConfigHendler.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFVerificationCodeView.h"
#import <YYImage/YYAnimatedImageView.h>
#import "CRFLogoView.h"
#import "UIImage+Color.h"
#import "UILabel+Edge.h"
#import "CRFAlertUtils.h"
#import "CRFQuickRechargeViewController.h"
#import "CRFNewRechargeModel.h"
#import "CRFRechargeDetailView.h"
#import "CRFSupportBankInfoViewController.h"
#import "CRFQuickSupportListViewController.h"

@interface CRFRechargeViewController () < UITextFieldDelegate>
@property (strong, nonatomic)UILabel *codeShowLabel;
@property (strong, nonatomic)UILabel *codeTipLabel;
@property (strong, nonatomic)UILabel *moneyShowLabel;
@property (strong, nonatomic)UIView *moneyBgview;
@property (strong, nonatomic)UIView *codeBgview;
@property (strong, nonatomic)YYLabel *promptLabel;
@property (strong, nonatomic)UITextField *moneyTextField;
@property (strong, nonatomic)UITextField *codeTextField;
@property (strong, nonatomic)UILabel *helpTextView;
@property (strong, nonatomic)UILabel *quickHelpLabel;
@property (nonatomic, assign) BOOL sendCode;
@property (nonatomic,   copy) NSString *minimum;
@property (nonatomic,   copy) NSString *maxnum;
@property (strong, nonatomic)UIButton *rechargeBtn;
@property (strong, nonatomic)UIButton *recordBtn;
@property (strong, nonatomic)UIButton *supportBtn;

@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (strong, nonatomic)CRFLogoView *logoView;

@property (nonatomic, strong) CRFVerificationCodeView *verificationCodeView;

@property (nonatomic, strong) CRFRechargeDetailView  *rechargeDetailView;

@property (nonatomic, strong) CRFBankListModel  *curruntBankInfo;
@end

@implementation CRFRechargeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.moneyTextField.text = nil;
    self.codeTextField.text = nil;
}
-(UIButton *)supportBtn{
    if (!_supportBtn) {
        _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_supportBtn setTitleColor:kBtnAbleBgColor forState:UIControlStateNormal];
        [_supportBtn setTitleColor:kBtnAbleBgColor forState:UIControlStateSelected];
        [_supportBtn setTitle:self.rechargeType==Default_recharge?@"限额说明 >":@"支持银行 >" forState:UIControlStateNormal];
        _supportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_supportBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_supportBtn addTarget:self action:@selector(supportBankEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _supportBtn;
}
-(CRFRechargeDetailView *)rechargeDetailView{
    if (!_rechargeDetailView) {
        _rechargeDetailView = [[CRFRechargeDetailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _rechargeDetailView;
}
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _helpView.title = @"充值提醒";
        [_helpView drawContent:@"请确保卡上有足够余额，以免因尝试次数过多被限制，影响您的投资"];
    }
    return _helpView;
}

- (void)sendRecharge:(id)sender {
    [CRFAPPCountManager setEventID:@"RECHARGE_EVENT" EventName:self.rechargeType == Default_recharge?@"快捷充值按钮":@"转账充值按钮"];

    if (self.rechargeType == Default_recharge) {
        
    }
    [self.view endEditing:YES];
    if (self.moneyTextField.text.length <= 0) {
        [CRFUtils showMessage:@"请输入充值金额"];
        return;
    }
    if (self.rechargeType == Default_recharge) {
        if ([[self.moneyTextField.text getOriginString]doubleValue] > [[self.maxnum getOriginString] doubleValue]&&![self.maxnum isEqualToString:@"- -"]) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"单笔充值金额输入最大%@元，更大金额的充值请见大额充值指南",self.maxnum]];
            return;
        }
        if ([[self.moneyTextField.text getOriginString] doubleValue] < [[self.minimum getOriginString] doubleValue]&&![self.minimum isEqualToString:@"- -"]) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"充值金额不能低于%@元，",self.minimum]];
            return;
        }
    }
    
    if ([[self.moneyTextField.text getOriginString] doubleValue] < 5&&[self.minimum isEqualToString:@"- -"]) {
        [CRFUtils showMessage:[NSString stringWithFormat:@"充值金额不能低于5元"]];
        return;
    }
    if (self.rechargeType != Default_recharge) {
        if ([[self.moneyTextField.text getOriginString] doubleValue] < 5) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"充值金额不能低于5元"]];
            return;
        }
    }
    
    if (self.codeTextField.text.length == 0) {
        [CRFUtils showMessage:@"请输入验证码"];
        return;
    }
    if (!self.sendCode) {
        [CRFUtils showMessage:@"请先发送验证码"];
        return;
    }
    if (self.codeTextField.text.length != 6) {
        [CRFUtils showMessage:@"验证码格式不正确"];
        return;
    }
    [CRFLoadingView loading];
    
    weakSelf(self);
    if (self.rechargeType == Default_recharge) {
        //[NSString stringWithFormat:APIFormat(kRechargePath),kUuid]@"http://10.194.11.227:8070/webp2p_interface_mysql/account/entrust/%@/recharge",kUuid
        NSString *url = [NSString stringWithFormat:APIFormat(kRechargePath),kUuid];
        [[CRFStandardNetworkManager defaultManager] post:url paragrams:@{@"amount":[self.moneyTextField.text calculateWithHighPrecision],@"validateCode":self.codeTextField.text,@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            [CRFAPPCountManager setEventID:@"RECHARGE_EVENT" EventName:@"快捷充值成功"];
            [strongSelf.navigationController pushViewController:[CRFRechargeSuccessViewController new] animated:YES];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            [CRFUtils showMessage:response[kMessageKey]];
            [CRFAPPCountManager setFailedEventID:@"recharge_failed" reason:response[kMessageKey] productNo:@""];
        }];
    }else{
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kQuickRechargePath),kUuid] paragrams:@{@"transferAmount":[self.moneyTextField.text calculateWithHighPrecision],@"verifyCode":self.codeTextField.text,} success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            CRFNewRechargeModel *model = [CRFResponseFactory handleDataWithDic:response[@"data"] forClass:[CRFNewRechargeModel class]];
            CRFQuickRechargeViewController *quickVc = [CRFQuickRechargeViewController new];
            quickVc.rechargeModel = model;
            [CRFAPPCountManager setEventID:@"RECHARGE_TRANSFER_EVENT" EventName:@"转账充值成功"];

            [strongSelf.navigationController pushViewController:quickVc animated:YES];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            [CRFUtils showMessage:response[kMessageKey]];
            [CRFAPPCountManager setFailedEventID:@"recharge_transfer_failed" reason:response[kMessageKey] productNo:@""];
        }];
    }
    
}

-(void)supportBankEvent:(UIButton*)btn{
    if (self.rechargeType ==Default_recharge) {
        CRFSupportBankInfoViewController *controller = [CRFSupportBankInfoViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        CRFQuickSupportListViewController *controller = [CRFQuickSupportListViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)rechargeRecord {
    CRFRecordViewController *controller = [CRFRecordViewController new];
    controller.selectedIndex = 0;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)bankInfo {
    if (!_bankInfo) {
        _bankInfo = @"";
    }
    return _bankInfo;
}
-(void)showQuickRechargeView{
    CRFNewRechargeModel *rechargeModel = [CRFAppManager defaultManager].rechargeModel;
    self.rechargeDetailView.rechargeInfo = rechargeModel;
    if (rechargeModel&&rechargeModel.chgDt && [rechargeModel.uuid isEqualToString:[CRFAppManager defaultManager].userInfo.customerUid]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *timeDate = [dateFormatter dateFromString:rechargeModel.chgDt];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:timeDate];
        NSDate *mydate = [timeDate dateByAddingTimeInterval:interval];
        NSDate *nowDate = [[NSDate date]dateByAddingTimeInterval:interval];
        //两个时间间隔
        NSTimeInterval timeInterval = [mydate timeIntervalSinceDate:nowDate];
        timeInterval = -timeInterval;
        if (timeInterval/(24*60*60) <3 ||timeInterval/(24*60*60) == 3) {
            [self.rechargeDetailView show];
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitUI];
    [self setLayoutSubview];
//    [self rightBarButton];
    self.rechargeBtn.enabled = NO;
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    if (userInfo.openBankCardNo.length>4) {
        self.bankInfo = [NSString stringWithFormat:@"%@卡(%@)",[userInfo.bankCode getBankCode].bankName,[userInfo.openBankCardNo substringFromIndex:userInfo.openBankCardNo.length - 4]];
    }
    self.navigationItem.title = NSLocalizedString(@"title_recharge", nil);
    [self setPromptLaberInfo];
    [self setRightView];
    [self getTextFromNetwork];
    [self setHelpTextViewInfo:nil];
}
-(void)setInitUI{
    self.promptLabel = [[YYLabel alloc]init];
    self.promptLabel.numberOfLines = 0;
    
    self.moneyBgview = [[UIView alloc]init];
    self.moneyBgview.backgroundColor = [UIColor whiteColor];
    
    self.moneyShowLabel = [UILabel new];
    self.moneyShowLabel.textColor = UIColorFromRGBValue(0x666666);
    self.moneyShowLabel.font = [UIFont systemFontOfSize:15];
    self.moneyShowLabel.text = @"充值金额(元)";
    
    self.moneyShowLabel.backgroundColor = [UIColor clearColor];
    
    self.moneyTextField = [[UITextField alloc]init];
    self.moneyTextField.font = [UIFont systemFontOfSize:14];
    self.moneyTextField.borderStyle = UITextBorderStyleNone;
    self.moneyTextField.textColor = UIColorFromRGBValue(0x666666);
    self.moneyTextField.backgroundColor = [UIColor clearColor];
    self.moneyTextField.delegate = self;
    if (self.rechargeType != Default_recharge) {
        self.moneyTextField.placeholder = @"不能低于5元";
    }
    self.moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.codeTipLabel= [UILabel new];
    self.codeTipLabel.text = @"输入验证码以确认充值";
    self.codeTipLabel.textColor = UIColorFromRGBValue(0x999999);
    self.codeTipLabel.font = [UIFont systemFontOfSize:13];
    self.codeTipLabel.backgroundColor = [UIColor clearColor];
    
    self.codeBgview = [[UIView alloc]init];
    self.codeBgview.backgroundColor = [UIColor whiteColor];
    
    self.codeShowLabel = [UILabel new];
    self.codeShowLabel.textColor = UIColorFromRGBValue(0x666666);
    self.codeShowLabel.font = [UIFont systemFontOfSize:15];
    self.codeShowLabel.text = @"验证码";
    self.codeShowLabel.backgroundColor = [UIColor clearColor];
    
    self.codeTextField = [[UITextField alloc]init];
    self.codeTextField.font = [UIFont systemFontOfSize:14];
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.codeTextField.textColor = UIColorFromRGBValue(0x666666);
    self.codeTextField.backgroundColor = [UIColor clearColor];
    self.codeTextField.delegate = self;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [self.rechargeBtn setTitle:@"充值" forState:UIControlStateSelected];
    [self.rechargeBtn setTitle:@"充值" forState:UIControlStateHighlighted];
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius  = 5.0f;
    [self.rechargeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xE14534)] forState:UIControlStateHighlighted];
    [self.rechargeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xE14534)] forState:UIControlStateNormal];
    [self.rechargeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xCCCCCC)] forState:UIControlStateDisabled];
    [self.rechargeBtn addTarget:self action:@selector(sendRecharge:) forControlEvents:UIControlEventTouchUpInside];

    self.helpTextView = [UILabel new];
    self.helpTextView.font = [UIFont systemFontOfSize:13];
    self.helpTextView.textColor = UIColorFromRGBValue(0x999999);
    self.helpTextView.backgroundColor = [UIColor clearColor];
    self.helpTextView.numberOfLines = 0;
    
    self.quickHelpLabel = [UILabel new];
    self.quickHelpLabel.font = [UIFont systemFontOfSize:17];
    self.quickHelpLabel.textColor = UIColorFromRGBValue(0xcccccc);
    self.quickHelpLabel.backgroundColor = [UIColor clearColor];
    self.quickHelpLabel.numberOfLines = 0;
    
    self.logoView = [CRFLogoView new];
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    NSString *titleStr =@"充值记录";
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:titleStr];
    [self.recordBtn setTitle:titleStr forState:UIControlStateNormal];
    [self.recordBtn setTitle:titleStr forState:UIControlStateSelected];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [title addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xfb4d3a), NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} range:titleRange];
    
//    [self.recordBtn setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateNormal];
//    [self.recordBtn setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateSelected];
    [self.recordBtn setAttributedTitle:title forState:UIControlStateNormal];
    [self.recordBtn setAttributedTitle:title forState:UIControlStateSelected];
    [self.recordBtn addTarget:self action:@selector(rechargeRecord) forControlEvents:UIControlEventTouchUpInside];

    if (self.rechargeType == Default_recharge) {
        
        [self.view addSubview:self.recordBtn];
    }else{
        [self.view addSubview:self.quickHelpLabel];
    }
    [self.view addSubview:self.promptLabel];
    [self.moneyBgview addSubview:self.moneyShowLabel];
    [self.moneyBgview addSubview:self.moneyTextField];
    [self.view addSubview:self.moneyBgview];
    [self.view addSubview:self.codeTipLabel];
    [self.codeBgview addSubview:self.codeShowLabel];
    [self.codeBgview addSubview:self.codeTextField];
    [self.view addSubview:self.codeBgview];
    [self.view addSubview:self.supportBtn];
    [self.view addSubview:self.rechargeBtn];
    [self.view addSubview:self.helpTextView];
    [self.view addSubview:self.logoView];
    
}
-(void)setLayoutSubview{
//
    if (self.rechargeType == Default_recharge) {

        
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(kSpace);
            make.right.mas_equalTo(-kSpace);
            make.bottom.mas_equalTo(self.moneyBgview.mas_top);
        }];
    }else{
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(kSpace);
            make.right.mas_equalTo(-kSpace);
            make.bottom.mas_equalTo(self.moneyBgview.mas_top);
        }];
    }
    [self.moneyBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(75);
        make.height.mas_equalTo(51);
    }];
    [self.moneyShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyBgview.mas_top).with.mas_offset(0);
        make.left.mas_equalTo(self.moneyBgview.mas_left).with.mas_offset(kSpace);
        make.bottom.mas_equalTo(self.moneyBgview.mas_bottom).with.mas_offset(0);
        make.width.mas_equalTo(90);
    }];
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyShowLabel.mas_top).with.mas_offset(0);
        make.bottom.mas_equalTo(self.moneyShowLabel.mas_bottom).with.mas_offset(0);
        make.left.mas_equalTo(self.moneyShowLabel.mas_right).with.mas_offset(10);
        make.right.mas_equalTo(self.moneyBgview.mas_right).with.mas_offset(0);
    }];
    [self.codeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.top.mas_equalTo(self.moneyBgview.mas_bottom).with.mas_offset(0);
        make.height.mas_equalTo(33);
    }];
    [self.codeBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.codeTipLabel.mas_bottom).with.mas_offset(0);
        make.height.mas_equalTo(51);
    }];
    [self.codeShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeBgview.mas_top).with.mas_offset(0);
        make.left.mas_equalTo(self.codeBgview.mas_left).with.mas_offset(kSpace);
        make.bottom.mas_equalTo(self.codeBgview.mas_bottom).with.mas_offset(0);
        make.width.mas_equalTo(70);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeShowLabel.mas_top).with.mas_offset(0);
        make.bottom.mas_equalTo(self.codeShowLabel.mas_bottom).with.mas_offset(0);
        make.left.mas_equalTo(self.codeShowLabel.mas_right).with.mas_offset(0);
        make.right.mas_equalTo(self.codeBgview.mas_right).with.mas_offset(0);
    }];
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSpace);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.codeBgview.mas_bottom).with.mas_offset(15);
    }];
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.top.mas_equalTo(self.supportBtn.mas_bottom).with.mas_offset(20);
        make.height.mas_equalTo(42);
    }];
    if (self.rechargeType == Default_recharge) {
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.rechargeBtn.mas_bottom).with.mas_offset(20);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(70, 17));
        }];
        [self.helpTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rechargeBtn.mas_left).with.mas_offset(0);
            make.right.equalTo(self.rechargeBtn.mas_right).with.mas_offset(0);
            make.top.mas_equalTo(self.recordBtn.mas_bottom).with.mas_offset(15);
        }];
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(self.helpTextView.mas_bottom).with.mas_offset(30);
            make.height.mas_equalTo(18);
        }];
    }else{
        [self.helpTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rechargeBtn.mas_left).with.mas_offset(0);
            make.right.equalTo(self.rechargeBtn.mas_right).with.mas_offset(0);
            make.top.mas_equalTo(self.rechargeBtn.mas_bottom).with.mas_offset(15);
        }];
        [self.quickHelpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rechargeBtn.mas_left).with.mas_offset(0);
            make.right.equalTo(self.rechargeBtn.mas_right).with.mas_offset(0);
            make.top.mas_equalTo(self.helpTextView.mas_bottom).with.mas_offset(5);
        }];
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(self.quickHelpLabel.mas_bottom).with.mas_offset(30);
            make.height.mas_equalTo(18);
        }];
    }
    
}
- (void)getTextFromNetwork {
    if (self.rechargeType != Default_recharge) {
        return;
    }
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kSupportBanklistPath) paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        NSArray <CRFBankListModel *>*array = [CRFResponseFactory getBankListForResult:response];
        [strongSelf setHelpTextViewInfo:[strongSelf formatString:array]];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
         [strongSelf setHelpTextViewInfo:[strongSelf formatString:nil]];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setPromptLaberInfo {
    if (self.rechargeType == Default_recharge) {
        NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"label_recharge_prompt", nil),self.bankInfo];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, totalString.length)];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:kLinkTextColor} range:[totalString rangeOfString:self.bankInfo]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range:[totalString rangeOfString:NSLocalizedString(@"label_recharge_prompt1", nil)]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range:[totalString rangeOfString:NSLocalizedString(@"label_recharge_prompt2", nil)]];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"recharge_help_icon"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(0, 0, 30, 30);
        NSMutableAttributedString *attributed1 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
        [attributedString appendAttributedString:attributed1];
        [self.promptLabel setAttributedText:attributedString];
        weakSelf(self);
        [self.promptLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (CGSizeEqualToSize(rect.size, CGSizeMake(30, 30))) {
                strongSelf(weakSelf);
                [strongSelf.helpView show:strongSelf.navigationController.view];
            }
        }];
    }
    else{
        NSString *name = @"400-178-9898";
        CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
        if (userInfo.financialPhone.length) {
            name = [NSString stringWithFormat:@"%@ %@",userInfo.financialName,userInfo.financialPhone];
        }
        NSString *totalString = [NSString stringWithFormat:@"联系专属顾问: %@，可快速协助您完成大额充值。",name];
        NSMutableAttributedString *attributedString =[CRFStringUtils setAttributedString:totalString lineSpace:5 attributes1:nil range1:NSRangeZero attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(0, totalString.length) attributes3:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:kLinkTextColor} range3:[totalString rangeOfString:name] attributes4:nil range4:NSRangeZero];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"recharge_phone"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(0, 0, 25, 25);
        NSMutableAttributedString *attributed1 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
        [attributedString insertAttributedString:attributed1 atIndex:[totalString rangeOfString:name].location-1];
        [self.promptLabel setAttributedText:attributedString];
        weakSelf(self);
        [self.promptLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            strongSelf(weakSelf);
            if ([name isEqualToString:@"400-178-9898"]) {
                NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:400-178-9898"]];
                if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                        [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL:callUrl];
                    }
                }
            }else{
                NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",userInfo.financialPhone]];
                if ([CRFUtils validateCurrentMobileSystem10_2]) {
                    if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                        if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                            [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL:callUrl];
                        }
                    }
                }else{
                    NSString *title = [NSString stringWithFormat:@"您的专属顾问：\n%@ %@",userInfo.financialPhone,userInfo.financialName];
                    [CRFAlertUtils showAlertTitle:title container:strongSelf cancelTitle:@"取消" confirmTitle:@"呼叫" cancelHandler:nil confirmHandler:^{
                        NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",userInfo.financialPhone]];
                        if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                            if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                                [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                            }
                            else {
                                [[UIApplication sharedApplication] openURL:callUrl];
                            }
                        }
                    }];
                }
                
            }
        }];
    }
}

- (void)setHelpTextViewInfo:(NSString *)info {
    if (self.rechargeType == Default_recharge) {
        NSMutableAttributedString *attributedString = [CRFStringUtils setAttributedString:info lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, info.length) attributes2:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range2:[info rangeOfString:NSLocalizedString(@"label_recharge_explain1", nil)] attributes3:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:kLinkTextColor} range3:[info rangeOfString:@"400-178-9898"] attributes4:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range4:[info rangeOfString:NSLocalizedString(@"label_recharge_explain1", nil)] attributes5:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range5:[info rangeOfString:@"5"] attributes6:nil range6:NSRangeZero];
        if (self.curruntBankInfo) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:NSMakeRange([info rangeOfString:@"单日"].location+2, [self.curruntBankInfo formatDayOrder].length)];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:NSMakeRange([info rangeOfString:@"单笔"].location+2, [self.curruntBankInfo formatSingleOrder].length)];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:NSMakeRange([info rangeOfString:@"单月"].location+2, [self.curruntBankInfo formatMonthOrder].length)];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[info rangeOfString:self.curruntBankInfo.minimum]];
        }
        

        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, 0, 16, 16);//设置frame
        attchment.image = [UIImage imageNamed:@"recharge_phone"];//设置图片
        
        NSAttributedString *attributed1 = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
        [attributedString insertAttributedString:attributed1 atIndex:[info rangeOfString:@"400-178-9898"].location-2];
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(-3) range:NSMakeRange([info rangeOfString:@"400-178-9898"].location-2, 1)];
        self.helpTextView.userInteractionEnabled = YES;
        weakSelf(self);
        self.helpTextView.text = info;
        self.helpTextView.enabledTapEffect = NO;
        [self.helpTextView yb_addAttributeTapActionWithStrings:@[@"大额充值指南",@"400-178-9898"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            [weakSelf setAppCountManager];//埋点
            if ([CRFAppManager defaultManager].majiabaoFlag) {
                return ;
            }
            strongSelf(weakSelf);
            if ([string isEqualToString:@"大额充值指南"]) {
                CRFStaticWebViewViewController *controller = [CRFStaticWebViewViewController new];
                controller.urlString = [CRFHomeConfigHendler defaultHandler].bankInfoTipModel.jumpUrl;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            }
            if ([string isEqualToString:@"400-178-9898"]) {
//                [CRFAlertUtils showAlertTitle:@"400 178 9898" container:strongSelf cancelTitle:@"取消" confirmTitle:@"呼叫" cancelHandler:nil confirmHandler:^{
                    NSURL *callUrl = [NSURL URLWithString:@"tel:400-178-9898"];
                    if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                        if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                            [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL:callUrl];
                        }
                    }
//                }];
            }

        }];
        
        [self.helpTextView setAttributedText:attributedString];

    }else{
        [self setHelpTextQuick];
    }
    
}
-(void)setHelpTextQuick{
    NSString *info = @"重要提示：\n1.请务必使用本人的银行卡（仅限借记卡）往指定的富友企业户打款；\n2.请务必将充值码准确的完整的填入备注栏（如；用途、附言、摘要、备注等），如果出现可以填写多种备注信息的情况，请全部完整的填写充值码；\n3.充值码有效期3天，每个充值码仅可使用1次；\n4.您可以选择的转账方式有：柜面（不支持现金）、网银、手机银行，限额请以转账银行提供为准。\n5.若有疑问请联系客服热线：400-178-9898.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:info];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, info.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:NSMakeRange(0, info.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFD8375), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[info rangeOfString:@"将充值码准确的完整的填入备注栏"]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFD8375), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[info rangeOfString:@"有效期3天"]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFD8375), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[info rangeOfString:@"限额请以转账银行提供为准"]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFD8375), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[info rangeOfString:@"仅可使用1次"]];
    self.helpTextView.userInteractionEnabled = YES;
    
    [self.helpTextView setAttributedText:attributedString];
    NSString *quickInfo = @"以招商银行为例的操作示范。";
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:quickInfo];
    NSMutableParagraphStyle *paragraphStyle1 =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, quickInfo.length)];
    [attributedString1 addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:NSMakeRange(0, quickInfo.length)];
    [attributedString1 addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range:[quickInfo rangeOfString:@"操作示范"]];
    [attributedString1 addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[quickInfo rangeOfString:@"操作示范"]];
    self.quickHelpLabel.userInteractionEnabled = YES;
    weakSelf(self);
    self.quickHelpLabel.text = quickInfo;
    self.quickHelpLabel.enabledTapEffect = NO;
    [self.quickHelpLabel yb_addAttributeTapActionWithStrings:@[@"操作示范"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        strongSelf(weakSelf);
        [CRFAPPCountManager setEventID:@"RECHARGE_TRANSFER_EXAMPLE" EventName:@"操作示范"];
        CRFStaticWebViewViewController *controller = [CRFStaticWebViewViewController new];
        controller.urlString = kQuickHandleH5;
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    [self.quickHelpLabel setAttributedText:attributedString1];
    
}
- (void)setRightView {
    _verificationCodeView = [[CRFVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, 125, 51)];
    _verificationCodeView.textFont = [UIFont systemFontOfSize:13.0];
    _verificationCodeView.cornerRadius = 27.0 / 2.0;
    _verificationCodeView.contentEdgeInsets = UIEdgeInsetsMake(23.0 / 2.0, kSpace, 23.0 / 2.0, kSpace);
    _verificationCodeView.normalColor = UIColorFromRGBValue(0xFBB203);
    _verificationCodeView.normalBorderColor = UIColorFromRGBValue(0xFBB203);
    _verificationCodeView.borderWidth = 1.0f;
    _verificationCodeView.disableBorderColor = UIColorFromRGBValue(0xBBBBBB);
    _verificationCodeView.disableColor = UIColorFromRGBValue(0xBBBBBB);
    _verificationCodeView.initializeText = NSLocalizedString(@"button_get_verify_code", nil);
    _verificationCodeView.sendingText = NSLocalizedString(@"button_re_get_verify_code", nil);
    weakSelf(self);
    [_verificationCodeView setBeginSendCode:^{
        strongSelf(weakSelf);
        [strongSelf sendVerifyCode];
    }];
    self.codeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.codeTextField.rightView = _verificationCodeView;
}

- (void)sendVerifyCode {
    [self.view endEditing:YES];
    if ([self.moneyTextField.text isEmpty]) {
        [CRFUtils showMessage:@"toast_input_money_after_send_code"];
        return;
    }
    if (self.rechargeType == Default_recharge) {
        if ([[self.moneyTextField.text getOriginString] doubleValue] < [[self.minimum getOriginString] doubleValue]) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"充值金额不能低于%@元",self.minimum]];
            return;
        }
        if ([[self.moneyTextField.text getOriginString] doubleValue] > [[self.maxnum getOriginString] doubleValue]&&![self.maxnum isEqualToString:@"- -"]) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"单笔充值金额输入最大%@元，更大金额的充值请见大额充值指南",self.maxnum]];
            return;
        }
    }
    if ([[self.moneyTextField.text getOriginString] doubleValue] < 5&&[self.minimum isEqualToString:@"- -"]) {
        [CRFUtils showMessage:[NSString stringWithFormat:@"充值金额不能低于5元"]];
        return;
    }
    if ([[self.moneyTextField.text getOriginString] doubleValue] < 5) {
        [CRFUtils showMessage:[NSString stringWithFormat:@"充值金额不能低于5元"]];
        return;
    }
    [CRFLoadingView loading];
    weakSelf(self);
    
    [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendTransformVerifyCodePath),kUuid] paragrams:@{kMobilePhone:[CRFAppManager defaultManager].userInfo.phoneNo,kIntent:self.rechargeType == Default_recharge? @"7":@"11",@"type":@"0",@"picCode":@""} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:@"toast_send_verify_code"];
        strongSelf.sendCode = YES;
        [strongSelf.verificationCodeView timerStart];
        [CRFAPPCountManager setEventID:self.rechargeType == Default_recharge?@"RECHARGE_GETCODE_EVENT":@"RECHARGE_TRANSFER_GETCODE_EVENT" EventName:self.rechargeType == Default_recharge?@"充值页验证码获取成功":@"转账页充值页验证码获取成功"];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFAPPCountManager setEventFailed:self.rechargeType == Default_recharge?@"RECHARGE_GETCODE_EVENT":@"RECHARGE_TRANSFER_GETCODE_EVENT" reason:response[kMessageKey]];
        [strongSelf.verificationCodeView resetTimer];
    }];
}

- (NSString *)formatString:(NSArray <CRFBankListModel *>*)array {
    if (!array) {
        self.minimum = @"- -";
        self.maxnum = @"- -";
        return [NSString stringWithFormat:NSLocalizedString(@"label_recharge_explain_none", nil)];
    }
    for (CRFBankListModel *model in array) {
        if ([[[CRFAppManager defaultManager].userInfo.bankCode getBankCode].bankName isEqualToString:model.bankName]) {
            self.curruntBankInfo = model;
            self.minimum = model.minimum;
            self.maxnum =[[model.quotaMap objectForKey:@"appSignWithholdQuata"] firstObject];
            return [NSString stringWithFormat:NSLocalizedString(@"label_recharge_explain", nil),self.minimum,model.bankName,[model formatSingleOrder],[model formatDayOrder],[model formatMonthOrder]];
        }
    }
    self.minimum = @"- -";
    self.maxnum = @"- -";
    return [NSString stringWithFormat:NSLocalizedString(@"label_recharge_explain_none", nil)];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.verificationCodeView resetTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.verificationCodeView destory];
}

#pragma mark ===
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.moneyTextField]) {
        if (self.codeTextField.text.length) {
            if (string.length) {
                self.rechargeBtn.enabled = YES;
            }else if(self.moneyTextField.text.length>1){
                self.rechargeBtn.enabled = YES;
            }else{
                self.rechargeBtn.enabled = NO;
            }
        }else{
            self.rechargeBtn.enabled = NO;
        }
    }else{
        if (self.moneyTextField.text.length) {
            if (string.length) {
                self.rechargeBtn.enabled = YES;
            }else if(self.codeTextField.text.length>1){
                self.rechargeBtn.enabled = YES;
            }else{
                self.rechargeBtn.enabled = NO;
            }
        }else{
            self.rechargeBtn.enabled = NO;
        }
    }
    if ([textField isEqual:self.moneyTextField]&&self.moneyTextField.text.length>7 && string.length > 0) {
        return NO;
    }
    if (textField.text.length == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        return NO;
    }
    
    NSArray <NSString *>*array = [textField.text componentsSeparatedByString:@"."];
    if (array.count > 1) {
        NSString *str = [array lastObject];
        if (str.length >= 2 && string.length > 0) {
            return NO;
        }
    }
    return YES;
}

- (void)dealloc {
    [self.verificationCodeView destory];
    //    self.verificationCodeView = nil;
    DLog(@"dealloc is: %@",NSStringFromClass([self class]));
    
}

@end

