//
//  CRFProtocol.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFProtocol.h"

@implementation CRFProtocol

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"protocolUrl":@"jumpUrl"};
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}
-(NSString *)name{
    if (!_name) {
        _name = @"";
    }
    return _name;
}
-(NSString *)protocolUrl{
    if (!_protocolUrl) {
        _protocolUrl = @"";
    }
    _protocolUrl =  [_protocolUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    return _protocolUrl;
}
@end
