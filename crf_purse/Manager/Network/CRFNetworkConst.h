//
//  CRFNetworkConst.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//


#ifndef CRFNetworkConst_h
#define CRFNetworkConst_h
#import <Foundation/Foundation.h>

/*
 kHostPath 主机地址
 kTransformProtocol  传输协议
 kBaseHttpPath  请求拼接url
 kH5DomainPath  h5的主机地址
 */

//ci  开发环境
#ifdef CI
//合规：10.194.68.108:8080 10.194.11.227  10.194.61.136
static NSString *const kHostPath = @"10.194.61.136:8080";

static NSString *const kTransformProtocol = @"http";

static NSString *const kBaseHttpPath = @"%@://%@/webp2p_interface_mysql/%@";

static NSString *const kH5DomainPath = @"financeapp-static-ci.crfchina.com";

static NSString *const kOnlineCustomerService =@"https://m-uat.crfchina.com/mci_front/start.html?guestid=%@&name=%@&app=2";


// 内网测试环境
#elif UAT
//static NSString *const kTransformProtocol = @"http";
//static NSString *const kHostPath =@"10.194.11.227:8070";
//static NSString *const kHostPath =@"10.194.11.201:8070";//缪长伟
// 10.194.62.136:8080,10.194.69.108
//static NSString *const kHostPath =@"10.194.11.230:8070";//王建
static NSString *const kHostPath = @"financeapp-static-bruat.crfchina.com";

static NSString *const kBaseHttpPath = @"%@://%@/webp2p_interface_mysql/%@";

static NSString *const kTransformProtocol = @"https";
/*
 (非合规)financeapp-static-uat.crfchina.com。  10.194.69.51:8080
 */
static NSString *const kH5DomainPath = @"financeapp-static-bruat.crfchina.com"/* @"financeapp-static-brtest.crfchina.com"*/;

static NSString *const kOnlineCustomerService =@"https://m-bruat.crfchina.com/mci_front/start.html?guestid=%@&name=%@&app=2";

// 外网测试环境
#elif PRE

static NSString *const kTransformProtocol = @"https";
static NSString *const kHostPath = @"financeapp-static-uat.crfchina.com";
//static NSString *const kHostPath =@"10.194.11.201:8070";//缪长伟

static NSString *const kBaseHttpPath = @"%@://%@/webp2p_interface_mysql/%@";

//PRE:financeapp-static-uat.crfchina.com  合规：financeapp-static-brtest.crfchina.com。10.194.69.51:8080/10.194.11.227:8070
//PRE:financeapp-static-uat.crfchina.com  合规：financeapp-static-brtest.crfchina.com
static NSString *const kH5DomainPath = @"financeapp-static-uat.crfchina.com";
static NSString *const kOnlineCustomerService =@"https://m-uat.crfchina.com/mci_front/start.html?guestid=%@&name=%@&app=2";

#else
//生产环境

static NSString *const kTransformProtocol = @"https";

static NSString *const kBaseHttpPath = @"%@://%@/webp2p_interface_mysql/%@";

static NSString *const kHostPath =@"financeapp.crfchina.com";

static NSString *const kH5DomainPath = @"financeapp-static.crfchina.com";

static NSString *const kOnlineCustomerService =@"https://m.crfchina.com/mci_front/start.html?guestid=%@&name=%@&app=2";

#endif

static NSString *const kH5DetailPath = @"%@://%@";

#define kMonthPaymentDetailH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"monthPayment?investNo=%@"]
/**
 产品详情页。h5
 
 @param a 产品编号
 @return url
 */
#define kInvsetDetailH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/invests_detail.html?contractPrefix=%@"]
#define kDebtDetailH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"app/transfer/detail?transferingNo=%@&rightsNo=%@"]
/**
 产品详情页。h5(马甲包)
 
 @param a 产品编号
 @return url
 */
#define kMJInvsetDetailH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/invest_detail_mjb.html?contractPrefix=%@"]

/**
 产品详情页。h5(主包审核包)
 
 @param a 产品编号
 @return url
 */
#define kApplyInvsetDetailH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/invests_detail_sh.html?contractPrefix=%@"]

/**
 拼接请求地址
 
 @param a 具体地址
 @return url
 */
#define APIFormat(a)     [NSString stringWithFormat:kBaseHttpPath,kTransformProtocol,kHostPath,a]

/**
 拼接h5`s URL
 
 @return url
 */
#define kH5DetailFormatPath [NSString stringWithFormat:kH5DetailPath,@"https",kH5DomainPath]

/**
 测评结果1
 
 @return url
 */
