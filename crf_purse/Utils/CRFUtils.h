//
//  CRFUtils.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFCouponModel.h"
#import "CRFMyInvestProduct.h"

@interface CRFUtils : NSObject


+ (UIFont *)fontWithSize:(CGFloat)size;
/**
 是否是马甲包

 @return value
 */
+ (BOOL)isMaJiaBao;

+ (BOOL)normalUser;

+ (CGFloat)getTabBarBottomMargen;

+ (CGFloat)getStatusBarMargen;

+ (BOOL)applying;

/**
 get main queue

 @param callback callback
 */
+ (void)getMainQueue:(void (^)(void))callback;

/**
 get camera auth status

 @return status
 */
+ (BOOL)allowCamera;

/**
 获取设备uuid

 @return uuid
 */
+(NSString *)getDeviceUUId;
/**
 get photos auth status

 @return status
 */
+ (BOOL)allowPhotos;

/**
 获取可用的controller

 @return controller
 */
+ (UIViewController *)getVisibleViewController;

/**
 get width with title

 @param title title
 @param font font
 @param height height
 @return width
 */
//+ (CGFloat)widthWithTitle:(NSString *)title font:(UIFont *)font height:(CGFloat)height;

/**
 get size with text

 @param size size
 @param text text
 @param fondNumber fond number
 @return size
 */
//+ (CGSize)boundingRectWithSize:(CGSize)size text:(NSString *)text fontNumber:(CGFloat)fondNumber;

//+ (CGSize)boundingRectWithSize:(CGSize)size text:(NSString *)text fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace;

/**
 toast 显示

 @param message 显示内容
 */
+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString*)message drution:(CGFloat)time;
/**
 delay callback

 @param second second
 @param handle handle
 */
+ (void)delayAfert:(int)second handle:(void(^)(void))handle;

/**
 根据cardID 获取银行名称

 @param idCard cardID
 @return bank name
 */
+ (NSString *)getBankName:(NSString*)idCard;

/**
 等比缩放图片

 @param croppedImage image
 @return size
 */
+ (CGSize)croppedImage:(UIImage *)croppedImage;

/**
 裁剪图片

 @param image image
 @param size size
 @return image
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

+ (NSArray <CRFMyInvestProduct *>*)sortDatas:(NSArray <CRFMyInvestProduct *>*)datas type:(NSInteger)type;

+ (NSArray <CRFMyInvestProduct *>*)sortDatas:(NSArray <CRFMyInvestProduct *>*)datas;

+ (NSInteger)isReturnFileVideo:(NSString*)string;

+ (BOOL)isIPhoneXAll;
+ (BOOL)validateCurrentMobileSystem10_2;

/**
 筛选出最优计划

 @param couponArray 筛选对象
 @param amount 符合条件
 @param days XXXXX
 @param type 连盈、月盈
 @return 筛选结果
 */
+ (CRFCouponModel *)selectedBestWithArray:(NSArray*)couponArray ForMoney:(NSString*)amount AndFreezid:(NSInteger)freezid days:(NSInteger)days type:(BOOL)type ;

/**
 返回出资收益

 @param amount 出资金额
 @param yInterestRate 利率
 @param day 出借天数
 @param NCP 合规
 @param type 产品类型
 @return <#return value description#>
 */
+ (CGFloat)incomeAmount:(NSString *)amount yInterestRate:(NSString *)yInterestRate day:(NSInteger)day NCP:(BOOL)NCP type:(BOOL)type;


+ (NSString *)getFailedmessage;
/**
 <#Description#>

 @param imageNamed <#imageNamed description#>
 @return <#return value description#>
 */
+ (UIImage *)loadImageResource:(NSString *)imageNamed;

/**
 是否为合规产品

 @param source 产品类型
 @return bool
 */
+ (BOOL)complianceProduct:(NSString *)source;


+(NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString;
@end
