//
//  CRFAppCache.m
//  crf_purse
//
//  Created by maomao on 2017/7/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAppCache.h"
#import "CRFFilePath.h"
#import <WebKit/WKWebsiteDataStore.h>

@implementation CRFAppCache
+ (instancetype)shared {
    static CRFAppCache *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CRFAppCache alloc]init];
    });
    return manager;
}

- (NSUInteger)getPathSizeFile:(NSString*)path {
    NSUInteger size=0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        return 0;
    }
    NSArray* array=  [fileManager subpathsAtPath:path];
    for (NSString* fileName in array) {
        size= size + [[fileManager attributesOfItemAtPath:[path stringByAppendingFormat:@"/%@",fileName] error:nil] fileSize];
    }
    return size;
}

- (NSString*)getAppCacheSize {
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
    NSUInteger sizeTotal = intg + [self getPathSizeFile:[NSString stringWithFormat:@"%@/MP4",[CRFFilePath getDocumentPath]]];
    NSString * sizeStr = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:sizeTotal]];
    return sizeStr;
}

- (void)clearAppCache:(dispatch_block_t)complete {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] deleteOldFilesWithCompletionBlock:nil];
    [CRFAppCache removeHomeCache];
    [self clearWebViewCache];
    //移除开机视频文件
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[NSString stringWithFormat:@"%@/MP4",[CRFFilePath getDocumentPath]]];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[CRFFilePath getFilePath:fileName] error:nil];
    }
     complete();
}

- (void)clearWebViewCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            DLog(@"clear webView cache!");
        }];
    } else {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

- (NSString *)fileSizeWithInterge:(NSInteger)size {
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%.2fB",size*1.00];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.2fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.2fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.2fG",aFloat];
    }
}

+ (void)setHomeInfoDic:(NSDictionary *)dic {
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [ud setObject:newEncodedObject forKey:kHome_cache_key];
    [ud synchronize];
}

+ (NSMutableDictionary *)getHomeInfo {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:kHome_cache_key];
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!dic) {
        dic = [NSMutableDictionary new];
    }
    return dic;
    
}

+ (void)setInvestRecordList:(NSMutableArray *)array {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:array];
    [ud setObject:newEncodedObject forKey:kInvest_record_cache];
    [ud synchronize];
}

+ (NSMutableArray *)getToastInfoArray {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [ud objectForKey:kInvest_record_cache];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    if (!array)
        array = [[NSMutableArray alloc]init];
    return array; 
}

+ (NSMutableArray *)getInvestRecord {
    return nil;
}

+ (void)removeHomeCache {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kHome_cache_key];
    [ud synchronize];
}

@end
