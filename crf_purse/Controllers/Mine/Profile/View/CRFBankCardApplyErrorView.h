//
//  CRFBankCardApplyErrorView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFBankCardApplyErrorView : UIView

@property (nonatomic, copy) void (^ (closeHandler))(void);

- (CGFloat)getThisHeight;



@end
