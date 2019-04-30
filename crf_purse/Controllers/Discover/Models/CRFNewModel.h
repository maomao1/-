//
//  CRFNewModel.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 新闻model
 */
@interface CRFNewModel : NSObject

/**
 图片加载地址
 */
@property (nonatomic, copy) NSString *iconUrl;

/**
 跳转的url
 */
@property (nonatomic, copy) NSString *jumpUrl;

/**
 新闻时间
 */
@property (nonatomic, copy) NSString *publicTime;

/**
 新闻状态
 */
@property (nonatomic, copy) NSString *status;

/**
 新闻标题
 */
@property (nonatomic, copy) NSString *title;

@end
