//
//  NSString+CRF.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "NSString+CRF.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "CRFRSAUtil.h"
#import <CommonCrypto/CommonDigest.h>  

@implementation NSString (CRF)

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)getAppId {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (BOOL)validateUserName {
    NSString *regex = @"((^[a-zA-Z]+(·[a-zA-Z]+)*$))|(^[\u4e00-\u9fa5]+(·[\u4e00-\u9fa5]+)*$)";
    return [self isValidateByRegex:regex];
}

//身份证号
- (BOOL)validateIdentityCard {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

//银行卡
- (BOOL)validateBankCardNumber {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:self];
}

//银行卡后四位
- (BOOL)validateBankCardLastNumber {
    BOOL flag;
    if (self.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:self];
}

+ (NSString *)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char  *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]||[platform isEqualToString:@"iPhone10,4"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,2"]||[platform isEqualToString:@"iPhone10,5"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,3"]||[platform isEqualToString:@"iPhone10,6"]) return @"iPhoneX";
    if ([platform isEqualToString:@"iPhone11,4"]||[platform isEqualToString:@"iPhone10,6"]) return @"iPhoneXsMax";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhoneXs";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhoneXR";

    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPodTouch6G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad4";
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPadAir2";
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPadmini4";
    if ([platform isEqualToString:@"i386"]) return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhoneSimulator";
    
    return platform;
}

- (BOOL)isEmpty {
    if ([self isKindOfClass:[NSNull class]] || !self || self.length <= 0) {
        return YES;
    }
    return NO;
}

- (BOOL)validatePhoneNumber {
    NSString *phoneNumberRegixSimple = @"^1\\d{10}";
    return [self isValidateByRegex:phoneNumberRegixSimple];
}

- (BOOL)isValidPwd {
    NSString *passwordRegex = @"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,20}$"/*@"^[A-Za-z0-9]{6,20}+$"*/;
    return [self isValidateByRegex:passwordRegex];
}

- (BOOL)isEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

- (BOOL)stringIsNumber {
    NSString *numberReges = @"^[0-9]*$";
    return [self isValidateByRegex:numberReges];
}

- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (CRFBankCardInfo *)getBankCardInfo {
    if (self.length < 6) {
        return nil;
    }
    for (CRFBankCardInfo *cardInfo in [CRFAppManager defaultManager].bankCards) {
        if ([cardInfo.cardBin isEqualToString:[self substringToIndex:6]]) {
            return cardInfo;
        }
    }
    return nil;
}

- (CRFBankCardInfo *)getValidateBankCardInfo {
    if (self.length < 6) {
        return nil;
    }
    for (CRFBankCardInfo *cardInfo in [CRFAppManager defaultManager].bankCards) {
        if ([cardInfo.cardBin isEqualToString:[self substringToIndex:6]]) {
            return cardInfo;
        }
    }
    CRFBankCardInfo *cardInfo = [CRFBankCardInfo new];
    cardInfo.bankName = @"银行";
    return cardInfo;
}

- (CRFBankCardInfo *)getBankCode {
    for (CRFBankCardInfo *cardInfo in [CRFAppManager defaultManager].bankCards) {
        if ([cardInfo.bankCode isEqualToString:self]) {
            return cardInfo;
        }
    }
    CRFBankCardInfo *cardInfo = [CRFBankCardInfo new];
    cardInfo.bankName = @"银行";
    return cardInfo;
}

- (NSString *)formatMoblePhone {
    if (self.length < 5) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@******%@",[self substringToIndex:3],[self substringFromIndex:self.length - 2]];
}

- (NSString *)calculateWithHighPrecision {
    NSString *formatString = [self getOriginString];
    if (formatString.doubleValue <= .0f) {
        return @"0";
    }
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:formatString];
    NSDecimalNumber *mutableDecimalNumber = [decimalNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    return [NSString stringWithFormat:@"%.0f",mutableDecimalNumber.doubleValue];
}

- (NSString *)formatPlaceholderMoney{
    if (self.length>4) {
        return [NSString stringWithFormat:@"%@万", [self substringWithRange:NSMakeRange(0, self.length - 4)] ];
    }
    return self;
}

