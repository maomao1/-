//
//  NSString+AttributedString.m
//  crf_purse
//
//  Created by xu_cheng on 2018/2/11.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)

- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber {
    UIFont *fond = [UIFont systemFontOfSize:fondNumber];
    NSDictionary *attribute = @{NSFontAttributeName:fond};
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return retSize;
}

- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace {
    UIFont *fond = [UIFont systemFontOfSize:fondNumber];
    NSMutableParagraphStyle *paragraphStyle = nil;
    if (lineSpace > 0) {
        paragraphStyle  =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
    }
    NSDictionary *attribute = @{NSFontAttributeName:fond, NSParagraphStyleAttributeName: paragraphStyle};
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return retSize;
}

- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace paragraphSpace:(CGFloat)paragraphSpace {
    UIFont *fond = [UIFont systemFontOfSize:fondNumber];
    NSMutableParagraphStyle *paragraphStyle = nil;
    if (lineSpace > 0) {
        paragraphStyle  =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
    }
    if (paragraphSpace) {
        if (paragraphStyle) {
            [paragraphStyle setParagraphSpacing:paragraphSpace];
        } else {
            paragraphStyle  =
            [[NSMutableParagraphStyle alloc] init];
             [paragraphStyle setParagraphSpacing:paragraphSpace];
        }
    }
    NSDictionary *attribute = @{NSFontAttributeName:fond, NSParagraphStyleAttributeName: paragraphStyle};
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return retSize;
}

- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace paragraphSpace:(CGFloat)paragraphSpace charSpace:(CGFloat)charSpace {
    UIFont *fond = [UIFont systemFontOfSize:fondNumber];
    NSMutableParagraphStyle *paragraphStyle = nil;
    if (lineSpace > 0) {
        paragraphStyle  =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
    }
    if (paragraphSpace) {
        if (paragraphStyle) {
            [paragraphStyle setParagraphSpacing:paragraphSpace];
        } else {
            paragraphStyle  =
            [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setParagraphSpacing:paragraphSpace];
        }
    }
    NSDictionary *attribute = @{NSFontAttributeName:fond, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName:@(charSpace)};
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return retSize;
}

- (CGSize)boundingRectWithSize:(CGSize)size fontNumber:(CGFloat)fondNumber lineSpace:(CGFloat)lineSpace charSpace:(CGFloat)charSpace {
    UIFont *fond = [UIFont systemFontOfSize:fondNumber];
    NSMutableParagraphStyle *paragraphStyle = nil;
    if (lineSpace > 0) {
        paragraphStyle  =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
    }
    NSDictionary *attribute = @{NSFontAttributeName:fond, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName:@(charSpace)};
    CGSize retSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return retSize;
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [self sizeWithAttributes:attributes];
    } else {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}


@end
