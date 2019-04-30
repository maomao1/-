//
//  CRFShiftInInvestmentView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFShiftInInvestmentView.h"
#import "CRFShiftInInvestmentTableViewCell.h"
#import "UITableViewCell+Access.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "CRFStringUtils.h"
#import "CRFHomeConfigHendler.h"
#import "CRFControllerManager.h"
#import "UITableView+Custom.h"
#import "CRFVerificationCodeView.h"

@interface CRFShiftInInvestmentView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CRFVerificationCodeView *verificationCodeView;

@property (nonatomic, assign) CGFloat keybaordHeight;

@property (nonatomic, assign) BOOL updateFrame;

/**
 投资按钮
 */
@property (nonatomic, strong) UIButton *investButton;

/**
 发送验证码按钮
 */
@property (nonatomic, strong) UIButton *timerButton;

/**
 是否发送了验证码
 */
@property (nonatomic, assign) BOOL flag;

/**
 协议是否勾选
 */
@property (nonatomic, assign) BOOL protocolSelected;

/**
 遮罩
 */
@property (nonatomic, strong) UIView *blackView;

/**
 键盘弹起动画时间
 */
@property (nonatomic, assign) CGFloat keyboardShowTimeInterval;

/**
 键盘隐藏动画时间
 */
@property (nonatomic, assign) CGFloat keyboardHideTimeInterval;

@end

@implementation CRFShiftInInvestmentView

- (CGFloat)keyboardShowTimeInterval {
    if (_keyboardShowTimeInterval <= .0f) {
        return .3f;
    }
    return _keyboardShowTimeInterval;
}

- (CGFloat)keyboardHideTimeInterval {
    if (_keyboardHideTimeInterval <= .0f) {
        return .3f;
    }
    return _keyboardHideTimeInterval;
}

- (NSString *)verifyCode {
    return [self cellWithIndex:3].textField.text;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initializeView];
        [self configTableViewHeaderView];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification];
         [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification];
    }
    return self;
}

- (void)keyboardHide:(NSNotification *)notification {
    self.keyboardHideTimeInterval = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    DLog(@"keyboard hide is %@",[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]);
}

- (void)keyboardShow:(NSNotification *)notification {
    if (!self.updateFrame) {
        return;
    }
    self.keyboardShowTimeInterval = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.keybaordHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITextField *textField = ((CRFShiftInInvestmentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).textField;
    CGRect rect = [textField.superview convertRect:textField.frame toView:self.blackView];
    if (kScreenHeight - rect.origin.y - rect.size.height < self.keybaordHeight) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.blackView).with.offset(-(self.keybaordHeight - 100));
        }];
        if ([self.investmentDelegate respondsToSelector:@selector(updateViewLayoutWithAnimationDuration:)]) {
            [self.investmentDelegate updateViewLayoutWithAnimationDuration:self.keyboardShowTimeInterval];
        }
    }
    DLog(@"keyboard show is %@",[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]);
}

- (void)initializeView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorColor = kCellLineSeparatorColor;
    [self.tableView setTextEidt:YES];
    _tableView.dataSource = self;
    [self addSubview:self.tableView];
    _investButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.investButton];
    [_investButton setTitle:@"转投" forState:UIControlStateNormal];
    _investButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_investButton setBackgroundColor:UIColorFromRGBValue(0xFB4D3A)];
    [_investButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_investButton addTarget:self action:@selector(invest) forControlEvents:UIControlEventTouchUpInside];
    [self.investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.investButton.mas_top);
        make.left.right.top.equalTo(self);
    }];
}

