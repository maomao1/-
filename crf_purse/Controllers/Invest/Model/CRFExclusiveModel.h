//
//  CRFExclusiveModel.h
//  crf_purse
//
//  Created by maomao on 2018/4/18.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFExclusiveModel : NSObject
@property (nonatomic, copy) NSString *content;    ///
@property (nonatomic, copy) NSString *lowestAmount; ///<
@property (nonatomic, copy) NSString *investUnit;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *xt_rate;
@property (nonatomic, copy) NSString *content_open;
@property (nonatomic, copy) NSString *content_close;

@end
