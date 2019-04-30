//
//  CRFInvestStatusTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestStatusTableViewCell.h"
#import "CRFStringUtils.h"
#import "CRFTimeUtil.h"
#import "UILabel+Edge.h"


@interface CRFInvestStatusTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet YYLabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, weak) IBOutlet UILabel *InvestDynamicLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, copy) NSString *dynamicString;

@property (nonatomic, strong) UIImageView *helpImageView;

@property (nonatomic, copy) NSString *remainDays;
@property (weak, nonatomic) IBOutlet UILabel *autoInvestAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoInvestYearRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoInvestBeginTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endAutoInvestAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeAutoInvestAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *endInvestBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endInvestEndTimeLabel;

- (IBAction)scanProfitHelp:(id)sender;

@end

@implementation CRFInvestStatusTableViewCell

- (UIImageView *)helpImageView {
    if (!_helpImageView) {
        _helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_help"]];
        _helpImageView.contentMode = UIViewContentModeCenter;
        _helpImageView.userInteractionEnabled = YES;
        [_helpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dynamicHelp)]];
    }
    return _helpImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.InvestDynamicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kSpace));
        make.top.equalTo(@15);
        make.right.equalTo(@(-kSpace));
        make.bottom.equalTo(@-15);
    }];
}

- (void)setProduct:(CRFProductDetail *)product {
    _product = product;
    if (_product) {
        [self setUp];
    } else {
        [self setUpDefault];
    }
}

