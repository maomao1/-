//
//  CRFBannerView.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFActivity.h"
#import "CRFFunction.h"
#import "CRFAppHomeModel.h"
#import "CRFBannerMoreView.h"

static CGFloat const kBannerHeight = 159;
static CGFloat const kFunctionViewHeight = 105;

static CGFloat const kOldFunctionViewHeight = 105;

#define kNewUserViewHeight 201 - 68 * (1 - kWidthRatio)

#define kUnloginHeaderHeight (kBannerHeight *kWidthRatio + ([CRFAppManager defaultManager].majiabaoFlag? 0: kFunctionViewHeight) + kButtonHeight + kTopSpace + kNewUserViewHeight)

#define kOldUserHeaderHeight (kBannerHeight *kWidthRatio + ([CRFAppManager defaultManager].majiabaoFlag? 0: kFunctionViewHeight) + kButtonHeight + kTopSpace - kTopSpace / 2.0)

#define kUnloginNoActivityHeaderHeight (kBannerHeight *kWidthRatio + ([CRFAppManager defaultManager].majiabaoFlag? 0: kFunctionViewHeight) + 8 + kNewUserViewHeight)

#define kOldUserNoActivityHeaderHeight (kBannerHeight *kWidthRatio + ([CRFAppManager defaultManager].majiabaoFlag? 0: kFunctionViewHeight) - kTopSpace / 2.0)

#define kOldUserNoActivityInvestHeaderHeight (kBannerHeight *kWidthRatio + kOldFunctionViewHeight - kTopSpace / 2.0)

#define kOldUserInvestHeaderHeight (kBannerHeight *kWidthRatio + kOldFunctionViewHeight + kButtonHeight + kTopSpace - kTopSpace / 2.0)

typedef NS_ENUM(NSUInteger, ActivityType) {
    Activity        = 0,
    None            = 1,
};

/**
 banner type

 - User_Default: 老用户
 - Account_Bank_None: 未开卡用户
 - Invest_None: 未投资用户
 - User_Logout: 未登录用户
 */
typedef NS_ENUM(NSUInteger, BannerType) {
    User_Default                = 0,
    Account_Bank_None           = 1,
    Invest_None                 = 2,
    User_Logout                 = 3
};

@protocol BannerViewDelegate;

@interface CRFBannerView : UIView

/**
 活动类型
 */
@property (nonatomic, assign) ActivityType type;

/**
 banber 类型
 */
@property (nonatomic, assign) BannerType bannerTpye;

/**
 新用户的model
 */
@property (nonatomic, strong) CRFAppHomeModel *homeModel;
/**
 新手福利帮助model
 */
@property (nonatomic, strong) CRFAppHomeModel *helpModel;
/**
 banner`s delegate
 */
@property (nonatomic, weak) id <BannerViewDelegate>bannerDelegate;

/**
 banner的url
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*banners;

/**
 功能按钮的集合
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*functions;

/**
 活动内容
 */
@property (nonatomic, strong) NSArray <CRFActivity *>*activities;

@end

@protocol BannerViewDelegate <NSObject>

/**
 功能按钮的事件回调

 @param indexPath indexPath
 */
- (void)functionDidSelected:(NSIndexPath *)indexPath url:(NSString *)urlString;

/**
 活动事件的回调

 @param  activity model
 */

- (void)activityDidSelected:(CRFActivity *)activity;

/**
 banner 被点击了的回调

 @param linkUrl linkURL
 */
- (void)bannerDidSelected:(NSString *)linkUrl;

/**
 点击回调

 @param linkUrl linkUrl
 */
- (void)loginAfterFunctionDidSelected:(NSString *)linkUrl;

/**
 新手注册的按钮点击事件

 @param index index
 */
- (void)userToFinishFromRegister:(NSInteger)index;

/**
 使用帮助
 */
- (void)userHelp:(CRFAppHomeModel *)helpItem;

@end
