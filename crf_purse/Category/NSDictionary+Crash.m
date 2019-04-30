//
//  NSDictionary+Crash.m
//  crf_purse
//
//  Created by xu_cheng on 2018/2/7.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "NSDictionary+Crash.h"
#import <objc/runtime.h>

@implementation NSDictionary (Crash)

+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Method oldMethod = class_getInstanceMethod([self class], @selector(objectForKey:));
        Method newMethod = class_getInstanceMethod([self class], @selector(customObjectForKey:));
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

- (id)customObjectForKey:(id)aKey {
    id object = [self customObjectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
}


+ (instancetype)dictionaryWithObjects:(const id[])objects forKeys:(const id[])keys count:(NSUInteger)cnt {
    NSMutableArray *validKeys = [NSMutableArray new];
    NSMutableArray *validObjs = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < cnt; i ++) {
        if (objects[i] && keys[i]) {
            [validKeys addObject:keys[i]];
            [validObjs addObject:objects[i]];
        }
    }
    return [self dictionaryWithObjects:validObjs forKeys:validKeys];
}

+ (instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ... {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    id eachObject;
    va_list argumentList;
    if (firstObject) {
        [objects addObject: firstObject];
        va_start(argumentList, firstObject);
        NSUInteger index = 1;
        while ((eachObject = va_arg(argumentList, id))) {
            (index++ & 0x01) ? [keys addObject: eachObject] : [objects addObject: eachObject];
        }
        va_end(argumentList);
    }
    if (objects.count == keys.count) {
        // 直接写空 跳到最后返回
    } else {
        (objects.count < keys.count)?[keys removeLastObject]:[objects removeLastObject];
    }
    return [self dictionaryWithObjects:objects forKeys:keys];
}

@end
