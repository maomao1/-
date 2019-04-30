//
//  CRFJPushModel.h
//  crf_purse
//
//  Created by maomao on 2017/9/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFJPushModel : NSObject
@property (nonatomic ,copy) NSString *intent;//通知类型：0.打开应用 1.打开 H5 2.打开消息详情 3.打开公告详情 FAPP_1600:<不同设备登录或者异地登录
@property (nonatomic ,copy) NSString *pageUrl;// 通知类型是打开h5，则为 h5链接
@property (nonatomic ,copy) NSString *batchNo;//消息批次号，用来查询消息详情

@end

@interface CRFJPushMessageModel : NSObject
@property (nonatomic ,copy) NSString *alert;
@property (nonatomic ,copy) NSString *badge;
@end
