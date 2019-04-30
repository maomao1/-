//
//  CRFMineInvestTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFMyInvestProduct.h"

@interface CRFMineInvestTableViewCell : UITableViewCell

@property (nonatomic, strong) CRFMyInvestProduct *product;

/**
 0:未计息（出借中）。1:计息中（退出中）。2:已结束
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) void (^(helpHandler))(BOOL attributedImage, NSIndexPath *indexPath);

@property (nonatomic, strong) NSIndexPath *indexPath;


@end
