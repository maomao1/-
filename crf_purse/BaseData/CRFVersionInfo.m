//
//  CRFVersionInfo.m
//  CashLoan
//
//  Created by crf on 15/10/19.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import "CRFVersionInfo.h"

@implementation CRFVersionInfo
@synthesize versionCode,updateTime,appLink,appTips,level;
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"versionCode":@"versionCode",
             @"appTips"    :@"appTips",
             @"appLink"    :@"appLink",
             @"updateTime" :@"updateTime",
             @"level"      :@"level"
             };
}
- (id)init{
    if(self = [super init]){
        versionCode =  [[NSString alloc] init];
        updateTime =  [[NSString alloc] init];
        appLink =  [[NSString alloc] init];
        appTips =  [[NSString alloc] init];
        level   =  [[NSString alloc] init];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}
- (NSString *)appTips{
    return [appTips stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}
@end
