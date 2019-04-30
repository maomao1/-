//
//  CRFRefreshUserInfoHandler.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFRefreshUserInfoHandler : NSObject

+ (instancetype)defaultHandler;

@property (nonatomic, strong) CRFUserInfo *userInfo;

@property (nonatomic, copy) NSString *investingHtml;
@property (nonatomic, copy) NSString *invitingContent;
@property (nonatomic, copy) NSString *invitingTitle;


- (void)refreshStandardUserInfo:(void (^)(BOOL success, id response))handler;


- (void)clearUserInfo;


- (void)getInvestingDatas:(void (^)(BOOL success, id response))handler;

@end
