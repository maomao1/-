//
//  CRFActivity.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFActivity.h"
#import "CRFTimeUtil.h"
@implementation CRFActivity

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"notice_id":@"id",
             @"contentUrl":@"url",
             };
}

- (NSString *)contentUrl {
    if (!_contentUrl) {
        _contentUrl = @"";
    }
    return _contentUrl;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self=[super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}

-(NSString *)content{
    if(!_content){
        _content = @"";
    }
    return _content;
}
-(NSString *)title{
    if(!_title){
        _title = @"";
    }
    return _title;
}
-(NSString *)notice_id{
    if(!_notice_id){
        _notice_id = @"";
    }
    return _notice_id;
}


@end
