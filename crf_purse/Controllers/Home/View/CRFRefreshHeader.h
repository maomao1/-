//
//  CRFRefreshHeader.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRFAccountInfo.h"

typedef void(^CRFRefreshBlock)(void);

/**
 刷新类型

 - UserLogin: 已登陆
 - Unlogin: 未登录
 */
typedef NS_ENUM(NSUInteger, RefreshType) {
    UserLogin       = 0,
    Unlogin         = 1,
};

@interface CRFRefreshHeader : UIView

/**
 bind scrollView
 */
@property (nonatomic, strong) UIScrollView *bindingScrollView;

/**
 init

 @param bindingScrollView bindingScrollView
 @return object
 */
- (instancetype)initWithBindingScrollView:(UIScrollView *)bindingScrollView;


/**
 刷新回调
 */
@property (nonatomic, copy) CRFRefreshBlock refreshBlock;

/**
 刷新类型
 */
@property (nonatomic, assign) RefreshType refreshType;

/**
 用户信息
 */
@property (nonatomic, strong) CRFAccountInfo *accountInfo;

/**
 添加监听

 @param change change
 */
- (void)observerScrollView:(NSDictionary *)change;

@end
