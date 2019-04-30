//
//  AppDelegate+Service.m
//  crf_purse
//
//  Created by mystarains on 2018/11/7.
//  Copyright © 2018 com.crfchina. All rights reserved.
//

#import "AppDelegate+Service.h"

@implementation AppDelegate (Service)

- (void)channelDrainageCallBack{

    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kChannelDrainagePath),[CRFAppManager defaultManager].clientInfo.idfa] success:^(CRFNetworkCompleteType errorType, id response) {
        
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        
    }];
}
@end
