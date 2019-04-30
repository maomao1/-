//
//  CRFInvestEvent.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestEvent.h"

@implementation CRFInvestEvent

- (NSString *)eventTime {
    return self.occurredTime;
}

- (NSString *)eventContent {
    return self.realStatusInfo;
}

@end
