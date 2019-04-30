//
//  NSString+AttributedString.h
//  crf_purse
//
//  Created by xu_cheng on 2018/2/11.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedString)

/**
 获取富文本高度

 @param size 指定大小（获取宽或者高）
 @param fondNumber 字体大小
 @return size
 */
- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber;

/**
 获取富文本高度

 @param size 指定大小（获取宽或者高）
 @param fondNumber 字体大小
 @param lineSpace 行间距
 @return size
 */
- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace;

/**
 获取富文本高度

 @param size 指定大小（获取宽或者高）
 @param fondNumber 字体大小
 @param lineSpace 行间距
 @param paragraphSpace 段间距
 @return size
 */
- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace paragraphSpace:(CGFloat)paragraphSpace;

/**
 获取富文本高度

 @param size 指定大小（获取宽或者高）
 @param fondNumber 字体大小
 @param lineSpace 行间距
 @param paragraphSpace 段间距
 @param charSpace 字间距
 @return size
 */
- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace paragraphSpace:(CGFloat)paragraphSpace charSpace:(CGFloat)charSpace;

/**
 获取富文本高度

 @param size 指定大小（获取宽或者高）
 @param fondNumber 字体大小
 @param lineSpace 行间距
 @param charSpace 字间距
 @return size
 */
- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace charSpace:(CGFloat)charSpace;


- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
