//
//  CRFControllerManager.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFControllerManager.h"
#import "CRFHomePageViewController.h"
#import "CRFMineViewController.h"
#import "CRFAlertUtils.h"
#import "JCAlertController.h"

@interface CRFControllerManager()

@property (nonatomic, assign) BOOL alertExist;
@end

@implementation CRFControllerManager

+ (instancetype)sharedInstance {
    static CRFControllerManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _alertExist = NO;
    }
    return self;
}
+ (void)receivePushMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle {
    if (!message) {
        return;
    }
    if (![CRFAppManager defaultManager].login) {
        return;
    }
    if ([[CRFUtils getVisibleViewController] isKindOfClass:[JCAlertController class]]) {
        DLog(@"alertViewController is exist");
        return;
    }
    if ([CRFControllerManager sharedInstance].alertExist) {
        DLog(@"alertViewController is exist");
        return;
    }
    [self resetAppConfig];
    [CRFAlertUtils showAlertTitle:message message:nil container:[CRFUtils getVisibleViewController] cancelTitle:@"取消" confirmTitle:confirmTitle cancelHandler:^{
        [[CRFAppManager defaultManager] removeWindowUsenessViews];
        [CRFControllerManager sharedInstance].alertExist = NO;
//        [self getTabBarController].selectedIndex = 0;
       
        [[CRFUtils getVisibleViewController].navigationController popToRootViewControllerAnimated:YES];
//        [CRFUtils delayAfert:0.2 handle:^{
//            [self getTabBarController].selectedIndex = 0;
//        }];

    } confirmHandler:^ {
        [[CRFAppManager defaultManager] removeWindowSubViews];
        [CRFControllerManager sharedInstance].alertExist = NO;
        CRFLoginViewController *controller = [CRFLoginViewController new];
        controller.popType = PopHome;
        controller.hidesBottomBarWhenPushed = YES;
        [[CRFUtils getVisibleViewController].navigationController pushViewController:controller animated:YES];
    }];
    [CRFControllerManager sharedInstance].alertExist = YES;
}

+ (void)receivePushMessageGotoLogin {
    [self resetAppConfig];
    CRFLoginViewController *controller = [CRFLoginViewController new];
    controller.popType = PopHome;
    controller.hidesBottomBarWhenPushed = YES;
    [[CRFUtils getVisibleViewController].navigationController pushViewController:controller animated:YES];
}

+ (UITabBarController *)getTabBarController {
    return [CRFUtils getVisibleViewController].tabBarController;
}

+ (CRFHomePageViewController *)getHomeController {
    return (CRFHomePageViewController *)([((UINavigationController *)[self getTabBarController].viewControllers[0]).viewControllers firstObject]);
}

+ (CRFMineViewController *)getMineController {
    return (CRFMineViewController *)([((UINavigationController *)[self getTabBarController].viewControllers[3]).viewControllers firstObject]);
}

+ (void)resetAppConfig {
    [[CRFRefreshUserInfoHandler defaultHandler] clearUserInfo];
    //    [[CRFAppManager defaultManager] removeWindowUsenessViews];
    [self resetHomeConfig];
    [self resetMineConfig];
}

+ (void)resetHomeConfig {
    if ([self getHomeController].userLoginCallback) {
        [self getHomeController].userLoginCallback();
    }
}

+ (void)resetMineConfig {
    [self getMineController].investInfo = nil;
    [self refreshMine];
}

+ (void)refreshHomeUserAssert {
    if ([self getHomeController].refreshUserAssert) {
        [self getHomeController].refreshUserAssert();
    }
}

+ (void)refreshMine {
    if ([self getMineController].refreshUserAssertAccount) {
        [self getMineController].refreshUserAssertAccount();
    }
}

+ (void)loadingHomeUserAvatar {
//    if ([self getHomeController].changeUserHeaderImage) {
//        [self getHomeController].changeUserHeaderImage();
//    }
}

+ (void)refreshUserInfo {
    [CRFRefreshUserInfoHandler defaultHandler].userInfo = [CRFAppManager defaultManager].userInfo;
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
        NSLog(success?@"refresh user info success !":@"refresh user info failed !");
    }];
}

+ (void)refreshTotalAssert {
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUserAssetsTotalPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"===============================");
        DLog(@"get user assets success.");
        CRFAccountInfo *info = [CRFResponseFactory getAccountInfo:response];
        [CRFAppManager defaultManager].accountInfo = info;
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        DLog(@"refreshTotalAssert failed");
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

+ (void)pushLoginViewControllerFrom:(UIViewController *)contorller popType:(PopType)popType {
    CRFLoginViewController *loginController = [CRFLoginViewController new];
    loginController.hidesBottomBarWhenPushed = YES;
    loginController.popType = popType;
    [contorller.navigationController pushViewController:loginController animated:YES];
}

@end
