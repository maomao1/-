//
//  CRFLocationManager.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFLocationManager : NSObject

+ (instancetype)defaultManager;

/**
 开始定位
 */
- (void)startPositioning;

@end
