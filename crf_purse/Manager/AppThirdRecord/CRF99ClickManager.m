//
//  CRF99ClickManager.m
//  crf_purse
//
//  Created by maomao on 2017/9/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRF99ClickManager.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation CRF99ClickManager
+(void)initSDK{
    //打印 SDK 执行信息,发布 APP 时一定要将该方法设置为 false
#ifdef DEBUG
    [AppTrack setShowLog:YES];
#else
    [AppTrack setShowLog:NO];
#endif
    [AppTrack setOzAppVer:[CRFAppManager defaultManager].clientInfo.versionCode]; //设置 APP 版本信息
    NSLog(@"99 click channel id is %@",kChannelId);
    [AppTrack setOzChannel:kChannelId]; //设置 APP 分发渠道信息
    NSString *adi = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [AppTrack setOzaid:adi]; //获取设备 IDFA
    [AppTrack setOpenIntervalSecond:30]; //设置 APP 被覆盖后转入后台运行指定时间时期记为一次启动
    [AppTrack countAppOpen];//统计 APP 打开次数并初始化 SDK
}
@end
