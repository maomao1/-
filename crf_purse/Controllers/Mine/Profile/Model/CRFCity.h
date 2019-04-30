//
//  CRFCity.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CRFTown : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

@end

@interface CRFSubCity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray <NSDictionary *>*townes;
@property (nonatomic, strong) NSArray <CRFTown *>*lastTowns;

@end


@interface CRFCity : NSObject

@property (nonatomic, strong) NSArray <NSDictionary *>*city;
@property (nonatomic, strong) NSArray <CRFSubCity *>*subCities;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *postCode;

@end

@interface CRFSubBankCity : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

@end

@interface CRFBankCity : NSObject
/*"code": "120",
 "name": "天津市",
 "area": [
 {
 "code": "1100",
 "name": "天津市"
 }*/
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <NSDictionary *>*area;

@property (nonatomic, strong) NSArray <CRFSubBankCity *>*bankCities;

@end

