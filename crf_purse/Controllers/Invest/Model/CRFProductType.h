//
//  CRFProductType.h
//  crf_purse
//
//  Created by maomao on 2017/7/24.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFProductModel.h"

@interface CRFProductType : NSObject
@property  (nonatomic , copy) NSString  *productTypeName;///<产品类型名字  现金贷。生活贷
@property  (nonatomic , strong)NSArray  *lsProductList;  ///<所有产品 数据
@property  (nonatomic , strong)NSMutableArray *finishProductList;///<已售完的计划 数据
@property  (nonatomic , strong)NSMutableArray *unfinishProductList;///<未售完的计划
@property  (nonatomic , strong)NSMutableArray *totalProductList;

@property  (nonatomic , assign) BOOL    isOpen;///< 是否展开 已售完的计划

@end

@interface CRFProductListType: NSObject
@property  (nonatomic ,assign) NSInteger       selectedIndex;///<0 未选中 1 长期2中期 3短期
@property  (nonatomic  ,assign) BOOL          selectedType; ///<yes  选中了产品类型
@property  (nonatomic , copy)  NSString       *typeStr;
@property  (nonatomic , strong)NSMutableArray *oldList;

@property  (nonatomic , strong)NSMutableArray *longTermProductList;///<长期产品数据
@property  (nonatomic , strong)NSMutableArray *midTermProductList;///<中期产品数据
@property  (nonatomic , strong)NSMutableArray *shortTermProductList;///<短期产品数据
@property  (nonatomic , strong)NSMutableArray *resultList; ///<筛选后的数组
@property  (nonatomic , strong)NSMutableArray *ascList;///<升序数组 按照出借期 升序排列
- (NSMutableArray *)selectedArrayForIndex:(NSInteger)index;
@end
