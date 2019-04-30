//
//  CRFHomeConfigHendler.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeConfigHendler.h"
#import "CRFFilePath.h"
#import "CRFAppCache.h"
@interface CRFHomeConfigHendler()

@property (nonatomic, copy) void (^(getInvestProtocolHandler))(BOOL success);
@end

@implementation CRFHomeConfigHendler

+ (instancetype)defaultHandler {
    static CRFHomeConfigHendler *handler = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (NSDictionary *)localizedHomeDatas {
    return [CRFAppCache getHomeInfo];
}

- (NSMutableDictionary *)homeDataDicM {
    if (!_homeDataDicM) {
        _homeDataDicM = [CRFAppCache getHomeInfo];
    }
    return _homeDataDicM;
}

- (void)parseActivity:(id)response {
    [self.homeDataDicM setValue:[CRFResponseFactory handleDataForResult:response WithClass:[CRFActivity class]] forKey:kUserActivityKey];
    [CRFAppCache setHomeInfoDic:self.homeDataDicM];
}
//-(void)parseAdConfig:(id)response{
//    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:popup_key] forKey:popup_key];
//    [CRFAppCache setHomeInfoDic:self.homeDataDicM];
//}
- (void)parseHomeConfig:(id)response {
    //banner
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:banner_key] forKey:banner_key];
    self.bankInfoTipModel = [[CRFResponseFactory handleBannerDataForResult:response ForKey:kBankInfoTipsKey] firstObject];
    self.productTitleList = [CRFResponseFactory handleBannerDataForResult:response ForKey:kProductTitleListKey];
    self.authInfoArr =[CRFResponseFactory handleBannerDataForResult:response ForKey:kBankAuthKey];
    self.authPotocolArr =[CRFResponseFactory handleBannerDataForResult:response ForKey:kPotocolAuthKey];
    self.monthBillTips = [[CRFResponseFactory handleBannerDataForResult:response ForKey:kMonthBillTipsKey] firstObject];
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:kPotocolAuthKey] forKey:kPotocolAuthKey];
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:kCheckSwitch_key] forKey:kCheckSwitch_key];
    //footerview 数据
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:bottomList_key] forKey:bottomList_key];
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:kProductExclusivePlanKey] forKey:kProductExclusivePlanKey];
    
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:home_platform_data_key] forKey:home_platform_data_key];
    //
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:home_about_crfchina_key] forKey:home_about_crfchina_key];
    //新手特享
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:newUser_key] forKey:newUser_key];
    //新手福利帮助
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:newUserHelp_key] forKey:newUserHelp_key];
    //
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:topMenu_key] forKey:topMenu_key];
    //
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:popup_key] forKey:popup_key];
    [self.homeDataDicM setValue:[CRFResponseFactory handleBannerDataForResult:response ForKey:suspension_key] forKey:suspension_key];
    
    [self.homeDataDicM setValue:[CRFResponseFactory handleProtocolForResult:response ForKey:kRegister_protocolKey] forKey:kRegister_protocolKey];
    [self.homeDataDicM setValue:[CRFResponseFactory handleProtocolForResult:response ForKey:kInvestmenttranser_protocolKey] forKey:kInvestmenttranser_protocolKey];
    [self.homeDataDicM setValue:[CRFResponseFactory handleProtocolForResult:response ForKey:kDebttransfer_protocalKey] forKey:kDebttransfer_protocalKey];
    //协议
    [self.homeDataDicM setValue:[CRFResponseFactory handleProtocolForResult:response ForKey:kXjd_invest_protocal] forKey:kXjd_invest_protocal];
    [self.homeDataDicM setValue:[CRFResponseFactory handleProtocolForResult:response ForKey:kOffline_invest_protocal] forKey:kOffline_invest_protocal];
    [self.homeDataDicM setValue:[CRFResponseFactory handleProtocolForResult:response ForKey:kRule_invest_protocal] forKey:kRule_invest_protocal];
    
    self.investXjdProtocols = [self.homeDataDicM objectForKey:kXjd_invest_protocal];
    self.investLifeProtocols = [self.homeDataDicM objectForKey:kOffline_invest_protocal];
    self.investRuleProtocols = [self.homeDataDicM objectForKey:kRule_invest_protocal];
    self.createAccountProtocols = [CRFResponseFactory handleProtocolForResult:response ForKey:@"open_protocol"];
    self.applyRegisterProtocols = [CRFResponseFactory handleProtocolForResult:response ForKey:kApplyRegisterProtocol];
    self.applyInvestProtocols = [CRFResponseFactory handleProtocolForResult:response ForKey:kApplyInvestProtocol];
    [CRFAppCache setHomeInfoDic:self.homeDataDicM];
}

@end
