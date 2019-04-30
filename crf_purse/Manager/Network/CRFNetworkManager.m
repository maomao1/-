//
//  CRFNetworkManager.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNetworkManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CRFFilePath.h"
#import "CRFTimeUtil.h"
#import "CRFRSAParamEncrypt.h"



/*AFHTTPSessionManager 为何每次都是new一个？为何没有重用？
 *
 *网络接口请求都是以delegate的回调方式抛出，若重用一个manager，则在回调用无法区分
 *是哪个接口的回调。（主要是tag）
 *计划：每次都new一个对象，绑定一个tag，每个接口（manager）绑定一个区分标示（tag）
 *
 *若采用callback方式，则manager可以重用，不用以tag区分。
 *
 */

@interface CRFNetworkManager() {
    
}

@property (nonatomic, strong) NSDictionary *messageDict;

@end

@implementation CRFNetworkManager

+ (instancetype)sharedInstance {
    static CRFNetworkManager *manager = nil;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
        
    });
    return manager;
}

- (NSDictionary *)messageDict {
    if (!_messageDict) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ErrorMessage" ofType:@"plist"];
        _messageDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return _messageDict;
}

- (instancetype)init {
    if (self = [super init]) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}

- (NSDictionary *)transformParagrams:(id)paragrams {
    if ([paragrams isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [paragrams mutableCopy];
        [dict setObject:[CRFAppManager defaultManager].userInfo.customerUid forKey:@"customerUid"];
        [dict setObject:[CRFAppManager defaultManager].clientInfo.versionName forKey:@"appName"];
        [dict setObject:[CRFAppManager defaultManager].clientInfo.os forKey:@"mobileOs"];
        [dict setObject:[CRFAppManager defaultManager].clientInfo.versionCode forKey:@"appVersion"];
        [dict setObject:[CRFAppManager defaultManager].clientInfo.deviceId forKey:@"deviceInfo"];
        return dict;
    }
    return nil;
}

- (NSDictionary *)getHeaders:(NSDictionary *)headers {
    if (!headers) {
        return @{@"version-code":[CRFAppManager defaultManager].clientInfo.versionCode,@"packageName":[NSString getAppId],@"mobileOs":[CRFAppManager defaultManager].clientInfo.os,@"deviceno":[CRFUserDefaultManager getDeviceUUID],@"clientId":[CRFAppManager defaultManager].clientInfo.clientId,@"mchntNo":kMchntNo};
    }
    NSMutableDictionary *dict = [headers mutableCopy];
    [dict setValue:[CRFAppManager defaultManager].clientInfo.versionCode forKey:@"version-code"];
    [dict setValue:[NSString getAppId] forKey:@"packageName"];
    [dict setValue:[CRFAppManager defaultManager].clientInfo.os forKey:@"mobileOs"];
    [dict setValue:[CRFUserDefaultManager getDeviceUUID] forKey:@"deviceno"];
    [dict setValue:[CRFAppManager defaultManager].clientInfo.clientId forKey:@"clientId"];
    [dict setValue:kMchntNo forKey:@"mchntNo"];
    return dict;
}

- (AFHTTPSessionManager *)getJsonSessionManager {
    NSURLSessionConfiguration *sc = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sc];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = self.timeInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    DLog(@"request timeout is %ld",(NSInteger)manager.requestSerializer.timeoutInterval);
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    return manager;
}

- (AFHTTPSessionManager *)getDefaultJsonSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = self.timeInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    DLog(@"request timeout is %ld",(NSInteger)manager.requestSerializer.timeoutInterval);
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    return manager;
}

- (AFHTTPSessionManager *)getHttpSessionManager {
    NSURLSessionConfiguration *sc = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sc];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = self.timeInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    DLog(@"request timeout is %ld",(NSInteger)manager.requestSerializer.timeoutInterval);
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    return manager;
}

