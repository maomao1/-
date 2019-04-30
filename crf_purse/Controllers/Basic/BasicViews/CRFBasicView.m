//
//  CRFBasicView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@implementation CRFBasicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(resourceDidUpdate) name:kReloadResourceNotificationName];
    }
    return self;
}

- (void)resourceDidUpdate {
    
}

@end
