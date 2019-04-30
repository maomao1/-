//
//  CRFAlertUtils.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFStringUtils.h"
/*
 cancel title default black color,
 
 comfirm title default red color,
 
 title text font is border,
 
 message text font is system,
 */
@interface CRFAlertUtils : NSObject


/**
 show alertView
 
 @param title title
 @param message message
 @param container container
 @param cancelTitle cancel title
 @param confirmTitle confirmTitle
 @param cancelHandler cancel handler
 @param confirmHandler confirmHandler
 */
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;

/**
 show alert view
 
 @param title title
 @param imagedName imagedNmae
 @param container container
 @param cancelTitle cancel title
 @param confirmTitle confirm title
 @param cancelHandler cancel handler
 @param confirmHandler confirmHandler
 */
+ (void)showAlertTitle:(NSString *)title imagedName:(NSString *)imagedName container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;

/**
 show alert view
 
 @param title title
 @param message message
 @param imagedName imagedName
 @param container containber
 @param cancelTitle cancel title
 @param confirmTitle confirm title
 @param cancelHandler cancel handler
 @param confirmHandler confirm handler
 */
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message imagedName:(NSString *)imagedName container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;

/**
 show alert view
 
 @param title title
 @param message message
 @param container container
 @param cancelTitle cancel title
 @param confirmTitle confirm title
 @param cancelHandler cancel handler
 @param confirmHandler confirm handler
 */
+ (void)showAlertTitle:(NSString *)title contentLeftMessage:(NSString *)message container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;


+ (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle items:(NSArray <NSString *>*)items completeHandler:(void (^)(NSInteger index))completeHandler cancelHandler:(void (^)(void))cancelHandler;

+ (void)actionSheetWithItems:(NSArray <NSString *> *)items container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle completeHandler:(void (^)(NSInteger index))completeHandler cancelHandler:(void (^)(void))cancelHandler;

+ (void)showAlertMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;
+ (void)showAlertMidMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;

+ (void)showAlertLeftTitle:(NSString *)title AttributedMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;

+ (void)showAppointmentForwardAlertMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;
+ (void)showAlertTitle:(NSString *)title  container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler;
@end

