//
//  CRFClientInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/6.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFClientInfo.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation CRFClientInfo

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}

- (NSString *)versionNum {
    if (!_versionNum) {
        _versionNum =[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _versionNum;
}
- (NSString *)versionName {
    if (!_versionName) {
        _versionName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    return _versionName;
}

- (NSString *)versionCode {
    if (!_versionCode) {
        _versionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _versionCode;
}

- (NSString *)deviceId {
    return [CRFUserDefaultManager getDeviceUUID];
}

- (NSString *)idfa {
    if (!_idfa) {
        _idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    }
    return _idfa;
}

- (NSString *)os {
    if (!_os) {
        _os = @"IOS";
    }
    return _os;
}

- (NSString *)osVersion {
    if (!_osVersion) {
        _osVersion = [UIDevice currentDevice].systemVersion;
    }
    return _osVersion;
}
- (NSString *)clientId{
    if (!_clientId) {
        _clientId = @"";
    }
    return _clientId;
}
@end