- (void)configTableViewHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [headerView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = UIColorFromRGBValue(0x333333);
    titleLabel.text = @"转投";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    self.tableView.tableHeaderView = headerView;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"operate_close"] forState:UIControlStateNormal];
    closeButton.imageView.contentMode = UIViewContentModeCenter;
    [headerView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

/**
 转投回调
 */
- (void)invest {
    if (!self.selctedProduct) {
        [CRFUtils showMessage:@"请选择转投产品"];
        return;
    }
    if (!self.flag) {
         [CRFUtils showMessage:@"请先发送验证码"];
        return;
    }
    if ([[self cellWithIndex:3].textField.text isEmpty]) {
         [CRFUtils showMessage:@"验证码不能为空"];
        return;
    }
    if ([self cellWithIndex:3].textField.text.length != 6) {
         [CRFUtils showMessage:@"验证码格式不正确"];
        return;
    }
    if (!self.protocolSelected) {
        [CRFUtils showMessage:@"请勾选并阅读协议"];
        return;
    }
    if ([self.investmentDelegate respondsToSelector:@selector(shiftInInvestment)]) {
        [self.investmentDelegate shiftInInvestment];
    }
}

#pragma mark --UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFShiftInInvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CRFShiftInInvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textField.hidden = YES;
        if (self.accountAmount) {
            [cell.titleLabel setAttributedText:[self formatAccountAmount]];
        }
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).with.offset(kSpace);
        }];
    } else if (indexPath.row == 1) {
        cell.textField.hidden = YES;
        cell.titleLabel.text = @"选择转投目标产品";
        cell.iconImageView.image = [UIImage imageNamed: @"operate_switch"];
        cell.hasAccessoryView = YES;
    } else if (indexPath.row == 2) {
        cell.textField.hidden = YES;
        cell.titleLabel.text = @"选择返现／加息红包";
        cell.iconImageView.image = [UIImage imageNamed:@"transfer_select_coupons"];
         cell.hasAccessoryView = YES;
    } else if (indexPath.row == 3) {
        cell.textField.placeholder = @"输入动态验证码";
        cell.iconImageView.image = [UIImage imageNamed:@"operate_code"];
        cell.textField.rightView = [self configTextFieldRightView];
        cell.textField.rightViewMode = UITextFieldViewModeAlways;
        cell.textField.delegate = self;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        cell.textField.hidden = YES;
        [cell.selectedButton setImage:[UIImage imageNamed:@"protocol_unselected"] forState:UIControlStateNormal];
        [cell.selectedButton setImage:[UIImage imageNamed:@"protocol_selected"] forState:UIControlStateSelected];
        [cell.selectedButton addTarget:self action:@selector(switchImage:) forControlEvents:UIControlEventTouchUpInside];
        [self formatProtocolContent:cell.titleLabel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([self.investmentDelegate respondsToSelector:@selector(chooseProduct)]) {
            [self.investmentDelegate chooseProduct];
        }
    } else if (indexPath.row == 2) {
        if (!self.selctedProduct) {
            [CRFUtils showMessage:@"请选择转投产品"];
            return;
        }
        if ([self.investmentDelegate respondsToSelector:@selector(selectedCoupon)]) {
            [self.investmentDelegate selectedCoupon];
        }
    }
}

- (CRFShiftInInvestmentTableViewCell *)cellWithIndex:(NSInteger)index {
    return [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (UIView *)configTextFieldRightView {
    _verificationCodeView = [[CRFVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, 125, 50)];
    _verificationCodeView.textFont = [UIFont systemFontOfSize:13.0];
    _verificationCodeView.cornerRadius = 27.0 / 2.0;
    _verificationCodeView.contentEdgeInsets = UIEdgeInsetsMake(23 / 2.0, kSpace, 23 / 2.0, kSpace);
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
        [strongSelf beginTimer];
    }];
    return _verificationCodeView;
}

- (NSAttributedString *)formatAccountAmount {
    NSString *string = [NSString stringWithFormat:@"可转投金额:%@元",_accountAmount];
    return [CRFStringUtils setAttributedString:string lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string rangeOfString:@"可转投金额:"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[string rangeOfString:_accountAmount] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[string rangeOfString:@"元"] attributes4:nil range4:NSRangeZero];
}

- (void)formatProtocolContent:(UILabel *)protocolLabel {
    NSMutableString *protocolString = [NSMutableString new];
    NSArray *protocols = [CRFHomeConfigHendler defaultHandler].investXjdProtocols;
    NSMutableArray <NSURL *>*urls = [NSMutableArray new];
    NSMutableArray <NSString *>* protocolNames = [NSMutableArray new];
    for (CRFProtocol *pro in protocols) {
        [protocolString appendFormat:@"%@、",pro.name];
        [urls addObject:[NSURL URLWithString:pro.protocolUrl]];
        [protocolNames addObject:pro.name];
    }
    [protocolString deleteCharactersInRange:NSMakeRange(protocolString.length - 1, 1)];
    NSString *string = [NSString stringWithFormat:@"我已阅读并同意%@",protocolString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, string.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x999999) range:[string rangeOfString:@"我已阅读并同意"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x999999) range:NSMakeRange(string.length - 1, 1)];
    for (NSString *str in protocolNames) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:[string rangeOfString:str]];
    }
    protocolLabel.attributedText = attributedString;
    protocolLabel.enabledTapEffect = NO;
    protocolLabel.userInteractionEnabled = YES;
    weakSelf(self);
    [protocolLabel yb_addAttributeTapActionWithStrings:protocolNames tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        strongSelf(weakSelf);
        if ([strongSelf.investmentDelegate respondsToSelector:@selector(openProtocolUrl:)]) {
            [strongSelf.investmentDelegate openProtocolUrl:[urls objectAtIndex:index].absoluteString];
        }
    }];
}

