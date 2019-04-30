//
//  CRFManagerDeviceCell.h
//  crf_purse
//
//  Created by maomao on 2017/9/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFBindDevicesModel.h"
static NSString *const CRFManagerDeviceCell_ID = @"CRFManagerDeviceCell_Identifier";
@interface CRFManagerDeviceTableViewCell : UITableViewCell
- (void)crfSetContent:(CRFBindDevicesModel*)model;
@end