- (void)setUpDefault {
    NSString *string1 =   [NSString stringWithFormat:@"%@\n期初出借本金(元)",@"0.00"];
    NSString *string2 = [NSString stringWithFormat:@"%@%%\n期望年化收益率",@"0.00"];
    NSString *string3 = [NSString stringWithFormat:@"%@\n累计收益(元)",@"0.00"];
    if (self.type == 0) {
        NSString *string4 = [NSString stringWithFormat:@"申请日期:%@",@"- -"];
        NSString *string5 = [NSString stringWithFormat:@"预计始计息日:%@",@"- -"];
        [self.beginTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string4 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string4 rangeOfString:@"申请日期:"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string4 rangeOfString:@"- -"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self.endTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string5 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string5 rangeOfString:@"预计始计息日:"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string5 rangeOfString:@"- -"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    }
    else {
        NSString *string4 = [NSString stringWithFormat:@"始计息日:%@",@"- -"];
        NSString *string5 = [NSString stringWithFormat:@"封闭期至:%@",@"- -"];
        [self.beginTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string4 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string4 rangeOfString:@"始计息日:"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string4 rangeOfString:@"- -"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self.endTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string5 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string5 rangeOfString:@"封闭期至:"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string5 rangeOfString:@"- -"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    }
    
    [self.leftLabel setAttributedText:[CRFStringUtils setAttributedString:string1 lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string1 rangeOfString:@"0.00"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string1 rangeOfString:@"期初出借本金(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.leftLabel setTextAlignment:NSTextAlignmentCenter];
    [self.rightTopLabel setAttributedText:[CRFStringUtils setAttributedString:string2 lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string2 rangeOfString:@"0.00"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string2 rangeOfString:@"期望年化收益率"] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range3:[string2 rangeOfString:@"%"] attributes4:nil range4:NSRangeZero]];
    [self.rightTopLabel setTextAlignment:NSTextAlignmentCenter];
    [self.rightBottomLabel setAttributedText:[CRFStringUtils setAttributedString:string3 lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string3 rangeOfString:@"0.00"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string3 rangeOfString:@"累计收益(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.rightBottomLabel setTextAlignment:NSTextAlignmentCenter];
    [self.endTimeLabel setTextAlignment:NSTextAlignmentRight];
}

- (void)setUp {
    NSString *string1 =  [NSString stringWithFormat:@"%@\n期初出借本金(元)",self.product.amount];
    NSString *string2;
    if (self.type != 2) {
        string2 = [NSString stringWithFormat:@"%@%%\n期望年化收益率",[self.product formatRangeOfExpectYearRate]];
    }else{
        string2 = [NSString stringWithFormat:@"%@%%\n期望年化收益率",self.product.yearrate];
    }
    if (self.type == 0) {

        NSString *subString4 = @"申请日期:";
        NSString *string4 = [NSString stringWithFormat:@"%@%@",subString4,self.product.applyDate];
        NSString *subString5 = @"";
        NSString *string5 = @"";
        NSString *lastString5 = @"";
        if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
            subString5 = @"预计计息日期:";
            long long beginDay = [CRFTimeUtil getTimeIntervalWithFormatDate:self.product.applyDate];
            long long desDays = beginDay + [CRFTimeUtil getTimeIntervalWithDay:self.waitDays];
            NSString *time = [CRFTimeUtil formatLongTime:desDays pattern:@"yyyy-MM-dd"];
            lastString5 = time;
            string5 = [NSString stringWithFormat:@"%@%@",subString5,lastString5];
        } else {
            if ([self.product.source integerValue] == 2 && ![self.product.proType isEqualToString:@"4"]) {
                subString5 = @"封闭期至:";
                lastString5 = self.product.closeDate;
                string5 = [NSString stringWithFormat:@"%@%@",subString5,self.product.closeDate];
            } else {
                long long beginDay = [CRFTimeUtil getTimeIntervalWithFormatDate:self.product.applyDate];
                long long desDays = beginDay + [CRFTimeUtil getTimeIntervalWithDay:self.waitDays];
                NSString *time = [CRFTimeUtil formatLongTime:desDays pattern:@"yyyy-MM-dd"];
                subString5 = @"预计始计息日:";
                lastString5 = time;
                string5 = [NSString stringWithFormat:@"%@%@",subString5,time];
                
            }
        }
        [self.endTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string5 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string5 rangeOfString:subString5] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string5 rangeOfString:lastString5] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        
        [self.beginTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string4 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string4 rangeOfString:subString4] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string4 rangeOfString:self.product.applyDate] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        
    }
    else {
        NSString *string5 = nil;
        NSString *subString = nil;
        NSString *dateString = nil;
        NSString *string4 = nil;
        NSString *subString4 = nil;
        NSString *dateString4 = nil;
        if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
            subString4 = @"起息日期:";
            dateString4 = self.product.interestStartDate;
            if (self.type == 1) {
                subString = @"到期日期:";
                dateString = self.product.closeDate;
            } else {
                subString = @"结束日期:";
                dateString = self.product.exitDate;
            }
        } else {
            subString4 = @"始计息日:";
            dateString4 = self.product.interestStartDate;
            
            if (self.type == 1 && [self.product.proType integerValue] == 4) {
                string5 = [NSString stringWithFormat:@"封闭期至:- -"];
                subString = @"封闭期至:";
                dateString = @"- -";
            } else {
                if (self.type == 2) {
                    DLog(@"exit date is %@",self.product.exitDate);
                    string5 = [NSString stringWithFormat:@"结束日期:%@",self.product.exitDate];
                    subString = @"结束日期:";
                    dateString = self.product.exitDate;
                } else {
                    string5 = [NSString stringWithFormat:@"封闭期至:%@",self.product.closeDate];
                    subString = @"封闭期至:";
                    dateString = self.product.closeDate;
                }
            }
        }
        string4 = [NSString stringWithFormat:@"%@%@",subString4,dateString4];
        string5 = [NSString stringWithFormat:@"%@%@",subString,dateString];
        
        [self.beginTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string4 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string4 rangeOfString:subString4] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string4 rangeOfString:dateString4] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self.endTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string5 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string5 rangeOfString:subString] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string5 rangeOfString:dateString] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    }
    [self.leftLabel setAttributedText:[CRFStringUtils setAttributedString:string1 lineSpace:5 attributes1:@{NSFontAttributeName:CRFFONT(AkrobatZT, 20),NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[string1 rangeOfString:self.product.amount] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string1 rangeOfString:@"期初出借本金(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.leftLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.rightTopLabel setAttributedText:[CRFStringUtils setAttributedString:string2 lineSpace:5 attributes1:@{NSFontAttributeName:CRFFONT(AkrobatZT, 18),NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string2 rangeOfString:self.type == 2?self.product.yearrate:[self.product formatRangeOfExpectYearRate]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string2 rangeOfString:@"期望年化收益率"] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range3:[string2 rangeOfString:@"%"] attributes4:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range4:[string2 rangeOfString:@"%" options:NSBackwardsSearch]]];
    [self.rightTopLabel setTextAlignment:NSTextAlignmentCenter];
    NSString *string3 = [NSString stringWithFormat:@"%@\n到期预期收益(元)",self.product.expectedBenefitAmount];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"forward_filter_icon_introduction"]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 0, 30, 30);
    NSMutableAttributedString *attributed1 = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:14.0] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attributedString =[CRFStringUtils setAttributedString:string3 lineSpace:5 attributes1:@{NSFontAttributeName:CRFFONT(AkrobatZT, 18),NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string3 rangeOfString:self.product.expectedBenefitAmount] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string3 rangeOfString:@"到期预期收益(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
    if (!self.isAppointmentForward) {
        [attributedString appendAttributedString:attributed1];
    }
    strongSelf(self);
    [self.rightBottomLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if ([strongSelf.delegate respondsToSelector: @selector(showProfitExplainViewIsEnd:)]) {
            [strongSelf.delegate showProfitExplainViewIsEnd:self.type == 2];
        }
    }];
    [self.rightBottomLabel setAttributedText:attributedString];
    [self.rightBottomLabel setTextAlignment:NSTextAlignmentCenter];
    [self.endTimeLabel setTextAlignment:NSTextAlignmentRight];
    
}
-(void)scanProfitHelp:(id)sender{
    if ([self.delegate respondsToSelector: @selector(showProfitExplainViewIsEnd:)]) {
        [self.delegate showProfitExplainViewIsEnd:self.type == 2];
    }
}
- (CGFloat)fondSize {
    if (kScreenWidth == 320) {
        return 12.0f;
    }
    return 13.0f;
}

