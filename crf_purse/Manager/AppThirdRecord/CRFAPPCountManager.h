//
//  CRFAPPCountManager.h
//  crf_purse
//
//  Created by maomao on 2017/9/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMAnalytics/MobClick.h>
#import "Aspects.h"
static NSString *CRFLoggingTrackedEvents = @"CRFLoggingTrackedEvents";
static NSString *CRFLoggingEventName     = @"CRFLoggingEventName";
static NSString *CRFLoggingFuncName      = @"CRFLoggingFuncName";
static NSString *CRFLoggingEventID       = @"CRFLoggingEventID";
static NSString *CRFLoggingSelectorName  = @"CRFLoggingSelectorName";
@interface CRFAPPCountManager : NSObject
+(instancetype)sharedManager;

- (void)crf_pageViewEnter:(NSString*)pageTitle;

- (void)crf_pageViewEnd:(NSString *)pageTitle;

+(void)crf_setupWithConfiguration;

+(void)setEventID:(NSString*)eventId EventName:(NSString*)eventName;

+(void)getEventIdForKey:(NSString *)keyName;


+ (void)setFailedEventID:(NSString *)eventID reason:(NSString *)reason productNo:(NSString*)productNo;
+(void)setEventFailed:(NSString*)eventId reason:(NSString *)reason ;
@end
