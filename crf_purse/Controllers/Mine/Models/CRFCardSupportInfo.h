//
//  CRFCardSupportInfo.h
//  crf_purse
//
//  Created by maomao on 2017/8/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFCardSupportInfo : NSObject
@property (nonatomic ,copy) NSString *businessSupport;
@property (nonatomic, copy) NSString *bankCardNo;
@property (nonatomic, copy) NSString *bankCardType;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *failCode;
@property (nonatomic, copy) NSString *failReason;
@property (nonatomic, copy) NSString *result;
@end
