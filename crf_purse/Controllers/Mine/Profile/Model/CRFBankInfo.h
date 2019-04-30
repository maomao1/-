//
//  CRFBankInfo.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFBankInfo : NSObject

/**
 银行代码
 */
@property (nonatomic, copy) NSString *bankCode;

/**
 银行卡背景图
 */
@property (nonatomic, copy) NSString *bankPicUrl;

/**
 0原卡1新卡
 */
@property (nonatomic, copy) NSString *cardFlag;

/**
 银行卡号
 */
@property (nonatomic, copy) NSString *openBankCardNo;

@end
