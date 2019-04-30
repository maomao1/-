//
//  UIViewController+Dismiss.m
//  crf_purse
//
//  Created by maomao on 2017/10/25.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "UIViewController+Dismiss.h"
#import <objc/runtime.h>
#import "CRFTabBarViewController.h"

@implementation UIViewController (Dismiss)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(dismissViewControllerAnimated:completion:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(crf_dismissViewControllerAnimated:completion:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    Method originalMethod1 = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzledMethod1 = class_getInstanceMethod(self, @selector(crf_presentViewController:animated:completion:));
    method_exchangeImplementations(originalMethod1, swizzledMethod1);
}

- (void)crf_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    DLog(@"===%@====",NSStringFromClass([self class]));

    [self crf_presentViewController:viewControllerToPresent animated:flag completion:completion];

    
}

- (void)crf_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    DLog(@"==%@==",NSStringFromClass([self class]));
    if ([self isKindOfClass:[CRFTabBarViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.presentedViewController crf_dismissViewControllerAnimated:flag completion:completion];
        });
        return;
    }

    [self crf_dismissViewControllerAnimated:flag completion:completion];

    
    
}


@end