- (BOOL)validateBankCard {
    //去掉前端校验银行卡
    return YES;
    if(!self || [@"" isEqualToString:self])
        return NO;
    int sum = 0;
    int len = (int)[self length];
    int i = 0;
    if (len<15 || len>19) {
        return NO;
    }
    while (i < len) {
        NSString *tmpString = [self substringWithRange:NSMakeRange(len - 1 - i, 1)];
        int tmpVal = [tmpString intValue];
        if (i % 2 != 0) {
            tmpVal *= 2;
            if(tmpVal>=10) {
                tmpVal -= 9;
            }
        }
        sum += tmpVal;
        i++;
    }
    if((sum % 10) == 0)  {
        return YES;
    }else {
        return NO;
    }
}

- (NSString *)formatPercent {
    NSArray <NSString *>*chares = [self componentsSeparatedByString:@"."];
    if (chares.count == 2 && [[chares lastObject] doubleValue] <= 0) {
        return [chares firstObject];
    }
    return self;
}

- (NSString *)formatMoney {
    if ([self containsString:@","]) {
        return self;
    }
    if ([self doubleValue] <= 0) {
        return @"0.00";
    }
    if ([self isEmpty]) {
        return @"0";
    }
    NSString *formatString = self;
    if (![self containsString:@"."]) {
        formatString = [NSString stringWithFormat:@"%@.00",self];
    }
    NSArray *a = [formatString componentsSeparatedByString:@"."];
    NSString *firstString = [a firstObject];
    NSInteger index = 0;
     NSMutableString *desString = [NSMutableString new];
    for (NSInteger i = firstString.length - 1; i < firstString.length; i --) {
        index ++;
        [desString insertString:[firstString substringWithRange:NSMakeRange(i, 1)] atIndex:0];
        if (index % 3 == 0 && i != 0) {
            [desString insertString:@"," atIndex:0];
        }
    }
    [desString appendFormat:@".%@",[a lastObject]];
    return [desString copy];
}

- (NSString *)formatBeginMoney {
    if ([self containsString:@","]) {
        return self;
    }
    if ([self isEmpty]) {
        return @"0";
    }
    NSString *string = [self formatPercent];
    NSArray *arr = [string componentsSeparatedByString:@"."];
    NSString *des = [arr firstObject];
    NSInteger index = 0;
    NSMutableString *desString = [NSMutableString new];
    for (NSInteger i = des.length - 1; i < des.length; i --) {
        index ++;
        [desString insertString:[des substringWithRange:NSMakeRange(i, 1)] atIndex:0];
        if (index % 3 == 0 && i != 0) {
            [desString insertString:@"," atIndex:0];
        }
    }
    if (arr.count == 2) {
         [desString appendFormat:@".%@",[arr lastObject]];
    }
   
    return [desString copy];
}

- (NSString *)getOriginString {
    if ([self containsString:@","]) {
       return [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    return self;
}

- (NSString *)formatProfitMoney {
    if ([self containsString:@","]) {
        return self;
    }
    if ([self doubleValue] <= 0) {
        return @"0.00";
    }
    NSString *formatString = self;
    if (![self containsString:@"."]) {
        formatString = [NSString stringWithFormat:@"%@.00",self];
    }
    NSArray *a = [formatString componentsSeparatedByString:@"."];
    NSString *firstString = [a firstObject];
//    NSString *lastString = [a lastObject];
//    if (lastString && [lastString integerValue] <= 0) {
//        return [self formatBeginMoney];
//    }
    NSInteger index = 0;
    NSMutableString *desString = [NSMutableString new];
    for (NSInteger i = firstString.length - 1; i < firstString.length; i --) {
        index ++;
        [desString insertString:[firstString substringWithRange:NSMakeRange(i, 1)] atIndex:0];
        if (index % 3 == 0 && i != 0) {
            [desString insertString:@"," atIndex:0];
        }
    }
    [desString appendFormat:@".%@",[a lastObject]];
    return [desString copy];
}

+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
     NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // MAC地址不带冒号
//    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    return [outstring uppercaseString];
}

//RSA公钥加密
- (NSString *)rsaEncrypt {
    return [CRFRsaUtil encryptString:self publicKey:crfPubkey];
}

//RSA公钥解密
- (NSString *)rsaDecrypt {
    return [CRFRsaUtil decryptString:self publicKey:crfPubkey];
}


- (NSString *)md5 {
    const char* character = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(character, (CC_LONG)strlen(character), result);
    
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x",result[i]];
    }
    
    return md5String;  
}

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '*' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString*)urlEncodedString {
    NSString *encodedString = self;
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

- (NSString*)sha256 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
- (NSString*)sha512 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)formatJsonToString {
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

- (NSString *)formatJsonStirng {
    NSString *newString = self;
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}

@end