#define kEvaluatingResult1H5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/evaluating/evaluating_result1.html"]

/**
 马甲包的开户协议
 
 @return url
 */
#define kOpenAccountProtocolH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/agreement/threeParty.html"]

/**
 测评结果2
 
 @return url
 */
#define kEvaluatingResult2H5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/evaluating/evaluating_result2.html"]

/**
 测评结果3
 
 @return url
 */
#define kEvaluatingResult3H5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/evaluating/evaluating_result3.html"]

/**
 新手帮助
 
 @return url
 */
#define kHomeHelpH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/banner/welfare.html"]
/**
 转账充值操作示范
 
 @return url
 */
#define kQuickHandleH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/appAudit/handle_rule.html"]

/**
 红包优惠券
 
 @return url
 */
#define kRedAndCouponH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/redPacket/yh_redPacket.html"]

/**
 红包使用帮助
 
 @return url
 */
#define kCouponUseExplainH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/redPacket/Instructions.html"]

/**
 版本说明
 
 @return url
 */
#define kVersionExplainH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/versionNo/versionNo.html"]

/**
 了解兑换码
 
 @return url
 */
#define kKnowCouponCodeH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/redPacket/code.html"]

/**
 风险揭示书加载页面
 
 @return url
 */
#define kRiskRevealH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/evaluating/evaluating_result.html"]
#define kRiskAgainH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/evaluating/evaluating.html"]

/**
 投资测评
 
 @return url
 */
#define kInvestTestH5 [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/evaluating/evaluating.html"]

/**
 关于我们
 
 @return url
 */
#define kHomeAboutMineH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/tab/aboutus.html"]

/**
 关于我们(马甲)
 
 @return url
 */
#define kApplyHomeAboutMineH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/appAudit/aboutUs.html"]

/**
 系统维护公告
 
 @return url
 */
#define kSystemNoticeH5  [NSString stringWithFormat:@"%@/%@",kH5DetailFormatPath,@"webp2p_static/invests/views/404/notice.html"]

/*
 版本更新
 */
static NSString *const kUpVersionPath = @"app/version/query";

/*
 上传奔溃日志
 */
static NSString *const kErrorLogPath = @"app/errorlog";

/*
 用户登录
 */
static NSString *const kUserLoginPath = @"auth/login";

/*
 检查手机号是否注册
 */
static NSString *const kCheckVerifyCodePath = @"auth/register/check";

/*
 设置密码
 */
static NSString *const kSetPwdPath = @"auth/register/mobilePhone";

/*
 发送验证码（无token验证）
 */
static NSString *const kSendVerifyCodePath = @"sms/verifycode";

/*
 发送验证码 （有token验证）
 */
static NSString *const kSendTransformVerifyCodePath = @"sms/verifycode/%@/token";

/*
 忘记密码时，检查手机号是否被注册
 */
static NSString *const kForgetPwdPath = @"auth/resetPwd/check";

/*
 重置密码
 */
static NSString *const kResetPwdPath = @"auth/resetPwd/modify";

/*
 图形验证码
 */
static NSString *const kGraphicCaptchaPath = @"sms/graphicCaptcha/%@";

/*
 修改密码
 */
static NSString *const kModifyPwdPath = @"auth/modifyPwd/%@";
/*
 获取协议认证验证码
 */
static NSString *const kCardSignedPath = @"%@/queryCardPrepareSigned";
/*
 确认协议认证验证码
 */
static NSString *const kConfirmSignedPath = @"%@/queryCardConfirmSigned";
/*
 用户登出
 */
static NSString *const kLogoutPath = @"auth/logout/%@";

/*
 校验登录接口
 */
static NSString *const kVerifyLoginPath = @"auth/login/smsCode";

/*
 上传头像
 */
static NSString *const kUploadImagePath = @"file/imageUpload/%@";

/*
 获取用户总资产
 */
static NSString *const kGetUserAssetsTotalPath = @"investment/my/%@/assetsTotal";

/*
 获取用户信息
 */
static NSString *const kGetUserInfoPath = @"auth/userinfo/%@";

/*
 获取设备列表
 */
static NSString *const kGetDevicesInfoPath = @"app/binding/%@/device";

/*
 获取用户消息
 */
static NSString *const kGetMessagePath = @"app/message/%@";
/*
 删除消息
 */
static NSString *const kDeleteMessagePath = @"app/message/%@/delete";
/*
 设置消息已读状态
 */
static NSString *const kSetMessageStatusPath = @"app/message/%@/read";

/*
 获取未读消息
 */
static NSString *const kGetUnreadMessagePath = @"app/message/%@/unread/list";

