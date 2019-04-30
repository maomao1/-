//
//  CRFInvestRecordTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestRecordTableViewCell.h"

@implementation CRFInvestRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRedeemRecord:(CRFRedeemRecord *)redeemRecord {
    _redeemRecord = redeemRecord;
    self.dateLabel.text = _redeemRecord.transferdate;
    NSString *title = [NSString stringWithFormat:@"退出金额：%@元",[_redeemRecord.amount formatProfitMoney]];
    NSString *content = [NSString stringWithFormat:@"其中：本金%@元，收益%@元",[_redeemRecord.capital formatProfitMoney],[_redeemRecord.profit formatProfitMoney]];
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

@end
