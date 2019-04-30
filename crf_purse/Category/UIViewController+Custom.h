//
//  UIViewController+Custom.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSUInteger const kRightBarButtonFlag = 1001;

@interface UIViewController (Custom)


- (void)setCustomRightBarButtonWithImageNamed:(NSString *)imageNamed target:(id)target selector:(SEL)selector;


- (void)setCustomRightBarBorderButtonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize target:(id)target selector:(SEL)selector titleColor:(UIColor*)color;

- (void)setSystemRightBarButtonWithImageNamed:(NSString *)imageNamed target:(id)target selector:(SEL)selector;

/**
 设置系统导航栏标题
 
 @param title 总标题
 @param lineSpace 行间距
 @param content 第一行内容
 @param attributed 当行属性
 @param subContent 第二行内容
 @param subAttributed 当行属性
 */
- (void)setAttributedTitle:(NSString *)title lineSpace:(CGFloat)lineSpace attributedContent:(NSString *)content attributed:(NSDictionary *)attributed subContent:(NSString *)subContent subAttributed:(NSDictionary *)subAttributed;


/**
 设置自定义导航栏标题
 
 @param title 总标题
 @param lineSpace 行间距
 @param content 第一行内容
 @param attributed 当行属性
 @param subContent 第二行内容
 @param subAttributed 当行属性
 */
- (void)setCustomAttributedTitle:(NSString *)title lineSpace:(CGFloat)lineSpace attributedContent:(NSString *)content attributed:(NSDictionary *)attributed subContent:(NSString *)subContent subAttributed:(NSDictionary *)subAttributed;

/**
 设置系统自带导航看标题
 
 @param title 标题
 */
- (void)setSyatemTitle:(NSString *)title;

- (void)setCustomLineTitle:(NSString *)title;

/**
 自定义导航栏标题（没有导航线）
 
 @param title 标题
 */
- (void)setCustomTitle:(NSString *)title;

- (void)setRightButtonDisplay:(BOOL)display;


/**
 <#Description#>

 @param scrollView <#scrollView description#>
 */
- (void)autoLayoutSizeContentView:(UIScrollView *)scrollView;



@end

