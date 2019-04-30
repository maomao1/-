//
//  CRFResponseFactory.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFResponseFactory.h"
@implementation CRFResponseFactory

+ (NSArray<CRFBankInfo *> *)handlerBankInfo:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFBankInfo class] json:result[kDataKey][@"cardList"]];
}

+ (CRFCardSupportInfo*)handleDataForResult:(id)result{
    return [CRFCardSupportInfo yy_modelWithJSON:result[@"data"]];
}

+ (CRFUserInfo *)hadleLoginDataForResult:(id)result{
    return [CRFUserInfo yy_modelWithJSON:result[@"data"]];
}

+ (CRFAccountInfo *)getAccountInfo:(id)result {
    return [CRFAccountInfo yy_modelWithJSON:result[@"data"]];
}

+ (NSArray <CRFCouponModel *> *)handleCouponData:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFCouponModel class] json:result[kDataKey]];
}

+ (CRFVersionInfo *)hadleVersionDataForResult:(id)result{
    return [CRFVersionInfo yy_modelWithJSON:result[@"data"]];
}

+ (NSArray *)handleBannerDataForResult:(id)result ForKey:(NSString *)key{
    return [NSArray yy_modelArrayWithClass:[CRFAppHomeModel class] json:[result[@"data"] objectForKey:key]];
}

+ (NSArray *)handlerDiscoveryTopMenus:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFAppHomeModel class] json:result[kDataKey][@"discover_new_menu"]];
}

+ (NSArray *)handleProductDataForResult:(id)result ForKey:(NSString *)key{
    return [NSArray yy_modelArrayWithClass:[CRFProductModel class] json:[result[@"data"] objectForKey:key]];
}

+ (NSArray *)handleDataForResult:(id)result WithClass:(id)item{
    return [NSArray yy_modelArrayWithClass:item json:result[@"data"]];
}

+ (NSArray *)handleProductDataForResult:(id)result WithClass:(id)item ForKey:(NSString *)key{
    return [NSArray yy_modelArrayWithClass:item json:[result[@"data"] objectForKey:key]];
}

+ (NSArray *)handleProtocolForResult:(id)result ForKey:(NSString *)key {
     return [NSArray yy_modelArrayWithClass:[CRFProtocol class] json:[result[@"data"] objectForKey:key]];
}

+ (NSString *)getPageUrl:(id)result {
    NSArray *list = result[@"data"][@"app_open_page"];
    NSDictionary *dict = [CRFUtils isIPhoneXAll] ? list.lastObject : list.firstObject;
    return dict[@"iconUrl"];
}

+ (NSArray<CRFAddress *> *)getAddressList:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFAddress class] json:result[@"data"][@"lsAddress"]];
}

+ (NSArray *)getBankListForResult:(id)result{
    if (!result[kDataKey] && ![result[kDataKey] isKindOfClass:[NSNull class]]) {
        return @[];
    }
    return [NSArray yy_modelArrayWithClass:[CRFBankListModel class] json:result[@"data"][@"supportbanks"]];
}

+ (NSArray <CRFProtocol *>*)getCreateAccountProtool:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFProtocol class] json:result[@"data"][@"open_protocol"]];
}

+ (NSArray <CRFProtocol *> *)getInvestProtocol:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFProtocol class] json:result[@"data"][@"offline_invest_protocal"]];;
}

+(NSArray *)getCashRecord:(id)result{
    return [NSArray yy_modelArrayWithClass:[CRFCashRecordModel class] json:result[@"data"][@"lsRecord"]];
}

+(NSArray*)getMessageList:(id)result{
    return [NSArray yy_modelArrayWithClass:[CRFMessageModel class] json:result[@"data"][@"lsMsg"]];
}

+ (NSArray<CRFMyInvestProduct *> *)myInvestList:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFMyInvestProduct class] json:result[@"data"][@"investList"]];
}

+ (NSArray *)handlerNewsWithResult:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFNewModel class] json:result[kDataKey][@"lsNewsDto"]];
}

+ (NSArray *)handlerAnnouncementWithResult:(id)result {
    return [NSArray yy_modelArrayWithClass:[CRFActivity class] json:result[kDataKey][@"lsAnnouncement"]];
}

+(id)handleDataWithDic:(NSDictionary *)result forClass:(id)item{
    return [item yy_modelWithDictionary:result];
}

@end
