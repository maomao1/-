//
//  AppDelegate+Version.m
//  crf_purse
//
//  Created by SHLPC1321 on 2017/7/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "AppDelegate+UpdateVersion.h"
#import "CRFSettingData.h"
#import "CRFUpdateView.h"

@implementation AppDelegate (UpdateVersion)
#pragma mark - 版本更新 methods
- (void)versionUpgrade {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[CRFAppManager defaultManager].clientInfo.os forKey: @"mobileOs"];//手机系统，Android、IOS
    [param setValue:[NSString getAppId] forKey:@"packageName"];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kUpVersionPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"check new version failed !");
    }];
}

- (void)parseResponse:(id)response {
    NSLog(@"check new version, info is %@",response);
    NSDictionary *resultDic = (NSDictionary*)response;
    NSString  *status = resultDic[kResult];
    if ([status isEqualToString:kSuccessResultStatus]) {
       CRFVersionInfo *versionInfo = [CRFResponseFactory hadleVersionDataForResult:response];
        if (versionInfo.versionCode.integerValue > [[CRFAppManager defaultManager].clientInfo.versionCode integerValue]) {
            CRFUpdateView *alertView = [[CRFUpdateView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) Title:@"新版本介绍" Content:versionInfo.appTips IsForce:versionInfo.level ClickCallBack:^{
                if ([versionInfo.appLink isKindOfClass: [NSString class]]) {
                    if ([versionInfo.appLink hasPrefix: @"http://"] || [versionInfo.appLink hasPrefix: @"https://"]) {
                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: versionInfo.appLink]];
                    }
                    if ([versionInfo.level isEqualToString:@"1"]) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            exit(0);
                        });
                    }
                }
            } CancelCallBack:^{
                [CRFSettingData setToastedVersionDialog:YES];
            } IsHome:YES];
            if ([versionInfo.level isEqualToString:@"1"]||![CRFSettingData isToastedVersionDialog]) {
                [alertView show];
            }
        }
    } else {
         NSLog(@"check new version failed !");
    }
}
@end
