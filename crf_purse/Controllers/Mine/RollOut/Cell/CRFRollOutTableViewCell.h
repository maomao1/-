//
//  CRFRollOutTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/18.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRechargeTableViewCell.h"

@interface CRFRollOutTableViewCell : CRFRechargeTableViewCell

@property (nonatomic, strong) UIButton *allInButton;

@property (nonatomic, copy) void (^(allInHandler))(void);

@end
