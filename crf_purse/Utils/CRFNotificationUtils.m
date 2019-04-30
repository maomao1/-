//
//  CRFNotificationUtils.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/9.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNotificationUtils.h"

@implementation CRFNotificationUtils


+ (void)postNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

+ (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

+ (void)postNotificationName:(NSString *)name object:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

+ (void)addNotificationWithObserver:(id)observer
                           selector:(SEL)action
                               name:(NSString *)name {
    if (!observer) return;
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:action
                                                 name:name
                                               object:nil];
}

+ (void)addNotificationWithObserver:(id)observer selector:(SEL)action name:(NSString *)name object:(id)object {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:action name:name object:object];
}

+ (void)removeObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

+ (void)removeObserver:(id)observer notificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
}

+ (void)removeObserver:(id)observer notificationName:(NSString *)name object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:observer];
}

@end

NSString *const kRegisterSuccessNotificationName = @"registerSuccessNotificationName";

NSString *const kReceiveRemoteNotificationName = @"receiveRemoteNotificationName";

NSString *const kWebViewNotFoundNotificationName = @"webViewNotFound";

NSString *const kAuthorizedSignatoryNotificationName = @"authorizedSignatory";

NSString *const kReloadResourceNotificationName = @"reloadResourceNotificationName";

NSString *const kDismissGestureNotificationName = @"dismissGestureNotificationName";

NSString *const kGestureErrorToLoginNotificationName = @"gestureErrorToLoginNotificationName";
