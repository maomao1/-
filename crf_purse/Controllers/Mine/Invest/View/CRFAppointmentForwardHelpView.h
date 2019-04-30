//
//  CRFAppointmentForwardHelpView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 类型

 - CRFHelpViewStyleOnlyContent: 只有内容
 - CRFHelpViewStyleContainTitleAndContext: 有标题和内容
 - CRFHelpViewStyleIllustration: 有标题、图片、内容
 - CRFHelpViewStyleScrollIllustration: 有标题、图片、内容可滚动
 */
typedef NS_ENUM(NSUInteger, CRFHelpViewStyle) {
    CRFHelpViewStyleOnlyContent                 = 0,
    CRFHelpViewStyleContainTitleAndContext      = 1,
    CRFHelpViewStyleIllustration                = 2,
    CRFHelpViewStyleScrollIllustration          = 3,
    CRFHelpViewStyleContainCancelBtn            = 4,
    CRFHelpViewStyleImageView            = 5,

};

@interface CRFAppointmentForwardHelpView : UIView

@property (nonatomic, assign) CRFHelpViewStyle helpStyle;

/**
 毛玻璃样式
 */
@property (nonatomic, assign) UIBlurEffectStyle effectStyle;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 内容颜色
 */
@property (nonatomic, strong) UIColor *contentColor;

/**
 消失的终点
 */
@property (nonatomic, assign) CGPoint dissmissPoint;

/**
 设置内容

 @param content 内容
 */
- (void)drawContent:(NSString *)content;

/**
 显示view

 @param view view
 */
- (void)show:(UIView *)view;


/**
 显示view

 @param view view
 @param handler 消失后的会掉
 */
- (void)show:(UIView *)view dismissHandler:(void (^)(void))handler;



@end
