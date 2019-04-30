//
//  CRFAppointmentForwardPopView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/20.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardPopView.h"
#import "CRFOperationCell.h"

@interface CRFAppointmentForwardPopView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UITableView *popTableView;
@property (nonatomic ,assign) CGFloat tableHeight;
@property (nonatomic ,assign) BOOL isHaveCoupon;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, strong) NSDictionary *protocolInfo;
@end

@implementation CRFAppointmentForwardPopView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.popTableView];
        self.isAgree = NO;
    }
    return self;
}

- (void)closeEvent {
    [self dismiss];
    [CRFAPPCountManager setEventID:@"invest_cancel" EventName:self.productItem.contractPrefix];

//    [CRFAPPCountManager setFailedEventID:@"invest_cancel" reason:@"取消出资"];
}

- (void)setBtnStatus:(BOOL)isSelected {
    self.isAgree = isSelected;
}

- (void)setCouponsCount:(NSInteger)couponsCount {
    self.isHaveCoupon = (couponsCount > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isHaveCoupon ? 3 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 132;
    }else if (indexPath.row == 1){
        if (self.isHaveCoupon) {
            return 46;
        } else {
            return self.rowHeight;
        }
    }else{
        return self.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFOperationCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:!self.isHaveCoupon ? @"appointmentAssignCell" : @"appintmentCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFOperationCell" owner:nil options:nil] objectAtIndex:!self.isHaveCoupon ? 5 : 3];
        }
        cell.model = self.productItem;
    } else if (indexPath.row == 1) {
        if (self.isHaveCoupon) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFOperationCell" owner:nil options:nil] objectAtIndex:1];
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"protocolCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFOperationCell" owner:nil options:nil] objectAtIndex:2];
            }
            cell.protocolInfo = self.protocolInfo;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"protocolCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFOperationCell" owner:nil options:nil] objectAtIndex:2];
        }
        cell.protocolInfo = self.protocolInfo;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    weakSelf(self);
    if (indexPath.row ==1 && self.isHaveCoupon) {
        cell.hasAccessoryView = YES;
        if (self.couponName && self.couponName.length > 0) {
            cell.couponNameLabel.text = self.couponName;
        }
    }
    if (self.isHaveCoupon) {
        if ([self.popViewDelegate respondsToSelector:@selector(autoSelectedCoupon:)]) {
            [self.popViewDelegate autoSelectedCoupon:self.investAmount];
        }
    }
    cell.btnStatusBlock = ^(BOOL isSelected){
        [weakSelf setBtnStatus:isSelected];
    };
    cell.push_block = ^(CRFProductModel *model, NSString *urlstr) {
        if ([weakSelf.popViewDelegate respondsToSelector:@selector(reviewProtocol:)]) {
            [weakSelf.popViewDelegate reviewProtocol:urlstr];
        }
    };
    cell.selectedBlock = ^(NSString *amountCount){
        if ([weakSelf.popViewDelegate respondsToSelector:@selector(autoSelectedCoupon:)]) {
            [weakSelf.popViewDelegate autoSelectedCoupon:amountCount];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && self.isHaveCoupon) {
        if ([self.popViewDelegate respondsToSelector:@selector(gotoCouponsViewController)]) {
            [self.popViewDelegate gotoCouponsViewController];
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
    if (self.forwardType == CRFForwardProductTypeAutoInvest) {
        title.text = @"转投";
    } else {
        title.text = @"预约转投";
    }
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(kScreenWidth-46-kSpace, 0, 46, 46);
    [closeBtn setImage:[UIImage imageNamed:@"operate_close"] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    closeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-48);
    weakSelf(self);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        weakSelf.popTableView.frame = CGRectMake(0, kScreenHeight-weakSelf.tableHeight-48, kScreenWidth, weakSelf.tableHeight);
    } completion:^(BOOL finished) {
       
    }];
}

- (void)dismiss {
    weakSelf(self);
    if ([self.popViewDelegate respondsToSelector:@selector(cancel)]) {
        [self.popViewDelegate cancel];
    }
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        weakSelf.popTableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-48);
    } completion:^(BOOL finished) {
        weakSelf.frame =CGRectZero;
    }];
}

- (UITableView *)popTableView {
    if (!_popTableView) {
        _popTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _popTableView.scrollEnabled = NO;
        _popTableView.delegate = self;
        _popTableView.dataSource = self;
        _popTableView.backgroundColor = [UIColor whiteColor];
        [_popTableView setSeparatorColor:kCellLineSeparatorColor];
        
    }
    return _popTableView;
}

- (void)setProductItem:(CRFProductModel *)productItem {
    _productItem = productItem;
    [self.popTableView reloadData];
}

- (void)setRowHeight:(NSInteger)rowHeight{
    _rowHeight = rowHeight;
    self.tableHeight = (self.isHaveCoupon ? 224 : 178) + _rowHeight;
    [self.popTableView reloadData];
}

- (void)selectedCoupon:(NSString *)couponName {
    CRFOperationCell *cell = (CRFOperationCell *)[self.popTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
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
        self.rowHeight = CGFLOAT_MIN;
        return;
    }
    NSMutableAttributedString *info = self.protocolInfo[@"info"];
    self.rowHeight = [info.string boundingRectWithSize:CGSizeMake(kScreenWidth - 59, CGFLOAT_MAX) fontNumber:13 * kWidthRatio lineSpace:15 charSpace:1.5].height + 14;
    if (self.rowHeight < 30) {
        self.rowHeight = 62 * kWidthRatio;
    }
}

- (void)configProtocolInfo {
    NSMutableString *protocolString = [[NSMutableString alloc]initWithString:@"我已阅读并同意"];
    NSMutableArray *names =[[NSMutableArray alloc]init];
    NSMutableArray <NSURL *>*linkArray = [[NSMutableArray alloc]init];
    if (self.protocolArray.count) {
        for (CRFProtocol *item in self.protocolArray) {
            [protocolString appendFormat:@"%@、",item.name];
            if ([NSURL URLWithString:item.protocolUrl]) {
                [linkArray addObject:[NSURL URLWithString:item.protocolUrl]];
            }else{
                [linkArray addObject:[NSURL URLWithString:@""]];
            }
            
            [names addObject:item.name];
        }
        [protocolString deleteCharactersInRange:NSMakeRange(protocolString.length - 1, 1)];
        NSString *endString = self.forwardType == CRFForwardProductTypeAutoInvest ? @"；同意将自动加入转投的出借计划， 自动适用上述各项协议及约定。" : @"；同意将自动加入预约转投的出借计划， 自动适用上述各项协议及约定。";
        [protocolString appendString:endString];
        
        NSMutableAttributedString *attString_potocl = [[NSMutableAttributedString alloc] initWithString:protocolString];
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [attString_potocl addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, protocolString.length)];
        [attString_potocl addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0*kWidthRatio]} range:[protocolString rangeOfString:@"我已阅读并同意"]];
         [attString_potocl addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0*kWidthRatio]} range:[protocolString rangeOfString:endString]];
        for (NSString *str in names) {
            [attString_potocl addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0*kWidthRatio]} range:[protocolString rangeOfString:str]];
        }
        self.protocolInfo = @{@"name":names,@"url":linkArray,@"info":attString_potocl};
    } else {
        self.protocolInfo = @{@"name":names,@"url":linkArray,@"info":@""};
    }
}

- (void)setItem:(NSInteger)item {
    _item = item;
    CRFOperationCell *cell = (CRFOperationCell *)[self.popTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.appointmentForwardLabel.text = _item == 1 ? @"本金转投":@"本息转投";
}


@end
