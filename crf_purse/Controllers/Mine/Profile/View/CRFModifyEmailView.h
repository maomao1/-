//
//  CRFModifyEmailView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@interface CRFModifyEmailView : CRFBasicView

- (instancetype)initWithLinkUrl:(NSString *)linkUrl;

- (void)show:(void(^)(void))handler;

@end