- (void)GETImage:(NSString *)urlString tag:(NSUInteger)tag delegate:(id <ResponseProtocol>)delegate paragram:(id)paragrams headers:(id)headers {
    if (![self hasNetwork:delegate tag:tag]) {
        return;
    }
    NSURLSessionConfiguration *sc = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sc];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dict = [self getHeaders:headers];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg", nil];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.tag = tag;
    DLog(@"put URL is %@",urlString);
    DLog(@"paragrames is %@",paragrams);
    if (!paragrams) {
        paragrams = @{};
    }
    if (self.isLoading) {
         [CRFLoadingView loading];
    }
    [manager GET:urlString parameters:paragrams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handlerResponseSuccess:responseObject delegate:delegate tag:manager.tag];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handlerResponseError:error delegate:delegate tag:manager.tag originSelecter:@selector(GETImage:tag:delegate:paragram:headers:) paragram:@[urlString,@(tag),delegate,paragrams,dict]];
    }];}

- (void)GET:(NSString *)urlString tag:(NSUInteger)tag delegate:(id <ResponseProtocol>)delegate paragram:(id)paragrams headers:(id)headers{
    if (![self hasNetwork:delegate tag:tag]) {
        return;
    }
    AFHTTPSessionManager *manager = [self getJsonSessionManager];
    NSDictionary *dict = [self getHeaders:headers];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    manager.tag = tag;
    DLog(@"get URL is %@",urlString);
    DLog(@"paragrames is %@",paragrams);
    if (self.isLoading) {
         [CRFLoadingView loading];
    }
    if (!paragrams) {
        paragrams = @{};
    }
    [manager GET:urlString parameters:paragrams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handlerResponseSuccess:responseObject delegate:delegate tag:manager.tag];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handlerResponseError:error delegate:delegate tag:manager.tag originSelecter:@selector(GET:tag:delegate:paragram:headers:) paragram:@[urlString,@(tag),delegate,paragrams,dict]];
    }];
}

- (void)POST:(NSString *)urlString paragram:(id)paragrams headers:(id)headers successHandler:(void (^)(id response))successHandler failedHandler:(void(^)(NSError *error))errorHandler {
    if (![self hasNetwork]) {
        if (errorHandler) {
            errorHandler(nil);
        }
        return;
    }
    AFHTTPSessionManager *manager = [self getDefaultJsonSessionManager];
    NSDictionary *dict = [self getHeaders:headers];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptDict = [self rsaEncrypt:paragrams url:urlString];
    DLog(@"put URL is %@",urlString);
    DLog(@"paragrames is %@",rsaEncryptDict);
    if (self.isLoading) {
         [CRFLoadingView loading];
    }
    [manager POST:urlString parameters:rsaEncryptDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [CRFLoadingView dismiss];
        if (successHandler) {
            successHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handeleNetworkErrorResponse:error successCallback:successHandler failedHandle:errorHandler];
    }];
}

- (void)PUT:(NSString *)urlString tag:(NSUInteger)tag delegate:(id <ResponseProtocol>)delegate paragram:(id)paragrams headers:(id)headers {
    if (![self hasNetwork:delegate tag:tag]) {
        return;
    }
    AFHTTPSessionManager *manager = [self getJsonSessionManager];
    NSDictionary *dict = [self getHeaders:headers];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    manager.tag = tag;
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptDict = [self rsaEncrypt:paragrams url:urlString];
    DLog(@"put URL is %@",urlString);
    DLog(@"paragrames is %@",rsaEncryptDict);
    if (self.isLoading) {
         [CRFLoadingView loading];
    }
    [manager PUT:urlString parameters:rsaEncryptDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handlerResponseSuccess:responseObject delegate:delegate tag:manager.tag];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handlerResponseError:error delegate:delegate tag:manager.tag originSelecter:@selector(PUT:tag:delegate:paragram:headers:) paragram:@[urlString,@(tag),delegate,paragrams,dict]];
    }];
}


