//
//  CRFActivity.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//
//公告 通知栏
#import <Foundation/Foundation.h>
static NSString *const notice_key  = @"activeData";   ///<公告栏key

@interface CRFActivity : NSObject<NSCoding>

@property (nonatomic, copy) NSString *content;    ///<公告内容
@property (nonatomic, copy) NSString *title;      ///<公告标题
@property (nonatomic, copy) NSString *notice_id;
@property (nonatomic, copy) NSString *publicTime;    ///<公告详细链接
@property (nonatomic, copy) NSString *contentUrl;


@end
