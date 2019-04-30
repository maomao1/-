//
//  CRFExcluPlanCell.h
//  crf_purse
//
//  Created by maomao on 2018/3/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFExclusiveModel.h"
typedef void (^scanExclusiveCallback)(NSString* amount,NSInteger btnStatus);
typedef NS_ENUM(NSInteger, buttonStatus) {
    buttonScanExclusive,
    buttonRecharge = 1,
};
static NSString *const CRFExcluPlanCellId  = @"CRFExcluPlanCellIdentifier";
@interface CRFExcluPlanCell : UITableViewCell
@property (nonatomic, copy) NSString *iconNamed;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) CRFExclusiveModel *excModel;
@property (nonatomic,copy) scanExclusiveCallback scanCallBack;
@property (nonatomic,assign) buttonStatus btnStatus;
@end
