//
//  CRFMessageVerifyViewController.m
//  crf_purse
//
//  Created by maomao on 2018/6/15.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFMessageVerifyViewController.h"
#import "CRFMessageVerifyCell.h"
#import "CRFVerifyFailedViewController.h"
#import "CRFRelateAccountStatusViewController.h"
#import "CRFOpenAccountStatusViewController.h"
@interface CRFMessageVerifyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSArray     *dataSource;
@property (nonatomic,strong) NSArray     *placeHolderSource;
@property (nonatomic,copy)   NSString    *verifyData;
@property (nonatomic,strong) UIButton    *footerBtn;
@end

@implementation CRFMessageVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarbuttonForBlack];
    [self initData];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSpace/2);
        make.left.right.bottom.equalTo(self.view);
    }];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 49+kSpace/2, 0);
        self.mainTableView.scrollIndicatorInsets = self.mainTableView.contentInset;
    }
#endif
    [self setTableViewFooter];
}
-(void)initData{
    [self setSyatemTitle:@"短信验证"];
    self.dataSource = @[@"银行预留手机号",@"验证码"];
    self.placeHolderSource = @[@"",@"请输入验证码"];
}
-(void)setTableViewFooter{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    footer.backgroundColor = [UIColor clearColor];
    self.footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.footerBtn.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
    self.footerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.footerBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.footerBtn];
    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(46);
    }];
    self.footerBtn.layer.masksToBounds = YES;
    self.footerBtn.layer.cornerRadius = 5.0f;
    [self.footerBtn setTitle:self.ResultType==OpenResult?@"开户": @"确认" forState:UIControlStateNormal];
    self.mainTableView.tableFooterView = footer;
}
-(void)btnClick{
    NSString *codeStr = [self getVerifyCodeStr];
    if (codeStr.length == 0) {
        [CRFUtils showMessage:@"toast_input_verify_code"];
        
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        self.verifyData = [userDefault objectForKey:@"verifyData_key"];
        [param setValue:self.verifyData forKey:@"requestRefNo"];
        [param setValue:codeStr forKey:@"smsCd"];
        [self verifyCodeInfo:param];
    }
}
-(void)verifyCodeInfo:(NSMutableDictionary*)param{
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kConfirmSignedPath),kUuid] paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf reloadUserInfo];
        if (self.ResultType == OpenResult) {
            [CRFUtils delayAfert:kToastDuringTime handle:^{
                [strongSelf.navigationController pushViewController:[CRFOpenAccountStatusViewController new] animated:YES];
                
            }];
        }else if(self.ResultType == RelateResult){
            
            [CRFUtils delayAfert:kToastDuringTime handle:^{
                [strongSelf.navigationController pushViewController:[CRFRelateAccountStatusViewController new] animated:YES];
                
            }];
        }else if(self.ResultType == CloseResult){
            
            [CRFUtils delayAfert:kToastDuringTime handle:^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [CRFUtils delayAfert:kToastDuringTime handle:^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)reloadUserInfo{
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
        NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
        if (!success) {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    }];
}
-(void)sendSignedCode:(CRFButton*)btn{
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kCardSignedPath),kUuid]  success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        if([response[kResult] isEqualToString:kSuccessResultStatus]){
            strongSelf.verifyData = response[kDataKey];
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setValue:strongSelf.verifyData forKey:@"verifyData_key"];
            [userDefault synchronize];
        }
//        [[strongSelf getVerifyCodeView] startSendVerify];
        [btn crfStartCountDown];
        [CRFUtils showMessage:@"toast_send_verify_code"];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
//        [self getVerifyCodeView].enable = YES;
        btn.enabled = YES;
        [CRFUtils showMessage:response[kMessageKey]];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFMessageVerifyCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CRFMessageVerifyId_first];
        weakSelf(self);
        [cell setCodeBack:^(CRFButton *codeBtn) {
            DLog(@"获取验证码");
            [weakSelf sendSignedCode:codeBtn];
        }];
//        [self sendVerify:cell];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CRFMessageVerifyId_second];
    }
    cell.leftTitle = self.dataSource[indexPath.row];
    cell.placeHoderStr = self.placeHolderSource[indexPath.row];
    cell.numberStr =[[CRFAppManager defaultManager].userInfo formatMobilePhone];
    
    return cell;
}
- (CRFVerifyCodeView *)getVerifyCodeView {
    return ((CRFMessageVerifyCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).verifyCodeView;
}
- (NSString *)getVerifyCodeStr {
    return ((CRFMessageVerifyCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField.text;
}
//-(void)sendVerify:(CRFMessageVerifyCell*)cell{
//    weakSelf(self);
//    
////    [cell.verifyCodeView setCallback:^{
////        DLog(@"获取验证码");
////        [weakSelf sendSignedCode];
////    }];
////    [cell.verifyCodeView setTimeoutHandle:^{
////        DLog(@"重新获取验证码");
////        [weakSelf sendSignedCode];
////    }];
//}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_mainTableView registerClass:[CRFMessageVerifyCell class] forCellReuseIdentifier:CRFMessageVerifyId_first];
        [_mainTableView registerClass:[CRFMessageVerifyCell class] forCellReuseIdentifier:CRFMessageVerifyId_second];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.rowHeight = 56;
        _mainTableView.backgroundColor = [UIColor clearColor];
        [_mainTableView setTextEidt:YES];
    }
    return _mainTableView;
}
-(void)dealloc{
    _mainTableView = nil;
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
