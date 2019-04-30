//
//  CRFDataSourceFactory.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CRFDataSourceFactory : NSObject

/**
 根据产品详情获取出资详情的本地数据

 @param source 产品来源（线上-线下）
 @param productType 产品类型
 @param status 产品状态（计息中、未计息、已结束）
 @return list
 */
+ (NSArray <NSArray *>*)factoryInvestDetailDataSource:(NSInteger)source productType:(NSInteger)productType status:(NSInteger)status ;


@end
