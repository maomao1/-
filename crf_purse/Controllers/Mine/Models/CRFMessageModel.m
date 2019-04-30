//
//  CRFMessageModel.m
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMessageModel.h"
#import "CRFTimeUtil.h"
@implementation CRFMessageModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"mes_id"     :@"id"
             };
}

//- (NSString *)pushTime {
//
//    return [CRFTimeUtil getTimeToShowWithTimestamp:_pushTime];
//}



- (id)copyWithZone:(NSZone *)zone {
    CRFMessageModel *model = [[[self class] allocWithZone:zone] init];
    model.createTime = self.createTime;
    model.content = self.content;
    model.createName = self.content;
    model.mes_id = self.mes_id;
    model.isRead = self.isRead;
    model.pushTime = self.pushTime;
    model.status = self.status;
    model.subject = self.subject;
    model.type = self.type;
    model.updateName = self.updateName;
    model.updateTime = self.updateTime;
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    CRFMessageModel *model = [[[self class] allocWithZone:zone] init];
    model.createTime = self.createTime;
    model.content = self.content;
    model.createName = self.content;
    model.mes_id = self.mes_id;
    model.isRead = self.isRead;
    model.pushTime = self.pushTime;
    model.status = self.status;
    model.subject = self.subject;
    model.type = self.type;
    model.updateName = self.updateName;
    model.updateTime = self.updateTime;
    return model;
}
@end
