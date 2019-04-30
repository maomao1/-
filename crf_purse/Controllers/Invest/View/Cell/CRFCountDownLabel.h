//
//  CRFCountDownLabel.h
//  crf_purse
//
//  Created by maomao on 2017/7/25.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFTimeUtil.h"

@interface CRFCountDownLabel : UILabel
@property (nonatomic, assign) long long countDownTimer;

@property (nonatomic, assign) long long beginTime;
@property (nonatomic, strong) NSTimer *timer;

- (void)startTimer;
@end
