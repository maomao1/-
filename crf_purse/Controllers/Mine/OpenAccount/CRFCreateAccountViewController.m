//
//  CRFCreateAccountViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCreateAccountViewController.h"
#import "CRFCreateAccountTableViewCell.h"
#import "CRFSupportBankInfoViewController.h"
#import "IQKeyboardManager.h"
#import "CRFPickerView.h"
#import "CRFChangeMBView.h"
#import "CRFOpenAccountStatusViewController.h"
#import "CRFHomeConfigHendler.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFRelateAccountViewController.h"
#import "CRFCardSupportInfo.h"
#import "UITableView+Custom.h"
#import "CRFAlertUtils.h"
#import "CRFStringUtils.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "NSAttributedString+JCCalculateSize.h"
#import "CRFLogoView.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFMessageVerifyViewController.h"
@interface CRFCreateAccountViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate> {
    NSMutableArray <NSMutableArray <NSString *>*>*titles;
    NSArray <NSArray <NSString *>*>*placeholders;
    NSMutableArray <NSMutableArray <NSString *>*>*values;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CRFChangeMBView *mbView;
@property (nonatomic, strong) CRFPickerView *pickerView;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, copy) NSString *mobleNumber;
@property (nonatomic, strong) UIButton *protocolButton;
@property (nonatomic, copy) NSString *telePhone;
@property (nonatomic, assign) BOOL   isSupport;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, strong)CRFAppointmentForwardHelpView *helpView;
@end

@implementation CRFCreateAccountViewController

