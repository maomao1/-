//
//  CRFInvestEvent.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFInvestEvent : NSObject

@property (nonatomic, copy) NSString *eSort;
@property (nonatomic, copy) NSString *eventCode;
@property (nonatomic, copy) NSString *eventContent;
@property (nonatomic, copy) NSString *eventTime;
@property (nonatomic, copy) NSString *status;


//fts

@property (nonatomic, copy) NSString *realStatusInfo;
@property (nonatomic, copy) NSString *topStatusInfo;
@property (nonatomic, copy) NSString *occurredTime;
@property (nonatomic, copy) NSArray *preStatusInfo;




@end
