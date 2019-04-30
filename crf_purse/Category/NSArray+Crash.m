//
//  NSArray+Crash.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "NSArray+Crash.h"

@implementation NSArray (Crash)

- (id)objectAtIndexCheck:(NSUInteger)index {
    if (index >= [self count]) {
        DLog(@"crash");
        return nil;
    }
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        DLog(@"crash");
        return nil;
    }
    return value;
}

+ (instancetype)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    NSMutableArray *ma = [NSMutableArray new];
    for (NSUInteger i = 0; i < cnt; i ++) {
        if (objects[i]) {
            [ma addObject:objects[i]];
        }
    }
    return [[NSArray alloc] initWithArray:ma];
}

@end
