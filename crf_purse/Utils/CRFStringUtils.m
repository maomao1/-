//
//  CRFStringUtils.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFStringUtils.h"
#import <CoreText/CoreText.h>

@implementation CRFStringUtils
+ (NSMutableAttributedString *)changedLineSpaceWithTotalString:(NSString *)string lineSpace:(CGFloat)lineSpace ParagrapSpace:(CGFloat)paragraphSpace{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setParagraphSpacing:paragraphSpace];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    return attributeStr;
}
+ (NSMutableAttributedString *)changedLineSpaceWithTotalString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    return attributeStr;
}

+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)string linkUrl:(NSURL *)url subStringArray:(NSArray<NSString *> *)subStringArray {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    for (NSString *str in subStringArray) {
        NSRange range = [string rangeOfString:str options:NSBackwardsSearch];
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blueColor]
                             range:range];
        [attributeStr addAttribute:NSLinkAttributeName value:url range:range];
    }
    return attributeStr;
}
+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)string linkUrlArray:(NSArray<NSURL *> *)urlArray subStringArray:(NSArray<NSString *> *)subStringArray {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i< subStringArray.count; i++) {
        NSString *str = [subStringArray objectAtIndex:i];
        NSRange range = [string rangeOfString:str options:NSBackwardsSearch];
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blueColor]
                             range:range];
        [attributeStr addAttribute:NSLinkAttributeName value:[urlArray objectAtIndex:i] range:range];
    }
    return attributeStr;
}

+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (lineSpace > 0) {
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, totalString.length)];
    }
    if (attributes1) {
        [attString addAttributes:attributes1 range:range1];
    }
    if (attributes2) {
        [attString addAttributes:attributes2 range:range2];
    }
    if (attributes3) {
        [attString addAttributes:attributes3 range:range3];
    }
    if (attributes4) {
        [attString addAttributes:attributes4 range:range4];
    }
    return attString;
}

+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4 attributes5:(NSDictionary <NSString *, id>*)attributes5 range5:(NSRange)range5 {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (lineSpace > 0) {
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, totalString.length)];
    }
    if (attributes1) {
        [attString addAttributes:attributes1 range:range1];
    }
    if (attributes2) {
        [attString addAttributes:attributes2 range:range2];
    }
    if (attributes3) {
        [attString addAttributes:attributes3 range:range3];
    }
    if (attributes4) {
        [attString addAttributes:attributes4 range:range4];
    }
    if (attributes5) {
        [attString addAttributes:attributes5 range:range5];
    }
    return attString;
}

+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4 attributes5:(NSDictionary <NSString *, id>*)attributes5 range5:(NSRange)range5 attributes6:(NSDictionary <NSString *, id>*)attributes6 range6:(NSRange)range6 {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (lineSpace > 0) {
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, totalString.length)];
    }
    if (attributes1) {
        [attString addAttributes:attributes1 range:range1];
    }
    if (attributes2) {
        [attString addAttributes:attributes2 range:range2];
    }
    if (attributes3) {
        [attString addAttributes:attributes3 range:range3];
    }
    if (attributes4) {
        [attString addAttributes:attributes4 range:range4];
    }
    if (attributes5) {
        [attString addAttributes:attributes5 range:range5];
    }
    if (attributes6) {
        [attString addAttributes:attributes6 range:range6];
    }
    return attString;
}


+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString highlightText:(NSString *)highlightText highlightColor:(UIColor *)highlightColor {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    if (highlightText.length) {
        [attString addAttribute:NSForegroundColorAttributeName value:highlightColor range:[totalString rangeOfString:highlightText]];
    }
    return attString;
}


@end

