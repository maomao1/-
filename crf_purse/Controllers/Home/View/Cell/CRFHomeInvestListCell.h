//
//  CRFHomeInvestListCell.h
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"
#import "CRFLabel.h"
#import "CRFDebtModel.h"

static NSString *const CRFHomeInvestListCellId  = @"CRFHomeInvestListCellIdentifier";

NS_ASSUME_NONNULL_BEGIN

@interface CRFHomeInvestListCell : UITableViewCell

@property(nonatomic ,strong) CRFProductModel *productModel;


@end

NS_ASSUME_NONNULL_END
