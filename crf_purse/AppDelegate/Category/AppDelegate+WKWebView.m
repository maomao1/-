//
//  AppDelegate+WKWebView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate+WKWebView.h"
#import "CRFRsaUtil.h"

@implementation AppDelegate (WKWebView)
+ (void)catchWkWebViewContentViewCrash {
    const char *className = @"WKContentView".UTF8String;
    Class WKContentViewClass = objc_getClass(className);
    SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
    SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
    BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
    BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
    if (!addIsSecureTextEntry || !addSecureTextEntry) {
        DLog(@"WKContentView-Crash->修复失败");
    }
}

BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}



@end
