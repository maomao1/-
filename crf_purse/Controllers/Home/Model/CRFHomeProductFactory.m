//
//  CRFHomeProductFactory.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeProductFactory.h"
#import "NSArray+Crash.h"

@implementation CRFHomeProductFactory


- (BOOL)hasNewProduct {
    return self.noviceProducts && self.noviceProducts.count > 0;
}

- (BOOL)hasOldProduct {
    return self.oldUserProducts && self.oldUserProducts.count > 0;
}

- (BOOL)hasRecommendProduct {
    return self.recommendProduct && self.recommendProduct.count > 0;
}

- (CRFProductModel *)getProduct:(NSIndexPath *)indexPath {
    NSArray <CRFProductModel *>*models = [self.products objectAtIndexCheck:indexPath.section];
    if (models) {
        return [models objectAtIndexCheck:indexPath.row];
    }
    return nil;
}

- (BOOL)complianceProduct:(NSIndexPath *)indexPath {
    CRFProductModel *model = [self getProduct:indexPath];
    if (!model) {
        return NO;
    }
    return !([model.productType integerValue] == 3);
}

- (BOOL)hasProductTips:(CRFProductModel *)model {
    if (!model) {
        return NO;
    }
    return (model.tipsStart && model.tipsStart.length > 0) || ([model.isFull integerValue] == 1);
}

- (BOOL)mutableNewProduct {
    return self.noviceProducts.count > 1;
}

- (CGFloat)productArea:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self hasNewProduct]) {
            return [self calculateNoviceProductArea];
        }
    }
    if ([self hasProductTips:[self getProduct:indexPath]]) {
        return 89;
    }
    return 83;
}

- (CGFloat)calculateNoviceProductArea {
    CGFloat productArea = 40.0f;
    for (NSInteger index = 0; index < self.noviceProducts.count; index ++) {
        CRFProductModel *model = [self.noviceProducts objectAtIndexCheck:index];
        if ([self hasProductTips:model]) {
            productArea = productArea + 89;
        } else {
            productArea = productArea + 83;
        }
    }
    return productArea;
}

- (CGFloat)productHeight:(NSIndexPath *)indexPath {
    return [self productArea:indexPath];;
}

- (CRFProductModel *)getNoviceProduct:(NSInteger)index {
    return [self.noviceProducts objectAtIndexCheck:index];
}

- (CGFloat)sectionProductHeaderHeight:(NSInteger)section {
    if (section == 0) {
        if ([self hasNewProduct]) {
            return kTopSpace / 2.0;
        }
        return kCellHeight + kTopSpace / 2.0;
    }
    return kCellHeight;
}

- (CGFloat)sectionProductFooterHeight:(NSInteger)section {
    if (section == 0) {
        if ([self hasNewProduct]) {
            return kTopSpace / 2.0;
        }
        return kCellHeight;
    }
    return kCellHeight;
}

- (NSInteger)numberOfProducts:(NSInteger)section {
    if (section == 0 && [self hasNewProduct]) {
        return 1;
    }
    return ((NSArray *)[self.products objectAtIndexCheck:section]).count;
}

- (NSInteger)numberOfSections{
    
    NSInteger sectionNum = 0;
    
    if (self.hasRecommendProduct) {
        sectionNum = sectionNum + 1;
    }
    if (self.hasNewProduct | self.hasOldProduct) {
        sectionNum = sectionNum + 1;
    }
    
    return sectionNum;
    
}

@end