- (void)back {
    [self.view endEditing:YES];
    [super back];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    self.mobleNumber = [CRFAppManager defaultManager].userInfo.phoneNo;
    if (values.count > 2) {
        [values[2] replaceObjectAtIndex:0 withObject:[[CRFAppManager defaultManager].userInfo.phoneNo formatMoblePhone]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [values[1] replaceObjectAtIndex:1 withObject:[[CRFAppManager defaultManager].userInfo.phoneNo formatMoblePhone]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = NSLocalizedString(@"title_open_account", nil);
    self.mobleNumber = [CRFAppManager defaultManager].userInfo.phoneNo;
    titles = [@[[@[NSLocalizedString(@"cell_label_real_name", nil),NSLocalizedString(@"cell_label_identifier_create_account", nil)] mutableCopy],[@[NSLocalizedString(@"cell_label_bankcard_no",nil),NSLocalizedString(@"cell_label_bank_mobile_phone", nil)] mutableCopy]] mutableCopy];
    placeholders = @[@[@"",NSLocalizedString(@"cell_label_placeholder_identifier", nil)] ,@[@"",@"",@""],@[@""]];
    values = [@[[@[@"",@""] mutableCopy],[@[@"",[[CRFAppManager defaultManager].userInfo formatMobilePhone]] mutableCopy]] mutableCopy];
    [self footerView];
    [self confihBMView];
    [self addPickerView];
    [self.tableView setTextEidt:YES];
    [self autoLayoutSizeContentView:self.tableView];
}
- (CRFAppointmentForwardHelpView *)helpView {
    if (!_helpView) {
        _helpView = [CRFAppointmentForwardHelpView new];
        _helpView.helpStyle = CRFHelpViewStyleContainTitleAndContext;
        _helpView.title = @"银行预留手机号";
        [_helpView setDissmissPoint:CGPointMake(kScreenWidth , 0)];
        [_helpView drawContent:@"请确保注册手机与银行预留手机号一致，否则将会导致开户失败；\n\n如果目前不一致，可联系我司客服修改注册手机号或者自行前往银行修改预留手机号。"];
    }
    return _helpView;
}
- (void)confihBMView {
    _mbView = [[CRFChangeMBView alloc] init];
    weakSelf(self);
    __weak __typeof(values) weakValues = values;
    [self.mbView setCommitHandler:^(NSString *code, NSString *moblePhone){
        strongSelf(weakSelf);
        strongSelf.mobleNumber = moblePhone;
        [CRFLoadingView loading];
        [[CRFStandardNetworkManager defaultManager] post:APIFormat(kChangeMoblePhonePath) paragrams:@{kMobilePhone:moblePhone,kVerifyCode:code} success:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            if (weakValues.count > 2) {
                [weakValues[2] replaceObjectAtIndex:0 withObject:strongSelf.mobleNumber];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [weakValues[1] replaceObjectAtIndex:1 withObject:strongSelf.mobleNumber];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [strongSelf checkUserAccountStatus];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFUtils showMessage:response[kMessageKey]];
            [CRFLoadingView dismiss];
            strongSelf.mobleNumber = [CRFAppManager defaultManager].userInfo.phoneNo;
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == titles.count-1) {
        return CGFLOAT_MIN;
    }
    return kTopSpace / 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == titles.count-1) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopSpace / 2)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }
    if (section == 2) {
        return 33;
    }
    NSString *title = NSLocalizedString(@"header_bind_bank_card", nil);
    CGFloat height = [title boundingRectWithSize:CGSizeMake(kScreenWidth - 2*kSpace, MAXFLOAT) fontNumber:13 lineSpace:5].height;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, 0, kScreenWidth - kSpace * 2, 60)];
        topLabel.text = NSLocalizedString(@"header_create_account_top_title", nil);
        topLabel.numberOfLines = 0;
        topLabel.textColor = UIColorFromRGBValue(0x999999);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:topLabel.text];;
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, topLabel.text.length)];
        [topLabel setAttributedText:attributedString];
        topLabel.font = [UIFont systemFontOfSize:13.0f];
        [view addSubview:topLabel];
        return view;
    } else if (section == 1) {
        NSString *title = NSLocalizedString(@"header_bind_bank_card", nil);
        CGFloat height = [title boundingRectWithSize:CGSizeMake(kScreenWidth - 2*kSpace, MAXFLOAT) fontNumber:13 lineSpace:5].height;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, 0, kScreenWidth - kSpace * 2, height)];
        bottomLabel.textColor = UIColorFromRGBValue(0x999999);
        bottomLabel.font = [UIFont systemFontOfSize:13.0];
        bottomLabel.numberOfLines = 0;
        [bottomLabel setAttributedText:[CRFStringUtils setAttributedString:title lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x888888)} range1:[title rangeOfString:@"绑定银行卡：\n推荐绑定广发、兴业、光大、平安、工商、建设、中信银行储蓄卡。"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0xbbbbbb)} range2:[title rangeOfString:@"若绑定的银行卡属于非一类账户，您的充值和提现体验将会受到影响，因此建议您绑定一类账户。具体账户类型可咨询发卡行。"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
//        bottomLabel.text = NSLocalizedString(@"header_bind_bank_card", nil);
        [view addSubview:bottomLabel];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, 0, kScreenWidth - kSpace , 33)];
        bottomLabel.textColor = UIColorFromRGBValue(0x999999);
        bottomLabel.font = [UIFont systemFontOfSize:13.0];
        if (self.telePhone) {
            NSString *info = [NSString stringWithFormat:NSLocalizedString(@"footer_create_account_bottom", nil),[values[1][0] getBankCardInfo].phone];
            [bottomLabel setAttributedText:[CRFStringUtils setAttributedString:info lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, info.length - [values[1][0] getBankCardInfo].phone.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kLinkTextColor} range2:[info rangeOfString:[values[1][0] getBankCardInfo].phone] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        }
        self.bottomLabel = bottomLabel;
        [view addSubview:bottomLabel];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFCreateAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createAccountCell"];
    if (!cell) {
        cell = [[CRFCreateAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"createAccountCell"];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(addTextFieldNotification:) name:UITextFieldTextDidChangeNotification  object:cell.textField];
        cell.textField.delegate = self;
    }
    cell.indexPath = indexPath;
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.rightViewStyle = Help;
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
#ifdef WALLET
        if ([CRFUtils normalUser]) {
            cell.rightViewStyle = List;
        } else {
            cell.rightViewStyle = CanEdit;
        }
#else
        cell.rightViewStyle = List;
#endif
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        weakSelf(self);
        [cell.textField setPasteHandler:^ (CRFBankNoTextField *textField){
            strongSelf(weakSelf);
            [strongSelf pasteTextFieldValue:textField];
        }];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        cell.rightViewStyle = CanEdit;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    } else {
        if (titles.count > 2) {
            if (indexPath.section == 1 && indexPath.row == 2) {
                cell.hasAccessoryView = YES;
                cell.rightViewStyle = Default;
            } else {
                cell.hasAccessoryView = NO;
                if (indexPath.section == 2 && indexPath.row == 0) {
                    cell.rightViewStyle = Verify;
                } else {
                    cell.rightViewStyle = Default;
                }
            }
        } else {
            if (indexPath.section == 1 && indexPath.row == 1) {
                cell.rightViewStyle = Verify;
            } else if (indexPath.section == 0 && indexPath.row == 0) {
                cell.rightViewStyle = CanEdit;
            } else {
                cell.rightViewStyle = Default;
            }
            cell.hasAccessoryView = NO;
        }
    }
    cell.textField.placeholder = placeholders[indexPath.section][indexPath.row];
    cell.textField.text = values[indexPath.section][indexPath.row];
    [cell updateWithTitle:cell.textLabel.text];
    weakSelf(self);
    [cell setRightHandler:^(NSInteger index){
        strongSelf(weakSelf);
        if (index == 1) {
            [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_view_call_message", nil) message:nil container:strongSelf cancelTitle:NSLocalizedString(@"alert_view_i_known", nil) confirmTitle:NSLocalizedString(@"alert_view_call", nil) cancelHandler:nil confirmHandler:^{
                NSURL *callUrl = [NSURL
                                  URLWithString:[NSString stringWithFormat:@"tel:400-178-9898"]];
                if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                    [[UIApplication sharedApplication] openURL:callUrl];
                }
            }];
        } else if (index == 2) {
            [CRFAPPCountManager setEventID:@"OPEN_ACCOUNT_BANK_LIST_EVENT" EventName:@"银行列表"];
            CRFSupportBankInfoViewController *controller= [CRFSupportBankInfoViewController new];
            [strongSelf.navigationController pushViewController:controller animated:YES];
        } else if (index == 3) {
            [CRFAPPCountManager setEventID:@"OPEN_ACCOUNT_MODIFY_PHONE" EventName:@"开户修改预留手机号"];
            [strongSelf.mbView show];
        }else if (index == 5){
            [weakSelf.helpView show:[UIApplication sharedApplication].delegate.window dismissHandler:nil];
        }
    }];
    return cell;
}

