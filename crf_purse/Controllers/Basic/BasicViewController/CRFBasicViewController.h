//
//  CRFBasicViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFSupervisionInfoView.h"
#import "UIViewController+Custom.h"


typedef NS_ENUM(NSUInteger, RequestStatus) {
    Status_Normal                       = 0,
    Status_Off_Line                     = 1,
    Status_Not_Found                    = 2,
    Status_Coupon_None                  = 3,
    Status_Home_Net_Error               = 4,
    Status_AppointForward_None          = 5,
    Status_ExclusivePlan_None           = 6,
};

@interface CRFBasicViewController : UIViewController<CRFSupervisionInfoViewDelegate>

@property (nonatomic, strong) CRFSupervisionInfoView *signatoryView;

@property (nonatomic, assign) RequestStatus requestStatus;

@property (nonatomic, copy) void (^(requestStatusOperationHandler))(void);

@property (nonatomic, copy) void (^ (viewBringSubViewToFrondHandler))(void);
- (void)setDefautBarColor;
- (void)setBlackBarColor;
//导航栏左边按钮(黑色)
- (void)backBarbuttonForBlack;

/**
 自定义白色返回按钮
 */
- (void)customNavigationBackForWhite;

/**
 自定义黑色返回按钮
 */
- (void)customNavigationBackForBlack;

/**
 更新资源文件
 */
- (void)resourceDidUpdate;

/**
 导航栏返回按钮(白色)
 */
- (void)backBarbuttonForWhite;

/**
 <#Description#>
 */
- (void)authAuthorizedSignatoryView;

/**
 返回事件
 */
- (void)back;

/**
监听网络状态

 @param status 默认页
 @param handler 回调
 */
- (void)addRequestNotificationStatus:(RequestStatus)status handler:(void (^)(void))handler;

-(void)setBarWhiteTextColor;
//设置三方埋点 
-(void)setAppCountManager;
@end
