//
//  CRFFilePath.h
//  crf_purse
//
//  Created by maomao on 2017/8/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *const kBankListFilePath = @"bankListFilePath";

@interface CRFFilePath : NSObject
+(NSString *)getDocumentPath;
+(NSString *)createCachePath:(NSString *)filePath;
+ (NSString *)getFilePath:(NSString *)fileName;
+(BOOL)isFileIsExist:(NSString *)filePath;

+ (NSString *)getBankCardListPath:(NSString *)fileName;

+ (NSString *)createFilePath:(NSString *)filePath;
@end
