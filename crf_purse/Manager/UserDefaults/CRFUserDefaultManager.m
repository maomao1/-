//
//  CRFUserDefaultManager.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUserDefaultManager.h"
#import "CRFTimeUtil.h"
#import "CRFKeyChain.h"

static NSString *const kLaunchFirstValuekey   = @"firshLaunch";

static NSString *const kInputAccountHistory   = @"inputAccount";//登录账号记录
//static NSString *const kTouchIDSwitchKey = @"touchIDSwitch";

static NSString *const kUserLoginTimeKey = @"userLoginTime";
static NSString *const kHomeAnnouchKey_cache = @"home_annouch_cache";
static NSString *const kDeviceUUIDKey = @"deviceUUID";

static NSString *const kBankListVersionKey = @"bankListVersionKey";

static NSString *const kTemporaryGestureKey = @"temporaryGestureKey";

static NSString *const kFinalGestureKey = @"finalGestureKey";

static NSString *const kAppBackgroungTimeKey = @"appBackgroungTime";

static NSString *const kFirstInstallTimeKey = @"firstInstallTimeKey";

static NSString *const kGestureErrorMaxKey = @"gestureErrorMaxKey";

@implementation CRFUserDefaultManager

+ (void)setObject:(id)object key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getObject:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)setBool:(BOOL)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getBoolValue:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setInteger:(NSInteger)integer key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:integer forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getInteger:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

#pragma mark ----

+ (void)setTouchIDSwitch:(BOOL)on {
    [self setBool:on key:[NSString stringWithFormat:@"%@_TouchID_Status",kUuid]];
}

+ (BOOL)getTouchID {
    return [self getBoolValue:[NSString stringWithFormat:@"%@_TouchID_Status",kUuid]];
}

+ (void)setInputAccountInfo:(NSString *)value{
    [self setObject:value key:kInputAccountHistory];
}

+ (NSString *)getInputAccout{
    return [self getObject:kInputAccountHistory];
}

+ (void)setUserLoginTime {
    [self setObject:@([CRFTimeUtil getCurrentTimeInteveral]) key:kUserLoginTimeKey];
}

+ (long long)getUserLoginTime {
    return [[self getObject:kUserLoginTimeKey] longLongValue];
}

+ (void)removeLoginTime {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserLoginTimeKey];
}

//
+ (void)setLocalVersionValue:(NSString *)value{
    [self setObject:value key:kLaunchFirstValuekey];
}

+ (NSString *)getLocalVersionValue{
    return [self getObject:kLaunchFirstValuekey];
}

+ (NSString *)getDeviceUUID {
    NSString *deviceUUID = [CRFKeyChain keyChainLoad];
    if (!deviceUUID || deviceUUID.length <= 0) {
        deviceUUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [CRFKeyChain keyChainSave:deviceUUID];
    }
    DLog(@"device uuid is %@",deviceUUID);
    return deviceUUID;
}

+ (void)setBankCardAuditErrorFlag:(BOOL)flag {
    [self setObject:@(flag) key:[NSString stringWithFormat:@"%@bankCardFlag",[self getInputAccout]]];
}

+ (BOOL)getBankCardAuthErrorFlag {
    NSNumber *number = [self getObject:[NSString  stringWithFormat:@"%@bankCardFlag",[self getInputAccout]]];
    if (!number) {
        return NO;
    }
    return number.boolValue;
}

+ (void)setBankDatasVersion:(NSInteger)version {
    [self setInteger:version key:kBankListVersionKey];
}

+ (NSInteger)getBankDatasVersion {
    return [self getInteger:kBankListVersionKey];
}

+ (void)setUserAccountSecret:(BOOL)secret {
    [self setObject:@(secret) key:[NSString stringWithFormat:@"user_%@",kUuid]];
}

+ (BOOL)getUserAccountSecret {
    NSNumber *number = [self getObject:[NSString stringWithFormat:@"user_%@",kUuid]];
    if (!number) {
        return YES;
    }
    return number.boolValue;
}

+ (void)setBankAuditStatus:(BOOL)status {
    [self setObject:@(status) key:[NSString stringWithFormat:@"audit_status_%@",kUuid]];
}

+ (BOOL)bankAuditStatus {
    NSNumber *number = [self getObject:[NSString stringWithFormat:@"audit_status_%@",kUuid]];
    if (!number) {
        return NO;
    }
    return number.boolValue;
}

+ (void)setResourceFlag:(NSString *)sourcePath key:(NSString *)sourceKey {
    if (!sourcePath || [sourcePath isEmpty]) {
        NSLog(@"nothing save");
        return;
    }
    [self setObject:sourcePath key:sourceKey];
}

+ (NSString *)getResourceFlag:(NSString *)sourceKey {
    if (!sourceKey || [sourceKey isEmpty]) return nil;
    return [self getObject:sourceKey];
}

+ (void)saveFinalGesture:(NSString *)gesture {
    [self setObject:gesture key:[NSString stringWithFormat:@"%@%@",kFinalGestureKey,[self getInputAccout]]];
}

+ (void)saveTemporaryGesture:(NSString *)gesture {
    [self setObject:gesture key:[NSString stringWithFormat:@"%@%@",kTemporaryGestureKey,[self getInputAccout]]];
}

+ (NSString *)getFinalGesture {
    return [self getObject:[NSString stringWithFormat:@"%@%@",kFinalGestureKey,[self getInputAccout]]];
}

+ (NSString *)getTemporaryGesture {
    return [self getObject:[NSString stringWithFormat:@"%@%@",kTemporaryGestureKey,[self getInputAccout]]];
}

+ (void)setAppBackgroundTime {
    [self setObject:@([CRFTimeUtil getCurrentTimeInteveral]) key:[NSString stringWithFormat:@"%@%@",kAppBackgroungTimeKey,[self getInputAccout]]];
}

+ (long long)getAppBackgroungTime {
    NSNumber *number = [self getObject:[NSString stringWithFormat:@"%@%@",kAppBackgroungTimeKey,[self getInputAccout]]];
    if (number) {
        return number.longLongValue;
    }
    return 0;
}

+ (void)setFirstInstallFlag {
    [self setBool:YES key:kFirstInstallTimeKey];
}

+ (BOOL)getFirstInstallFlag {
    return [self getBoolValue:kFirstInstallTimeKey];
}

+ (void)setGestureErrorMaxFlag:(BOOL)flag {
     [self setObject:@(flag) key:[NSString stringWithFormat:@"%@%@",kGestureErrorMaxKey,[self getInputAccout]]];
}

+ (BOOL)getGestureErrorMaxFlag {
    NSNumber *number = [self getObject:[NSString stringWithFormat:@"%@%@",kGestureErrorMaxKey,[self getInputAccout]]];
    if (number) {
        return number.boolValue;
    }
    return NO;
}


@end
