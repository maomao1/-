//
//  CRFExclusivePopView.m
//  crf_purse
//
//  Created by maomao on 2018/3/23.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFExclusivePopView.h"
#import "CRFOperationCell.h"
@interface CRFExclusivePopView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *mainTab;
@property (nonatomic ,assign) CGFloat  tableHeight;
@property (nonatomic ,assign) BOOL     isHaveCoupon;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, strong) NSDictionary *protocolInfo;
@end
@implementation CRFExclusivePopView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainTab];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160;
    }else if (indexPath.row == 1){
        return  46;
    }else{
        return self.rowHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFOperationCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"exclusiveCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFOperationCell" owner:nil options:nil] objectAtIndex:4];
        }
        cell.exclusiveModel = self.productItem;
        cell.exclusiveAmount = self.exclusiveAmount;
    } else if (indexPath.row == 1) {
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
    cell.protocolDidSelected = self.isAgree;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    weakSelf(self);
    
    if (indexPath.row ==1) {
        cell.hasAccessoryView = YES;
        if (self.couponName && self.couponName.length > 0) {
            cell.couponNameLabel.text = self.couponName;
        }
    }
    if ([self.popViewDelegate respondsToSelector:@selector(autoSelectedCoupon:)]) {
        [self.popViewDelegate autoSelectedCoupon:self.exclusiveAmount];
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
    if (indexPath.row == 1) {
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

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-48);
    weakSelf(self);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        weakSelf.mainTab.frame = CGRectMake(0, kScreenHeight-weakSelf.tableHeight-48, kScreenWidth, weakSelf.tableHeight);
    } completion:^(BOOL finished) {
        weakSelf.isShow = YES;
    }];
}

- (void)dismiss {
    weakSelf(self);
    if ([self.popViewDelegate respondsToSelector:@selector(cancel)]) {
        [self.popViewDelegate cancel];
    }
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        weakSelf.mainTab.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-48);
    } completion:^(BOOL finished) {
        weakSelf.isShow = NO;
        weakSelf.frame =CGRectZero;
    }];
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
-(void)setExclusiveAmount:(NSString *)exclusiveAmount{
    _exclusiveAmount = exclusiveAmount;
    CRFOperationCell *cell = (CRFOperationCell *)[self.mainTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.exclusiveAmount = exclusiveAmount;
//    [self.mainTab reloadData];
}
- (void)setRowHeight:(NSInteger)rowHeight{
    _rowHeight = rowHeight;
    self.tableHeight = 252 + _rowHeight;
    [self.mainTab reloadData];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
