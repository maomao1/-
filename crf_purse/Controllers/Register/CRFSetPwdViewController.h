//
//  CRFSetPwdViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

typedef NS_ENUM(NSUInteger, PasswordType) {
    NewPassword         = 0,
    ForgetPassword      = 1,
    ModifyPassword      = 2,
};

@interface CRFSetPwdViewController : CRFBasicViewController

@property (nonatomic, assign) PasswordType type;

@property (nonatomic, copy) NSString *verifyId, *mobilePhone;

@end