/*
 获取APS出资动态
 */
static NSString *const kProductDynamicPath = @"investment/product/%@/dynamic";

/*
 获取FTS出资动态
 */
static NSString *const kFTSProductDynamicPath = @"investment/fts/%@/dynamic";

/*
 获取NCP出资动态
 */
static NSString *const kNCPProductDynamicPath = @"investment/ncp/%@/dynamic";
/*
 获取首页配置信息
 */
static NSString *const kHomeConfigPath = @"apppageconfig/getAppHomeConfig";

/*
 获取首页配置信息(权限配置)
 */
static NSString *const kAppHomeConfigPath = @"apppageconfig/getAppPageConfig";

/*
 获取首页产品列表
 */
static NSString *const kHomeProductsListPath = @"apppageconfig/getAppHomeProductList?customerUid=%@";

/*
 获取首页公告
 */
static NSString *const kHomeAnnouncementPath = @"announcement/getAnnouncementList";

/*
 获取产品列表
 */
static NSString *const kInvestProductListPath = @"investment/product/list";
/*
 获取合规产品列表
 */
static NSString *const kInvestNewProductList     = @"investment/product/newlist";
/*
 2018-4-9  合规产品列表 更换
 */
static NSString *const kInvestNewProductListPath     = @"investment/product/queryProductList";
/*
 获取定制产品列表
 */
static NSString *const kExclusiveProductList     = @"investment/my/%@/getCustomizeList";
static NSString *const kInvestContinutionPath     = @"/invest/%@/investContinuation";
/*
 获取债权列表
 */
static NSString *const kDebtListPath        = @"investment/queryInvestDebtList";
/*
 查询提前退出信息
 */
static NSString *const kQueryRedeemInfoPath = @"investment/my/%@/queryRedeem";

/*
 查询可转投金额
 */
static NSString *const kQueryAppointmentForwardAmountPath = @"investment/%@/subscribe/queryPreclearInvestAmount";

/*
 提前退出
 */
static NSString *const kAdvanceRedeemPath = @"invest/%@/earlyRedeem";

/*
 获取产品详情
 */
static NSString *const kInvestProductDetailUrlPath = @"investment/product/%@/detail";
/*
 获取开屏页
 */
static NSString *const kGetAppPageConfigPath = @"apppageconfig/getAppPageConfig/%@";

/*
 意见反馈
 */
static NSString *const kFeedbackPath = @"app/feedback/%@";

/*
 修改用户信息
 */
static NSString *const kModifyUserInfoPath = @"auth/modify/%@";

/*
 修改邮箱
 */
static NSString *const kModifyEmailPath = @"account/certification/%@/email";

/*
 添加收货地址
 */
static NSString *const kAddAddressPath = @"account/address/%@/add";

/*
 获取收获地址列表
 */
static NSString *const kGetAddressListPath = @"account/address/%@/list";

/*
 更新收获地址
 */
static NSString *const kUpdateAddressPath = @"account/address/%@/update/%@";

/*
 更改用户银行预留手机号
 */
static NSString *const kChangeMoblePhonePath = @"account/verify/phone";

/*
 开户
 */
static NSString *const kCreateAccountPath = @"account/open/%@";

/*
 检查用户开户状态
 */
static NSString *const kCheckUserAccountStatusPath = @"account/fuiou/userinfo";

/*
 关联开户
 */
static NSString *const kRelateAccountPath = @"account/link/%@";

/*
 充值
 */
static NSString *const kRechargePath = @"account/entrust/%@/recharge";
/*
 转账充值
 */
static NSString *const kQuickRechargePath = @"account/%@/rechargeTransfer";

/*
 提现
 */
static NSString *const kDrawPath     = @"account/entrust/%@/withdraw";

/*
 投资记录列表
 */
static NSString *const kInvestRecordPath = @"investment/product/record";

/*
 获取优惠券列表
 */
static NSString *const kCouponPath  = @"activity/%@/findGiftCouponList";

/*
 出资
 */
static NSString *const KInvestMoneyPath = @"investment/%@/invest";

/*
 获取支持银行列表、额度
 */
static NSString *const kSupportBanklistPath = @"account/support/banklist";

/*
 获取银行卡片信息
 */
static NSString *const kBankcardInfoPath = @"account/cardinfo";

/*
 充值提现记录
 */
static NSString *const kAccountRecordListPath = @"account/transfer/%@/record";

/*
 获取我的出资列表
 */
static NSString *const kInvestListPath = @"investment/my/%@/investlist";

/*
 获取出资产品详情
 */
static NSString *const kInvestProductDetailPath = @"investment/my/%@/detail";