- (void)POSTForUpload:(NSString *)urlString datas:(NSData *)data fileName:(NSString *)fileName tag:(NSUInteger)tag delegate:(id <ResponseProtocol>)delegate paragram:(id)paragrams headers:(id)headers {
    if (![self hasNetwork:delegate tag:tag]) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.tag = tag;
    DLog(@"POST URL is %@",urlString);
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptDict = [self rsaEncrypt:paragrams url:urlString];
    DLog(@"paragrames is %@",rsaEncryptDict);
    NSDictionary *dict = [self getHeaders:headers];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    if (self.isLoading) {
         [CRFLoadingView loading];
    }
    [manager POST:urlString parameters:rsaEncryptDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data
                                    name:@"image"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handlerResponseSuccess:responseObject delegate:delegate tag:manager.tag];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handlerResponseError:error delegate:delegate tag:manager.tag originSelecter:@selector(POSTForUpload:datas:fileName:tag:delegate:paragram:headers:) paragram:@[urlString,data,fileName,@(tag),delegate,paragrams,dict]];
    }];
}

- (void)POST:(NSString *)urlString tag:(NSUInteger)tag delegate:(id <ResponseProtocol>)delegate paragram:(id)paragrams headers:(id)headers {
    if (![self hasNetwork:delegate tag:tag]) {
        return;
    }
    AFHTTPSessionManager *manager = [self getJsonSessionManager];
    NSDictionary *dict = [self getHeaders:headers];
    for (NSString *key in dict.allKeys) {
        [manager.requestSerializer setValue:dict[key] forHTTPHeaderField:key];
    }
    manager.tag = tag;
    DLog(@"POST URL is %@",urlString);
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptDict = [self rsaEncrypt:paragrams url:urlString];
    DLog(@"paragrames is %@",rsaEncryptDict);
    if (self.isLoading) {
         [CRFLoadingView loading];
    }
    [manager POST:urlString parameters:rsaEncryptDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handlerResponseSuccess:responseObject delegate:delegate tag:manager.tag];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handlerResponseError:error delegate:delegate tag:manager.tag originSelecter:@selector(POST:tag:delegate:paragram:headers:) paragram:@[urlString,@(tag),delegate,paragrams,dict]];
    }];
}

- (void)DownLoadTask:(NSString*)urlString{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *fullPath = [CRFFilePath createCachePath:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *task =[manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *fileName=[fullPath stringByAppendingPathComponent:response.suggestedFilename];return [NSURL fileURLWithPath:fileName];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
 //                       return [NSURL fileURLWithPath:filePath];
    }];
    [task resume];
}

- (void)downLoadTask:(NSString*)urlString filePath:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))filePath responseHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))complateHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *task =[manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return filePath(targetPath, response);
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        complateHandler(response, filePath, error);
    }];
    [task resume];
}

- (BOOL)netStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}
- (void)networkIsVisible:(void(^)(BOOL visible))callback {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        ReachabilityAvailable aa = {0, NO};
        self.reachabilityAvailable = aa;
        callback(NO);
    }
    self.networkStatus = manager.networkReachabilityStatus;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable: {
                
                if (self.networkStatus == 0) {
                  ReachabilityAvailable aa = {0,NO};
                     self.reachabilityAvailable = aa;
                } else {
                   ReachabilityAvailable aa = {0,YES};
                     self.reachabilityAvailable = aa;
                }
               
                [CRFUtils getMainQueue:^{
                    callback(NO);
                }];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                if (self.networkStatus == 0) {
                    ReachabilityAvailable aa = {2,YES};
                    self.reachabilityAvailable = aa;
                } else {
                    ReachabilityAvailable aa = {2,NO};
                    self.reachabilityAvailable = aa;
                }
                [CRFUtils getMainQueue:^{
                    callback(YES);
                }];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                if (self.networkStatus == 0) {
                    ReachabilityAvailable aa = {1,YES};
                    self.reachabilityAvailable = aa;
                } else {
                    ReachabilityAvailable aa = {1,NO};
                    self.reachabilityAvailable = aa;
                }
                [CRFUtils getMainQueue:^{
                    callback(YES);
                }];
            }
                break;
            default: {
                [CRFUtils getMainQueue:^{
                    callback(NO);
                }];
            }
                break;
                
        }
        self.networkStatus = status;
    }];
}

- (BOOL)hasNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

- (BOOL)hasNetwork:(id <ResponseProtocol>)delegate tag:(NSInteger)tag {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if ([delegate respondsToSelector:@selector(AFNHttpResponseFaliure:tag:)]) {
            [delegate AFNHttpResponseFaliure:nil tag:tag];
        }
        return NO;
    }
    return YES;
}

