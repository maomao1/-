//
//  CRFURLCache.h
//  crf_purse
//
//  Created by SHLPC1321 on 2017/7/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Date @"date"
#define CachePolicy @"cachePolicy"
#define MinCacheInterval @"minCacheInterval"
#define MinRefresh  @"minRefresh"
#define ConfigurationPlist @"CrfUrlPlist"

typedef enum _CacheStoragePolicy {
    CacheRoutineCachePolicy = 0,//默认
    CachePermanentlyCacheStoragePolicy = 1,//强制
    CacheNotPolicy=2//无
} CacheStoragePolicy;
@interface CRFURLCache : NSObject{
    NSMutableString *urlPara;
    NSString *_urlPath;
}
- (id)initWithPath:(NSString *)paths  Parameter:(NSDictionary *)paramet;
//磁盘路径
@property (nonatomic, strong) NSString *diskCachePath;
//URLPATH
@property (nonatomic, strong) NSString *urlPath;

@property (nonatomic,strong)NSDictionary *parameter;
//缓存文件名
- (NSString *)cacheKeyForURL;
//存储文件
- (void)saveCacheInfo:(id)response ;
//过期保留时间
@property (nonatomic, assign) NSTimeInterval minCacheInterval;

//刷新时间
@property(nonatomic,assign) NSTimeInterval minRefresh;
//缓存策略
@property (nonatomic, assign)CacheStoragePolicy cachePolicy;
//检测缓存是否存在
- (BOOL)isCached ;
//读取缓存
- (id)GetCached;
//是否刷新数据
- (BOOL)GetCacheValue;
@end
