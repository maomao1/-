//
//  AppDelegate.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign)BOOL allowRotation;
#warning 懒猫切换成功去掉
@property (nonatomic,assign) NSInteger apiNum;
@end

