//
//  CRFGestureManager.m
//  crf_purse
//
//  Created by xu_cheng on 2018/4/10.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFGestureManager.h"
#import "CRFGestureViewController.h"
#import "CRFControllerManager.h"
#import "CRFGestureVerifyViewController.h"
#import "AppDelegate+UpdateVersion.h"


@interface CRFGestureManager()

@property (nonatomic, assign) BOOL upgraded;

@property (nonatomic, assign) BOOL verifyGestureEnd;

@end

@implementation CRFGestureManager

+ (instancetype)defaultManager {
    static CRFGestureManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)notification {
     [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(gestureErrorLogin) name:kGestureErrorToLoginNotificationName];
}

+ (void)registerNotification {
    [[self defaultManager] notification];
}

+ (void)verifyPassword:(NSString *)password handler:(void (^)(BOOL, id))handler {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[CRFAppManager defaultManager].userInfo.phoneNo                                               forKey:kMobilePhone];//账户（手机号码）
    [param setValue:password                                                    forKey:kLoginPwd];//用户密码
    [param setValue:[CRFAppManager defaultManager].clientInfo.versionNum                                     forKey: @"appVersion"];//当前登录应用版本号
    [param setValue:[CRFAppManager defaultManager].clientInfo.deviceId             forKey: @"deviceNo"];//手机设备号
    [param setValue:[CRFAppManager defaultManager].clientInfo.clientId             forKey: @"clientId"];//消息推送客户端ID，可为空
    [param setValue:[NSString stringWithFormat:@"%@",[CRFAppManager defaultManager].clientInfo.deviceToken]  forKey: @"uMengId"];//消息推送客户端deviceToken，可为空
    [param setValue:@"IOS"                                                         forKey: @"mobileOs"];//手机系统，Android、IOS
    [param setValue:[NSString getCurrentDeviceModel]                                 forKey: @"model"];//手机型号
    [param setValue:[UIDevice currentDevice].name                                 forKey: @"deviceName"];//手机设备名称
    [param setValue:[NSString getAppId]                     forKey: @"appId"];//
    [param setValue:[CRFAppManager defaultManager].clientInfo.idfa forKey:@"idfa"];
    [param setValue:[NSString getMacAddress] forKey:@"macAddress"];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kUserLoginPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        CRFUserInfo *userInfo = [CRFResponseFactory hadleLoginDataForResult:response];
        userInfo.phoneNo = [CRFAppManager defaultManager].userInfo.phoneNo;
        [CRFAppManager defaultManager].userInfo = userInfo;
        [CRFRefreshUserInfoHandler defaultHandler].userInfo = userInfo;
        [[CRFStandardNetworkManager defaultManager] destory];
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            if (success) {
                [[CRFStandardNetworkManager defaultManager] destory];
                [CRFUserDefaultManager setInputAccountInfo:[CRFAppManager defaultManager].userInfo.phoneNo];
                [CRFUserDefaultManager setUserLoginTime];
                if (handler) {
                    handler(YES, response);
                }
            } else {
                [CRFAppManager defaultManager].userInfo = nil;
                if (handler) {
                    handler(NO, response);
                }
            }
        }];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        if (handler) {
            handler(NO, response);
        }
    }];
}

+ (void)upgradeVersion {
    if (![CRFGestureManager defaultManager].upgraded && [CRFGestureManager defaultManager].verifyGestureEnd) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) versionUpgrade];
        [CRFGestureManager defaultManager].upgraded = YES;
    }
}

