//
//  CRFInvestListCell.h
//  crf_purse
//
//  Created by maomao on 2017/11/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"
static NSString *const CRFInvestListCellId  = @"CRFInvestListCellIdentifier";
@interface CRFInvestListCell : UITableViewCell
@property(nonatomic ,strong) CRFProductModel *productModel;
@property (nonatomic,strong) CRFAppintmentForwardProductModel *exclusiveProductInfo;

@property (nonatomic, strong) CRFAppintmentForwardProductModel *appointmentAssignProductInfo;
@property (nonatomic, assign) BOOL newBie;
@end
