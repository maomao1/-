//
//  CRFClientInfo.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/6.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFClientInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *clientId;///<push id
@property (nonatomic, copy) NSString *versionName;///<
@property (nonatomic, copy) NSString *versionCode;///<build number
@property (nonatomic, copy) NSString *versionNum; ///<version Number
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *os;//Android\IOS
@property (nonatomic, copy) NSString *osVersion;
@property (nonatomic, copy) NSString *idfa;
@property (nonatomic, copy) NSString *deviceToken;

@end