- (void)setHideBottomLine:(BOOL)hideBottomLine {
    _hideBottomLine = hideBottomLine;
    self.bottomLine.hidden = _hideBottomLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)formatDynamicTitle {
    NSString *string = @"";
    if (self.dynamicType == 0) {
        if ([self.originProduct.proType integerValue] == 3 || [CRFUtils complianceProduct:self.originProduct.investSource]) {
            if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
                self.remainDays = self.originProduct.queueDays;
            } else {
                self.remainDays = self.originProduct.queueDays;
            }
            string = [NSString stringWithFormat:@"申请出借成功，预计于%@天后开始计息",self.remainDays];
        } else {
            string = [NSString stringWithFormat:@"排队等待匹配中，近七日平均等待：%@天",self.originProduct.queueDays];
        }
    } else if (self.dynamicType == 1) {
        if ([self.originProduct.investStatus integerValue] == 5&&[self.originProduct.redeemType integerValue] == 1) {
            string = @"债权转让中";
        } else if ([self.originProduct.investStatus integerValue] == 3) {
            string = @"退出中";
        } else if ([self.originProduct.investStatus integerValue] == 6) {
            string = @"转投中";
        } else if ([self.originProduct.investStatus integerValue] == 2) {
            if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
                if ([self.originProduct.remainDays integerValue] <= 0) {
                    string = [NSString stringWithFormat:@"已到期，将于3天内完成结算支付"];
                } else {
                    string = [NSString stringWithFormat:@"计息中（剩余%@天）",self.originProduct.remainDays];
                }
            } else {
                if ([self.originProduct.proType integerValue] == 4 || [self.originProduct.proType integerValue] == 5) {
                    long long beginTime = [CRFTimeUtil getTimeIntervalWithFormatDate:self.originProduct.interestStartDate];
                    self.day = ([CRFTimeUtil getCurrentTimeInteveral] - beginTime) / 1000 / ([CRFTimeUtil getTimeIntervalWithDay:1]/1000);
                    if (self.day < 0) {
                        self.day = 0;
                    }
                    string = [NSString stringWithFormat:@"计息中（已投资%ld天，可随时申请退出）",self.day];
                } else {
                    string = [NSString stringWithFormat:@"计息中（锁定出借期%@天，剩余%@天）",self.originProduct.closeDays,self.originProduct.remainDays];
                }
            }
        }
    } else {
        if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
            if ([self.originProduct.investStatus integerValue] == 12) {
                string = @"已到期，将于3天内完成结算支付";
            } else if (self.originProduct.investStatus.integerValue == 31) {
                string = @"申请取消";
            } else {
                string = @"出借结束";
            }
        } else {
            if ([self.originProduct.investStatus integerValue] == 4) {
                if ([self.originProduct.proType integerValue] == 4 || [self.originProduct.proType integerValue] == 5) {
                    long long beginTime = [CRFTimeUtil getTimeIntervalWithFormatDate:self.originProduct.interestStartDate] / 1000;
                    long long endTime = [CRFTimeUtil getTimeIntervalWithFormatDate:self.originProduct.exitDate] / 1000;
                    self.day = (endTime - beginTime) / ([CRFTimeUtil getTimeIntervalWithDay:1] / 1000);
                    if (self.day < 0) {
                        self.day = 0;
                    }
                    string = [NSString stringWithFormat:@"出借结束（共投资了%ld天），资金已退出到可用余额。",self.day];
                    
                } else {
                    string =[NSString stringWithFormat:@"出借结束（锁定出借期%@天）。",self.originProduct.closeDays];
                }
            } else {
                if ([self.originProduct.proType integerValue] == 4 || [self.originProduct.proType integerValue] == 5) {
                    long long beginTime = [CRFTimeUtil getTimeIntervalWithFormatDate:self.originProduct.interestStartDate] / 1000;
                    long long endTime = [CRFTimeUtil getTimeIntervalWithFormatDate:self.originProduct.exitDate] / 1000;
                    self.day = (endTime - beginTime) / ([CRFTimeUtil getTimeIntervalWithDay:1] / 1000);
                    if (self.day < 0) {
                        self.day = 0;
                    }
                    string = [NSString stringWithFormat:@"出借结束（共投资了%ld天），\n资金已转投到其他出借计划（出借编号为%@）。",self.day,self.originProduct.investNo];
                    
                } else {
                    string = [NSString stringWithFormat:@"出借结束（锁定出借期%@天），资金已转投到其他出借计划（出借编号为%@）。",self.originProduct.closeDays,self.originProduct.investNo];
                }
            }
        }
    }
    self.dynamicString = string;
}

