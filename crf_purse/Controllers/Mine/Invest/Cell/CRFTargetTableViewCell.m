//
//  CRFTargetTableViewCell.m
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFTargetTableViewCell.h"
#import "CRFStringUtils.h"

@interface CRFTargetTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end

@implementation CRFTargetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.subTitle.font = [UIFont systemFontOfSize:12 * kWidthRatio];
    
}

- (IBAction)clickBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.didSelectedHandler) {
        self.didSelectedHandler(self);
    }
}

- (void)fillCellWithModek:(CRFProductModel *)sender {
    self.titleLab.text = sender.productName;
    NSString *string = [NSString stringWithFormat:@"%@%%",sender.yInterestRate];
    [self.percentLab setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:26 * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[string rangeOfString:sender.alreadyInvestPercent] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20 * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:[string rangeOfString:@"%"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.subTitle setAttributedText:[CRFStringUtils setAttributedString:sender.investContent lineSpace:0 attributes1:@{NSForegroundColorAttributeName: UIColorFromRGBValue(0xDDDDDD)} range1:[sender.investContent rangeOfString:@"|" options:NSBackwardsSearch] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetUI {
    self.selectBtn.selected = NO;
}

@end
