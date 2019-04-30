//
//  CRFCheckoutLoginVC.h
//  crf_purse
//
//  Created by SHLPC1321 on 2017/7/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

typedef NS_ENUM(NSUInteger, PopType) {
    PopDefault              =   0,
    PopHome                 =   1,
    PopFrom                 =   2,
};


@interface CRFCheckLoginViewController : CRFBasicViewController
@property (nonatomic, copy) NSString  * userAccount;///<用户手机号（账户）
@property (nonatomic, copy) NSString  * passwd;    ///<登录密码

@property (nonatomic, assign) PopType popType;
@end