- (void)addTextFieldNotification:(NSNotification *)notification {
    CRFBankNoTextField *tf = notification.object;
    if (tf.pasteFlag) {
        return;
    }
    CRFCreateAccountTableViewCell *cell =  (CRFCreateAccountTableViewCell *)tf.superview;
    NSMutableArray <NSString *>*array = values[cell.indexPath.section];
    if (cell.indexPath.section == 1 && cell.indexPath.row == 0) {
        NSMutableArray <NSString *>*subTitles = titles[cell.indexPath.section];
        if (tf.text.length == 6) {
            //支持的银行卡
            if ([tf.text getBankCardInfo]) {
                NSString *info = [NSString stringWithFormat:NSLocalizedString(@"footer_create_account_bottom", nil),[tf.text getBankCardInfo].phone];
                self.telePhone = [tf.text getBankCardInfo].phone;
                self.bankCode = [tf.text getBankCardInfo].bankCode;
                if (self.telePhone) {
                    if (self.bottomLabel) {
                        [self.bottomLabel setAttributedText:[CRFStringUtils setAttributedString:info lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, info.length - [tf.text getBankCardInfo].phone.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kLinkTextColor} range2:[info rangeOfString:[tf.text getBankCardInfo].phone] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                    }
                }
                [self updateDatas:subTitles array2:array tf:tf bankName:[tf.text getBankCardInfo].bankName];
            } else {
                self.bankCode = nil;
                self.telePhone = nil;
                if (titles.count > 2) {
                    [self deleteDatas:subTitles array2:array];
                }
            }
        } else {
            if (tf.text.length < 6) {
                if (titles.count == 3) {
                    [self deleteDatas:subTitles array2:array];
                }
            }
        }
    }
    if (cell.indexPath.section == 0 && cell.indexPath.row == 1) {
        tf.text = [tf.text uppercaseString];
    }
    [array replaceObjectAtIndex:cell.indexPath.row withObject:tf.text];
}

- (void)updateDatas:(NSMutableArray *)array1 array2:(NSMutableArray *)array2 tf:(UITextField *)tf bankName:(NSString *)bankName {
    if (array1.count == 3 || titles.count == 3) {
        return;
    }
    weakSelf(self);
    [CRFUtils getMainQueue:^{
        DLog(@"inset cell");
        strongSelf(weakSelf);
        [strongSelf.tableView beginUpdates];
        [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [strongSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        [array1 replaceObjectAtIndex:1 withObject:NSLocalizedString(@"cell_label_bank_name", nil)];
        [array1 addObject:NSLocalizedString(@"cell_label_bank_city", nil)];
        [titles addObject:[@[NSLocalizedString(@"cell_label_bank_mobile_phone", nil)] mutableCopy]];
        [values addObject:[@[[[CRFAppManager defaultManager].userInfo formatMobilePhone]] mutableCopy]];
        [array2 replaceObjectAtIndex:1 withObject:bankName];
        [array2 addObject:@""];
        if ([strongSelf.tableView respondsToSelector:@selector(endUpdates)]) {
            [strongSelf.tableView endUpdates];
        }
    }];
}

- (void)deleteDatas:(NSMutableArray *)array1 array2:(NSMutableArray *)array2 {
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    DLog(@"delete cell");
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    [titles removeLastObject];
    [values removeLastObject];
    [array1 removeLastObject];
    [array2 removeLastObject];
    [array1 replaceObjectAtIndex:1 withObject:NSLocalizedString(@"cell_label_bank_mobile_phone", nil)];
    [array2 replaceObjectAtIndex:1 withObject:[[CRFAppManager defaultManager].userInfo formatMobilePhone]];
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 103 + 78)];
    footerView.userInteractionEnabled = YES;
    UILabel *protocolTV = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, kScreenWidth - 40 - kSpace, 12)];
    protocolTV.backgroundColor = [UIColor clearColor];
    protocolTV.font = [UIFont systemFontOfSize:10.0];
    protocolTV.numberOfLines = 0;
    NSMutableString *protocolString = [NSMutableString new];
    NSMutableArray <NSString *>*protocolNames = [NSMutableArray new];
    NSMutableArray <NSString *>*protocolLinks = [NSMutableArray new];
