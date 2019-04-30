//
//  CRFRSAParamEncrypt.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFRSAParamEncrypt : NSObject

+ (NSDictionary *)rsaEncrypt:(NSDictionary *)paragrams url:(NSString *)url;

@end
