//
//  CRFInvestDynamicTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/25.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestDynamicTableViewCell.h"
#import "CRFStringUtils.h"
#import "CRFTimeUtil.h"
#import "CRFLabel.h"

@interface CRFInvestDynamicTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *currentContentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet CRFLabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;

@property (nonatomic, copy) NSString *remainDays;

@end


@implementation CRFInvestDynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.statusLabel.verticalAlignment = VerticalAlignmentBottom;
    // Initialization code
}

- (void)setProduct:(CRFMyInvestProduct *)product {
    _product = product;
    [self setTitleContent];
}

- (void)setTitleContent {
    if (self.type == 0) {
        if ([self.product.proType integerValue] == 3 || [CRFUtils complianceProduct:self.product.investSource]) {
            if ([CRFUtils complianceProduct:self.product.investSource]) {
                self.remainDays = self.product.queueDays;
            } else {
                self.remainDays = self.product.queueDays;
            }
            NSString *str = [NSString stringWithFormat:@"申请出借成功，预计于%@天后开始计息",self.remainDays];
            [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:self.remainDays] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        } else {
            NSString *str = [NSString stringWithFormat:@"排队等待匹配中，近七日平均等待：%@天。",self.product.queueDays];
            [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:self.product.queueDays] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        }
    } else if (self.type == 1) {
        if ([CRFUtils complianceProduct:self.product.investSource]) {
            NSString *string = nil;
            if ([self.product.remainDays integerValue] <= 0) {
                string = [NSString stringWithFormat:@"已到期，将于3天内完成结算支付"];
                
                self.currentContentLabel.text = string;
            } else {
                string = [NSString stringWithFormat:@"计息中（剩余%@天）",self.product.remainDays];
                [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:string highlightText:self.product.remainDays highlightColor:kRegisterButtonBackgroundColor]];
            }
        } else {
            if ([self.product.proType integerValue] == 1 || [self.product.proType integerValue] == 2|| [self.product.proType integerValue] == 3) {
                NSString *str = [NSString stringWithFormat:@"计息中（锁定出借期%@天，剩余%@天）",self.product.closeDays,self.product.remainDays];
                [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:self.product.closeDays options:NSBackwardsSearch] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range2:[str rangeOfString:self.product.remainDays] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
            } else {
                NSInteger beginDay = [CRFTimeUtil getTimeIntervalWithFormatDate:self.product.interestStartDate] / 1000;
                NSInteger day = ([CRFTimeUtil getCurrentTimeInteveral] / 1000 - beginDay) / ([CRFTimeUtil getTimeIntervalWithDay:1] / 1000);
                if (day < 0) {
                    day = 0;
                }
                NSString *str = [NSString stringWithFormat:@"计息中（已投资%ld天，可随时申请退出）",day];
                [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:[NSString stringWithFormat:@"%ld",day] options:NSBackwardsSearch] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
            }
        }
    } else if (self.type == 2 || self.type == 4) {
        if (self.type ==4 && self.product.redeemType.integerValue ==1) {
            self.currentContentLabel.text = @"债权转让中";
        }else{
            self.currentContentLabel.text = @"退出中";
        }
    } else if (self.type == 30) {
         self.currentContentLabel.text = @"申请取消";
    } else if (self.type == 5) {
        self.currentContentLabel.text = @"转投中";
    } else  if (self.type == 11) {
        if ([CRFUtils complianceProduct:self.product.investSource]) {
             self.currentContentLabel.text = @"已到期，将于3天内完成结算支付";
        } else {
             self.currentContentLabel.text = @"出借结束";
        }
    } else if (self.type == 3) {
        if ([CRFUtils complianceProduct:self.product.investSource]) {
//            if ([self.product.investStatus integerValue] == 12) {
//                self.currentContentLabel.text = @"已到期，将于3天内完成结算支付";
//            } else {
                self.currentContentLabel.text = @"出借结束";
//            }
        } else {
            if ([self.product.investStatus integerValue] == 4) {
                if ([self.product.proType integerValue] == 1 || [self.product.proType integerValue] == 2 || [self.product.proType integerValue] == 3) {
                    NSString *str = [NSString stringWithFormat:@"出借结束（锁定出借期%@天）。",self.product.closeDays];
                    [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:self.product.closeDays] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                } else {
                    NSInteger beginDay = [CRFTimeUtil getTimeIntervalWithFormatDate:self.product.interestStartDate] / 1000;
                    NSInteger day = ([CRFTimeUtil getTimeIntervalWithFormatDate:self.product.exitDate] / 1000 - beginDay) / ([CRFTimeUtil getTimeIntervalWithDay:1] / 1000);
                    if (day < 0) {
                        day = 0;
                    }
                    NSString *str =  [NSString stringWithFormat:@"出借结束（共投资了%ld天），资金已退出到可用余额。",day];
                    [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:[NSString stringWithFormat:@"%ld",day]] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                }
            } else if (self.product.investStatus.integerValue == 31) {
                 self.currentContentLabel.text = @"申请取消";
            } else {
                if ([self.product.proType integerValue] == 1 || [self.product.proType integerValue] == 2 || [self.product.proType integerValue] == 3) {
                    NSString *str = [NSString stringWithFormat:@"出借结束（锁定出借期%@天），资金已转投到其他出借计划（出借编号为%@）。",self.product.closeDays,self.product.investNo];
                    [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:2 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:self.product.closeDays] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                } else {
                    NSInteger beginDay = [CRFTimeUtil getTimeIntervalWithFormatDate:self.product.interestStartDate] / 1000;
                    NSInteger day = ([CRFTimeUtil getTimeIntervalWithFormatDate:self.product.exitDate] / 1000 - beginDay) / ([CRFTimeUtil getTimeIntervalWithDay:1] / 1000);
                    if (day < 0) {
                        day = 0;
                    }
                    NSString *str =  [NSString stringWithFormat:@"出借结束（共投资了%ld天），\n资金已转投到其他出借计划（出借编号为%@）",day,self.product.investNo];
                    [self.currentContentLabel setAttributedText:[CRFStringUtils setAttributedString:str lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} range1:[str rangeOfString:[NSString stringWithFormat:@"%ld",day]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range2:[str rangeOfString:[NSString stringWithFormat:@"资金已转投到其他出借计划（出借编号为%@）",self.product.investNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
                }
            }
        }
    }
}

- (void)setEvent:(CRFInvestEvent *)event {
    _event = event;
    [self.statusLabel setAttributedText:[CRFStringUtils setAttributedString:_event.eventContent lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:self.borderFont?  UIColorFromRGBValue(0x333333):UIColorFromRGBValue(0x666666)} range1:NSMakeRange(0, _event.eventContent.length) attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.dateLabel.text = _event.eventTime;
}

- (void)setCurrentPoint:(BOOL)currentPoint {
    _currentPoint = currentPoint;
    self.dotImageView.image = [UIImage imageNamed: _currentPoint?@"dot_red":@"dot_gray"];
}

- (void)setHideTopLine:(BOOL)hideTopLine {
    _hideTopLine = hideTopLine;
    [self layoutSubviews];
    [CRFUtils delayAfert:.1 handle:^{
        self.topConstraint.constant = CGRectGetMidY(self.dotImageView.frame);
    }];
}


- (void)setHideBottomLine:(BOOL)hideBottomLine {
    _hideTopLine = hideBottomLine;
    [self layoutIfNeeded];
    [self layoutSubviews];
    [CRFUtils delayAfert:.1f handle:^{
        self.bottomConstraint.constant = CGRectGetMidY(self.dotImageView.frame);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