#ifdef WALLET
    if (![CRFUtils normalUser]) {
        [protocolString appendFormat:@"《信而富财富管理有限公司》"];
        [protocolNames addObject:@"《信而富财富管理有限公司》"];
        [protocolLinks addObject:kOpenAccountProtocolH5];
    } else {
        for (CRFProtocol *p in [CRFHomeConfigHendler defaultHandler].createAccountProtocols) {
            [protocolString appendString:p.name];
            [protocolNames addObject:p.name];
            [protocolLinks addObject:p.protocolUrl];
        }
    }
#else
        for (CRFProtocol *p in [CRFHomeConfigHendler defaultHandler].createAccountProtocols) {
            [protocolString appendString:p.name];
            [protocolNames addObject:p.name];
            [protocolLinks addObject:p.protocolUrl];
        }
#endif
    
    NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"label_create_account_protocol", nil),protocolString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor} range:[totalString rangeOfString:protocolString]];
    
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, totalString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x666666) range:[totalString rangeOfString:NSLocalizedString(@"label_create_account_protocol1", nil)]];
    [protocolTV setAttributedText:attributedString];
    [footerView addSubview:protocolTV];
    protocolTV.userInteractionEnabled = YES;
    protocolTV.enabledTapEffect = NO;
    
    NSMutableAttributedString *contentChar = [[NSMutableAttributedString alloc] initWithString:totalString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]}];
    [contentChar addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, totalString.length)];
    CGFloat contentCharHeight = [contentChar sizeWithMaxWidth:kScreenWidth - 40 - kSpace].height + 4;
    protocolTV.frame = CGRectMake(35, 16, kScreenWidth - 40 - kSpace, contentCharHeight);
    weakSelf(self);
    [protocolTV yb_addAttributeTapActionWithStrings:protocolNames tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        strongSelf(weakSelf);
        CRFStaticWebViewViewController *webContorller = [CRFStaticWebViewViewController new];
#ifdef WALLET
        if (![CRFUtils normalUser]) {
            webContorller.urlString = kOpenAccountProtocolH5;
        } else {
            webContorller.urlString = [protocolLinks objectAtIndex:index];
        }
#else
            webContorller.urlString = [protocolLinks objectAtIndex:index];
#endif
        
        [strongSelf.navigationController pushViewController:webContorller animated:YES];
    }];
    
    _protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_protocolButton setImage:[UIImage imageNamed:@"protocol_selected"] forState:UIControlStateNormal];
    [_protocolButton setImage:[UIImage imageNamed:@"protocol_unselected"] forState:UIControlStateSelected];
    _protocolButton.selected = YES;
    [_protocolButton addTarget:self action:@selector(changed:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_protocolButton];
    _protocolButton.frame = CGRectMake(0, 0, 40, 44);
    _protocolButton.imageView.contentMode = UIViewContentModeCenter;
    UIButton *desButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [desButton setTitle:NSLocalizedString(@"button_create_account", nil) forState:UIControlStateNormal];
    desButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    desButton.backgroundColor = kButtonNormalBackgroundColor;
    desButton.layer.masksToBounds = YES;
    desButton.layer.cornerRadius = 5.0f;
    desButton.frame = CGRectMake(kSpace, 60, kScreenWidth - kSpace * 2, 42);
    [footerView addSubview:desButton];
    [desButton addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
#ifdef WALLET
    if (![CRFUtils normalUser]) {
        return;
    }
#endif
    CRFLogoView *logoView = [CRFLogoView new];
    [footerView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(footerView);
        make.bottom.equalTo(footerView.mas_bottom).with.offset(-30);
        make.height.mas_equalTo(18);
    }];
}

