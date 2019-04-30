//
//  CRFTimeUtil.h
//  CashLoan
//
//  Created by crf on 15/11/13.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFTimeUtil : NSObject

+ (NSString *)timeConvertToWeek:(NSString *)timeString;
//NSString日期 转换为NSDate
+ (NSDate *)stringConvertToDate:(NSString *)dateString;
//NSDate日期 转换NSString
+ (NSString *)dateConvertToString:(NSDate *)date;

//+(NSString *)NSDateToNSString:(NSDate *)date;

+ (NSString *)NSDateToNSString:(NSDate *)date withDateFormat:(NSString *)dateFormat isUTC:(BOOL)isUTC;
+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp;

+ (instancetype)getInstance;
- (NSDate *)getInternetDate:(NSString *)url;
- (NSString *)dateToString:(NSDate *)date tag:(int)tag;

//获取当前日期
+ (NSString *)getCurrentDate:(int)tag;
+ (NSString *)getCurrentTime:(int)tag;
+ (NSString *)getCurrentDateTime:(int)tag;
+ (NSString *)getCurrentTimeStamp;
+ (long long)getCurrentTimeInteveral;


+ (NSString *)formatLongTime:(long long)time pattern:(NSString *)pattern;

+ (long long)getTimeIntervalWithFormatDate:(NSString *)dateString;


+ (long long)getTimeIntervalWithDay:(NSInteger)day;

+ (NSDate *)getDateWithFormatDate:(NSString *)dateString;

+ (long long)formatDateString:(NSString *)dateString pattern:(NSString *)pattern;

+ (NSInteger)getDays:(long long)dayTimeStamp;

+ (NSString *)getCurrentDate;



@end
