//
//  CRFTimeUtil.m
//  CashLoan
//
//  Created by crf on 15/11/13.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import "CRFTimeUtil.h"

@implementation CRFTimeUtil
//获取当前日期
+ (NSString *)getCurrentDate:(int)tag{
    NSString  *date = [[NSString alloc]init];
    NSDate *  timeDate=[NSDate date];
    NSCalendar  * cal=[NSCalendar currentCalendar];
    NSUInteger  unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:timeDate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    switch (tag) {
        case 0:
            date= [NSString stringWithFormat:@"%4d-%02d-%02d",(int)year,(int)month,(int)day];
            break;
        case 1:
            date= [NSString stringWithFormat:@"%4d年%02d月%02d日",(int)year,(int)month,(int)day];
            break;
        case 2:
            date= [NSString stringWithFormat:@"%4d-%2d",(int)year,(int)month];
            break;
        case 3:
            date= [NSString stringWithFormat:@"%4d",(int)year];
            break;
        case 4:
            date= [NSString stringWithFormat:@"%4d%02d%02d",(int)year,(int)month,(int)day];
            break;
        case 5:
            date= [NSString stringWithFormat:@"%4d%02d",(int)year,(int)month];
            break;
            
        default:
            break;
    }
    return date;
    
}
//获取当前时间
+ (NSString *)getCurrentTime:(int)tag{
    NSString  *time = nil;
    NSDate *  timeDate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    switch (tag) {
        case 0:
            [dateformatter setDateFormat:@"HH:mm:ss"];
            break;
        case 1:
            [dateformatter setDateFormat:@"HH:mm"];
            break;
        case 2:
            [dateformatter setDateFormat:@"HH:mm"];
            break;
        case 3:
            [dateformatter setDateFormat:@"HH_mm_ss"];
            break;
        case 4:
            [dateformatter setDateFormat:@"HHmmss"];
            break;
        default:
            break;
    }
    
    
    time = [dateformatter stringFromDate:timeDate];
    
    return time;
    
}
//获取当前日期时间
+ (NSString *)getCurrentDateTime:(int)tag{
    NSString  *dateTime = [[NSString alloc]init];
    
    NSDate *  timeDate=[NSDate date];
    NSCalendar  * cal=[NSCalendar currentCalendar];
    NSUInteger  unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:timeDate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    switch (tag) {
        case 0:
            dateTime= [NSString stringWithFormat:@"%4d年%2d月%2d日",(int)year,(int)month,(int)day];
            break;
        
        default:
            break;
    }
    
    
    return dateTime;
}

/**
 *
 *根据时间字符串判断周几
 **/
+ (NSString *)timeConvertToWeek:(NSString *)timeString{
    
    NSDate *inputDate = [self stringConvertToDate:timeString];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];

}

//+(NSDate*) convertDateFromString:(NSString*)uiDate
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyy年MM月dd日"];
//    NSDate *date=[formatter dateFromString:uiDate];
//    return date;
//}



//NSString日期 转换为NSDate
+ (NSDate *)stringConvertToDate:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}


//NSDate日期 转换NSString
+ (NSString *)dateConvertToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}


+ (long long)getTimeIntervalWithFormatDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970] * 1000;
}

+ (NSDate *)getDateWithFormatDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)NSDateToNSString:(NSDate *)date withDateFormat:(NSString *)dateFormat isUTC:(BOOL)isUTC
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (isUTC)
    {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString= [dateFormatter stringFromDate:date];
    
    return dateString;
}

/*
 *
 *获取网络服务器时间
 *
 */

+ (instancetype)getInstance {
    static CRFTimeUtil *util = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util = [[self alloc] init];
    });
    return util;
}
- (NSDate *)getInternetDate:(NSString *)url{
    
    NSString *urlString = url;
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
     
                          returningResponse:&response error:nil];
    
//    NSLog(@"response is %@",response);
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5];
    
    date = [date substringToIndex:[date length]-4];
    
    
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    
    
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    return netDate;
}

- (NSString *)dateToString:(NSDate *)date tag:(int)tag
{
    NSString *formatStyle = @"yyyy-MM-dd";
    switch (tag) {
        case 0:
            formatStyle = @"yyyy-MM-dd";
            break;
        case 1:
            formatStyle = @"yyyy-MM-dd HH:mm:ss";
            break;
        case 2:
            formatStyle = @"yyyy";
            break;
        case 3:
            formatStyle = @"yyyy-MM";
            break;
        case 4:
            formatStyle = @"yyyy-MM-dd HH:mm";
            break;
        case 5:
            formatStyle = @"HH:mm:ss";
            break;
        case 6:
            formatStyle = @"HH:mm";
            break;
            
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStyle];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+(NSString *)getCurrentTimeStamp{
    NSDate *senddate = [NSDate date];
    return [NSString stringWithFormat:@"%ld",(long)[senddate timeIntervalSince1970]*1000];
}
+(long long)getCurrentTimeInteveral{
    NSDate *senddate = [NSDate date];
    return (long long)[senddate timeIntervalSince1970] * 1000;
}

// 计算时间（publishTime换为现在）
+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp
{
    double publishLong = [timestamp doubleValue]/ 1000.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];//设置时区,这个对于时间的处理有时很重要
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong];
    NSString *publishString = [formatter stringFromDate:publishDate];
    
    return publishString;
}
//时间转换
- (instancetype)initWithTimeIntervalSince1970:(NSTimeInterval)seconds{
    //设置时间显示格式:
//    NSString* timeStr = @"2011-01-26 17:40:50";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];

//    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

//    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    //时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    //时间戳转时间的方法:
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyyMMddHHMMss"];
//    NSDate *date = [formatter dateFromString:@"1283376197"];
//    NSLog(@"date1:%@",date);
    
    return nil;//return你想要的
}


+ (NSString *)formatLongTime:(long long)time pattern:(NSString *)pattern {
    if (time == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    //  date = [date initWithTimeIntervalSince1970:(time / 1000)];
    return [self formatDate:date pattern:pattern];
}

+ (NSString *)formatDate:(NSDate *)date pattern:(NSString *)pattern {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:pattern];
    return [format stringFromDate:date];
}

+ (long long)formatDateString:(NSString *)dateString pattern:(NSString *)pattern {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:pattern];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970] * 1000;
}

+ (NSInteger)getDays:(long long)dayTimeStamp {
    return dayTimeStamp / ([self getTimeIntervalWithDay:1] / 1000);
}

+ (long long)getTimeIntervalWithDay:(NSInteger)day {
    return 60 * 60 * 24 * day * 1000;
}

@end
