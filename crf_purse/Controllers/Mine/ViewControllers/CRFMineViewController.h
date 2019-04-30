//
//  CRFMineViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFMineViewController : CRFBasicViewController

@property (nonatomic, copy) NSString *investInfo;

@property (nonatomic, copy) void (^(refreshUserAssertAccount))(void);

- (void)refreshUnreadMessageCount;



@end
