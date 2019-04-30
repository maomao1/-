//
//  CRFRefreshUserInfoHandler.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRefreshUserInfoHandler.h"
#import "CRFSettingData.h"

@interface CRFRefreshUserInfoHandler()

@property (nonatomic, copy) void (^ (refreshStandardHandler))(BOOL success, id response);

@end

@implementation CRFRefreshUserInfoHandler

+ (instancetype)defaultHandler {
    static CRFRefreshUserInfoHandler *handler = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (void)getInvestingDatas:(void (^)(BOOL success,id response))handler {
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kInvistingURLPath),[CRFAppManager defaultManager].userInfo.customerUid] success:^(CRFNetworkCompleteType errorType, id response) {
        self.investingHtml = response[kDataKey][@"invitingHtml"];
        self.invitingContent = response[kDataKey][@"content"];
        self.invitingTitle = response[kDataKey][@"name"];
        if (handler) {
            handler(YES,response);
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        if (handler) {
            handler(NO, response);
        }
    }];
}

- (NSString *)investingHtml {
    if (!_investingHtml) {
        _investingHtml = @"";
    }
    return _investingHtml;
}

- (void)refreshStandardUserInfo:(void (^)(BOOL, id))handler {
    if ([CRFAppManager defaultManager].login) {
        weakSelf(self);
        self.userInfo = [CRFAppManager defaultManager].userInfo;
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUserInfoPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
                DLog(@"refresh user info");
                CRFUserInfo *userInfo = [CRFResponseFactory hadleLoginDataForResult:response];
                userInfo.accessToken = strongSelf.userInfo.accessToken;
                userInfo.userId = strongSelf.userInfo.userId;
                userInfo.phoneNo = strongSelf.userInfo.phoneNo;
                userInfo.refreshToken = strongSelf.userInfo.refreshToken;
                userInfo.customerUid = strongSelf.userInfo.customerUid;
//                userInfo.financialName = strongSelf.userInfo.financialName;
//                userInfo.financialPhone = strongSelf.userInfo.financialPhone;
                [CRFSettingData setCurrentAccountInfo:userInfo];
                [CRFAppManager defaultManager].userInfo = nil;
                if (handler) {
                    handler(YES, response);
                }
            } else {
                if (handler) {
                    handler(NO, response);
                }
            }
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            if (handler) {
                handler(NO, response);
            }
        }];
    }
}

- (void)clearUserInfo {
    self.investingHtml = nil;
    [[CRFStandardNetworkManager defaultManager] destory];
    [CRFAppManager defaultManager].accountInfo = nil;
    [CRFAppManager defaultManager].userInfo = nil;
    [CRFSettingData setCurrentAccountInfo:nil];
    [CRFUserDefaultManager removeLoginTime];
}

@end
