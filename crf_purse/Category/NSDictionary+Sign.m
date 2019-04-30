//
//  NSDictionary+CRF.m
//  crf_purse
//
//  Created by Bill on 2017/11/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "NSDictionary+Sign.h"

@implementation NSDictionary (Sign)

- (NSDictionary *)signature {
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, ([obj isKindOfClass:[NSString class]] ? [obj urlencode] : obj)]];
        [param setObject:[self objectForKey:key] forKey:key];
    }];
    
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *dot = kCrfSand; //后台下发
    // array => string
    NSString *plainText = [sortedArray componentsJoinedByString:@"&"];
    NSString *dotplainText = [NSString stringWithFormat:@"%@%@",plainText,dot];
    DLog(@"dotplainText is %@",dotplainText);
    NSString *signature = [dotplainText sha256];
    [param setObject:signature forKey:@"signature"];
    
    return param;
}

@end
