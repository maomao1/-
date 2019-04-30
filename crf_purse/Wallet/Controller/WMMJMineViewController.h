//
//  WMMJMineViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface WMMJMineViewController : CRFBasicViewController


@property (nonatomic, copy) NSString *investInfo;

@property (nonatomic, copy) void (^(refreshUserInfo))(void);

@property (nonatomic, copy) void (^(refreshUserAssertAccount))(void);

@property (nonatomic, copy) void (^(refreshMineConfig))(void);

@property (nonatomic, copy) void (^(refreshInvestList))(void);

- (void)refreshUnreadMessageCount;

@end
