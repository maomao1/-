//
//  CRFAgreementDto.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/25.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFAgreementDto : NSObject

/**
 协议名称
 */
@property (nonatomic, copy) NSString *protocolName;

/**
 协议PDF的URL
 */
@property (nonatomic, copy) NSString *pdfUrl;

/**
 协议HTML的URL
 */
@property (nonatomic, copy) NSString *htmlUrl;


/**
 协议编号
 */
@property (nonatomic, copy) NSString *protocolCode;

@end
