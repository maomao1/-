//
//  CRFDepositAccountHeaderView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@interface CRFDepositAccountHeaderView : CRFBasicView

/**
 init

 @param frame frame
 @param availableBalance 可用余额
 @param collectedBalance 未到账余额
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame availableBalance:(NSString *)availableBalance collectedBalance:(NSString *)collectedBalance;

@end
