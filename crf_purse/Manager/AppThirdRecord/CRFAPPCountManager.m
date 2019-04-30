//
//  CRFAPPCountManager.m
//  crf_purse
//
//  Created by maomao on 2017/9/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAPPCountManager.h"

@implementation CRFAPPCountManager
+(instancetype)sharedManager{
    static CRFAPPCountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CRFAPPCountManager alloc]init];
    });
    return manager;
}

- (void)crf_pageViewEnter:(NSString*)pageTitle{
    [MobClick beginLogPageView:pageTitle];
}

- (void)crf_pageViewEnd:(NSString *)pageTitle{
    [MobClick endLogPageView:pageTitle];
}

+(void)setEventID:(NSString*)eventId EventName:(NSString*)eventName{
    DLog(@"埋点事件ID:%@事件名称：%@",eventId,eventName)
    [MobClick event:eventId label:eventName];
}

#pragma =======自定义方法与vc绑定======
+ (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FucEvent" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
+(void)crf_setupWithConfiguration{
    NSDictionary *configs = [self dictionaryFromUserStatisticsConfigPlist];
    for (NSString *className in configs) {
        Class clazz = NSClassFromString(className);
        NSDictionary *config = configs[className];
        if (config[CRFLoggingTrackedEvents]) {
            for (NSDictionary *event in config[CRFLoggingTrackedEvents]) {
                SEL selector = NSSelectorFromString(event[CRFLoggingSelectorName]);
                [clazz aspect_hookSelector:selector
                               withOptions:AspectPositionAfter
                                usingBlock:^(id<AspectInfo> aspectInfo) {
                                    DLog(@"埋点拦截方法 %@-%@",event[CRFLoggingFuncName],event[CRFLoggingSelectorName]);
                                    [self setEventID:event[CRFLoggingEventID] EventName:event[CRFLoggingFuncName]];
                                } error:NULL];
            }
        }
    }
}
//
+(void)getEventIdForKey:(NSString *)keyName{
    NSDictionary *dic = @{@"设备管理"   :@"MYSETTING_MANAGER_DEVICE",
                          @"意见反馈"   :@"MYSETTING_FEEDBACK_EVENT",
                          @"关于我们"   :@"MYSETTING_ABOUTMINE_EVENT",
                          @"推送提醒"   :@"MYSETTING_PUSH_NOTICE_EVENT",
                          @"清除缓存"   :@"MYSETTING_CLEAR_EVENT",
                          @"版本说明"   :@"ABOUTMINE_VERSION_NOTES",
                          @"软件评分"   :@"ABOUTMINE_MARK_EVENT",
                          @"检测更新"   :@"ABOUTMINE_CHECT_UPDATE_EVENT",
                          @"修改登录密码":@"MYSETTING_MODIYPWD_EVENT",
                          @"我的投资"   :@"MINE_INVEST_EVENT",
                          @"优惠红包"  :@"MINE_REDENVELOPE_EVENT",
                          @"消息中心"   :@"MINE_MESSAGE_CENTER_EVENT",
                          @"我的客服"   :@"MINE_SERVICES_EVENT",
                          @"我的设置"   :@"MINE_SETTING_EVENT",
                          @"个人资料头像":@"PROFILE_AVATER_EVENT",
                          @"手机号"     :@"PROFILE_MOBILEPHONE_EVENT",
                          @"姓名"       :@"PROFILE_NAME_EVENT",
                          @"身份证"     :@"PROFILE_IDENTIFYCARD_EVENT",
                          @"银行卡"     :@"PROFILE_BANKCARD_EVENT",
                          @"风险测评"   :@"PROFILE_TESTSCORE_EVENT",
                          @"邮箱"      :@"PROFILE_MAIL_EVENT",
                          @"收货地址"   :@"PROFILE_ADRESS_EVENT",
                          @"出借人服务协议":@"MINE_INVEST_SERVICE_AGREEMENT",
                          @"资金退出记录":@"MINE_INVEST_SERVICE_AGREEMENT",
                          @"出借账单"   :@"MINE_INVEST_BILLS_EVENT",
                          @"债权明细"   :@"MINE_INVEST_CREDITO_EVENT",
                          
                          @"电话客服"   :@"MINE_SERVICES_EVENT",
                          @"理财顾问"   :@"MINE_ADVISER_EVENT",
                          @"在线客服"   :@"MINE_ONLINE_CUSTOMER_EVENT",
                          };
    NSString *eventId  = [dic objectForKey:keyName];
    [self setEventID:eventId EventName:keyName];
}

+ (void)setFailedEventID:(NSString *)eventID reason:(NSString *)reason productNo:(NSString *)productNo{
    if ([[CRFAppManager defaultManager].userInfo.phoneNo isEmpty]) {
        return;
    }
    [MobClick event:eventID attributes:@{@"账号":[CRFAppManager defaultManager].userInfo.phoneNo,@"时间":[CRFTimeUtil getCurrentDate],@"原因":reason, @"产品编号":productNo}];
}
+(void)setEventFailed:(NSString*)eventId reason:(NSString *)reason{
    [MobClick event:eventId attributes:@{@"原因":reason}];
//    [MobClick event:eventId label:reason];
}
@end
