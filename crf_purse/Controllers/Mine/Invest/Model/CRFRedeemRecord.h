//
//  CRFRedeemRecord.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/23.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFRedeemRecord : NSObject

@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *appdate;
@property (nonatomic,copy) NSString *approveresult;
@property (nonatomic,copy) NSString *capital;
@property (nonatomic,copy) NSString *investId;
@property (nonatomic,copy) NSString *investor;
@property (nonatomic,copy) NSString *profit;
@property (nonatomic,copy) NSString *transferdate;
@property (nonatomic,copy) NSString *transferreason;

@end
