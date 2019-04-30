//
//  CRFAppintmentForwardProductModel.h
//  crf_purse
//
//  Created by xu_cheng on 2018/4/3.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFAppintmentForwardProductModel : NSObject

@property (nonatomic ,copy) NSString      * type;        ///< 4合规 1常规产品 3现金贷
@property (nonatomic ,copy) NSString      * productName;        ///<产品名字
@property (nonatomic ,copy) NSString      * productTitle;
///<
@property (nonatomic ,assign) double yInterestRate;      ///<产品期望年化收益

@property (nonatomic ,copy) NSString      * productType;        ///<产品类型   3 现金贷 1连盈 2月盈
@property (nonatomic ,assign) NSInteger freezePeriod;       ///<产品出借期


@property (nonatomic ,copy) NSString      * contractPrefix;       ///<产品编号


@property (nonatomic ,assign) NSInteger remainDays;          ///<

@property (nonatomic, assign) long long lowestAmount;

@property (nonatomic, copy) NSString *planNo;
//新增最高最低收益率字段
@property (nonatomic ,copy) NSString      *minYield;
@property (nonatomic ,copy) NSString      *maxYield;
- (NSString *)formatYInterestRate;



@end
