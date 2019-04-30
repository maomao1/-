//
//  WMNCPTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/15.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const WMNCPInvestListCellId  = @"WMNCPInvestListCellIdentifier";

@interface WMNCPTableViewCell : UITableViewCell

@property(nonatomic ,strong) CRFProductModel *productModel;

@end
