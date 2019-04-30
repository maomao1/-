//
//  CRFOperationCell.m
//  crf_purse
//
//  Created by maomao on 2017/8/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFOperationCell.h"
#import "CRFStringUtils.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "CRFLabel.h"
@interface CRFOperationCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *yearProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezePeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UILabel *expectProfitLabel;
@property (weak, nonatomic) IBOutlet CRFLabel *linkTextView;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)potoclAgreement:(UIButton *)sender;


@end
@implementation CRFOperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.agreeBtn setImage:[UIImage imageNamed:@"operate_potcol_unselected"] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"operate_potcol_selected"] forState:UIControlStateSelected];
    self.moneyField.layer.masksToBounds = YES;
    self.moneyField.layer.borderWidth = 1.0f;
    self.moneyField.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    self.moneyField.layer.cornerRadius=20.0f;
    self.moneyField.leftViewMode = UITextFieldViewModeAlways;
    self.moneyField.rightViewMode = UITextFieldViewModeAlways;

    //
    self.moneyField.font = [UIFont systemFontOfSize:15.0];
    
    self.moneyField.delegate = self;
    
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65*kWidthRatio, 40)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 65*kWidthRatio, 40);
    [btn setImage:[UIImage imageNamed:@"operate_reduce"] forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGBValue(0xFEF0EC);
    [btn addTarget:self action:@selector(reduceMoneyAccount) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    
    [left addSubview:btn];
    self.moneyField.leftView = left;
    
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65*kWidthRatio, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame =CGRectMake(0, 0, 65*kWidthRatio, 40);
    [rightBtn setImage:[UIImage imageNamed:@"operate_add"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addMoneyAccount) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.backgroundColor = UIColorFromRGBValue(0xFEF0EC);
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderWidth = 1.0f;
    rightBtn.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    [right addSubview:rightBtn];
    self.moneyField.rightView = right;
    
    self.linkTextView.userInteractionEnabled = YES;
    self.linkTextView.verticalAlignment = VerticalAlignmentMiddle;
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldContentChange) name:UITextFieldTextDidChangeNotification];
}
- (void)addMoneyAccount{
    //    self.moneyField.font = [UIFont systemFontOfSize:15.0f];
    double unitAccout   = self.model.investunit.doubleValue;
    //    NSString *titleStr;
    self.moneyField.text = [NSString stringWithFormat:@"%.f",self.moneyField.text.doubleValue+unitAccout];
    if (self.model.isNewBie.integerValue == 1) {
        if (self.moneyField.text.doubleValue>self.model.highestAmount.doubleValue) {
            self.moneyField.text = self.model.highestAmount;
            [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额不能超过%@元",self.model.highestAmount]];
            return;
            
        }
    }
    //    if (self.moneyField.text.doubleValue > [[CRFAppManager defaultManager].accountInfo.availableBalance getOriginString].doubleValue) {
    //        titleStr = @"余额不足，去充值";
    //    }else{
    //        titleStr = @"马上加入";
    //    }
    
    if (self.textBlock) {
        self.textBlock(self.moneyField.text);
    }
    //    if (self.couponReset) {
    //        self.couponReset();
    //    }
    if (self.selectedBlock) {
        self.selectedBlock(self.moneyField.text);
    }
    [self setExpectProfitLabelStyle:self.moneyField.text];
}
- (void)reduceMoneyAccount{
    //    NSString *titleStr;
    if (!(self.moneyField.text.doubleValue-self.model.investunit.doubleValue < 0)) {
        self.moneyField.text = [NSString stringWithFormat:@"%.f",self.moneyField.text.doubleValue-self.model.investunit.doubleValue];
        //        titleStr = @"马上加入";
    }
    if (self.moneyField.text.doubleValue<[self.model.lowestAmount getOriginString].doubleValue) {
        //        self.moneyField.text = self.model.lowestAmount;
        self.moneyField.text =[NSString stringWithFormat:@"%@",self.model.lowestAmount];
        [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额不能低于%@元",self.model.lowestAmount]];
    }
    //    if (self.moneyField.text.doubleValue > [[CRFAppManager defaultManager].accountInfo.availableBalance getOriginString].doubleValue) {
    //        titleStr = @"余额不足，去充值";
    //    }
    
    if (self.textBlock) {
        self.textBlock(self.moneyField.text);
    }
    //    if (self.couponReset) {
    //        self.couponReset();
    //    }
    if (self.selectedBlock) {
        self.selectedBlock(self.moneyField.text);
    }
    [self setExpectProfitLabelStyle:self.moneyField.text];
}
-(void)updateBalancel{
    NSString *balanceStr =[NSString stringWithFormat:@"投资可用余额： %@ 元",[CRFAppManager defaultManager].accountInfo.availableBalance];
    NSMutableAttributedString *attString_balance = [[NSMutableAttributedString alloc] initWithString:balanceStr];
    [attString_balance addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, balanceStr.length)];
    [attString_balance addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[balanceStr rangeOfString:[CRFAppManager defaultManager].accountInfo.availableBalance]];
    [self.balanceLabel setAttributedText:attString_balance];
}
- (void)setModel:(CRFProductModel *)model{
    _model = model;
    NSString *yInterestStr =[NSString stringWithFormat:@"期望年化收益率 %@%%",[_model rangeOfYInterstRate]];
    NSString *freezeStr;
    if (![model.type isEqualToString:@"4"]) {
        freezeStr = [NSString stringWithFormat:@"锁定出借期  %@天",_model.freezePeriod];
    }else{
        freezeStr = [NSString stringWithFormat:@"到期日期  %@",[_model formatterCloseTimeTag:1]];
    }
    
    NSString *limitStr;
    if (model.highestAmount.longLongValue>0) {
        limitStr = [NSString stringWithFormat:@"加入上限:%@元",model.highestAmount.length>4 ? [[[model.highestAmount substringWithRange:NSMakeRange(0, model.highestAmount.length - 4)] formatBeginMoney] stringByAppendingString:@"万"]:[model.highestAmount formatBeginMoney]];
    }
//    else{
//        if (model.planAmount.length) {
//            limitStr = [NSString stringWithFormat:@"加入上限:%@元",model.planAmount.length>4 ? [[[model.planAmount substringWithRange:NSMakeRange(0, model.planAmount.length - 4)] formatBeginMoney] stringByAppendingString:@"万"]:[model.planAmount formatBeginMoney]];
//        }
//    }
    
    NSString *balanceStr =[NSString stringWithFormat:@"投资可用余额:%@元 %@",[CRFAppManager defaultManager].accountInfo.availableBalance,limitStr];
    
    NSMutableAttributedString *attString_year = [[NSMutableAttributedString alloc] initWithString:yInterestStr];
    [attString_year addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:12.f*kWidthRatio]} range:NSMakeRange(0, yInterestStr.length)];
    [attString_year addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[yInterestStr rangeOfString:[NSString stringWithFormat:@"%@%%",[_model rangeOfYInterstRate]]]];
    [self.yearProfitLabel setAttributedText:attString_year];
    
    NSMutableAttributedString *attString_free = [[NSMutableAttributedString alloc] initWithString:freezeStr];
    [attString_free addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:12.0f*kWidthRatio]} range:NSMakeRange(0, freezeStr.length)];
    if (![model.type isEqualToString:@"4"]) {
        [attString_free addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[freezeStr rangeOfString:_model.freezePeriod]];
    }else{
        [attString_free addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[freezeStr rangeOfString:[_model formatterCloseTimeTag:1]]];
    }
    [self.freezePeriodLabel setAttributedText:attString_free];
    
    
    NSMutableAttributedString *attString_balance = [[NSMutableAttributedString alloc] initWithString:balanceStr];
    [attString_balance addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, balanceStr.length)];
    [self.balanceLabel setAttributedText:attString_balance];
    
    self.moneyField.placeholder = [NSString stringWithFormat:@"最低投资%@元",[model.lowestAmount formatPlaceholderMoney]];
    [self.moneyField setValue:UIColorFromRGBValue(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    self.moneyField.text =[NSString stringWithFormat:@"%@",model.lowestAmount] ;
    [self.moneyField setValue:[UIFont systemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
    
    if (self.moneyField.text) {
        if (self.textBlock) {
            self.textBlock(self.moneyField.text);
        }
        if (self.selectedBlock) {
            self.selectedBlock(self.moneyField.text);
        }
    }
    
    [self setExpectProfitLabelStyle:self.moneyField.text];
    
    
}
- (void)setInvestAmount:(NSString *)investAmount{
    if (investAmount) {
        self.moneyField.text = investAmount;
        if (self.moneyField.text) {
            if (self.textBlock) {
                self.textBlock(self.moneyField.text);
            }
            if (self.selectedBlock) {
                self.selectedBlock(self.moneyField.text);
            }
        }
        [self setExpectProfitLabelStyle:self.moneyField.text];
    }
}
-(void)setExclusiveModel:(CRFProductModel *)exclusiveModel{
    _model = exclusiveModel;
    NSString *yInterestStr =[NSString stringWithFormat:@"期望年化收益率 %@%%",[_model rangeOfYInterstRate]];
    NSString *freezeStr;
    if (![exclusiveModel.type isEqualToString:@"4"]) {
        freezeStr = [NSString stringWithFormat:@"锁定出借期  %@天",_model.freezePeriod];
    }else{
        freezeStr = [NSString stringWithFormat:@"到期日期  %@",[_model formatterCloseTimeTag:1]];
    }
    NSMutableAttributedString *attString_year = [[NSMutableAttributedString alloc] initWithString:yInterestStr];
    [attString_year addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:12.f*kWidthRatio]} range:NSMakeRange(0, yInterestStr.length)];
    [attString_year addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[yInterestStr rangeOfString:[NSString stringWithFormat:@"%@%%",[_model rangeOfYInterstRate]]]];
    [self.yearProfitLabel setAttributedText:attString_year];
    
    NSMutableAttributedString *attString_free = [[NSMutableAttributedString alloc] initWithString:freezeStr];
    
    [attString_free addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:12.f*kWidthRatio]} range:NSMakeRange(0, freezeStr.length)];
    if (![exclusiveModel.type isEqualToString:@"4"]) {
        [attString_free addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[freezeStr rangeOfString:_model.freezePeriod]];
    }else{
        [attString_free addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[freezeStr rangeOfString:[_model formatterCloseTimeTag:1]]];
    }
    [self.freezePeriodLabel setAttributedText:attString_free];
    
    NSString *balanceStr =[NSString stringWithFormat:@"投资可用余额： %@ 元",[CRFAppManager defaultManager].accountInfo.availableBalance];
    NSMutableAttributedString *attString_balance = [[NSMutableAttributedString alloc] initWithString:balanceStr];
    [attString_balance addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, balanceStr.length)];
    [attString_balance addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[balanceStr rangeOfString:[CRFAppManager defaultManager].accountInfo.availableBalance]];
    [self.balanceLabel setAttributedText:attString_balance];
}
-(void)setExclusiveAmount:(NSString *)exclusiveAmount{
    if (!exclusiveAmount) {
        exclusiveAmount = @"0";
    }
    _exclusiveAmount = exclusiveAmount;
    NSString *expectStr;
    if (![self.model.type isEqualToString:@"4"]) {
        CGFloat MinMoney = [CRFUtils incomeAmount:self.exclusiveAmount yInterestRate:self.model.minYield day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue != 2];
        CGFloat MaxMoney = [CRFUtils incomeAmount:self.exclusiveAmount yInterestRate:self.model.maxYield day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue != 2];
        expectStr =[NSString stringWithFormat:@"%@~%@",[[NSString stringWithFormat:@"%.2f",MinMoney] formatMoney],[[NSString stringWithFormat:@"%.2f",MaxMoney] formatMoney]] ;
    }else{
        CGFloat MinMoney = [CRFUtils incomeAmount:self.exclusiveAmount yInterestRate:self.model.minYield day:(self.model.remainDays.integerValue - 1) NCP:YES type:self.model.productType.integerValue != 2];
        CGFloat MaxMoney = [CRFUtils incomeAmount:self.exclusiveAmount yInterestRate:self.model.maxYield day:(self.model.remainDays.integerValue - 1) NCP:YES type:self.model.productType.integerValue != 2];
        expectStr =[NSString stringWithFormat:@"%@~%@",[[NSString stringWithFormat:@"%.2f",MinMoney] formatMoney],[[NSString stringWithFormat:@"%.2f",MaxMoney] formatMoney]] ;
    }
    NSString *string =[NSString stringWithFormat:@"出借金额：%@元（期望收益%@元）",[self.exclusiveAmount formatBeginMoney],expectStr];
   NSMutableAttributedString *attString_expect = [CRFStringUtils setAttributedString:string lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range1:[string rangeOfString:[NSString stringWithFormat:@"（期望收益%@元）",expectStr]] attributes2:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[string rangeOfString:expectStr] attributes3:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range3:[string rangeOfString:[self.exclusiveAmount formatBeginMoney]] attributes4:nil range4:NSRangeZero];
    [self.expectProfitLabel setAttributedText:attString_expect];
}
- (void)setProtocolInfo:(NSDictionary *)protocolInfo {
    self.linkTextView.enabledTapEffect = NO;
    NSMutableArray *linkStrArr = protocolInfo[@"name"];
    NSMutableArray <NSURL *>*linkArray = protocolInfo[@"url"];
    NSMutableAttributedString *attString_potocl = protocolInfo[@"info"];
    [self.linkTextView setAttributedText:attString_potocl];
    weakSelf(self);
    [self.linkTextView yb_addAttributeTapActionWithStrings:linkStrArr tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        strongSelf(weakSelf);
        if (strongSelf.push_block) {
            strongSelf.push_block(strongSelf.model, [linkArray objectAtIndex:index].absoluteString);
        }
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (IBAction)potoclAgreement:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.btnStatusBlock) {
        self.btnStatusBlock(sender.selected);
    }
}
- (void)setExpectProfitLabelStyle:(NSString*)text{
    //    CGFloat bank_yrate = 0.003;
    //    switch (self.model.freezePeriod.integerValue) {
    //        case 90:
    //            bank_yrate = 0.011;
    //            break;
    //        case 180:
    //            bank_yrate = 0.013;
    //            break;
    //        case 360:
    //            bank_yrate = 0.015;
    //            break;
    //        case 720:
    //            bank_yrate = 0.021;
    //            break;
    //        case 1080:
    //            bank_yrate = 0.0275;
    //            break;
    //        default:
    //            break;
    //    }
    NSString *expectStr;
    if (self.model.isNewBie.integerValue == 4) {
        if (![self.model.type isEqualToString:@"4"]) {
//            CGFloat Money = [CRFUtils incomeAmount:text yInterestRate:self.model.yInterestRate day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue == 1];
//            expectStr =[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%.2f",Money] formatMoney]] ;
            CGFloat MinMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.minYield day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue != 2];
            CGFloat MaxMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.maxYield day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue != 2];
            expectStr =[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%.2f",MinMoney+MaxMoney] formatMoney]] ;
        }else{
            CGFloat MinMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.minYield day:(self.model.remainDays.integerValue - 1) NCP:YES type:self.model.productType.integerValue != 2];
            CGFloat MaxMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.maxYield day:(self.model.remainDays.integerValue - 1) NCP:YES type:self.model.productType.integerValue != 2];
            expectStr =[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%.2f",MinMoney+MaxMoney] formatMoney]] ;

        }
    }else{
        if (![self.model.type isEqualToString:@"4"]) {
            CGFloat MinMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.minYield day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue != 2];
            CGFloat MaxMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.maxYield day:self.model.freezePeriod.integerValue NCP:NO type:self.model.productType.integerValue != 2];
            expectStr =[NSString stringWithFormat:@"%@~%@",[[NSString stringWithFormat:@"%.2f",MinMoney] formatMoney],[[NSString stringWithFormat:@"%.2f",MaxMoney] formatMoney]] ;
        }else{
            CGFloat MinMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.minYield day:(self.model.remainDays.integerValue - 1) NCP:YES type:self.model.productType.integerValue != 2];
            CGFloat MaxMoney = [CRFUtils incomeAmount:text yInterestRate:self.model.maxYield day:(self.model.remainDays.integerValue - 1) NCP:YES type:self.model.productType.integerValue != 2];
            expectStr =[NSString stringWithFormat:@"%@~%@",[[NSString stringWithFormat:@"%.2f",MinMoney] formatMoney],[[NSString stringWithFormat:@"%.2f",MaxMoney] formatMoney]] ;
        }
    }
    
    NSString *string =[NSString stringWithFormat:@"期望收益：%@元",expectStr];
    NSMutableAttributedString *attString_expect = [[NSMutableAttributedString alloc] initWithString:string];
    [attString_expect addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, string.length)];
    [attString_expect addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[string rangeOfString:expectStr]];
    [self.expectProfitLabel setAttributedText:attString_expect];
    
}
#pragma mark ----
- (void)textFieldContentChange {
    //    NSString *titleStr;
    if (self.moneyField.text) {
        if (self.model.isNewBie.integerValue == 1) {
            if (self.moneyField.text.doubleValue > self.model.highestAmount.doubleValue) {
                self.moneyField.text = self.model.highestAmount;
                [self setExpectProfitLabelStyle:self.moneyField.text];
                [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额不能超过%@元",self.model.highestAmount]];
                return;
            }
        }
        if (self.moneyField.text.doubleValue<[self.model.lowestAmount getOriginString].doubleValue) {
            //            self.moneyField.text = self.model.lowestAmount;
            //            [CRFUtils showMessage:[NSString stringWithFormat:@"投资金额不能低于%@元",self.model.lowestAmount]];
        }
        //        if (self.moneyField.text.doubleValue > [[CRFAppManager defaultManager].accountInfo.availableBalance getOriginString].doubleValue) {
        //            titleStr = @"余额不足，去充值";
        //        }else{
        //            titleStr = @"马上加入";
        //        }
        if (self.textBlock) {
            self.textBlock(self.moneyField.text);
        }
        //        if (self.couponReset) {
        //            self.couponReset();
        //        }
    }
    [self setExpectProfitLabelStyle:self.moneyField.text];
    //    if (self.moneyField.text.floatValue > self.model.highestAmount.floatValue) {
    //        if (self.textBlock) {
    //            self.textBlock(self.moneyField.text);
    //        }
    //    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.selectedBlock) {
        self.selectedBlock(newText);
    }
    return YES;
}

- (void)setProtocolDidSelected:(BOOL)protocolDidSelected {
    _protocolDidSelected = protocolDidSelected;
    self.agreeBtn.selected = _protocolDidSelected;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (self.selectedBlock) {
//        self.selectedBlock(textField.text);
//    }
//}
- (void)dealloc {
    [CRFNotificationUtils removeObserver:self];
}
@end
