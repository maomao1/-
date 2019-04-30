//
//  CRFRegisterViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

typedef NS_ENUM(NSUInteger, ControllerType) {
    Register_User        = 0,
    Forget_User          = 1,
};

@interface CRFRegisterViewController : CRFBasicViewController

@property (nonatomic, assign) ControllerType cType;

@property (nonatomic, assign) BOOL popToRoot;

@property (nonatomic, copy) NSString *mobilePhone;


@end
