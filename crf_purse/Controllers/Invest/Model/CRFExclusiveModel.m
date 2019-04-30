//
//  CRFExclusiveModel.m
//  crf_purse
//
//  Created by maomao on 2018/4/18.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFExclusiveModel.h"

@implementation CRFExclusiveModel
-(NSString *)content{
    if (!_content) {
        _content = @"";
    }
    return _content;
}
-(NSString *)lowestAmount{
    if (!_lowestAmount) {
        _lowestAmount = @"0";
    }
    return _lowestAmount;
}
-(NSString *)investUnit{
    if (!_investUnit) {
        _investUnit = @"0";
    }
    return _investUnit;
}
@end