- (void)networkStatus:(void(^)(AFNetworkReachabilityStatus status))handler {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        handler(status);
    }];
}

- (void)handlerResponseSuccess:(id)responseObject delegate:(id <ResponseProtocol>)delegate tag:(NSInteger)tag {
    [CRFLoadingView dismiss];
    [CRFUtils getMainQueue:^{
        if ([delegate respondsToSelector:@selector(AFNHttpResponseSuccess:tag:)]) {
            [delegate AFNHttpResponseSuccess:responseObject tag:tag];
        }
    }];
}

- (void)handlerResponseError:(NSError *)error delegate:(id <ResponseProtocol>)delegate tag:(NSInteger)tag originSelecter:(SEL)originSelector paragram:(NSArray *)paragrams {
    [CRFLoadingView dismiss];
    NSHTTPURLResponse *responseInternal = error.userInfo[kErrorCodekey];
    DLog(@" error code is %ld", (long)responseInternal.statusCode);
    if (responseInternal.statusCode == 400) {
        id data = error.userInfo[kErrorDataKey];
        id oj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [CRFUtils getMainQueue:^{
            if ([oj[@"code"] isEqualToString:@"FUS_2000"]) {
                self.networkException = ^ (id response) {
                    if ([delegate respondsToSelector:@selector(AFNHttpResponseExecption:)]) {
                        [delegate AFNHttpResponseExecption:oj];
                    }
                };
                [self refreshToken:^(id response) {
                     DLog(@"response is %@", response);
                    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
                        if ([self respondsToSelector:originSelector]) {
                            NSDictionary *d = [paragrams lastObject];
                            NSMutableDictionary *muD = [d mutableCopy];
                            if ([d.allKeys containsObject:kAccessTokenKey]) {
                                [muD setValue:[CRFAppManager defaultManager].userInfo.accessToken forKey:kAccessTokenKey];
                            }
                            NSMutableArray *muA = [paragrams mutableCopy];
                            [muA replaceObjectAtIndex:paragrams.count - 1 withObject:muD];
                            [self performSelector:originSelector withObjects:muA];
                        }
                    } else {
                        if ([self tokenException:oj]) {
                            if ([delegate respondsToSelector:@selector(AFNHttpResponseExecption:)]) {
                                [delegate AFNHttpResponseExecption:oj];
                            }
                        } else {
                            if ([delegate respondsToSelector:@selector(AFNHttpResponseSuccess:tag:)]) {
                                [delegate AFNHttpResponseSuccess:oj tag:tag];
                            }
                        }
                    }
                } failedHandle:^(NSError *error) {
                      DLog(@"error is %@", error);
                    if ([delegate respondsToSelector:@selector(AFNHttpResponseFaliure:tag:)]) {
                        if (![self.messageDict.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)responseInternal.statusCode]]) {
                            DLog(@"request error is %@",error.description);
                            [delegate AFNHttpResponseFaliure:nil tag:tag];
                        } else {
                            NSError *crfError = [NSError errorWithDomain:@"" code:responseInternal.statusCode userInfo:@{@"message":[self.messageDict objectForKey:[NSString stringWithFormat:@"%ld",(long)responseInternal.statusCode]]}];
                            [delegate AFNHttpResponseFaliure:crfError tag:tag];
                        }
                    }
                }];
                return ;
            }
            if ([self tokenException:oj]) {
                if ([delegate respondsToSelector:@selector(AFNHttpResponseExecption:)]) {
                    [delegate AFNHttpResponseExecption:oj];
                    }
            } else {
                if ([delegate respondsToSelector:@selector(AFNHttpResponseSuccess:tag:)]) {
                    [delegate AFNHttpResponseSuccess:oj tag:tag];
                }
            }
        }];
    } else {
        [CRFUtils getMainQueue:^{
            if ([delegate respondsToSelector:@selector(AFNHttpResponseFaliure:tag:)]) {
                if (![self.messageDict.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)responseInternal.statusCode]]) {
                    DLog(@"request error is %@",error.description);
                    [delegate AFNHttpResponseFaliure:nil tag:tag];
                } else {
                    NSError *crfError = [NSError errorWithDomain:@"" code:responseInternal.statusCode userInfo:@{@"message":[self.messageDict objectForKey:[NSString stringWithFormat:@"%ld",(long)responseInternal.statusCode]]}];
                    [delegate AFNHttpResponseFaliure:crfError tag:tag];
                }
            }
        }];
    }
}

