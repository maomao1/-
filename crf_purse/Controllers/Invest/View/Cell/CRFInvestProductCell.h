//
//  CRFInvestProductCell.h
//  crf_purse
//
//  Created by maomao on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"
#import "CRFCountDownLabel.h"
static NSString  *const  CRFInvestProductCellId  = @"CRFInvestProductCellId";
static CGFloat const kTitleLabelWidth = 100;
@interface CRFInvestProductCell : UITableViewCell
@property (nonatomic, strong)  CRFProductModel *product;

@end
