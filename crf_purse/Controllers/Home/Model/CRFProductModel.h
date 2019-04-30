//
//  CRFProductModel.h
//  crf_purse
//
//  Created by maomao on 2017/7/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//
/*
 理财产品模型
*/
#import <Foundation/Foundation.h>
#import "CRFTimeUtil.h"
@interface CRFProductModel : NSObject <NSCoding>

@property (nonatomic ,copy) NSString      * type;        ///< 4合规 1常规产品 3现金贷
@property (nonatomic ,copy) NSString      * productName;        ///<产品名字
@property (nonatomic ,copy) NSString      * productTitle;       ///<
@property (nonatomic ,copy) NSString      * yInterestRate;      ///<产品期望年化收益
@property (nonatomic ,copy) NSString      * mInterestRate;      ///<产品期望月化收益
@property (nonatomic ,copy) NSString      * status  ;           ///<
@property (nonatomic ,copy) NSString      * productType;        ///<产品类型   3 现金贷 1连盈 2月盈
@property (nonatomic ,copy) NSString      * lowestAmount;       ///<产品起投
@property (nonatomic ,copy) NSString      * highestAmount  ;    ///<产品最高可投
@property (nonatomic ,copy) NSString      * investunit;         ///<产品投资单位
@property (nonatomic ,copy) NSString      * freezePeriod;       ///<产品出借期
@property (nonatomic ,copy) NSString      * planAmount  ;       ///<计划量
@property (nonatomic ,copy) NSString      * finishAmount;       ///<产品已投资量

@property (nonatomic ,copy) NSString      * contractPrefix;       ///<产品编号
@property (nonatomic ,copy) NSString      * pcProductUrl;       ///<pc产品详情页
@property (nonatomic ,copy) NSString      * appProductUrl;      ///<app产品详情页
@property (nonatomic ,copy) NSString      * uuid;              ///<产品id
@property (nonatomic ,copy) NSString      * isNewBie;           ///3 推荐 newBieSort
@property (nonatomic ,copy) NSString      * newBieSort;         ///newBieSort 产品排序

@property (nonatomic ,copy) NSString      * classNo  ;          ///<
@property (nonatomic ,copy) NSString      * remainDays;          ///<
@property (nonatomic ,copy) NSString      *closeTime;
//新增最高最低收益率字段
@property (nonatomic ,copy) NSString      *minYield;
@property (nonatomic ,copy) NSString      *maxYield;

//@property (nonatomic ,copy) NSString      * investunit;         ///<产品投资单位
//@property (nonatomic ,copy) NSString      * freezePeriod;       ///<产品出借期
//@property (nonatomic ,copy) NSString      * planAmount  ;       ///<计划量

@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic,copy)  NSString *   content;
@property (nonatomic,copy)  NSString *   others;
@property (nonatomic,copy)  NSString *   name;

@property (nonatomic, copy) NSString *alreadyInvestPercent;

@property (nonatomic, copy) NSString *saleTime;
@property (nonatomic, copy) NSString *isFull;
@property (nonatomic, copy) NSString *tipsStart;

@property (nonatomic, copy) NSString *investContent;

/**
 是否推荐 1推荐
 */
@property (nonatomic, copy) NSString *recommendedState;

//@property (nonatomic, copy) NSString *beginTime;


- (NSString *)formatYInterestRate;

-(NSString*)formatterCloseTimeTag:(NSInteger)tag;///<tag 1 yyyy-MM-dd  2 yyyy年MM月dd日

- (NSString *)rangeOfYInterstRate;
@end
