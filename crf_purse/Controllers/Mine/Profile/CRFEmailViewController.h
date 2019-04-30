//
//  CRFEmailViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFEmailViewController : CRFBasicViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^(refreshUserInfo))(void);

@end
