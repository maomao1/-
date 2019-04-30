//
//  CRFKeyChain.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CRFKeyChain : NSObject

/**
 *  存储字符串到 KeyChain
 *
 *  @param string NSString
 */
+ (void)keyChainSave:(NSString *)string;

/**
 *  从 KeyChain 中读取存储的字符串
 *
 *  @return NSString
 */
+ (NSString *)keyChainLoad;

/**
 *  删除 KeyChain 信息
 */
+ (void)keyChainDelete;

@end