- (NSDictionary *)rsaEncrypt:(NSDictionary *)paragrams url:(NSString *)url {
    return [CRFRSAParamEncrypt rsaEncrypt:paragrams url:url];
}

- (void)handeleNetworkErrorResponse:(NSError *)error successCallback:(void (^)(id response))successHandler failedHandle:(void (^)(NSError *error))failedError{
    [CRFLoadingView dismiss];
    NSHTTPURLResponse *responseInternal = error.userInfo[kErrorCodekey];
    DLog(@" error code is %ld", (long)responseInternal.statusCode);
    if (responseInternal.statusCode == 400) {
        id data = error.userInfo[kErrorDataKey];
        id oj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [CRFUtils getMainQueue:^{
            if ([self tokenException:oj]) {
                if (self.networkException) {
                    self.networkException(oj);
                    return ;
                }
            } else {
                if (successHandler) {
                    successHandler(oj);
                }
            }
        }];
    } else {
        [CRFUtils getMainQueue:^{
                if (![self.messageDict.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)responseInternal.statusCode]]) {
                    DLog(@"request error is %@",error.description);
                    if (failedError) {
                        failedError(nil);
                    }
                } else {
                    NSError *crfError = [NSError errorWithDomain:@"" code:responseInternal.statusCode userInfo:@{@"message":[self.messageDict objectForKey:[NSString stringWithFormat:@"%ld",(long)responseInternal.statusCode]]}];
                    if (failedError) {
                        failedError(crfError);
                }
                }
        }];
    }
}

/**
 <#Description#>
 */
- (void)refreshToken:(void (^)(id response))successHandler failedHandle:(void (^)(NSError *error))failedError {
    [self POST:[NSString stringWithFormat:APIFormat(kRefreshTokenPath),[CRFAppManager defaultManager].userInfo.userId] paragram:@{@"refreshToken":[CRFAppManager defaultManager].userInfo.refreshToken,@"grantType":@"refresh_token",@"timestamp":[CRFTimeUtil getCurrentTimeStamp],@"appId":[NSString getAppId],@"appSecret":@""} headers:@{kAccessTokenKey:[CRFAppManager defaultManager].userInfo.accessToken} successHandler:^ (id response) {
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            [CRFAppManager defaultManager].userInfo.accessToken = response[kDataKey][@"accessToken"];
             [CRFSettingData setCurrentAccountInfo:[CRFAppManager defaultManager].userInfo];
        }
        [CRFUtils getMainQueue:^{
            if (successHandler) {
                successHandler(response);
            }
        }];
    } failedHandler:failedError];
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if(methodSignature == nil) {
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return nil;
    } else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
        NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
        NSInteger requireParamCount = objects.count;
        NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id  obj = objects[i];
            [invocation setArgument:&obj atIndex:i+2];
        }
        [invocation invoke];
        //返回值处理
        id callBackObject = nil;
        if(methodSignature.methodReturnLength) {
            [invocation getReturnValue:&callBackObject];
        }
        return callBackObject;
    }
}

- (BOOL)tokenException:(NSDictionary *)dict {
    if ([dict[@"code"] isEqualToString:@"FUS_2000"] || [dict[@"code"] isEqualToString:@"FUS_2001"] || [dict[@"code"] isEqualToString:@"FUS_2002"] || [dict[@"code"] isEqualToString:@"FUS_2004"] || [dict[@"code"] isEqualToString:@"FUS_2005"] || [dict[@"code"] isEqualToString:@"FUS_2006"] || [dict[@"code"] isEqualToString:@"FUS_2007"] || [dict[@"code"] isEqualToString:@"FUS_2008"] || [dict[@"code"] isEqualToString:@"FUS_2009"] || [dict[@"code"] isEqualToString:@"FUS_2010"] ) {
        return YES;
    }
    return NO;
}

@end
