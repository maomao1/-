//
//  CRFCountDownLabel.m
//  crf_purse
//
//  Created by maomao on 2017/7/25.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCountDownLabel.h"

@implementation CRFCountDownLabel
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:12.0f];
        self.textColor = UIColorFromRGBValue(0xFC5B49);
    }
    return self;
}

- (void)setCountDownTimer:(long long)countDownTimer {
    _countDownTimer = countDownTimer;
    self.text = [self formatTime];
}

- (NSString *)formatTime {
    long long timeInter = (self.countDownTimer - self.beginTime) / 1000;
    if (timeInter <= 0) {
        return nil;
    }
    NSInteger hour = (NSInteger) timeInter / 3600;
    NSInteger minute =(NSInteger) (timeInter - 3600 * (long long)hour) / 60;
    NSInteger second = (NSInteger)(timeInter - 3600 * hour - 60 * minute);
    if (hour > 0) {
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,minute,second];
    }
    if (hour == 0 && minute == 0) {
        return [NSString stringWithFormat:@"00:00:%02zd",second];
    }
    if (hour == 0 && minute > 0) {
        return [NSString stringWithFormat:@"00:%02zd:%02zd",minute,second];
    }
    return nil;
}

- (void)startTimer {
//    if (self.countDownTimer - [CRFTimeUtil getCurrentTimeInteveral] <= 0) {
//        self.hidden = YES;
//        return;
//    }
        self.hidden = NO;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}

- (void)countdown {
     self.countDownTimer = (self.countDownTimer / 1000 - 1) * 1000;
    if (_countDownTimer <=0) {
        self.hidden = YES;
    }
    self.text = [self formatTime];
}
- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

@end
