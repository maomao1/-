//
//  CRFNewModel.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNewModel.h"

@implementation CRFNewModel
-(NSString *)iconUrl{
    if(!_iconUrl){
        _iconUrl = @"";
    }
    return _iconUrl;
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
-(NSString *)publicTime{
    if(!_publicTime){
        _publicTime = @"";
    }
    return _publicTime;
}
-(NSString *)status{
    if(!_status){
        _status = @"";
    }
    return _status;
}
@end
