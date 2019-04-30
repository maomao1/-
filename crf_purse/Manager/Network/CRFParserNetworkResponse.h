//
//  CRFParserNetworkResponse.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CRFDataModel;
@interface CRFDataModel:NSObject
@property (nonatomic , copy) NSString * code;
@property (nonatomic , copy) NSString * message;

@end
@interface CRFParserNetworkResponse : NSObject

/**
 解析网络请求的错误

 @param error error
 @param originSelector 原方法
 @param paragrams 原方法中的参数
 @param failedHandler 失败的回调
 */
+ (void)parserResponseError:(NSError *)error target:(id)target originSelecter:(SEL)originSelector paragram:(NSArray *)paragrams failed:(CRFNetworkFailedBlock)failedHandler;

/**
 解析刷新token失败的弹窗

 @param error error
 @param failedHandler failedHandler
 */
+ (void)parserRefreshTokenResponseError:(NSError *)error failed:(CRFNetworkFailedBlock)failedHandler;





@end
