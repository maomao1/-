//
//  CRFInvestRecordTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFRedeemRecord.h"

@interface CRFInvestRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) CRFRedeemRecord *redeemRecord;

@end
