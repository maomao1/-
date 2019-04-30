//
//  CRFHomeConfigHendler.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFProtocol.h"
@interface CRFHomeConfigHendler : NSObject


@property (nonatomic, strong) NSDictionary *localizedHomeDatas;

@property (nonatomic, strong) NSMutableDictionary *homeDataDicM;

@property (nonatomic, strong) NSArray <CRFProtocol *>*createAccountProtocols;

@property (nonatomic, strong) NSArray <CRFProtocol *>*investXjdProtocols;

@property (nonatomic, strong) NSArray <CRFProtocol *>*investLifeProtocols;

@property (nonatomic, strong) NSArray <CRFProtocol *>*investRuleProtocols;

@property (nonatomic, strong) CRFAppHomeModel *bankInfoTipModel;
@property (nonatomic ,strong) NSArray <CRFAppHomeModel*> *authInfoArr;
@property (nonatomic ,strong) NSArray <CRFAppHomeModel*> *authPotocolArr;

@property (nonatomic, strong) NSArray <CRFProtocol *> *applyRegisterProtocols;

@property (nonatomic, strong) NSArray <CRFProtocol *> *applyInvestProtocols;
/**
 合规账单注释说明
 */
@property (nonatomic, strong) CRFAppHomeModel *monthBillTips;

/**
 投资页分类标题
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*productTitleList;

/**
 解析首页活动

 @param response response
 */
- (void)parseActivity:(id)response;

/**
 解析首页配置项

 @param response resoponse
 */
- (void)parseHomeConfig:(id)response;

///**
// 解析首页广告弹窗
// 
// @param response resoponse
// */
//- (void)parseAdConfig:(id)response;
+ (instancetype)defaultHandler;

@end
