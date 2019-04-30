//
//  CRFAppHomeModel.h
//  crf_purse
//
//  Created by maomao on 2017/7/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const kHomePageArea_key       = @"newHomePage";
static NSString *const kDiscoverPageArea_key   = @"|discover|";
static NSString *const kRiskLimitArea_key      = @"RISK_LIMIT";

static NSString *const kCheckSwitch_key        = @"AUDITING_INTERFACE_SWITCH";
static NSString *const kDiscover_banner_key    = @"discover_banner";
static NSString *const banner_key              = @"app_banner";///< banner
static NSString *const bottomList_key          = @"app_block_menu";///< 底部块菜单
static NSString *const newUser_key             = @"app_new_exclusive";///< 新手特享
static NSString *const newUserHelp_key         = @"app_new_help";///< 新手福利帮助
static NSString *const newUserProduct_key      = @"app_new_product";///< 新手推荐产品
static NSString *const topMenu_key             = @"app_top_menu";///< 顶部菜单
static NSString *const oldUserProduct_key      = @"app_old_product";///< 老客户推荐产品
static NSString *const recommendProduct_key      = @"app_recommend_product";///< 推荐产品
static NSString *const popup_key               = @"app_pop_up";///< 弹出窗
static NSString *const suspension_key          = @"app_suspension";///< 悬浮项
static NSString *const home_about_crfchina_key = @"app_home_about_crfchina";///<首页关于信而富
static NSString *const home_platform_data_key  = @"standard_show";///<首页平台数据


static NSString *const kBankInfoTipsKey = @"app_cgbank_name";

static NSString *const kBankDatasJsonKey = @"card_bin_list";

static NSString *const kUserActivityKey = @"activity";
static NSString *const kUserUsuallyKey  = @"app_top_usually_menu";
static NSString *const kBankAuthKey     = @"app_bankauth_tips";///<银行提示认证
static NSString *const kPotocolAuthKey  = @"xy_auth_list";///<协议提示认证
//合规账单注释说明
static NSString *const kMonthBillTipsKey = @"month_tips";
static NSString *const kRegisterUserKey = @"xinshou_register";
static NSString *const kOpenAccountKey  = @"xinshou_openaccount";
static NSString *const kInvestmentKey   =  @"xinshou_investment";
//主包审核时注册协议
static NSString *const kApplyRegisterProtocol = @"investment_register_agreement_main_package";
//主包审核时出资协议
static NSString *const kApplyInvestProtocol = @"investment_agreement_main_package";
//static NSString *const kProtoclCash = @"xjd_invest_protocal";///<现金贷协议
//static NSString *const kProtoclLife = @"offline_invest_protocal";///<生活贷协议

static NSString *const kProductTitleListKey = @"product_category_period";

static NSString *const kProductExclusivePlanKey = @"product_exclusive_plan";


@interface CRFAppHomeModel : NSObject<NSCoding>
@property (nonatomic ,copy) NSString      * iconUrl; ///<图片地址
@property (nonatomic ,copy) NSString      * name  ;  ///<图片名字(或认证协议名字)
@property (nonatomic ,copy) NSString      * jumpUrl; ///<图片链接地址（认证协议地址）
@property (nonatomic ,copy) NSString      * urlKey;  ///<xinshou_register 新手注册 xinshou_openaccount新手开户xinshou_investment新手出资
@property (nonatomic ,copy) NSString      * url;

@property (nonatomic, copy) NSString *content;///<（认证提示）
@property (nonatomic, copy) NSString *subContent;
@property (nonatomic, copy) NSString *funcName;
@property (nonatomic, copy) NSString *time;///<
@property (nonatomic, copy) NSString *title;///<


@property (nonatomic, copy) NSString *path;


@end
