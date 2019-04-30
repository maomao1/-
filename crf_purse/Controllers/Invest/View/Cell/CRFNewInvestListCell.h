//
//  CRFNewInvestListCell.h
//  crf_purse
//
//  Created by maomao on 2018/7/3.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"
#import "CRFLabel.h"
#import "CRFDebtModel.h"
static NSString *const CRFNewInvestListCellId  = @"CRFNewInvestListCellIdentifier";
static NSString *const CRFDebtListCellId  = @"CRFDebtInvestListCellIdentifier";

@interface CRFNewInvestListCell : UITableViewCell
@property(nonatomic ,strong) CRFProductModel *productModel;
@property(nonatomic ,strong) CRFDebtModel    *debtModel;
@property (nonatomic ,strong) CRFLabel   * lineLabel;

@end
