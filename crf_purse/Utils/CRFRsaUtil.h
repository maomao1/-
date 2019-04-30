//
//  CRFRSAUtil.h
//  crf_purse
//
//  Created by bill on 2017/10/24.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFRsaUtil : NSObject

// 返回base64后的字符串, 转化成可以读的NSString (不是base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

// 返回 base64 后的字符串
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// 公钥针对NSData类型返回raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// 返回 base64 解密后的字符串
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// 私钥针对NSData类型返回raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;
+ (NSString *)signString:(NSString *)str privateKey:(NSString *)privKey;

@end

