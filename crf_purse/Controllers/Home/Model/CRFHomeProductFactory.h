//
//  CRFHomeProductFactory.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFHomeProductFactory : NSObject


@property (nonatomic, strong) NSMutableArray <NSArray <CRFProductModel *> *>*products;

/**
 新手产品
 */
@property (nonatomic, copy) NSArray <CRFProductModel *>* noviceProducts;

/**
  老用户精选产品
 */
@property (nonatomic, copy) NSArray <CRFProductModel *>* oldUserProducts;

/**
 推荐产品
 */
@property (nonatomic, copy) NSArray <CRFProductModel *>* recommendProduct;

- (BOOL)mutableNewProduct;


/**
 <#Description#>

 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (CGFloat)productHeight:(NSIndexPath *)indexPath;

/**
 <#Description#>

 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (BOOL)complianceProduct:(NSIndexPath *)indexPath;


- (BOOL)hasNewProduct;
- (BOOL)hasOldProduct;
- (BOOL)hasRecommendProduct;

- (CGFloat)sectionProductHeaderHeight:(NSInteger)section;

- (CGFloat)sectionProductFooterHeight:(NSInteger)section;

- (NSInteger)numberOfProducts:(NSInteger)section;

- (NSInteger)numberOfSections;

@end
