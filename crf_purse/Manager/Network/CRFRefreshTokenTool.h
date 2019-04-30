//
//  CRFRefreshTokenTool.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFRefreshTokenTool : NSObject


/**
 刷新token

 @param complete 成功后的回调
 @param failed 失败后的回调
 @param target target
 @param originSelector 原方法
 @param params 原方法中的参数
 */
+ (void)refreshToken:(CRFNetworkRefreshTokenCompleteBlock)complete failed:(CRFNetworkFailedBlock)failed target:(id)target originSelector:(SEL)originSelector params:(NSArray *)params;



+ (void)refreshToken:(CRFNetworkCompleteBlock)completeHandler failed:(CRFNetworkFailedBlock)failedHandler;

@end