+ (void)coolStartVerifyGesture {
    if ([CRFAppManager defaultManager].login) {
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            if (success) {
                if ([CRFUserDefaultManager getTouchID] && [CRFUserDefaultManager getFinalGesture]) {
                    //既有指纹、又有手势
                    CRFGestureViewController *contorller = [CRFGestureViewController new];
                    [contorller setResultHandler:^(BOOL result){
                        [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                        [CRFGestureManager upgradeVersion];
                    }];
                    contorller.type = GestureViewControllerTypeLogin;
                    [contorller setLoginHandler:^(CRFGestureViewController *targetController){
                        [targetController dismissViewControllerAnimated:YES completion:^{
                            [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                            [self gotoLogin];
                        }];
                    }];
                    [[CRFUtils getVisibleViewController] presentViewController:contorller animated:YES completion:^{
                        [[CRFAppManager defaultManager] verifyTouchID:^(TouchStatus status) {
                            if (status == VerifySuccess) {
                                [contorller dismissViewControllerAnimated:YES completion:^{
                                    [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                                    [CRFGestureManager upgradeVersion];
                                }];
                            } else if (status == VerifyFailed){
                                [contorller dismissViewControllerAnimated:YES completion:^{
                                    [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                                    [self gotoLogin];
                                }];
                            } else {
                                NSLog(@"cancel touch id");
                                [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                                [self gotoLogin];
                            }
                        }];
                    }];
                } else if (![CRFUserDefaultManager getFinalGesture] && [CRFUserDefaultManager getTouchID]) {
                    //只有指纹
                    [[CRFAppManager defaultManager] verifyTouchID:^(TouchStatus status) {
                        if (status == VerifySuccess) {
                            NSLog(@"verify success");
                            [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                            [CRFGestureManager upgradeVersion];
                        } else if (status == VerifyFailed){
                            [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                            [self gotoLogin];
                        }else if (status == NotFoundTouchID){
                            [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                            [CRFUserDefaultManager setTouchIDSwitch:NO];
                        }else {
                            NSLog(@"cancel touch id");
                            [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                            [self gotoLogin];
                        }
                    }];
                } else if ([CRFUserDefaultManager getFinalGesture] && ![CRFUserDefaultManager getTouchID]) {
                    //只有手势
                    CRFGestureViewController *contorller = [CRFGestureViewController new];
                    [contorller setResultHandler:^(BOOL result){
                        [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                        [CRFGestureManager upgradeVersion];
                    }];
                    contorller.type = GestureViewControllerTypeLogin;
                    [contorller setLoginHandler:^(CRFGestureViewController *targetController){
                        [targetController dismissViewControllerAnimated:YES completion:^{
                            [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                            [self gotoLogin];
                        }];
                    }];
                    [[CRFUtils getVisibleViewController] presentViewController:contorller animated:YES completion:nil];
                } else {
                    [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                    [CRFGestureManager upgradeVersion];
                    NSLog(@"没有设置手势、没有设置指纹");
                }
            } else {
                [CRFGestureManager defaultManager].verifyGestureEnd = YES;
                [CRFGestureManager upgradeVersion];
            }
        }];
    } else {
        [CRFGestureManager defaultManager].verifyGestureEnd = YES;
        [CRFGestureManager upgradeVersion];
    }
}

+ (void)hotStartVerifyGesture {
    long long currentTime = [CRFTimeUtil getCurrentTimeInteveral];
    long long lastTime = [CRFUserDefaultManager getAppBackgroungTime];
    long long diffTime = (currentTime - lastTime) / 1000;
    if (diffTime > 60 * 2) {
        [self coolStartVerifyGesture];
    }
}

+ (void)firstInstallAfterSettingGesture {
    if (![CRFUserDefaultManager getFirstInstallFlag] || [CRFUserDefaultManager getGestureErrorMaxFlag]) {
        [CRFUserDefaultManager setGestureErrorMaxFlag:NO];
        [self settingGesture];
    }
}

+ (void)settingGesture {
    [CRFUtils delayAfert:.3 handle:^{
        [CRFUserDefaultManager setFirstInstallFlag];
        CRFGestureViewController *controller = [CRFGestureViewController new];
        [controller setValue:@3 forKey:@"type"];
        [[CRFUtils getVisibleViewController] presentViewController:controller animated:YES completion:nil];
    }];
}

+ (void)gotoLogin {
    [CRFUtils getMainQueue:^{
        [CRFAppManager defaultManager].userInfo = nil;
        [CRFSettingData setCurrentAccountInfo:nil];
        [CRFControllerManager resetHomeConfig];
        [[CRFStandardNetworkManager defaultManager] destory];
        [CRFControllerManager pushLoginViewControllerFrom:[CRFUtils getVisibleViewController] popType:PopDefault];
    }];
}

- (void)gestureErrorLogin {
    UIViewController *controller = [CRFUtils getVisibleViewController];
    if (![controller isKindOfClass:[CRFGestureVerifyViewController class]] && ![controller isKindOfClass:[CRFGestureViewController class]]) {
        [CRFGestureManager gotoLogin];
    }
}

@end
