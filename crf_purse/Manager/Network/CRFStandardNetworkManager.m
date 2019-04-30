//
//  CRFNetworkManager.m
//  CRF_AFNetwork
//
//  Created by bill on 2017/11/28.
//  Copyright © 2017年 bill. All rights reserved.
//


#import "CRFStandardNetworkManager.h"
#import "CRFNetworkTask.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CRFParserNetworkResponse.h"
#import "CRFRSAParamEncrypt.h"


@interface CRFStandardNetworkManager ()

/**
 <#Description#>
 */
@property (nonatomic, strong) NSMutableArray *tasks;

/**
 <#Description#>
 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/**
 网络header透传信息
 */
@property (nonatomic, strong) NSDictionary *headerDict;

@end


@implementation CRFStandardNetworkManager

- (NSTimeInterval)timeInterval {
    if (_timeInterval <= 0) {
        _timeInterval = 30;
    }
    return _timeInterval;
}

- (NSDictionary *)headerDict {
    if (!_headerDict) {
        CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
        CRFClientInfo *clientInfo = [CRFAppManager defaultManager].clientInfo;
        _headerDict = @{@"version-code":clientInfo.versionCode,@"packageName":[NSString getAppId],@"mobileOs":clientInfo.os,@"deviceno":[CRFUserDefaultManager getDeviceUUID],@"clientId":clientInfo.clientId,@"mchntNo":kMchntNo,kAccessTokenKey:userInfo.accessToken};
    }
    return _headerDict;
}

+ (instancetype)defaultManager {
    static CRFStandardNetworkManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
         [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        _manager = [AFHTTPSessionManager manager];
         AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy = securityPolicy;
    }
    return self;
}

- (void)setNetworkManagerConfig {
    [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.manager.requestSerializer.timeoutInterval = self.timeInterval;
    [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.manager.requestSerializer.HTTPShouldUsePipelining = YES;
    DLog(@"request timeout is %ld",(NSInteger)self.manager.requestSerializer.timeoutInterval);
    self.manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    for (NSString *key in self.headerDict.allKeys) {
        [self.manager.requestSerializer setValue:self.headerDict[key] forHTTPHeaderField:key];
    }
}

#pragma mark ------------get---------
- (void)get:(NSString *)url success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    [self get:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] paragrams:nil success:completeHandler failed:failedHandler];
}

- (void)get:(NSString *)url paragrams:(NSDictionary *)paragrams success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [self setNetworkManagerConfig];
    DLog(@"methed is get,url is %@",url);
    DLog(@"paragrams is %@",paragrams);
    NSURLSessionDataTask *task = [self.manager GET:url parameters:paragrams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeTask:task];
        if (completeHandler) {
            completeHandler(CRFNetworkCompleteTypeSuccess,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeTask:task];
        [CRFParserNetworkResponse parserResponseError:error target:self originSelecter:@selector(get:success:failed:) paragram:@[url,completeHandler,failedHandler] failed:failedHandler];
    }];
    [self addTask:task url:url];
}

- (void)getWithGraphCode:(NSString *)url success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self setNetworkManagerConfig];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg", nil];
    [self.manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     DLog(@"methed is get,url is %@",url);
    NSURLSessionDataTask *task = [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeTask:task];
        if (completeHandler) {
            completeHandler(CRFNetworkCompleteTypeSuccess,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeTask:task];
        [CRFParserNetworkResponse parserResponseError:error target:self originSelecter:@selector(getWithGraphCode:success:failed:) paragram:@[url,completeHandler,failedHandler] failed:failedHandler];
    }];
    [self addTask:task url:url];
}

#pragma mark   ---------post--------
- (void)post:(NSString *)url paragrams:(NSDictionary *)paragrams success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [self setNetworkManagerConfig];
      DLog(@"methed is post,url is %@",url);
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptParagrams = [CRFRSAParamEncrypt rsaEncrypt:paragrams url:url];
    DLog(@"rsaEncryptParagrams is %@",rsaEncryptParagrams);
    NSURLSessionDataTask *task = [self.manager POST:url parameters:rsaEncryptParagrams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self removeTask:task];
        if (completeHandler) {
            completeHandler(CRFNetworkCompleteTypeSuccess,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self removeTask:task];
        [CRFParserNetworkResponse parserResponseError:error target:self originSelecter:@selector(post:paragrams:success:failed:) paragram:@[url,paragrams,completeHandler,failedHandler] failed:failedHandler];
    }];
    [self addTask:task url:url];
}

