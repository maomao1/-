//
//  AppDelegate+Push.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate+Push.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/ASIdentifierManager.h>

static NSString *kJPushAppKey = @"4c92f79814949f20dc82e5da";//正式环境
//static NSString *kJPushAppKey = @"0e52bc60e1a7e46ec1181ea2";//

@implementation AppDelegate (Push)

- (void)registerNotification:(NSDictionary *)launchOptions {
    //    NSString *advertisingId = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    //    [JPUSHService setAlias:@"1111" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:iResCode== 0?@"chenggong":@"faile" message:iAlias delegate:nil cancelButtonTitle:@"cancle" otherButtonTitles: nil];
    //        [alert show];
    //    } seq:1];
    //    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:kChannelId apsForProduction:YES advertisingIdentifier:nil];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey channel:kChannelId apsForProduction:YES];
    //本地通知内容获取
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (remoteNotification) {
        [userDefault setValue:remoteNotification forKey:@"local_push_info"];
    } else {
        [userDefault removeObjectForKey:@"local_push_info"];
    }
    [userDefault synchronize];
    
#ifdef DEBUG
    [JPUSHService setDebugMode];
#else
    [JPUSHService setLogOFF];
#endif
    
}

- (void)uploadToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    [CRFAppManager defaultManager].clientInfo.clientId = [JPUSHService registrationID];
    [CRFAppManager defaultManager].clientInfo.deviceToken= [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                                                            stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        DLog(@"JPush didReceiveNotificationResponse content %@",userInfo);
        [JPUSHService handleRemoteNotification:userInfo];
        [CRFNotificationUtils postNotificationName:kReceiveRemoteNotificationName userInfo:userInfo];
    }
    completionHandler();
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
}

- (void)crfEnterBackground:(UIApplication *)application{
    if (![CRFAppManager defaultManager].login) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        return;
    }
    NSInteger badgeNum = [CRFAppManager defaultManager].unMessageCount.integerValue;
    [JPUSHService setBadge:badgeNum];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum];
}
@end
