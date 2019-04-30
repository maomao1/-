//
//  CRFCreditorTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFCreditor.h"

@interface CRFCreditorTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, strong) CRFCreditor *creditor;

@property (nonatomic, assign) NSInteger source;

@end
