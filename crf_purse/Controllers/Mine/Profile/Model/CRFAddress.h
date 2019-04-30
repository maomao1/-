//
//  CRFAddress.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFAddress : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *districtCode;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, copy) NSString *addressName;

@property (nonatomic, copy) NSString *subAddress;

- (NSString *)formatAddress;

@end
