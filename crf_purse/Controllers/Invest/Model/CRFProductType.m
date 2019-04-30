//
//  CRFProductType.m
//  crf_purse
//
//  Created by maomao on 2017/7/24.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFProductType.h"
@implementation CRFProductType
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"lsProductList"     :@"lsProduct"
             };
}
- (NSMutableArray *)finishProductList{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_lsProductList.count; i++) {
        NSDictionary *dic = [_lsProductList objectAtIndex:i];
        CRFProductModel *model = [CRFProductModel yy_modelWithDictionary:dic];
        if ([model.isFull isEqualToString:@"1"]) {
            [array addObject:model];
        }
    }
    return array;
}
- (NSMutableArray *)unfinishProductList{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_lsProductList.count; i++) {
        NSDictionary *dic = [_lsProductList objectAtIndex:i];
        CRFProductModel *model = [CRFProductModel yy_modelWithDictionary:dic];
        if ([model.isFull isEqualToString:@"0"]) {
            [array addObject:model];
        }
    }
    return array;
}
- (NSMutableArray *)totalProductList{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_lsProductList.count; i++) {
        NSDictionary *dic = [_lsProductList objectAtIndex:i];
        CRFProductModel *model = [CRFProductModel yy_modelWithDictionary:dic];
            [array addObject:model];
    }
    return array;
}
@end
@implementation CRFProductListType
- (instancetype)init{
    self = [super init];
    if (self) {
        _longTermProductList   = [[NSMutableArray alloc]init];
        _midTermProductList    = [[NSMutableArray alloc]init];
        _shortTermProductList  = [[NSMutableArray alloc]init];
        _resultList            = [[NSMutableArray alloc]init];
    }
    return self;
}
- (NSMutableArray *)ascList{
    NSMutableArray *finishArray = [NSMutableArray array];
    NSMutableArray *unfinishArray = [NSMutableArray array];
    for (CRFProductModel *item in _resultList) {
        if ([item.isFull isEqualToString:@"1"]) {
            [finishArray addObject:item];
        }else{
            
            [unfinishArray addObject:item];
        }
    }
    NSArray *asc_unfinish = [unfinishArray sortedArrayUsingComparator:^NSComparisonResult(CRFProductModel *obj1, CRFProductModel *obj2){
        return obj1.freezePeriod.integerValue - obj2.freezePeriod.integerValue;
    }];
    
    NSArray *asc_finish = [finishArray sortedArrayUsingComparator:^NSComparisonResult(CRFProductModel *obj1, CRFProductModel *obj2){
        return obj1.freezePeriod.integerValue - obj2.freezePeriod.integerValue;
    }];
    NSMutableArray *resultArr = [NSMutableArray array];
    [resultArr addObjectsFromArray:asc_unfinish];
    [resultArr addObjectsFromArray:asc_finish];
    return resultArr;
}

- (NSMutableArray *)longTermProductList{
    
    NSMutableArray *longArray = [NSMutableArray array];
    for (int i=0; i<_oldList.count; i++) {
        CRFProductType *item = [_oldList objectAtIndex:i];
        NSMutableArray *array = [NSMutableArray array];
        for (CRFProductModel *model in item.totalProductList) {
            if (model.freezePeriod.integerValue>359 ) {
                [array addObject:model];
            }
        }
        [longArray addObject:array];
    }
    return longArray;
}
- (NSMutableArray *)midTermProductList{
    NSMutableArray *longArray = [NSMutableArray array];
    for (int i=0; i<_oldList.count; i++) {
        CRFProductType *item = [_oldList objectAtIndex:i];
        NSMutableArray *array = [NSMutableArray array];
        for (CRFProductModel *model in item.totalProductList) {
            if (model.freezePeriod.integerValue>179 & model.freezePeriod.integerValue<360 ) {
                [array addObject:model];
            }
        }
        [longArray addObject:array];
    }
    return longArray;
}
- (NSMutableArray *)shortTermProductList{
    NSMutableArray *longArray = [NSMutableArray array];
    for (int i=0; i<_oldList.count; i++) {
        CRFProductType *item = [_oldList objectAtIndex:i];
        NSMutableArray *array = [NSMutableArray array];

        for (CRFProductModel *model in item.totalProductList) {
            if (model.freezePeriod.integerValue<180 ) {
                [array addObject:model];
            }
        }
        [longArray addObject:array];
    }
    return longArray;
}

- (NSMutableArray *)selectedArrayForIndex:(NSInteger)index{
    if (index == 1) {
        return self.longTermProductList;
    }else if (index ==2){
        return self.midTermProductList;
    }else if (index == 3){
        return self.shortTermProductList;
    }else{
        return nil;
    }
}
@end
