//
//  CRFHomeViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFHomeProductFactory.h"
#import "CRFRefreshHeader.h"
#import "CRFBannerMoreView.h"
#import "CRFAppointmentForwardHelpView.h"
#import "CRFExclusiveModel.h"
@interface CRFHomeViewController : CRFBasicViewController

@property (nonatomic, strong) UITableView *recommendTabView;
@property (nonatomic, strong) NSMutableArray <NSArray <CRFProductModel *>*> *productArray;
@property (nonatomic, strong) CRFHomeProductFactory *productFactory;
@property (nonatomic, strong) CRFRefreshHeader *refreshTopHeader;

@property (nonatomic, strong) CRFCustomHeaderView *headerView;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, copy) void (^(userLoginCallback))(void);
@property (nonatomic, copy) void (^(changeUserHeaderImage))(void);
@property (nonatomic, copy) void (^(refreshUserAssert))(void);
@property (nonatomic, strong) CRFAppointmentForwardHelpView *helpView;
@property (nonatomic, strong) CRFExclusiveModel  *exclusiveItem;
- (void)assignmentHome:(NSDictionary *)dict;

- (void)setFooterView;

@end
