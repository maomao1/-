//
//  CRFCashRecordModel.h
//  crf_purse
//
//  Created by maomao on 2017/8/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFCashRecordModel : NSObject
@property (nonatomic ,copy) NSString * amount;  ///<额度
@property (nonatomic ,copy) NSString * amountFen;
@property (nonatomic ,copy) NSString * checkTime;
@property (nonatomic ,copy) NSString * createName;
@property (nonatomic ,copy) NSString * createTime;
@property (nonatomic ,copy) NSString * fcpNo;
@property (nonatomic ,copy) NSString * investorName;
@property (nonatomic ,copy) NSString * jyTime;   ///< 时间
@property (nonatomic ,copy) NSString * jyType;   ///< 1充值 2 提现
@property (nonatomic ,copy) NSString * status;
@property (nonatomic ,copy) NSString * updateName;
@property (nonatomic ,copy) NSString * updateTime;

@property (nonatomic,copy) NSString * title;

@end