- (void)setDynamicContent {
    if (self.dynamicType == 0) {
        if ([self.originProduct.proType integerValue] == 3 || [CRFUtils complianceProduct:self.originProduct.investSource]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dynamicString];
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"申请出借成功，预计于"]];
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[self.dynamicString rangeOfString:self.remainDays]];
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"天后开始计息"]];
            [self.InvestDynamicLabel setAttributedText:attributedString];
            [self.InvestDynamicLabel setTextAlignment:NSTextAlignmentCenter];
        } else {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dynamicString];
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"排队等待匹配中，近七日平均等待："]];
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[self.dynamicString rangeOfString:self.originProduct.queueDays]];
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"天"]];
            [self.InvestDynamicLabel setAttributedText:attributedString];
            [self.InvestDynamicLabel setTextAlignment:NSTextAlignmentCenter];
        }
    } else if (self.dynamicType == 1) {
        if ([self.originProduct.investStatus integerValue] == 3 || [self.originProduct.investStatus integerValue] == 5 || [self.originProduct.investStatus integerValue] == 6) {
            self.InvestDynamicLabel.text = self.dynamicString;
        } else if ([self.originProduct.investStatus integerValue] == 2) {
            if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
                if ([self.originProduct.remainDays integerValue] <= 0) {
                    self.InvestDynamicLabel.text = self.dynamicString;
                } else {
                    [self.InvestDynamicLabel setAttributedText:[CRFStringUtils setAttributedString:self.dynamicString highlightText:self.originProduct.remainDays highlightColor:UIColorFromRGBValue(0xFB4D3A)]];
                }
            } else {
                if ([self.originProduct.proType integerValue] == 4 || [self.originProduct.proType integerValue] == 5) {
                    [self.InvestDynamicLabel setAttributedText:[CRFStringUtils setAttributedString:self.dynamicString lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[self.dynamicString rangeOfString:@"计息中（已投资"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[self.dynamicString rangeOfString:[NSString stringWithFormat:@"%ld",self.day]] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[self.dynamicString rangeOfString:@"天，可随时申请退出"] attributes4:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range4:[self.dynamicString rangeOfString:self.originProduct.investNo options:NSBackwardsSearch] attributes5:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range5:[self.dynamicString rangeOfString:@"）。" options:NSBackwardsSearch]]];
                } else {
                    [self.InvestDynamicLabel setAttributedText:[CRFStringUtils setAttributedString:self.dynamicString lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[self.dynamicString rangeOfString:@"计息中（锁定出借期"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[self.dynamicString rangeOfString:self.originProduct.closeDays] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[self.dynamicString rangeOfString:@"天，剩余"] attributes4:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range4:[self.dynamicString rangeOfString:self.originProduct.remainDays options:NSBackwardsSearch] attributes5:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range5:[self.dynamicString rangeOfString:@"天）" options:NSBackwardsSearch]]];
                }
            }
        }
    } else {
        if ([self.originProduct.investStatus integerValue] == 4) {
            if ([self isAgilityProduct]) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dynamicString];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"出借结束（共投资了"]];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[self.dynamicString rangeOfString:[NSString stringWithFormat:@"%ld",self.day]]];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"天），资金已退出到可用余额。"]];
                [self.InvestDynamicLabel setAttributedText:attributedString];
            } else {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dynamicString];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"出借结束（锁定出借期"]];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range:[self.dynamicString rangeOfString:self.originProduct.closeDays]];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range:[self.dynamicString rangeOfString:@"天)。"]];
                [self.InvestDynamicLabel setAttributedText:attributedString];
            }
        } else {
            if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
                self.InvestDynamicLabel.text = self.dynamicString;
            } else {
                if ([self isAgilityProduct]) {
                    [self.InvestDynamicLabel setAttributedText:[CRFStringUtils setAttributedString:self.dynamicString lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[self.dynamicString rangeOfString:@"出借结束（共投资了"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[self.dynamicString rangeOfString:self.originProduct.closeDays] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[self.dynamicString rangeOfString:[NSString stringWithFormat:@"天），\n资金已转投到其他出借计划（出借编号为%@",self.originProduct.investNo]] attributes4:nil range4:NSRangeZero]];
                    
                } else {
                    [self.InvestDynamicLabel setAttributedText:[CRFStringUtils setAttributedString:self.dynamicString lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:[self.dynamicString rangeOfString:@"出借结束（锁定出借期"] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[self.dynamicString rangeOfString:self.originProduct.closeDays] attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range3:[self.dynamicString rangeOfString:[NSString stringWithFormat:@"天），资金已转投到其他出借计划（出借编号为%@）。",self.originProduct.investNo]] attributes4:nil range4:NSRangeZero]];
                }
            }
        }
    }
    [self.InvestDynamicLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)setOriginProduct:(CRFMyInvestProduct *)originProduct {
    _originProduct = originProduct;
    [self formatDynamicTitle];
    [self setDynamicContent];
}

