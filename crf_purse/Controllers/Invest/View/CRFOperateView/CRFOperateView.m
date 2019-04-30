//
//  CRFOperateView.m
//  crf_purse
//
//  Created by maomao on 2017/8/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFOperateView.h"
#import "CRFOperationCell.h"
#import "UITableViewCell+Access.h"
#import "UITableView+Custom.h"

#define Operate_view_height   330

@interface CRFOperateView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *mainTab;
@property (nonatomic ,assign) CGFloat  tableHeight;
@property (nonatomic ,assign) BOOL     isHaveCoupon;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, strong) NSDictionary *protocolInfo;

@end
@implementation CRFOperateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainTab];
        self.isAgree = NO;
        [self.mainTab setTextEidt:YES];
    }
    return self;
}

- (void)closeEvent {
    [self dismiss];
//    [CRFAPPCountManager setFailedEventID:@"invest_cancel" reason:@"取消出资"];
    [CRFAPPCountManager setEventID:@"invest_cancel" EventName:self.productItem.contractPrefix];
}

- (void)setBtnStatus:(BOOL)isSelected {
    self.isAgree = isSelected;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#ifdef WALLET
    if ([CRFUtils normalUser]) return 3;
    return 2;
#else
    return 3;
#endif
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 171;
    }else if (indexPath.row == 1){
        return  46;
    }else{
        return self.RowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFOperationCell *cell = [CRFOperationCell crfReuseIdentifier:tableView index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    weakSelf(self);
    cell.textBlock =^(NSString *contentext){
        strongSelf(weakSelf);
        if ([strongSelf.crf_delegate respondsToSelector:@selector(amountValueDidChanged:)]) {
            strongSelf.amount = contentext;
            [strongSelf.crf_delegate amountValueDidChanged:contentext];
        }
    };
    cell.protocolDidSelected = self.isAgree;
    cell.model = self.productItem;
    cell.investAmount = self.investAmount;
    cell.protocolInfo = self.protocolInfo;
    if (indexPath.row ==1) {
        cell.hasAccessoryView = YES;
        if (self.couponName && self.couponName.length > 0) {
            cell.couponNameLabel.text = self.couponName;
        }
    }
    cell.btnStatusBlock = ^(BOOL isSelected){
        [weakSelf setBtnStatus:isSelected];
    };
    cell.push_block = ^(CRFProductModel *model, NSString *urlstr) {
        if ([weakSelf.crf_delegate respondsToSelector:@selector(reviewProtocol:)]) {
            [weakSelf.crf_delegate reviewProtocol:urlstr];
        }
    };
    cell.selectedBlock = ^(NSString *amountCount){
        if ([weakSelf.crf_delegate respondsToSelector:@selector(autoSelectedCoupon:)]) {
            [weakSelf.crf_delegate autoSelectedCoupon:amountCount];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self endEditing:YES];
    if (indexPath.row ==1) {
        if (self.amount.doubleValue < self.productItem.lowestAmount.doubleValue) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额不能低于%@元",self.productItem.lowestAmount]];
            return;
        }
//        if (self.productItem.highestAmount.doubleValue>0 && self.amount.doubleValue > self.productItem.highestAmount.doubleValue) {
//            [CRFUtils showMessage:@"不能超过加入上限"];
//            return;
//        }
        if (self.amount.doubleValue&& self.amount.longLongValue%self.productItem.investunit.longLongValue !=0 ) {
            [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额必须为%@的整倍数",self.productItem.investunit]];
            return;
        }
        if ([self.crf_delegate respondsToSelector:@selector(gotoCouponsViewController)]) {
            [CRFAPPCountManager setEventID:@"INVEST_DETAILS_COUPON_EVENT" EventName:self.productItem.contractPrefix];
            [self.crf_delegate gotoCouponsViewController];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 46;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    UILabel *title = [UILabel new];
    title.textColor = UIColorFromRGBValue(0x333333);
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:title];
    title.frame = CGRectMake(30, 15, kScreenWidth-60, 16);
    title.text = @"投资";
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(kScreenWidth-46-kSpace, 0, 46, 46);
    [closeBtn setImage:[UIImage imageNamed:@"operate_close"] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    closeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}
- (void)registerKeyBoardNotice {
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification];
}

- (void)removeKeyBoardNotice {
    [CRFNotificationUtils removeObserver:self notificationName:UIKeyboardWillShowNotification];
    [CRFNotificationUtils removeObserver:self notificationName:UIKeyboardWillHideNotification];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-48);
    weakSelf(self);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        weakSelf.mainTab.frame = CGRectMake(0, kScreenHeight-weakSelf.tableHeight-48, kScreenWidth, weakSelf.tableHeight);
        
    } completion:^(BOOL finished) {
        weakSelf.isShow = YES;
        [weakSelf registerKeyBoardNotice];
    }];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-48);
    weakSelf(self);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        weakSelf.mainTab.frame = CGRectMake(0, kScreenHeight-weakSelf.tableHeight-48, kScreenWidth, weakSelf.tableHeight);

    } completion:^(BOOL finished) {
        weakSelf.isShow = YES;
        [weakSelf registerKeyBoardNotice];
    }];
}

