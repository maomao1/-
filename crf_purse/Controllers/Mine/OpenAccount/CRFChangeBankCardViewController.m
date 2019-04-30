//
//  CRFChangeBankCardViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFChangeBankCardViewController.h"
#import "CRFChangeBankCardInfoView.h"
#import "CRFCreateAccountTableViewCell.h"
#import "CRFLogoView.h"
#import "UITableViewCell+Access.h"
#import "UITableView+Custom.h"
#import "CRFUploadImageViewController.h"
#import "CRFSupportBankInfoViewController.h"
#import "CRFPickerView.h"
#import "CRFStringUtils.h"
#import "CRFAlertUtils.h"
#import "CRFBankCardViewController.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFCommonResultViewController.h"

@interface CRFChangeBankCardViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>*titles;
@property (nonatomic, strong) NSMutableArray <NSString *>*values;
@property (nonatomic, strong) CRFPickerView *pickerView;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, copy) NSString *telePhone;
@property (nonatomic, assign) BOOL   isSupport;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic,copy)  NSString *phoneCode;
@property (nonatomic, copy) NSString *branchName;

@property (nonatomic, strong)CRFAppointmentForwardHelpView *helpView;
@end

@implementation CRFChangeBankCardViewController
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _helpView.title = @"银行预留手机号";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth , 0)];
        [_helpView drawContent:@"为保证您的资金账户安全，银行卡预留手机号须与平台注册手机号一致；默认为注册手机号，此处无法修改哦~"];
    }
    return _helpView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换银行卡";
    self.titles = [NSMutableArray arrayWithObjects:@"新银行卡号",@"银行预留手机号",@"验证码", nil];
    self.values = [NSMutableArray arrayWithObjects:@"",[[CRFAppManager defaultManager].userInfo formatMobilePhone],@"", nil];
    [self setUpTableView];
    [self addPickerView];
    [self configTableViewHeaderView];
    [self configTableViewFooterView];
    [self.tableView setTextEidt:YES];
}

- (void)setUpTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    footerView.backgroundColor = [UIColor clearColor];
    _bottomLabel = [UILabel new];
    _bottomLabel.font = [self getFont];
    _bottomLabel.textColor = UIColorFromRGBValue(0x999999);
    [footerView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).with.offset(kSpace);
        make.top.equalTo(footerView).with.offset(10);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.height.mas_equalTo(0);
    }];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:commitButton];
    commitButton.layer.masksToBounds = YES;
    commitButton.layer.cornerRadius = 5.0f;
    [commitButton setTitle:@"下一步" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    commitButton.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
    [commitButton addTarget:self action:@selector(commitInfo) forControlEvents:UIControlEventTouchUpInside];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).with.offset(kSpace);
        make.top.equalTo(self.bottomLabel.mas_bottom).with.offset(40);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.height.mas_equalTo(kRegisterButtonHeight);
    }];
    CRFLogoView *logoView = [[CRFLogoView alloc] init];
    [footerView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(footerView);
        make.top.equalTo(commitButton.mas_bottom).with.offset(30);
        make.height.mas_equalTo(18);
    }];
    self.tableView.tableFooterView = footerView;
}

