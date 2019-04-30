//
//  CRFNotificationUtils.h
//  crf_purse
//
//  Created by xu_cheng on 2017/10/9.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface CRFNotificationUtils : NSObject

/**
 post nofitication.

 @param name name.
 */
+ (void)postNotificationName:(NSString *)name;

/**
 post nofitication.

 @param name name.
 @param userInfo user info.
 */
+ (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo;

/**
 post nofitication.

 @param name name.
 @param object object.
 */
+ (void)postNotificationName:(NSString *)name object:(id)object;

/**
 add notification observer.

 @param observer observer.
 @param action action.
 @param name name.
 */
+ (void)addNotificationWithObserver:(id)observer selector:(SEL)action name:(NSString *)name;

/**
 add notification observer.

 @param observer observer.
 @param action action.
 @param name name.
 @param object object.
 */
+ (void)addNotificationWithObserver:(id)observer selector:(SEL)action name:(NSString *)name object:(id)object;

/**
 remove observer.

 @param observer observer.
 */
+ (void)removeObserver:(id)observer;

/**
 remove observer.

 @param observer observer.
 @param name name.
 */
+ (void)removeObserver:(id)observer notificationName:(NSString *)name;

/**
 remove observer.

 @param observer observer.
 @param name name.
 @param object object.
 */
+ (void)removeObserver:(id)observer notificationName:(NSString *)name object:(id)object;


@end


static NSString *const kJPushChangeDevice = @"FAPP_1600";///<不同设备登录或者异地登录

//收到多设备登陆的推送通知
extern NSString *const kReceiveRemoteNotificationName;

extern NSString *const kWebViewNotFoundNotificationName;

extern NSString *const kAuthorizedSignatoryNotificationName;

extern NSString *const kReloadResourceNotificationName;

extern NSString *const kDismissGestureNotificationName;

extern NSString *const kGestureErrorToLoginNotificationName;

extern NSString *const kRegisterSuccessNotificationName;
