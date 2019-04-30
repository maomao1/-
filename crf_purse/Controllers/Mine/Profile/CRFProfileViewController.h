//
//  CRFProfileViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicTableViewController.h"

@interface CRFProfileViewController : CRFBasicTableViewController


@property (nonatomic, copy) void (^(updateProfileHandler))(NSIndexPath *indexPath);

@end