- (void)setAccessoryImageView {
    if ([self isNeedHelp]) {
        [self setHelp];
    } else {
        if (![self autoInvestment]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roll_out_icon"]];
        self.accessoryView = imageView;
        [self.InvestDynamicLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@50);
        }];
        }
    }
}

- (void)setHelp {
    [self addSubview:self.helpImageView];
    self.InvestDynamicLabel.contentInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    CGFloat titleWidth = [self.dynamicString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) fontNumber:15].width + 12;
    [self.helpImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).with.offset(titleWidth / 2.0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (BOOL)isNeedHelp {
    if (self.dynamicType == 0 && [self.originProduct.proType integerValue] != 3 && ![CRFUtils complianceProduct:self.originProduct.investSource]) {
        return YES;
    }
    return NO;
}

- (void)dynamicHelp {
    DLog(@"点击了帮助");
    if (self.investDynamicHelpHandler) {
        self.investDynamicHelpHandler();
    }
}

/**
 是否是灵活留存产品
 
 @return value
 */
- (BOOL)isAgilityProduct {
    return ([self.originProduct.proType integerValue] == 4 || [self.originProduct.proType integerValue] == 5);
}

- (void)setAutoInvestProduct:(CRFProductDetail *)autoInvestProduct {
    _autoInvestProduct = autoInvestProduct;
    if (!_autoInvestProduct) {
        return;
    }
    self.autoInvestAmountLabel.text = _autoInvestProduct.amount;
    self.autoInvestBeginTimeLabel.text = _autoInvestProduct.interestStartDate;
    NSString *year = [NSString stringWithFormat:@"%@%%",[_autoInvestProduct formatRangeOfExpectYearRate]];
    self.autoInvestYearRateLabel.attributedText = [CRFStringUtils setAttributedString:year lineSpace:0 attributes1:@{NSFontAttributeName:CRFFONT(AkrobatZT, 14)} range1:[year rangeOfString:@"%"] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
}

- (void)setAutoInvestDynamicInfo:(NSObject *)autoInvestInfo {
    if ([autoInvestInfo isKindOfClass:[CRFProductDetail class]]) {
        if (((CRFProductDetail *)autoInvestInfo).investStatus.integerValue == 2) {
            self.InvestDynamicLabel.text = @"计息中";
        }
        else if (((CRFProductDetail *)autoInvestInfo).investStatus.integerValue == 5 || ((CRFProductDetail *)autoInvestInfo).investStatus.integerValue == 3) {
            if (((CRFProductDetail *)autoInvestInfo).investStatus.integerValue == 5&&((CRFProductDetail *)autoInvestInfo).redeemType.integerValue == 1) {
                self.InvestDynamicLabel.text = @"债权转让中";
            }else{
                self.InvestDynamicLabel.text = @"退出中";
            }
        } else {
            self.InvestDynamicLabel.text = @"转投中";
        }
    } else {
        if (((CRFMyInvestProduct *)autoInvestInfo).investStatus.integerValue == 2) {
            self.InvestDynamicLabel.text = @"计息中";
        } else if (((CRFMyInvestProduct *)autoInvestInfo).investStatus.integerValue == 5 || ((CRFMyInvestProduct *)autoInvestInfo).investStatus.integerValue == 3) {
            if (((CRFMyInvestProduct *)autoInvestInfo).investStatus.integerValue == 5&&((CRFMyInvestProduct *)autoInvestInfo).redeemType.integerValue == 1) {
                self.InvestDynamicLabel.text = @"债权转让中";
            }else{
                self.InvestDynamicLabel.text = @"退出中";
            }
        } else {
            self.InvestDynamicLabel.text = @"转投中";
        }
    }
    self.InvestDynamicLabel.textAlignment = NSTextAlignmentCenter;
}

- (BOOL)autoInvestment {
    return self.product.isAbleFlexibleForward.integerValue == 2;
}

- (void)setAccessoryViewNone {
    self.accessoryView = nil;
    [self.InvestDynamicLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kSpace));
    }];
}