/*
 FTS账单
 */
static NSString *const kInvestBillPath = @"investment/my/%@/ftsbill";

/*
 APS账单
 */
static NSString *const kInvestOffLineBillPath = @"investment/my/%@/offlinebill";

/*
 获取预约转投详情
 */
static NSString *const kGetAppointmentForwardDetailPath = @"investment/%@/subscribe/querySubscribeInvestDetail";

/*
 取消预约
 */
static NSString *const kCancelAppointmentForwardPath = @"investment/%@/subscribe/cancel";

/*
 预约转投
 */
static NSString *const kAppointmentForwardPath = @"invest/%@/subscribe/saveSubscribeInvest";
/*
 获取预约转投产品列表（包含续投产品)
 */
static NSString *const kAppointmentContainAssignProductPath = @"investment/my/%@/getTransferListNew";

/*
 FTS债权
 */
static NSString *const kInvestftsdebtPath = @"investment/my/%@/ftsdebt";

/*
 NCP(合规)出借账单
 */
static NSString *const kInvestNCPBillPath = @"investment/my/%@/ncpbill";

/*
 NCP(合规)债权列表
 */
static NSString *const kInvestNCPDebtPath = @"investment/my/%@/ncpdebt";

/*
 APS债权
 */
static NSString *const kInvestOffLinedebtPath = @"investment/my/%@/offlinedebt";

/*
 获取转投产品
 */
static NSString *const kGetTransferPath = @"investment/product/list/%@/transfer";

/*
 产品退出
 */
static NSString *const kProductRedemptionPath = @"investment/my/%@/redemption";

/*
 退出记录
 */
static NSString *const kProductLogoutPath = @"investment/my/%@/redemption/detail";

/*
 转投
 */
static NSString *const kTrandferProductPath = @"investment/my/%@/product/transfer";

/*
 分月回款明细
 */
static NSString *const kReceiveCashDetailPath = @"investment/my/%@/%@/%@/%@";
/*
 APS出资动态
 */
static NSString *const kInvestOfflineDynamicPath = @"investment/offline/%@/dynamic";
/*
 发现banner
 */
static NSString *const kDiscoveryBannerPath = @"apppageconfig/getAppPageConfig/discover_banner";
/*
 发现memu
 */
static NSString *const kDiscoveryTopPath = @"apppageconfig/getAppPageConfig/discover_menu";
/*
 发现新memu(3.2.0版)
 */
static NSString *const kDiscoveryNewTopPath = @"apppageconfig/getAppPageConfig/discover_new_menu";
/*
 发现新闻
 */
static NSString *const kDiscoveryTrendsPath = @"discovery/news/trends";

/*
 获取转投协议
 */
static NSString *const kInvistingURLPath = @"app/my/%@/inviting";

/*
 恒丰授权接口
 */
static NSString *const kAuthBankPath  = @"app/tograntauthorization/%@";

/*
 新合规授权接口
 */
static NSString *const kAuthProtocolPath  = @"app/toProtocolValidation/%@";

/*
 获取转投匹配计划列表
 */
static NSString *const kGetAppointmentForwardPath = @"investment/my/%@/getTransferList";

/*
 兑换优惠券
 */
static NSString *const kConvertCouponPath = @"activity/%@/exchangeCoupons/%@";
/*
 获取可用优惠券
 */
static NSString *const  kGetUserGiftPath = @"activity/%@/getGiftDetailList?status=1";
/*
 刷新token
 */
static NSString *const kRefreshTokenPath = @"auth/token/%@/refresh";

/*
 更换银行卡
 */
static NSString *const kChangeBankCardPath = @"account/changeCard/%@";
/*
 欲更换银行卡（获取验证码）
 */
static NSString *const kGetChangeBankCardCodePath = @"%@/prepareChangeCard";
/*
 确认更换银行卡
 */
static NSString *const kConfirmChangeBankCardPath = @"%@/confirmChangeCard/%@";
/*
 获取银行卡列表
 */
static NSString *const kGetBankCardListPath = @"account/queryChangeCard/%@";
/*
 马甲包新闻列表
 */
static NSString *const kMJDiscoveryPath = @"discovery/news/trends/mj";

/*
 获取出借额度
 */
static NSString *const kUserLimitQuota  = @"account/%@/queryLimitQuota";

/*
 积分墙回调接口
 */
static NSString *kChannelDrainagePath  = @"channelDrainage/callback/%@";
/*
 查询借款人信息
 */
static NSString *kFindDisclosureePath  = @"investment/findDisclosure";
/*
 分段计息详情信息
 */