- (void)configTableViewHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120*kWidthRatio+130)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = UIColorFromRGBValue(0xAAAAAA);
    titleLabel.text = @"您当前绑定的银行卡是：";
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headerView).with.offset(kSpace);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
    }];
    CRFChangeBankCardInfoView *cardInfoView = [[CRFChangeBankCardInfoView alloc] init];
    [cardInfoView.bankBgImg sd_setImageWithURL:[NSURL URLWithString:self.bankInfo.bankPicUrl]];
    [headerView addSubview:cardInfoView];
    [cardInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(kSpace);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.height.mas_equalTo(120*kWidthRatio+40);
    }];
    UILabel *promptLabel = [UILabel new];
    [headerView addSubview:promptLabel];
    promptLabel.text = @"请输入新的银行卡信息：";
    promptLabel.textColor = UIColorFromRGBValue(0xAAAAAA);
    promptLabel.font = [UIFont systemFontOfSize:14.0];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardInfoView);
        make.top.equalTo(cardInfoView.mas_bottom).with.offset(15);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.height.mas_equalTo(15);
    }];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFCreateAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createAccountCell"];
    if (!cell) {
        cell = [[CRFCreateAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"createAccountCell"];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(addTextFieldNotification:) name:UITextFieldTextDidChangeNotification  object:cell.textField];
        cell.textField.delegate = self;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textField.text = self.values[indexPath.row];
    [cell updateWithTitle:cell.textLabel.text];
    weakSelf(self);
    if (indexPath.row == 0) {
        cell.rightViewStyle = List;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.textField setPasteHandler:^ (CRFBankNoTextField *textField){
            strongSelf(weakSelf);
            [strongSelf pasteTextFieldValue:textField];
        }];
    }
    else if (indexPath.row == 1) {
        if (self.values.count ==3) {
            cell.rightViewStyle = PhoneNumber;
            cell.hasAccessoryView = NO;
        }else{
            cell.rightViewStyle = Default;
            cell.hasAccessoryView = NO;
        }
        
    } else if (indexPath.row == 2){
        if (self.values.count ==3) {
            cell.rightViewStyle = CodeValue;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.hasAccessoryView = NO;
        }else{
            cell.rightViewStyle = Default;
            cell.hasAccessoryView = YES;
        }
        
    }else if (indexPath.row == 3){
        cell.rightViewStyle = Default;
        cell.hasAccessoryView = NO;
    }else if (indexPath.row == 4){
        cell.rightViewStyle = Default;
        cell.hasAccessoryView = YES;
    }
    [cell setRightHandler:^(NSInteger index){
        strongSelf(weakSelf);
        if (index == 2) {
            [strongSelf.navigationController pushViewController:[CRFSupportBankInfoViewController new] animated:YES];
        }
        if (index == 6) {
            [weakSelf prepareChangeCardInfo];
        }
        if (index == 7) {
            [weakSelf.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:nil];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2&&self.titles.count==5) {
        [self.view endEditing:YES];
        [self showPickerView:YES];
    }
}

- (void)showPickerView:(BOOL)show {
    if (self.show == show) {
        return;
    }
    self.show = show;
    [self.pickerView update:self.show];
}

- (void)addPickerView {
    _pickerView = [[CRFPickerView alloc] initWithType:Create_Account];
    weakSelf(self);
    [_pickerView setCancelHandler:^{
        strongSelf(weakSelf);
        [strongSelf showPickerView:NO];
    }];
    [_pickerView setComplataHandler:^ (CRFBankCity *city, NSInteger subCityIndex, NSInteger townIndex){
        strongSelf(weakSelf);
        [strongSelf showPickerView:NO];
        NSString *string = [NSString stringWithFormat:@"%@%@",city.name,city.bankCities[townIndex].name];
        strongSelf.provinceCode = city.code;
        strongSelf.cityCode = city.bankCities[townIndex].code;
        strongSelf.branchName = string;
        [strongSelf.values replaceObjectAtIndex:2 withObject:string];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.pickerView show];
}

- (void)addTextFieldNotification:(NSNotification *)notification {
    CRFBankNoTextField *tf = notification.object;
    if (tf.pasteFlag) {
        return;
    }
    CRFCreateAccountTableViewCell *cell =  (CRFCreateAccountTableViewCell *)tf.superview;
    if (cell.rightViewStyle == List) {
        if (tf.text.length == 6) {
            //支持的银行卡
            if ([tf.text getBankCardInfo]) {
                NSString *info = [NSString stringWithFormat:NSLocalizedString(@"footer_create_account_bottom", nil),[tf.text getBankCardInfo].phone];
                self.telePhone = [tf.text getBankCardInfo].phone;
                self.bankCode = [tf.text getBankCardInfo].bankCode;
                if (self.bottomLabel) {
                    [self.bottomLabel setAttributedText:[CRFStringUtils setAttributedString:info lineSpace:0 attributes1:@{NSFontAttributeName:[self getFont],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, info.length - [tf.text getBankCardInfo].phone.length) attributes2:@{NSFontAttributeName:[self getFont],NSForegroundColorAttributeName:kLinkTextColor} range2:[info rangeOfString:[tf.text getBankCardInfo].phone] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                }
                [self updateDatas:tf bankName:[tf.text getBankCardInfo].bankName];
            } else {
                if (self.titles.count > 6) {
                    [self deleteDatas];
                }
            }
        } else {
            if (tf.text.length < 6) {
                if (self.titles.count == 5) {
                    [self deleteDatas];
                }
            }
        }
    }
    if (cell.rightViewStyle == List) {
        [self.values replaceObjectAtIndex:0 withObject:tf.text];
    }
    else if (cell.rightViewStyle == CodeValue){
        if (self.values.count>3) {
            [self.values replaceObjectAtIndex:4 withObject:tf.text];

        }else{
            [self.values replaceObjectAtIndex:2 withObject:tf.text];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pasteTextFieldValue:(UITextField *)textField {
    CRFCreateAccountTableViewCell *cell =  (CRFCreateAccountTableViewCell *)textField.superview;
    if (textField.text.length >= 6) {
        //支持的银行卡
        if ([textField.text getBankCardInfo]) {
            NSString *info = [NSString stringWithFormat:NSLocalizedString(@"footer_create_account_bottom", nil),[textField.text getValidateBankCardInfo].phone];
            self.telePhone = [textField.text getValidateBankCardInfo].phone;
            self.bankCode = [textField.text getValidateBankCardInfo].bankCode;
            if (self.telePhone) {
                if (self.bottomLabel) {
                    [self.bottomLabel setAttributedText:[CRFStringUtils setAttributedString:info lineSpace:0 attributes1:@{NSFontAttributeName:[self getFont],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, info.length - [textField.text getValidateBankCardInfo].phone.length) attributes2:@{NSFontAttributeName:[self getFont],NSForegroundColorAttributeName:kLinkTextColor} range2:[info rangeOfString:[textField.text getBankCardInfo].phone] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                }
            }
            [self updateDatas:textField bankName:[textField.text getValidateBankCardInfo].bankName];
        } else {
            if (self.titles.count > 3) {
                [self deleteDatas];
            }
        }
    } else {
        if (textField.text.length < 6) {
            if (self.titles.count == 5) {
                [self deleteDatas];
            }
        }
    }
    [self.values replaceObjectAtIndex:cell.indexPath.row withObject:textField.text];
}

- (void)updateDatas:(UITextField *)tf bankName:(NSString *)bankName {
    if (self.titles.count == 5 || self.values.count == 5) {
        return;
    }
    weakSelf(self);
    [CRFUtils getMainQueue:^{
        DLog(@"inset cell");
        strongSelf(weakSelf);
        if (self.telePhone) {
            [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(15);
            }];
            [UIView animateWithDuration:.0 animations:^{
                [self.tableView layoutIfNeeded];
            }];
            self.bottomLabel.hidden = NO;
        } else {
            self.bottomLabel.hidden = YES;
        }
        
        [self.titles insertObject:@"银行名称" atIndex:1];
        [self.titles insertObject:@"开户行所在地" atIndex:2];
        [self.values insertObject:bankName atIndex:1];
        [self.values insertObject:@"" atIndex:2];
        [strongSelf.tableView beginUpdates];
        [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        if ([strongSelf.tableView respondsToSelector:@selector(endUpdates)]) {
            [strongSelf.tableView endUpdates];
        }
    }];
}

- (void)deleteDatas {
    [self.tableView beginUpdates];
    [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:.0 animations:^{
        [self.tableView layoutIfNeeded];
    }];
    self.bottomLabel.hidden = YES;
    DLog(@"delete cell");
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.titles removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
    [self.values removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
    
    [self.tableView endUpdates];
}

- (UIFont *)getFont {
    if (kScreenWidth == 320) {
        return [UIFont systemFontOfSize:13.0];
    }
    return [UIFont systemFontOfSize:14.0];
}

- (void)parserResponse:(id)response {
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        CRFCardSupportInfo*cardInfo = [CRFResponseFactory handleDataForResult:response];
        self.telePhone = nil;
        self.bankCode = cardInfo.bankCode;
        if (self.values.count < 3) {
            UITextField *tf = [UITextField new];
            tf.text = cardInfo.bankCode;
            [self updateDatas:tf bankName:cardInfo.bankName];
        }
        if ([cardInfo.businessSupport isEqualToString:@"0"]) {
            self.isSupport = YES;
            [[CRFAppManager defaultManager] addRemoteBankInfoWithLocal:cardInfo];
        } else {
            self.isSupport = NO;
            [CRFUtils showMessage:@"toast_unsupport_bank_card"];
        }
    } else {
        [CRFUtils showMessage:response[kMessageKey]];
    }
}

- (void)commitInfo {
    if ([self.values[0] isEmpty]) {
        [CRFUtils showMessage:@"toast_input_bank_no"];
        return;
    }
    if (self.values.count <=2) {
        [CRFUtils showMessage:@"toast_bank_number_error"];
        return;
    }
    if ([self.values[2] isEmpty]) {
        [CRFUtils showMessage:@"toast_choose_address"];
        return;
    }
    if (!self.phoneCode.length) {
        [CRFUtils showMessage:@"toast_input_verify_code"];
        return;
    }
    
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kConfirmChangeBankCardPath),kUuid,self.phoneCode] paragrams:nil success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            weakSelf(self);
            [CRFUserDefaultManager setBankCardAuditErrorFlag:NO];
            [CRFUserDefaultManager setBankAuditStatus:YES];
            CRFCommonResultViewController *successViewController = [CRFCommonResultViewController new];
            successViewController.commonResult = CRFCommonResultSuccess;
            successViewController.result = @"银行卡更换成功！";
            successViewController.title = @"更换银行卡反馈";
            
            [successViewController setCommonButtonHandler:^(NSInteger index, CRFCommonResultViewController *resultController){
                strongSelf(weakSelf);
                [strongSelf goBackNeedUpdate:YES];
            }];
            [successViewController setPopHandler:^(CRFCommonResultViewController *resultController){
                strongSelf(weakSelf);
                [strongSelf goBackNeedUpdate:YES];
            }];
            [self.navigationController pushViewController:successViewController animated:YES];

        } else {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
    
    
    //    if (_isSupport) {
    //        CRFUploadImageViewController *imageViewController = [CRFUploadImageViewController new];
    //        imageViewController.cardNO = self.values[0];
    //        imageViewController.cityID = self.cityCode;
    //        DLog(@"bank card info is %@====%@    cityID is %@   bank code is %@",self.values,self.bankCode,self.cityCode,[self.values[0] getBankCardInfo].bankCode);
    //        imageViewController.bankNo = [self.values[0] getBankCardInfo].bankCode;
    //        [self.navigationController pushViewController:imageViewController animated:YES];
    //    } else {
    //        [CRFUtils showMessage:@"toast_unsupport_bank_card"];
    //    }
}
-(void)prepareChangeCardInfo{
    if ([self.values[0] isEmpty]) {
        [CRFUtils showMessage:@"toast_input_bank_no"];
        return;
    }
    if (self.values.count <=2) {
        [CRFUtils showMessage:@"toast_bank_number_error"];
        return;
    }
    if ([self.values[2] isEmpty]) {
        [CRFUtils showMessage:@"toast_choose_address"];
        return;
    }
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetChangeBankCardCodePath),kUuid] paragrams:@{@"bankCardNo":self.values[0],@"bankCode":self.bankCode,@"branchName":self.branchName,@"cityId":self.cityCode} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            [CRFUtils showMessage:@"toast_send_verify_code"];
            strongSelf(weakSelf);
            CRFCreateAccountTableViewCell *cell = (CRFCreateAccountTableViewCell *)[strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            [cell.codeBtn crfStartCountDown];
        }else {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
- (void)goBackNeedUpdate:(BOOL)update {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CRFBankCardViewController class]]) {
            if (update) {
                CRFBankCardViewController *controller = (CRFBankCardViewController *)viewController;
                if (controller.updateBankStatus) {
                    controller.updateBankStatus();
                }
            }
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    [super back];
}
#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CRFCreateAccountTableViewCell *cell = (CRFCreateAccountTableViewCell *)textField.superview;
    if (cell.rightViewStyle == PhoneNumber) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    CRFCreateAccountTableViewCell *cell = (CRFCreateAccountTableViewCell *)textField.superview;
    if (cell.rightViewStyle == List) {
        if ([textField.text validateBankCard]&&textField.text.length>0) {
            [self checkCardInfo:textField.text];
        } else {
            _isSupport = NO;
        }
    } else {
        _isSupport = NO;
    }
    if (cell.rightViewStyle == CodeValue) {
        self.phoneCode = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > 19) {
        return NO;
    }
    return YES;
}

- (void)checkCardInfo:(NSString*)text {
    [CRFLoadingView loading];
    [self.values replaceObjectAtIndex:0 withObject:text];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kBankcardInfoPath) paragrams:@{@"bankCardNo":text} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        [self parserResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
        self.isSupport = NO;
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

@end
