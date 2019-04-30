//
//  CRFAppHomeModel.m
//  crf_purse
//
//  Created by maomao on 2017/7/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAppHomeModel.h"

@implementation CRFAppHomeModel
-(NSString *)name{
    if (!_name) {
        _name = @"";
    }
    return _name;
}
-(NSString *)content{
    if (!_content) {
        _content = @"";
    }
    return _content;
}
-(NSString *)subContent{
    if (!_subContent) {
        _subContent = @"";
    }
    return _subContent;
}
-(NSString *)time{
    if (!_time) {
        _time=@"";
    }
    _time = [_time stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    return _time;
}
- (NSString *)funcName {
    return [NSString stringWithFormat:@"%@\n%@",_content,_subContent];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}

@end
