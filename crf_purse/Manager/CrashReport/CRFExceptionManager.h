//
//  CRFExceptionManager.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFSettingData.h"
@interface CRFExceptionManager : NSObject


/** 捕捉Crash */
void uncaughtExceptionHandler(NSException *exception);

+ (void)InstallUncaughtExceptionHandler;

+ (void)uploadCrashInfo;

@end
