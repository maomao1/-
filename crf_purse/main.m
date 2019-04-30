
//  main.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRF99ClickManager.h"
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [CRF99ClickManager initSDK];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
