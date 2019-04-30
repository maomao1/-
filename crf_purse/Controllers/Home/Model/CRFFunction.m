//
//  CRFFunction.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFFunction.h"

@implementation CRFFunction
-(NSString *)linkUrl{
    if(!_linkUrl){
        _linkUrl = @"";
    }
    return _linkUrl;
}
-(NSString *)title{
    if(!_title){
        _title = @"";
    }
    return _title;
}
-(NSString *)jumpUrl{
    if(!_jumpUrl){
        _jumpUrl = @"";
    }
    return _jumpUrl;
}
@end
