//
//  CRFRefreshTokenTool.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRefreshTokenTool.h"
#import "CRFRSAParamEncrypt.h"
#import "CRFParserNetworkResponse.h"

@implementation CRFRefreshTokenTool

+ (instancetype)sharedInstance {
    static CRFRefreshTokenTool *tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[self alloc] init];
    });
    return tool;
}

+ (void)refreshToken:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    DLog(@"request timeout is %ld",(NSInteger)manager.requestSerializer.timeoutInterval);
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    NSDictionary *dict = [self getHeaders];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    NSString *urlString = [NSString stringWithFormat:APIFormat(kRefreshTokenPath),kUuid];
    NSDictionary *rsaEncryptDict = [CRFRSAParamEncrypt rsaEncrypt:@{@"refreshToken":[CRFAppManager defaultManager].userInfo.refreshToken,@"grantType":@"refresh_token",@"timestamp":[CRFTimeUtil getCurrentTimeStamp],@"appId":[NSString getAppId],@"appSecret":@""} url:urlString];
    DLog(@"put URL is %@",urlString);
    DLog(@"paragrames is %@",rsaEncryptDict);
    [manager POST:urlString parameters:rsaEncryptDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[kResult] isEqualToString:kSuccessResultStatus]) {
            [CRFAppManager defaultManager].userInfo.accessToken = responseObject[kDataKey][@"accessToken"];
            [CRFSettingData setCurrentAccountInfo:[CRFAppManager defaultManager].userInfo];
            [[CRFStandardNetworkManager defaultManager] destory];
        }
        if (completeHandler) {
            completeHandler(CRFNetworkCompleteTypeSuccess,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"refresh token failed");
        [CRFParserNetworkResponse parserRefreshTokenResponseError:error failed:failedHandler];
    }];

}

+ (void)refreshToken:(CRFNetworkRefreshTokenCompleteBlock)complete failed:(CRFNetworkFailedBlock)failed target:(id)target originSelector:(SEL)originSelector params:(NSArray *)params {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    DLog(@"request timeout is %ld",(NSInteger)manager.requestSerializer.timeoutInterval);
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    NSDictionary *dict = [self getHeaders];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    NSString *urlString = [NSString stringWithFormat:APIFormat(kRefreshTokenPath),kUuid];
    NSDictionary *rsaEncryptDict = [CRFRSAParamEncrypt rsaEncrypt:@{@"refreshToken":[CRFAppManager defaultManager].userInfo.refreshToken,@"grantType":@"refresh_token",@"timestamp":[CRFTimeUtil getCurrentTimeStamp],@"appId":[NSString getAppId],@"appSecret":@""} url:urlString];
    DLog(@"put URL is %@",urlString);
    DLog(@"paragrames is %@",rsaEncryptDict);
    [manager POST:urlString parameters:rsaEncryptDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[kResult] isEqualToString:kSuccessResultStatus]) {
            [CRFAppManager defaultManager].userInfo.accessToken = responseObject[kDataKey][@"accessToken"];
            [CRFSettingData setCurrentAccountInfo:[CRFAppManager defaultManager].userInfo];
            [[CRFStandardNetworkManager defaultManager] destory];
            NSLog(@"refresh token success");
        }
        if (complete) {
            complete(CRFNetworkCompleteTypeSuccess,responseObject, target);
        } 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CRFParserNetworkResponse parserResponseError:error target:target originSelecter:originSelector paragram:params failed:failed];
    }];
}

+ (NSDictionary *)getHeaders {
    return @{@"version-code":[CRFAppManager defaultManager].clientInfo.versionCode,
             @"packageName":[NSString getAppId],
             @"mobileOs":[CRFAppManager defaultManager].clientInfo.os,
             @"deviceno":[CRFUserDefaultManager getDeviceUUID],
             @"clientId":[CRFAppManager defaultManager].clientInfo.clientId,
             @"mchntNo" :kMchntNo};
}

@end
