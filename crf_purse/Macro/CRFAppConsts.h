//
//  CRFAppConsts.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#ifndef CRFAppConsts_h
#define CRFAppConsts_h

#import <Foundation/Foundation.h>

#define kUuid [CRFAppManager defaultManager].userInfo.userId

#define kUserInfo [CRFAppManager defaultManager].userInfo

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define kStatusBarHeight [CRFUtils getStatusBarMargen]

#define kTabBarBottomMargen [CRFUtils getTabBarBottomMargen]

#define kNavigationbarHeight 44

#define kNavHeight (kStatusBarHeight + kNavigationbarHeight)

#define kTextDefaultColor UIColorFromRGBValue(0x333333)

#define kCellTitleTextColor UIColorFromRGBValue(0x666666)

#define kCellDetailTextColor UIColorFromRGBValue(0x888888)

/*999999*/
#define kTextEnableColor UIColorFromRGBValue(0x999999)
#define kTextWhiteColor UIColorFromRGBValue(0xFFFFFF)

/*FB4D3A*/
#define kTextWhiteHighLightColor UIColorFromRGBValueAndalpha(0xFFFFFF,0.1)

#define kTextRedHighLightColor UIColorFromRGBValue(0xE14534)

#define kTextRedDisableColor UIColorFromRGBValue(0xFD9D98)

#define kTextWhiteDisableColor UIColorFromRGBValue(0xEEEEEE)

//
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size): NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size): NO)
//

#define kTabBarHeight ([CRFUtils isIPhoneXAll] ? 83.0f : 49.0f)
#define kWidthRatio (kScreenWidth / 375)
#define kHeightRatio (kScreenHeight / 667)

#define weakSelf(Object) __weak __typeof(Object) weakSelf = Object;
#define strongSelf(Object) __strong __typeof(Object) strongSelf = Object;
#define blockSelf(Object) __block __typeof(Object) blockSelf = Object;

#define UIColorFromRGBValue(rgbValue)                                               \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0         \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0            \
blue:((float)(rgbValue & 0xFF)) / 255.0                     \
alpha:1.0]

#define UIColorFromRGBValueAndalpha(rgbValue,a)                                               \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0         \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0            \
blue:((float)(rgbValue & 0xFF)) / 255.0                     \
alpha:a]

#define UIColorFromRGB(R, G, B)                                               \
[UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.0]
#define NSRangeZero NSMakeRange(0, 0)

#define kCellLineSeparatorColor UIColorFromRGBValueAndalpha(0x000000, 0.1f)

#define kRegisterButtonBackgroundColor [CRFAppManager defaultManager].majiabaoFlag?UIColorFromRGBValue(0x8F87DB):UIColorFromRGBValue(0xFB4D3A)

#define kVerifyCodeBorderColor ([CRFUtils normalUser]?UIColorFromRGBValue(0xFBB203):UIColorFromRGBValue(0x8F87DB))

#define kButtonNormalBackgroundColor (![CRFUtils normalUser]?UIColorFromRGBValue(0x8F87DB):UIColorFromRGBValue(0xFB4D3A))

#define kButtonBorderNormalBackgroundColor ![CRFUtils normalUser]?UIColorFromRGBValue(0x8F87DB):UIColorFromRGBValue(0xF5A623)
//0xFC8A7E
#define kLinkTextColor ![CRFUtils normalUser]?UIColorFromRGBValue(0x6D66AF):UIColorFromRGBValue(0xFB4D3A)

#define kBackgroundColor UIColorFromRGBValue(0xf6f6f6)

#define kGraglientBeginColor UIColorFromRGBValue(0xFF7945)

#define kGraglientEndColor UIColorFromRGBValue(0xFB4D3A)

#define kTabBarSelectedColor UIColorFromRGBValue(0xEE5250)
#define kBtnAbleBgColor    UIColorFromRGBValue(0xFB4D3A)///<按钮可点击的背景色
#define kBtnEnableBgColor  UIColorFromRGBValue(0xcccccc)///<按钮不可点击的背景色

#define kProductMonthColor  UIColorFromRGBValue(0xF6AA26)///<月盈产品标签颜色
#define kProductContinuColor  UIColorFromRGBValue(0xF55354)///<连盈产品标签颜色
#define kGestureInfoBackgroundColor UIColorFromRGBValue(0xDDDDDD)
static CGFloat const kCellHeight = 44;
static CGFloat const kTopSpace = 16;
static CGFloat const kSpace = 15;
static CGFloat const kButtonHeight = 42;
static CGFloat const kRegisterSpace = 20;
static CGFloat const kToastDuringTime = 1.5f;
static CGFloat const kRegisterButtonHeight = 46;



#define CRFFONT(a,b) [UIFont fontWithName:a size:b]
static NSString *const  PingFangTc  = @"PingFang TC";
static NSString *const  AkrobatZT     = @"Akrobat";

//log重定义
#ifdef DEBUG
#define NSLog(fmt,...) NSLog((fmt),##__VA_ARGS__);
#else
#define NSLog(...) {}
#endif

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif


#endif /* CRFAppConsts_h */

