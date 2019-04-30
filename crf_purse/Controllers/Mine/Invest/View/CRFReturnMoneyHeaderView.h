//
//  CRFReturnMoneyHeaderView.h
//  crf_purse
//
//  Created by maomao on 2019/4/25.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFReceiveCashModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const CRFReturnMoneyHeaderViewId = @"CRFReturnMoneyHeaderViewIdentifier";
@interface CRFReturnMoneyHeaderView : UITableViewHeaderFooterView
@property (nonatomic ,copy) CRFReceiveCashModel *cashModel;
@end

NS_ASSUME_NONNULL_END
