//
//  CRFContractTableViewCell.m
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFContractTableViewCell.h"

@implementation CRFContractTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dayLab.layer.cornerRadius = 8;
    self.dayLab.clipsToBounds = YES;
    self.dayLab.layer.borderWidth = 1.0;
    self.dayLab.layer.borderColor = [UIColor colorWithRed:215/255.0 green:178/255.0 blue:3/255.0 alpha:1].CGColor;
    self.percentLab.layer.cornerRadius = 8;
    self.percentLab.clipsToBounds = YES;
    self.percentLab.layer.borderWidth = 1.0;
    self.percentLab.layer.borderColor = [UIColor colorWithRed:215/255.0 green:178/255.0 blue:3/255.0 alpha:1].CGColor;
    
}
- (IBAction)changeBtnStatus:(UIButton *)sender {

    if (self.selectBtn.selected) {
        self.selectBtn.selected = NO;
        self.model.status = NO;
    }
    else
    {
        self.selectBtn.selected = YES;
        self.model.status = YES;
    }
    [self.tab reloadData];
}
- (void)fillCellWithMoel:(CRFContractModel *)sender
{
    self.titleLab.text = sender.title;
    self.dayLab.text = sender.day;
    self.percentLab.text = sender.percent;
    self.timeLab.text = sender.time;
    self.loanLab.text = sender.loanMoney;
    self.switchLab.text = sender.switchMoney;
    self.numLab.text = sender.num;
    if (sender.status) {
        [self.selectBtn setImage:[UIImage imageNamed:sender.imageName2] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectBtn setImage:[UIImage imageNamed:sender.imageName1] forState:UIControlStateNormal];
    }
    self.selectBtn.selected = sender.status;
    self.model = sender;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
