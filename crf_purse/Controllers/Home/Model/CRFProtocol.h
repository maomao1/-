//
//  CRFProtocol.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const kXjd_invest_protocal          = @"xjd_invest_protocal";
static NSString *const kOffline_invest_protocal          = @"offline_invest_protocal";
static NSString *const kRule_invest_protocal        = @"ncp_invest_protocal";

static NSString *const kInvestmenttranser_protocolKey = @"investmenttransfer_protocal";
static NSString *const kDebttransfer_protocalKey = @"debttransfer_protocal";
static NSString *const kRegister_protocolKey = @"register_protocol";
//static NSString *const kInvestmenttranser_protocol = @"";

@interface CRFProtocol : NSObject<NSCoding>

/**
 协议地址
 */
@property (nonatomic, copy) NSString *protocolUrl;

/**
 协议名称
 */
@property (nonatomic, copy) NSString *name;

@end
