//
//  AppDelegate+Welcome.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate+Welcome.h"
#import "CRFWelcomeViewController.h"
#import "CRFTabBarViewController.h"
#import "AppDelegate+UpdateVersion.h"
@implementation AppDelegate (Welcome)

- (void)welcomeView{
    CRFWelcomeViewController *welcomVC = [CRFWelcomeViewController new];
//    weakSelf(self);
//    welcomVC.callBack = ^{
//        [weakSelf versionUpgrade];
//    };
    [UIApplication sharedApplication].delegate.window.rootViewController = welcomVC;
}
@end
