//
//  CRFNetworkTask.h
//  CRF_AFNetwork
//
//  Created by bill on 2017/11/28.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFNetworkTask : NSObject

@property (nonatomic, copy) NSString *digest;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end
