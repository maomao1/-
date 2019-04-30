//
//  UIButton+CRFRepeatClick.m
//  crf_purse
//
//  Created by maomao on 2017/9/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "UIButton+CRFRepeatClick.h"
#import <objc/runtime.h>

static const char *UIButton_acceptEventInterval = "UIButton_acceptEventInterval";
static const char *UIButton_acceptEventTime = "UIButton_acceptEventTime";
@implementation UIButton (CRFRepeatClick)
- (NSTimeInterval )crf_acceptEventInterval {
    return [objc_getAssociatedObject(self, UIButton_acceptEventInterval) doubleValue];
}

- (void)setCrf_acceptEventInterval:(NSTimeInterval)crf_acceptEventInterval {
    objc_setAssociatedObject(self, UIButton_acceptEventInterval, @(crf_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )crf_acceptEventTime {
    return [objc_getAssociatedObject(self, UIButton_acceptEventTime) doubleValue];
}

- (void)setCrf_acceptEventTime:(NSTimeInterval)crf_acceptEventTime {
    objc_setAssociatedObject(self, UIButton_acceptEventTime, @(crf_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取这两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    Method myMethod = class_getInstanceMethod(self, @selector(crf_sendAction:to:forEvent:));
    SEL mySEL = @selector(crf_sendAction:to:forEvent:);
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    //如果方法已经存在
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    } else {
        method_exchangeImplementations(systemMethod, myMethod);
    }
    /*-----以上主要是实现两个方法的互换,load是gcd的只shareinstance，保证执行一次-------*/
}

- (void)crf_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (NSDate.date.timeIntervalSince1970 - self.crf_acceptEventTime < self.crf_acceptEventInterval) {
        return;
    }
    if (self.crf_acceptEventInterval > 0) {
        self.crf_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    [self crf_sendAction:action to:target forEvent:event];
}
    
@end
