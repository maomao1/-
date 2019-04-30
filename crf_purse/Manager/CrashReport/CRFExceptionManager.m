//
//  CRFExceptionManager.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFExceptionManager.h"
#import "WOCrashProtectorManager.h"

NSUncaughtExceptionHandler *handler = nil;

@interface CRFExceptionManager()
@end

@implementation CRFExceptionManager
#pragma mark - 捕捉Crash
void uncaughtExceptionHandler(NSException *exception){
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"OsPhone:%@\nModel:%@\nException reason：%@\nException name：%@\nException stack：%@",[NSString getCurrentDeviceModel],[UIDevice currentDevice].model,name, reason, stackArray];
    //save crash
    [CRFSettingData setCrashBugData:exceptionInfo];
    NSLog(@"%@", exceptionInfo);
}

+ (void)InstallUncaughtExceptionHandler {
    [WOCrashProtectorManager makeAllEffective];
    //获取崩溃统计的函数指针
    handler = NSGetUncaughtExceptionHandler();
    //利用 NSSetUncaughtExceptionHandler，当程序异常退出的时候，可以先进行处理，然后做一些自定义的动作
    //其实控制台输出的日志信息就是NSException产生的，一旦程序抛出异常，程序就会崩溃，控制台就会有崩溃日志
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

+ (instancetype)sharedInstance {
    static CRFExceptionManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)uploadCrashInfo {
    NSString *info = [CRFSettingData getCrashBugData];
    if (info && ![info isEmpty]) {
        [CRFUtils delayAfert:5 handle:^{
            CRFClientInfo *clientInfo = [CRFAppManager defaultManager].clientInfo;
            [[CRFStandardNetworkManager defaultManager] post:APIFormat(kErrorLogPath) paragrams:@{@"customerUid":[CRFAppManager defaultManager].userInfo.customerUid,@"appName":clientInfo.versionName,@"mobileOs":clientInfo.os,@"appVersion":clientInfo.versionCode,@"deviceInfo":clientInfo.deviceId,@"errMsg":info} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
                    [CRFSettingData removeCrashBugData];
                     DLog(@"upload crash info success");
            } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
                DLog(@"upload crash info failed");
            }];
        }];
    }
}

@end