- (void)changed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        [self.view endEditing:YES];
        [self showPickerView:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CRFCreateAccountTableViewCell *cell = (CRFCreateAccountTableViewCell *)textField.superview;
    if (values.count > 2) {
        if (cell.indexPath.section == 2 && cell.indexPath.row == 0) {
            return NO;
        }
    } else {
        if (cell.indexPath.section == 1 && cell.indexPath.row == 1) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CRFCreateAccountTableViewCell *cell = (CRFCreateAccountTableViewCell *)textField.superview;
    if (cell.rightViewStyle == List) {
        if ([textField.text validateBankCard]) {
             [self checkCardInfo:textField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CRFCreateAccountTableViewCell *cell = (CRFCreateAccountTableViewCell *)textField.superview;
    if (cell.indexPath.section == 0 && cell.indexPath.row == 0) {
        if ([string isEmpty]) {
            return YES;
        }
        if ([string stringIsNumber]) {
            return NO;
        }
        return YES;
    }
    if (cell.indexPath.section == 0 && cell.indexPath.row == 1) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 18 && ![string isEmpty]) {
            return NO;
        }
    }
    if (cell.indexPath.section == 1 && cell.indexPath.row == 0) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 19) {
            return NO;
        }
    }
    return YES;
}

- (void)addPickerView {
    _pickerView = [[CRFPickerView alloc] initWithType:Create_Account];
    weakSelf(self);
    [_pickerView setCancelHandler:^{
        strongSelf(weakSelf);
        [strongSelf showPickerView:NO];
    }];
    __weak __typeof(values) weakArray = values;
    [_pickerView setComplataHandler:^ (CRFBankCity *city, NSInteger subCityIndex, NSInteger townIndex){
        strongSelf(weakSelf);
        [strongSelf showPickerView:NO];
        NSString *string = [NSString stringWithFormat:@"%@%@",city.name,city.bankCities[townIndex].name];
        strongSelf.provinceCode = city.code;
        strongSelf.cityCode = city.bankCities[townIndex].code;
        NSMutableArray *desArray = weakArray[1];
        [desArray replaceObjectAtIndex:2 withObject:string];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.pickerView show];
}

- (void)showPickerView:(BOOL)show {
    if (self.show == show) {
        return;
    }
    self.show = show;
    [self.pickerView update:self.show];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)createAccount {
    if ([values[0][0] isEmpty]) {
        [CRFUtils showMessage:@"toast_input_real_name"];
        return;
    }
    if (![values[0][0] validateUserName]) {
        [CRFUtils showMessage:@"您输入的姓名格式错误"];
        return;
    }
    if ([values[0][1] isEmpty]) {
        [CRFUtils showMessage:@"toast_input_identifier"];
        return;
    }
    if (![values[0][1] validateIdentityCard]) {
        [CRFUtils showMessage:@"toast_valide_identifier"];
        return;
    }
    if ([values[1][0] isEmpty]) {
        [CRFUtils showMessage:@"toast_input_bank_no"];
        return;
    }
        if (![values[1][0] validateBankCard]) {
             [CRFUtils showMessage:@"toast_bank_number_error"];
            return;
        }
    if (values.count <=2) {
        [CRFUtils showMessage:@"toast_unsupport_bank_card"];
        return;
    }
    if ([values[1][2] isEmpty]) {
        [CRFUtils showMessage:@"toast_choose_address"];
        return;
    }
    if (self.protocolButton.selected) {
        [CRFUtils showMessage:@"toast_choose_create_protocol"];
        return;
    }
    if (_isSupport) {
        [self createAccountInterface];
    } else {
        [CRFUtils showMessage:@"toast_unsupport_bank_card"];
    }
    //    [self checkUserAccountStatus];
    //    [self checkCardInfo];
    
}

- (void)checkCardInfo:(NSString*)text {
    [CRFLoadingView loading];
    weakSelf(self);
    __weak __typeof(values) weakvalues = values;
    __weak __typeof(titles) weakTitles = titles;
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kBankcardInfoPath) paragrams:@{@"bankCardNo":text} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        CRFCardSupportInfo*cardInfo = [CRFResponseFactory handleDataForResult:response];
        strongSelf.telePhone = nil;
        strongSelf.bankCode = cardInfo.bankCode;
        if (weakvalues.count < 3) {
            UITextField *tf = [UITextField new];
            tf.text = cardInfo.bankCode;
            [strongSelf updateDatas:weakTitles[1] array2:weakvalues[1] tf:tf bankName:cardInfo.bankName];
        }
        
        if ([cardInfo.businessSupport isEqualToString:@"0"]) {
            strongSelf.isSupport = YES;
        }else{
            strongSelf.isSupport = NO;
            [CRFUtils showMessage:@"toast_unsupport_bank_card"];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)createAccountInterface {
    [CRFLoadingView disableLoading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kCreateAccountPath),kUuid] paragrams:[self getUserInfo] success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            [CRFUtils delayAfert:kToastDuringTime handle:^{
                [strongSelf parseResponseStatus:response];
//                [strongSelf.navigationController pushViewController:[CRFOpenAccountStatusViewController new] animated:YES];
                [CRFAPPCountManager setEventID:@"OPEN_ACCOUNT_EVENT" EventName:@"开户成功"];
            }];
            
        } else {
            [CRFAPPCountManager setFailedEventID:@"open_account_failed" reason:response[kMessageKey] productNo:@""];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFAPPCountManager setFailedEventID:@"open_account_failed" reason:response[kMessageKey]  productNo:@""];
    }];
}
-(void)parseResponseStatus:(id)response{
    NSDictionary *result = (NSDictionary*)response;
    NSInteger status  = [result[@"data"][@"signed"] integerValue];
    if (status == 6||status == 1) {
        [self.navigationController pushViewController:[CRFOpenAccountStatusViewController new] animated:YES];
    }else{
        CRFMessageVerifyViewController *verifyVc = [CRFMessageVerifyViewController new];
        verifyVc.ResultType = OpenResult;
        [self.navigationController pushViewController:verifyVc animated:YES];
    }
}
- (void)checkUserAccountStatus {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":self.mobleNumber} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
            [CRFAlertUtils showAlertTitle:@"温馨提示" message:[NSString stringWithFormat:@"手机号码%@已开通存管账户，您可通过身份验证关联绑定该账户",strongSelf.mobleNumber] container:strongSelf cancelTitle:nil confirmTitle:@"去关联" cancelHandler:nil confirmHandler:^{
                CRFRelateAccountViewController *controller = [CRFRelateAccountViewController new];
                controller.relatePhone = strongSelf.mobleNumber;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            }];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (NSDictionary *)getUserInfo {
    return @{@"userName":values[0][0],@"openMobilePhone":self.mobleNumber,@"idNo":values[0][1],@"openBankCode":self.bankCode,@"openAccountCityNo":self.cityCode,@"openBankCardNo":values[1][0]};
}

- (void)pasteTextFieldValue:(UITextField *)textField {
    CRFCreateAccountTableViewCell *cell =  (CRFCreateAccountTableViewCell *)textField.superview;
    NSMutableArray <NSString *>*array = values[cell.indexPath.section];
    NSMutableArray <NSString *>*subTitles = titles[cell.indexPath.section];
    if (textField.text.length >= 6) {
        //支持的银行卡
        if ([textField.text getBankCardInfo]) {
            NSString *info = [NSString stringWithFormat:NSLocalizedString(@"footer_create_account_bottom", nil),[textField.text getBankCardInfo].phone];
            self.telePhone = [textField.text getBankCardInfo].phone;
            self.bankCode = [textField.text getBankCardInfo].bankCode;
            if (self.telePhone) {
                if (self.bottomLabel) {
                    [self.bottomLabel setAttributedText:[CRFStringUtils setAttributedString:info lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, info.length - [textField.text getBankCardInfo].phone.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kLinkTextColor} range2:[info rangeOfString:[textField.text getBankCardInfo].phone] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                }
            } else {
                if (self.bottomLabel) {
                    [self.bottomLabel setAttributedText:[CRFStringUtils setAttributedString:@"" lineSpace:0 attributes1:nil range1:NSRangeZero attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                }
            }
            [self updateDatas:subTitles array2:array tf:textField bankName:[textField.text getBankCode].bankName];
        } else {
            if (titles.count > 2) {
                [self deleteDatas:subTitles array2:array];
            }
        }
    } else {
        if (textField.text.length < 6) {
            if (titles.count == 3) {
                [self deleteDatas:subTitles array2:array];
            }
        }
    }
    if (cell.indexPath.section == 0 && cell.indexPath.row == 1) {
        textField.text = [textField.text uppercaseString];
    }
    [array replaceObjectAtIndex:cell.indexPath.row withObject:textField.text];
}

@end
