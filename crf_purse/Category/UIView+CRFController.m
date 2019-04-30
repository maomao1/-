//
//  UIView+CRFController.m
//  crf_purse
//
//  Created by mystarains on 2019/1/10.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "UIView+CRFController.h"

@implementation UIView (CRFController)

- (UIViewController *)viewController {
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

- (UINavigationController *)navigationController {
    return self.viewController.navigationController;
}

//获取导航控制器
//- (UINavigationController *)navigationController{
//    UIResponder * next = [self nextResponder];
//    while (next!=nil) {
//        if([next isKindOfClass:[UINavigationController class]]){
//            return (UINavigationController * )next;
//        }
//        next = [next nextResponder];
//    }
//    return nil;
//}

//获取标签控制器
- (UITabBarController *)tabBarController{
    UIResponder * next = [self nextResponder];
    while (next!=nil) {
        if([next isKindOfClass:[UITabBarController class]]){
            return (UITabBarController * )next;
        }
        next = [next nextResponder];
    }
    return nil;
}

//获取主窗口
- (UIWindow *)rootWindow{
    UIResponder * next = [self nextResponder];
    while (next!=nil) {
        if([next isKindOfClass:[UIWindow class]]){
            return (UIWindow * )next;
        }
        next = [next nextResponder];
    }
    return nil;
}

//获取Window当前显示的ViewController
- (UIViewController *)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}


@end