- (void)switchImage:(UIButton *)button {
    button.selected = !button.selected;
    self.protocolSelected = button.selected;
}

- (void)closeSelf {
    [self hide];
    if ([self.investmentDelegate respondsToSelector:@selector(closeView)]) {
        [self.investmentDelegate closeView];
    }
}

- (void)beginTimer {
    [self endEditing:YES];
    [self sendCode];
}

- (void)dealloc {
    [CRFNotificationUtils removeObserver:self];
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

#pragma mark --ResponseProtocl
- (void)sendCode {
    _flag = YES;
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] put:[NSString stringWithFormat:APIFormat(kSendTransformVerifyCodePath),kUuid] paragrams:@{kMobilePhone:[CRFAppManager defaultManager].userInfo.phoneNo,kIntent:@"5",@"type":@"0",@"picCode":@""} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:@"toast_send_verify_code"];
        [strongSelf.verificationCodeView timerStart];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
         [strongSelf.verificationCodeView resetTimer];
    }];
}

#pragma mark --UITextFiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > 6) {
        return NO;
    }
    return YES;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.4];
        _blackView.alpha = 0;
    }
    return _blackView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.blackView);
    }];
    if ([self.investmentDelegate respondsToSelector:@selector(updateViewLayoutWithAnimationDuration:)]) {
        [self.investmentDelegate updateViewLayoutWithAnimationDuration:self.keyboardHideTimeInterval];
    }
    return YES;
}

- (void)addInView:(UIView *)view {
    [view addSubview:self.blackView];
    [self.blackView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.blackView);
        make.height.mas_equalTo(0);
    }];
}

- (void)show {
    self.updateFrame = YES;
    [UIView animateWithDuration:self.keyboardShowTimeInterval animations:^{
        self.blackView.alpha = 1;
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50 * 7);
    }];
    if ([self.investmentDelegate respondsToSelector:@selector(updateViewLayoutWithAnimationDuration:)]) {
        [self.investmentDelegate updateViewLayoutWithAnimationDuration:self.keyboardShowTimeInterval];
    }
}

- (void)hide {
    self.updateFrame = NO;
    self.keybaordHeight = 0;
    [UIView animateWithDuration:self.keyboardHideTimeInterval animations:^{
        self.blackView.alpha = 0;
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    if ([self.investmentDelegate respondsToSelector:@selector(updateViewLayoutWithAnimationDuration:)]) {
        [self.investmentDelegate updateViewLayoutWithAnimationDuration:self.keyboardHideTimeInterval];
    }
}

- (void)setSelctedProduct:(CRFProductModel *)selctedProduct {
    _selctedProduct = selctedProduct;
    [self cellWithIndex:1].titleLabel.text = _selctedProduct.productName;
}

- (void)setSelectedCoupon:(CRFCouponModel *)selectedCoupon {
//    _selectedCoupon = selectedCoupon;
//     [self cellWithIndex:2].titleLabel.text = _selectedCoupon.giftName;
    
    CRFShiftInInvestmentTableViewCell *cell = (CRFShiftInInvestmentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (selectedCoupon && selectedCoupon.giftName.length > 0) {
        cell.titleLabel.text = selectedCoupon.giftName;
    } else {
        cell.titleLabel.text = @"选择返现／加息红包";
    }
    _selectedCoupon = selectedCoupon;
}

/**
 设置转投金额
 
 @param accountAmount 金额
 */
- (void)setAccountAmount:(NSString *)accountAmount {
    _accountAmount = accountAmount;
    [[self cellWithIndex:0].titleLabel setAttributedText:[self formatAccountAmount]];
}
@end