- (void)setEndInvestProduct:(CRFProductDetail *)endInvestProduct {
    _endInvestProduct = endInvestProduct;
    if (!_endInvestProduct) {
        return;
    }
    NSString *string5 = nil;
    NSString *subString = nil;
    NSString *dateString = nil;
    NSString *string4 = nil;
    NSString *subString4 = nil;
    NSString *dateString4 = nil;
    if ([CRFUtils complianceProduct:self.originProduct.investSource]) {
        subString4 = @"起息日期:";
        dateString4 = _endInvestProduct.interestStartDate;
        subString = @"结束日期:";
        dateString = _endInvestProduct.exitDate;
    } else {
        subString4 = @"始计息日:";
        dateString4 = _endInvestProduct.interestStartDate;
        DLog(@"exit date is %@",_endInvestProduct.exitDate);
        string5 = [NSString stringWithFormat:@"结束日期:%@",_endInvestProduct.exitDate];
        subString = @"结束日期:";
        dateString = _endInvestProduct.exitDate;
    }
    string4 = [NSString stringWithFormat:@"%@%@",subString4,dateString4];
    string5 = [NSString stringWithFormat:@"%@%@",subString,dateString];
    [self.endInvestBeginTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string4 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string4 rangeOfString:subString4] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string4 rangeOfString:dateString4] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.endInvestEndTimeLabel setAttributedText:[CRFStringUtils setAttributedString:string5 lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:[string5 rangeOfString:subString] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:[self fondSize]],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string5 rangeOfString:dateString] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.endInvestEndTimeLabel.textAlignment = NSTextAlignmentRight;
    self.incomeAutoInvestAmountLabel.text = _endInvestProduct.expectedBenefitAmount;
    self.endAutoInvestAmountLabel.text = _endInvestProduct.amount;
}


@end
