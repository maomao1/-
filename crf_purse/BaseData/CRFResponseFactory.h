//
//  CRFResponseFactory.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFUserInfo.h"
#import "CRFVersionInfo.h"
#import "CRFAppHomeModel.h"
#import "CRFProductModel.h"
#import "CRFProductType.h"
#import "CRFActivity.h"
#import "CRFProtocol.h"
#import "CRFAccountInfo.h"
#import "CRFAddress.h"
#import "CRFBankListModel.h"
#import "CRFCashRecordModel.h"
#import "CRFMessageModel.h"
#import "CRFCouponModel.h"
#import "CRFMyInvestProduct.h"
#import "CRFCardSupportInfo.h"
#import "CRFNewModel.h"
#import "CRFJPushModel.h"
#import "CRFSettingData.h"
#import "CRFBankInfo.h"
#import "CRFAppintmentForwardProductModel.h"

@interface CRFResponseFactory : NSObject


/**
 获取银行卡信息

 @param result json data
 @return list
 */
+ (NSArray <CRFBankInfo *>*)handlerBankInfo:(id)result;

+ (CRFCardSupportInfo*)handleDataForResult:(id)result;
/**
 处理登录接口返回信息

 @param result jsonData
 @return CRFUserInfo
 */
+ (CRFUserInfo*)hadleLoginDataForResult:(id)result;

/**
处理版本接口返回信息
 */
+ (CRFVersionInfo*)hadleVersionDataForResult:(id)result;

+ (NSArray <CRFCouponModel *> *)handleCouponData:(id)result;

/**
 处理首页数据(首页数据结构相似，定义一个model对象)
 */
+ (NSArray *)handleBannerDataForResult:(id)result ForKey:(NSString*)key;

/**
 处理产品数据
 */
+ (NSArray *)handleProductDataForResult:(id)result ForKey:(NSString*)key;
+ (NSArray *)handleProductDataForResult:(id)result WithClass:(id)item ForKey:(NSString*)key;
/**
 返回数组对象
 */
+ (NSArray *)handleDataForResult:(id)result WithClass:(id)item;

/**
 获取协议

 @param result result
 @param key key
 @return list
 */
+ (NSArray *)handleProtocolForResult:(id)result ForKey:(NSString *)key;

/**
 获取开屏页 图片的url

 @param result json
 @return url
 */
+ (NSString *)getPageUrl:(id)result;


/**
 获取用户资产信息

 @param result json
 @return account info
 */
+ (CRFAccountInfo *)getAccountInfo:(id)result;

/**
 <#Description#>

 @param result <#result description#>
 @return <#return value description#>
 */
+ (NSArray <CRFAddress*>*)getAddressList:(id)result;

+ (NSArray *) getBankListForResult:(id)result;

/**
 <#Description#>

 @param result <#result description#>
 @return <#return value description#>
 */
+ (NSArray <CRFProtocol *>*)getCreateAccountProtool:(id)result;

+ (NSArray *)getCashRecord:(id)result;

+ (NSArray *)getMessageList:(id)result;

+ (NSArray <CRFMyInvestProduct *>*)myInvestList:(id)result;

+ (NSArray <CRFProtocol *> *)getInvestProtocol:(id)result;

+ (NSArray *)handlerDiscoveryTopMenus:(id)result;

+ (NSArray *)handlerNewsWithResult:(id)result;

+ (NSArray *)handlerAnnouncementWithResult:(id)result;

+(id)handleDataWithDic:(NSDictionary*)result forClass:(id)item;

@end
