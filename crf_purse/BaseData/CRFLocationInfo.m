//
//  CRFLocationInfo.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFLocationInfo.h"

@implementation CRFLocationInfo
- (NSString *)latitude{
    if (!_latitude) {
        return @"";
    }
    return _latitude;
}
- (NSString *)longitude{
    if (!_longitude) {
        return @"";
    }
    return _longitude;
}
- (NSString *)city{
    if (!_city) {
        return @"";
    }
    return _city;
}
@end