static NSString *kDrawSegDetailPath  = @"/invests/interestDetail/%@/%@/%@/%@";

/*
 查看消息详情
 */
static NSString *kMessageDetailPath  = @"app/messageDetail/%@/%@";
/*
 根据批次号获取ID详情
 */
static NSString *kFindAnnouncementDetailPath  = @"announcement/findAnnouncementDetail/%@";


//const

static NSString *const kVerifyId = @"verifyId";
static NSString *const kMobilePhone = @"mobilePhone";
static NSString *const kResult = @"result";
static NSString *const kVerifyCode = @"verifyCode";
static NSString *const kLoginPwd = @"loginPwd";
static NSString *const kPicCode = @"picCode";
static NSString *const kIntent = @"intent";
static NSString *const kVerifyCodeType = @"type";
static NSString *const kNewPwd = @"newPwd";
static NSString *const kDataKey = @"data";
static NSString *const kSuccessResultStatus = @"0000";
static NSString *const kMessageKey = @"message";
static NSString *const kAccessTokenKey = @"accessToken";
static NSString *const kPageSizeKey = @"pageSize";
static NSString *const kPageNumberKey = @"pageNumber";
static NSString *const kMjStatus = @"mjStatus";

static NSString *const exclusive_key  = @"exclusive_plan";
/**
 H5需要的信息
 
 @return info
 */
#define kH5NeedHeaderInfo  [NSString stringWithFormat:@"accessToken=%@&deviceno=%@&packageName=%@&mobileOs=%@&customerUid=%@&version-code=%@&uuid=%@",[CRFAppManager defaultManager].userInfo.accessToken,[CRFUserDefaultManager getDeviceUUID],[NSString getAppId],[CRFAppManager defaultManager].clientInfo.os,[CRFAppManager defaultManager].userInfo.customerUid,[CRFAppManager defaultManager].clientInfo.versionCode,[CRFAppManager defaultManager].userInfo.userId]

static NSString *const kErrorDataKey = @"com.alamofire.serialization.response.error.data";
//com.alamofire.serialization.response.error.data
static NSString *const kErrorCodekey = @"com.alamofire.serialization.response.error.response";

//异常信息
static NSString *const kChangeDevice     = @"FUS_1101";///<不同设备登录或者异地登录,需要输入验证码
static NSString *const kTokenExceptionKey = @"FUS_2010";


//各大市场 appid。key
static NSString *const kUmengAppKey =@"59954b66ae1bf855d7000e45";
//@"59954b66ae1bf855d7000e45";
//static NSString *const kBaiduMobKey =@"e13e79bd75";
//@"e13e79bd75";

#ifdef WALLET
static NSString *const kChannelId   = @"AppStore_钱包";
#else
static NSString *const kChannelId   = @"AppStore";
#endif

/*
 马甲包提交app审核时的测试手机号(18964847377文超。 18565865748姜旺)
 */
static NSString *const kTestMoblePhone = @"18768812831";



/**
 type
 
 - CRFNetworkCompleteTypeSuccess: 请求成功
 - CRFNetworkCompleteTypeFailure: 请求失败
 - CRFNetworkCompleteCancelled: 请求取消
 */
typedef NS_ENUM(NSInteger,CRFNetworkCompleteType) {
    CRFNetworkCompleteTypeSuccess    =             0,
    CRFNetworkCompleteTypeFailure    =             1,
    CRFNetworkCompleteCancelled      =             2
};


/*
 网络请求完成后，处理返回数据的Block;
 
 @param errorType CRFNetworkCompleteType
 @param response
 CRFNetworkCompleteTypeSuccess -> http response
 CRFNetworkCompleteTypeFailure | CRFNetworkCompleteCancelled -> error <NSError>
 */

typedef void(^CRFNetworkCompleteBlock) (CRFNetworkCompleteType errorType, id response);


typedef void(^CRFNetworkRefreshTokenCompleteBlock) (CRFNetworkCompleteType errorType, id response, id target);

/**
 失败回调
 
 @param errorType 失败类型
 @param response 失败结果
 */
typedef void(^CRFNetworkFailedBlock) (CRFNetworkCompleteType errorType, id response);


/**
 网络是否可用
 */
typedef struct {
    NSUInteger status; //网络状态
    BOOL available; //是否可用
} ReachabilityAvailable;


typedef NS_ENUM(NSUInteger, CRFForwardProductType) {
    CRFForwardProductTypeAppointmentForward         = 0,//预约转投
    CRFForwardProductTypeAutoInvest                 = 1,//自动续投
};

#endif /* CRFNetworkConst_h */
