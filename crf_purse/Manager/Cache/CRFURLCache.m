//
//  CRFURLCache.m
//  crf_purse
//
//  Created by SHLPC1321 on 2017/7/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFURLCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CRFURLCache
@synthesize diskCachePath,urlPath=_urlPath;
static NSDateFormatter* CreateDateFormatter(NSString *format)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}
- (id)init{
    self=[super init];
    if (self) {
        self.diskCachePath=[self defaultCachePath];
        //默认 一周
        self.minCacheInterval=7*24*60*60;
        self.minRefresh=60;
        self.cachePolicy=CacheRoutineCachePolicy;
    }
    return self;
}
- (id)initWithPath:(NSString *)paths  Parameter:(NSDictionary *)paramet{
    self=[self init];
    self.urlPath=paths;
    self.parameter=paramet;
    return self;
}
- (NSString *)cacheKeyForURL
{
    //    NSString *strurl=[url absoluteString];
    NSString  *strurl=[[NSString stringWithFormat:@"%@%@",_urlPath,urlPara] stringByAddingPercentEscapesUsingEncoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    //     NSURL *urls=[NSURL URLWithString:strurl];
    const char *str = [strurl UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (unsigned int)strlen(str), r);
    NSString *strFileName=[NSString stringWithFormat:@"%@_%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",@"Ju", r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return strFileName;
}
- (void)saveCacheInfo:(id)response
{
    if(self.cachePolicy==CacheNotPolicy)return;
    
    [self createDiskCachePath];
    //    存储文件
    BOOL rcache=[response writeToFile:[self.diskCachePath stringByAppendingPathComponent:[self cacheKeyForURL]]atomically:YES];
    if (!rcache) {
        NSLog(@"缓存失败");
        return;
    }
    //
    NSMutableDictionary *dicCacheHead=[self HeadProperty];
    //    文件存储属性
    BOOL rhead=  [dicCacheHead writeToFile:[self.diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ heads",[self cacheKeyForURL]]]atomically:YES];
    if (!rhead) {
        NSLog(@"头文件写入失败");
    }
}
//添加头文件属性
- (NSMutableDictionary *)HeadProperty{
    NSDateFormatter  *dateformatter=CreateDateFormatter(@"EEE, dd MMM yyyy HH:mm:ss z");
    NSString *  locationString=[dateformatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dicCacheHead=[NSMutableDictionary dictionary];
    [dicCacheHead setObject:locationString forKey:Date];
    [dicCacheHead setObject:[NSNumber numberWithInteger:_cachePolicy] forKey:CachePolicy];
    [dicCacheHead setObject:[NSNumber numberWithDouble:_minCacheInterval] forKey:MinCacheInterval];
    [dicCacheHead setObject:[NSNumber numberWithDouble:_minRefresh] forKey:MinRefresh];
    return dicCacheHead;
}
//返回YES不请求网络
- (BOOL)GetCacheValue{
    BOOL isUseCache=[self isCached];
    //    判断是否有缓存
    if (isUseCache) {
        NSDate *date=[NSDate date];
        NSDictionary *dic=[self GetHeads];
        NSTimeInterval timecurret= [date timeIntervalSinceDate:[self dateFromHttpDateString:[NSString stringWithFormat:@"%@",dic[Date]]]];
        //        判断是否强制使用缓存
        if ([dic[CachePolicy] integerValue]==CachePermanentlyCacheStoragePolicy) {
            //            判断是否过期
            if([dic[MinCacheInterval]floatValue]<timecurret){
                isUseCache=NO;
            }
        }
        else{
            //            判断是否该重新刷新
            if ([dic[MinRefresh]floatValue]<timecurret) {
                isUseCache=NO;
            }
        }
    }
    return isUseCache;
    
}
- (NSString *)defaultCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:ConfigurationPlist];
}
- (void)createDiskCachePath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:diskCachePath])
    {
        [fileManager createDirectoryAtPath:diskCachePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    
}
- (BOOL)isCached{
    NSString *filepath=[self.diskCachePath stringByAppendingPathComponent:[self cacheKeyForURL]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filepath];
}
- (id)GetCached{
    NSString *filepath=[self.diskCachePath stringByAppendingPathComponent:[self cacheKeyForURL]];
    return [NSDictionary dictionaryWithContentsOfFile:filepath];
}
- (id)GetHeads{
    NSString *filepath=[self.diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ heads",[self cacheKeyForURL]]];
    return [NSDictionary dictionaryWithContentsOfFile:filepath];
}
- (void)setParameter:(NSDictionary *)parameter{
    urlPara=[NSMutableString string];
    for (NSString *str in [parameter allKeys]) {
        if (![str isEqualToString:@"weblogId"]&&![str isEqualToString:@"terNo"]) {
            [urlPara appendFormat:@"%@=%@&",str,parameter[str]];
        }
    }
}

- (NSDate *)dateFromHttpDateString:(NSString *)httpDate
{
    static NSDateFormatter *RFC1123DateFormatter;
    static NSDateFormatter *ANSICDateFormatter;
    static NSDateFormatter *RFC850DateFormatter;
    NSDate *date = nil;
    @synchronized(self) // NSDateFormatter isn't thread safe
    {
        // RFC 1123 date format - Sun, 06 Nov 1994 08:49:37 GMT
        if (!RFC1123DateFormatter) RFC1123DateFormatter = CreateDateFormatter(@"EEE, dd MMM yyyy HH:mm:ss z");
        date = [RFC1123DateFormatter dateFromString:httpDate];
        if (!date)
        {
            // ANSI C date format - Sun Nov  6 08:49:37 1994
            if (!ANSICDateFormatter) ANSICDateFormatter = CreateDateFormatter(@"EEE MMM d HH:mm:ss yyyy") ;
            date = [ANSICDateFormatter dateFromString:httpDate];
            if (!date)
            {
                // RFC 850 date format - Sunday, 06-Nov-94 08:49:37 GMT
                if (!RFC850DateFormatter) RFC850DateFormatter = CreateDateFormatter(@"EEEE, dd-MMM-yy HH:mm:ss z") ;
                date = [RFC850DateFormatter dateFromString:httpDate];
            }
        }
    }
    
    return date;
}
@end
