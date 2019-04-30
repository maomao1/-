//
//  CRFNCPClaimTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFClaimer.h"

@interface CRFNCPClaimTableViewCell : UITableViewCell


@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) CRFClaimer *claimer;

@property (nonatomic, copy) void (^ (lookupProtocolContent))(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^ (showClaimerDetail))(NSIndexPath *indexPath);

@end
