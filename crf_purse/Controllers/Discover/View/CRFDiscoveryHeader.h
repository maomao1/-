//
//  CRFDiscoveryHeader.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFDiscoveryHeader : UIView

@property (nonatomic, assign) BOOL hiddenLine;


@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^(pushNextHandle))(void);

@end
