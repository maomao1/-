//
//  CRFBindDevicesModel.h
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFBindDevicesModel : NSObject

/**
 设备名称
 */
@property (nonatomic, copy) NSString *deviceName;///<

/**
 设备唯一标示号
 */
@property (nonatomic, copy) NSString *deviceNo;///<

/**
 设备型号
 */
@property (nonatomic, copy) NSString *model;///<设备型号

/**
 更新时间
 */
@property (nonatomic ,copy) NSString *updateTime;///<绑定设备更新时间


@end
