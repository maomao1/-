//
//  CRFStringUtils.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFStringUtils : NSObject

/**
 add text line space
 
 @param string string
 @param lineSpace line space
 @return attributedString
 */
+ (NSMutableAttributedString *)changedLineSpaceWithTotalString:(NSString *)string lineSpace:(CGFloat)lineSpace;
+ (NSMutableAttributedString *)changedLineSpaceWithTotalString:(NSString *)string lineSpace:(CGFloat)lineSpace ParagrapSpace:(CGFloat)paragraphSpace;
/**
 add link with string
 
 @param string string
 @param url url
 @param subStringArray link string
 @return attributedString
 */
+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)string linkUrl:(NSURL *)url subStringArray:(NSArray <NSString *>*)subStringArray;

/**
 add link with string
 
 @param string string
 @param urlArray uar array
 @param subStringArray sub strings array
 @return mutableString
 */
+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)string linkUrlArray:(NSArray<NSURL *> *)urlArray subStringArray:(NSArray<NSString *> *)subStringArray;

/**
 set view attributed string
 
 @param totalString total stirng
 @param lineSpace line space
 @param attributes1 attributes
 @param range1 range
 @param attributes2 attributes
 @param range2 range
 @param attributes3 attributes
 @param range3 range
 @param attributes4 attributes
 @param range4 range
 @return attributed
 */
+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4;

/**
 set view attributed string
 
 @param totalString totoal attributed string
 @param lineSpace line space
 @param attributes1 attributes
 @param range1 range
 @param attributes2 attributes
 @param range2 range
 @param attributes3 attributes
 @param range3 range
 @param attributes4 attributes
 @param range4 range
 @param attributes5 attributes
 @param range5 range
 @return attributed string
 */
+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4 attributes5:(NSDictionary <NSString *, id>*)attributes5 range5:(NSRange)range5;

+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4 attributes5:(NSDictionary <NSString *, id>*)attributes5 range5:(NSRange)range5 attributes6:(NSDictionary <NSString *, id>*)attributes6 range6:(NSRange)range6;

/**
 <#Description#>
 
 @param totalString <#totalString description#>
 @param highlightText <#highlightText description#>
 @param highlightColor <#highlightColor description#>
 @return <#return value description#>
 */
+ (NSMutableAttributedString *)setAttributedString:(NSString *)totalString highlightText:(NSString *)highlightText highlightColor:(UIColor *)highlightColor;
@end