- (void)dismiss {
//    self.isAgree = NO;
    weakSelf(self);
    if ([self.crf_delegate respondsToSelector:@selector(cancel)]) {
        [self.crf_delegate cancel];
    }
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        weakSelf.mainTab.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-48);
    } completion:^(BOOL finished) {
        weakSelf.isShow = NO;
        weakSelf.frame =CGRectZero;
//        [weakSelf removeFromSuperview];
        [weakSelf removeKeyBoardNotice];
        [self endEditing:YES];
    }];
    
}

- (void)keyBoardWillShow:(NSNotification*)notification {
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    CGFloat TextViewFrameY = kScreenHeight +176 - self.tableHeight;
    CGFloat pointY = TextViewFrameY - (kScreenHeight - height);
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (pointY>0) {
        [UIView animateWithDuration:animationDuration animations:^{
           _mainTab.frame = CGRectMake(0, kScreenHeight-self.tableHeight-48-pointY, kScreenWidth, self.tableHeight);
        }];
    }

}
- (void)keyBoardHidden:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
         _mainTab.frame = CGRectMake(0, kScreenHeight-self.tableHeight-48, kScreenWidth, self.tableHeight);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (UITableView *)mainTab {
    if (!_mainTab) {
        _mainTab = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mainTab.scrollEnabled = NO;
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        _mainTab.backgroundColor = [UIColor whiteColor];
        [_mainTab setSeparatorColor:kCellLineSeparatorColor];
        
    }
    return _mainTab;
}

- (void)setProductItem:(CRFProductModel *)productItem {
    _productItem = productItem;
    [self.mainTab reloadData];
}
-(void)setRowHeight:(NSInteger)RowHeight{
    _RowHeight = RowHeight;
#ifdef WALLET
    if (![CRFUtils normalUser]) {
        self.tableHeight = 263;
    } else {
        self.tableHeight = 263+_RowHeight;
    }
#else
    self.tableHeight = 263+_RowHeight;
#endif
    [self.mainTab reloadData];
}
- (void)setInvestAmount:(NSString *)investAmount{
    if (investAmount) {
        _investAmount = investAmount;
        _amount = _investAmount;
        [self.mainTab reloadData];
    }
}

- (void)selectedCoupon:(NSString *)couponName {
     CRFOperationCell *cell = (CRFOperationCell *)[self.mainTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (couponName && couponName.length > 0) {
        cell.couponNameLabel.text = couponName;
    } else {
        cell.couponNameLabel.text = @"选择返现／加息红包";
    }
    self.couponName = couponName;
}

- (void)setProtocolArray:(NSArray *)protocolArray {
    _protocolArray = protocolArray;
    [self configProtocolInfo];
    if (_protocolArray.count <= 0) {
        self.RowHeight = CGFLOAT_MIN;
        return;
    }
    NSMutableAttributedString *info = self.protocolInfo[@"info"];
    self.RowHeight = [info.string boundingRectWithSize:CGSizeMake(kScreenWidth - 59, CGFLOAT_MAX) fontNumber:13 * kWidthRatio lineSpace:15 charSpace:1.5].height + 14;
    if (self.RowHeight < 30) {
        self.RowHeight = 62 * kWidthRatio;
    }
}

- (void)configProtocolInfo {
    NSMutableString *potoclStr = [[NSMutableString alloc]initWithString:@"同意"];
    NSMutableArray *names =[[NSMutableArray alloc]init];
    NSMutableArray <NSURL *>*linkArray = [[NSMutableArray alloc]init];
    if (self.protocolArray.count) {
        for (CRFProtocol *item in self.protocolArray) {
            [potoclStr appendFormat:@"%@、",item.name];
            if ([NSURL URLWithString:item.protocolUrl]) {
                [linkArray addObject:[NSURL URLWithString:item.protocolUrl]];
            }else{
                [linkArray addObject:[NSURL URLWithString:@""]];
            }
            
            [names addObject:item.name];
        }
        [potoclStr deleteCharactersInRange:NSMakeRange(potoclStr.length - 1, 1)];
        NSMutableAttributedString *attString_potocl = [[NSMutableAttributedString alloc] initWithString:potoclStr];
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [attString_potocl addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, potoclStr.length)];
        [attString_potocl addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0*kWidthRatio]} range:NSMakeRange(0, 2)];
        for (NSString *str in names) {
            [attString_potocl addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0*kWidthRatio]} range:[potoclStr rangeOfString:str]];
        }
        self.protocolInfo = @{@"name":names,@"url":linkArray,@"info":attString_potocl};
    } else {
       self.protocolInfo = @{@"name":names,@"url":linkArray,@"info":@""};
    }
}

- (BOOL)isAgree {
#ifdef WALLET
    if ([CRFUtils normalUser]) return _isAgree;
    return YES;
#else
    return _isAgree;
#endif
}

@end
