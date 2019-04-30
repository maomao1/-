//
//  CRFHomePageViewController.h
//  crf_purse
//
//  Created by mystarains on 2019/1/4.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFRefreshHeader.h"
#import "CRFHomeProductFactory.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFExclusiveModel.h"
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRFHomePageViewController : CRFBasicViewController

@property (nonatomic, strong) UITableView *recommendTabView;

@property (nonatomic, strong) CRFRefreshHeader *refreshTopHeader;
@property (nonatomic, strong) CRFHomeProductFactory *productFactory;
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (nonatomic, strong) CRFExclusiveModel  *exclusiveItem;

@property (nonatomic, assign) BOOL registerSuccess;

@property (nonatomic, copy) void (^(userLoginCallback))(void);
@property (nonatomic, copy) void (^(refreshUserAssert))(void);

- (void)assignmentHome:(NSDictionary *)dict;
- (void)refreshMessageCount:(NSString *)count;

@end

NS_ASSUME_NONNULL_END