- (void)postWithUploadImage:(NSString *)url datas:(NSData *)data fileName:(NSString *)fileName paragram:(id)paragrams success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    self.manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [self setNetworkManagerConfig];
      DLog(@"methed is post,url is %@",url);
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptParagrams = [CRFRSAParamEncrypt rsaEncrypt:paragrams url:url];
    DLog(@"rsaEncryptParagrams is %@",rsaEncryptParagrams);
    NSURLSessionDataTask *task = [self.manager POST:url parameters:rsaEncryptParagrams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data
                                    name:@"image"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self removeTask:task];
        if (completeHandler) {
            completeHandler(CRFNetworkCompleteTypeSuccess,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     [self removeTask:task];
        [CRFParserNetworkResponse parserResponseError:error target:self originSelecter:@selector(postWithUploadImage:datas:fileName:paragram:success:failed:) paragram:@[url,data,fileName,paragrams,completeHandler,failedHandler] failed:failedHandler];
    }];
    [self addTask:task url:url];
}

#pragma mark --------put------
- (void)put:(NSString *)url paragrams:(NSDictionary *)paragrams success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [self setNetworkManagerConfig];
      DLog(@"methed is put,url is %@",url);
    if (!paragrams) {
        paragrams = @{};
    }
    NSDictionary *rsaEncryptParagrams = [CRFRSAParamEncrypt rsaEncrypt:paragrams url:url];
    DLog(@"rsaEncryptParagrams is %@",rsaEncryptParagrams);
    NSURLSessionDataTask *task = [self.manager PUT:url parameters:rsaEncryptParagrams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeTask:task];
        if (completeHandler) {
            completeHandler(CRFNetworkCompleteTypeSuccess,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeTask:task];
        [CRFParserNetworkResponse parserResponseError:error target:self originSelecter:@selector(put:paragrams:success:failed:) paragram:@[url,paragrams,completeHandler,failedHandler] failed:failedHandler];
    }];
    [self addTask:task url:url];
}

#pragma mark  -------下载---------
- (void)downLoadTask:(NSString *)url filePath:(NSURL * _Nonnull (^)(NSURL * _Nullable, NSURLResponse * _Nonnull))filePath success:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return filePath(targetPath, response);
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
                failedHandler(CRFNetworkCompleteTypeFailure,error);
        } else {
            completeHandler(CRFNetworkCompleteTypeSuccess,filePath);
        }
    }];
    [task resume];
}

#pragma mark -------cancel network request------
- (void)cancel:(NSString *)url {
    CRFNetworkTask *networkTask = [self findTaskByURL:url];
    if (!networkTask) {
        DLog(@"cancel: can not find task with url: (%@)", url);
        return;
    }
    [networkTask.task cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tasks removeObject:networkTask];
    });
}

- (void)cancelAll {
    [self.manager.operationQueue cancelAllOperations];
}

#pragma mark - task manager
- (void)addTask:(NSURLSessionDataTask *)task url:(NSString *)url {
    NSString *digest = [url md5];
    CRFNetworkTask *networkTask = [[CRFNetworkTask alloc] init];
    networkTask.digest = digest;
    networkTask.task = task;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tasks addObject:networkTask];
    });
}

- (void)removeTask:(NSURLSessionDataTask *)task {
    CRFNetworkTask *taskToRemove = nil;
    for (CRFNetworkTask *networkTask in self.tasks) {
        if (networkTask.task.taskIdentifier == task.taskIdentifier) {
            taskToRemove = networkTask;
        }
    }
    if (!taskToRemove) {
        DLog(@"removeTask: nothing to remove");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tasks removeObject:taskToRemove];
    });
}

- (CRFNetworkTask *)findTaskByURL:(NSString *)url {
    NSString *digest = [url md5];
    for (CRFNetworkTask *networkTask in self.tasks) {
        if ([networkTask.digest isEqualToString:digest]) {
            return networkTask;
        }
    }
    return nil;
}


#pragma mark - getters
- (NSMutableArray *)tasks {
    if (!_tasks) {
        _tasks = [[NSMutableArray alloc] init];
    }
    return _tasks;
}

#pragma mark ------clear cache------
- (void)destory {
    self.headerDict = nil;
}

#pragma mark ------AFNetworkReachabilityManager--------
- (void)networkIsVisible:(void (^)(BOOL))callback {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        callback(NO);
    }
    self.networkStatus = manager.networkReachabilityStatus;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                
                [CRFUtils getMainQueue:^{
                    callback(NO);
                }];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                [CRFUtils getMainQueue:^{
                    callback(YES);
                }];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
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

- (void)addObserverNetworkStatus:(void (^)(AFNetworkReachabilityStatus))handler {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        handler(status);
    }];
}

@end
