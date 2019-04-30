//
//  CRFFilePath.m
//  crf_purse
//
//  Created by maomao on 2017/8/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFFilePath.h"
#define MP4  @"MP4"
@implementation CRFFilePath
+(NSString *)createCachePath:(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/MP4",path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return path;
}

+ (NSString *)createFilePath:(NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/%@",path,filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return path;
}

+(NSString  *)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}
+ (NSString *)getFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileNamePath =  [NSString stringWithFormat:@"%@/MP4/%@",path,fileName];
    
    return fileNamePath;
}
+(BOOL)isFileIsExist:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)getBankCardListPath:(NSString *)fileName {
    return [NSString stringWithFormat:@"%@/%@",[self getDocumentPath],fileName];
}
@end
