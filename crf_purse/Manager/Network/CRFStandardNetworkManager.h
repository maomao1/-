//
//  CRFNetworkManager.h
//  CRF_AFNetwork
//
//  Created by bill on 2017/11/28.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


/**
 接口请求默认是已json方式请求，json方式返回
 */
@interface CRFStandardNetworkManager : NSObject

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@property (nonatomic, assign) ReachabilityAvailable reachabilityAvailable;

+ (_Nonnull instancetype)defaultManager;


/**
 GET请求

 @param url url
 @param completeHandler 成功后的回调
 @param failedHandler 失败的回调
 */
- (void)get:(NSString *_Nonnull)url success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nonnull)failedHandler;


/**
 GET请求

 @param url url
 @param paragrams paragrams参数
 @param completeHandler 成功后的回调
 @param failedHandler 失败的回调
 */
- (void)get:(NSString *_Nonnull)url paragrams:(NSDictionary *_Nullable)paragrams success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nonnull)failedHandler;

/**
 获取图形验证码
 
 @param url url
 @param completeHandler 成功后的回调
 @param failedHandler 失败后的回调
 */
- (void)getWithGraphCode:(NSString *_Nonnull)url success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nullable)failedHandler;
/**
 POST请求
 
 @param url url
 @param paragrams paragrams
 @param completeHandler 成功后的回调
 @param failedHandler 失败的回调
 */
- (void)post:(NSString *_Nonnull)url paragrams:(NSDictionary *_Nullable)paragrams success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nonnull)failedHandler;

/**
 post请求（用户上传头像）
 
 @param url url
 @param data 图片二进制文件
 @param fileName 图片名称
 @param paragrams paragrams
 @param completeHandler 成功后的回调
 @param failedHandler 失败后的回调
 */
- (void)postWithUploadImage:(NSString *_Nonnull)url datas:(NSData *_Nonnull)data fileName:(NSString *_Nonnull)fileName paragram:(id _Nullable)paragrams success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nullable)failedHandler;


/**
 PUT请求

 @param url url
 @param paragrams paragrams
 @param completeHandler 成功后的回调
 @param failedHandler 失败后的回调
 */
- (void)put:(NSString *_Nonnull)url paragrams:(NSDictionary *_Nullable)paragrams success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nullable)failedHandler;

/**
 下载任务

 @param url url
 @param filePath 文件路径
 @param completeHandler 成功后的回调
 @param failedHandler 失败后的回调
 */
- (void)downLoadTask:(NSString *_Nonnull)url filePath:(NSURL * _Nonnull(^_Nullable)(NSURL * _Nullable targetPath, NSURLResponse *_Nonnull response))filePath success:(CRFNetworkCompleteBlock _Nonnull)completeHandler failed:(CRFNetworkFailedBlock _Nullable)failedHandler;


/*
 取消请求
 
 @param url
 */

- (void)cancel:(NSString * _Nonnull)url;


/**
 取消所有网络请求
 */
- (void)cancelAll;

/**
 清空网络请求中的用户信息（用于注销登录或者账号异常、登录成功、token刷新成功）
 */
- (void)destory;


/**
 网络是否可用
 
 @param callback callback
 */
- (void)networkIsVisible:(void(^_Nullable)(BOOL visible))callback;


/**
监听网络状态变化
 
 @param handler callback
 */
- (void)addObserverNetworkStatus:(void(^_Nonnull)(AFNetworkReachabilityStatus status))handler;


@end
