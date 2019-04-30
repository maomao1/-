//
//  CRFAppCache.h
//  crf_purse
//
//  Created by maomao on 2017/7/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef WALLET
static NSString *const  kHome_cache_key   = @"mj_home_cache_info";
static NSString *const  kInvest_record_cache    = @"mj_invest_record_cache";
#else
static NSString *const  kHome_cache_key   = @"home_cache_info";
static NSString *const  kInvest_record_cache    = @"invest_record_cache";
#endif

@interface CRFAppCache : NSObject

+ (instancetype)shared;

- (NSString*)getAppCacheSize;

- (void)clearAppCache:(dispatch_block_t)complete;

/**
 缓存投资页 投资记录 数据

 @param array array
 */
+ (void)setInvestRecordList:(NSMutableArray*)array;

/**
 清除webView cache
 */
- (void)clearWebViewCache;

/**
 缓存首页数据

 @param dic dic description
 */
+ (void)setHomeInfoDic:(NSDictionary *)dic;
+ (NSMutableDictionary*)getHomeInfo;
+ (NSMutableArray*)getInvestRecord;
@end
