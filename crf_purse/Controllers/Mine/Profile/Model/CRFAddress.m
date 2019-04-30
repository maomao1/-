//
//  CRFAddress.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAddress.h"
#import "CRFCity.h"

@implementation CRFAddress

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"addressId":@"id"};
}

- (NSString *)cityCode {
    if (!_cityCode) {
        _cityCode = @"";
    }
    return _cityCode;
}

- (NSString *)provinceCode {
    if (!_provinceCode) {
        _provinceCode = @"";
    }
    return _provinceCode;
}

- (NSString *)districtCode {
    if (!_districtCode) {
        _districtCode = @"";
    }
    return _districtCode;
}

- (NSString *)addressName {
    if (!_addressName) {
        _addressName = [NSString stringWithFormat:@"%@%@",self.subAddress,self.address];
        if (!_addressName) {
            _addressName = @"";
        }
    }
    return _addressName;
}

- (NSString *)subAddress {
    if (!_subAddress) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"crf_cities" ofType:@"json"];
        NSData *data=[NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        NSArray <CRFCity *>*jsonArray = [NSArray yy_modelArrayWithClass:[CRFCity class] json:jsonObject];
        NSString *firstString = @"";
        NSString *secondString = @"";
        NSString *lastString = @"";
        for (CRFCity *city in jsonArray) {
            if ([city.code isEqualToString:self.provinceCode]) {
                firstString = city.name;
            }
            for (CRFSubCity *subCity in city.subCities) {
                if ([subCity.code isEqualToString:self.cityCode]) {
                    secondString = subCity.name;
                }
                for (CRFTown *town in subCity.lastTowns) {
                    if ([town.code isEqualToString:self.districtCode]) {
                        lastString = town.name;
                        break;
                    }
                }
            }
        }
        _subAddress = [NSString stringWithFormat:@"%@%@%@",firstString,secondString,lastString];
    }
    return _subAddress;
}

- (NSString *)formatAddress {
    if (self.addressName.length > 6) {
        return [NSString stringWithFormat:@"%@******%@",[self.addressName substringToIndex:3],[self.addressName substringFromIndex:self.addressName.length - 3]];
    }
    return self.addressName;
}

/*customerUid String 客户ID
 isDefault String 是否默认地址 [1 是 其他否]
 contactName String 联系人
 mobilePhone String 手机号
 address String 地址
 postCode String 邮编
 provinceCode String 省编码
 cityCode String 市编码
 districtCode String 区县
 createTime String 创建时间
 updateTime String 更新时间 */

@end
