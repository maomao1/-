//
//  CRFDownButton.m
//  crf_purse
//
//  Created by maomao on 2017/8/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDownButton.h"
#import "CRFTimeUtil.h"
#import "UIImage+Color.h"

@implementation CRFDownButton
@synthesize  buttonStatus = _buttonStatus;

- (CRFDownButtonStatus)buttonStatus {
    if (![CRFAppManager defaultManager].login) {
        return CRFDownButtonStatusLogin;
    }
    if (![CRFAppManager defaultManager].accountStatus) {
        return CRFDownButtonStatusOpen;
    }
    if (self.newcomer) {
        if ([CRFAppManager defaultManager].userInfo.customerStatus.integerValue == 2) {
            return CRFDownButtonStatusNewcomer;
        }
    }
    if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].userInfo.accountStatus.integerValue == 2 && [CRFAppManager defaultManager].userInfo.riskConfirm.integerValue == 1) {
        return CRFDownButtonStatusEvalue;
    }
    return _buttonStatus;
}

- (void)setButtonStatus:(CRFDownButtonStatus)buttonStatus {
    _buttonStatus = buttonStatus;
    if (_buttonStatus == CRFDownButtonStatusRecharge) {
        [self setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
    } else if (_buttonStatus == CRFDownButtonStatusDisable) {
        [self setTitle:@"方案已满" forState:UIControlStateNormal];
    } else if (_buttonStatus == CRFDownButtonStatusAppointmentForward) {
        [self setTitle:@"预约转投" forState:UIControlStateNormal];
    } else if (_buttonStatus == CRFDownButtonStatusComfirm) {
        [self setTitle:@"确认" forState:UIControlStateNormal];
    } else if (_buttonStatus != CRFDownButtonStatusWaitSale) {
        [self setTitle:@"马上加入" forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font=[UIFont systemFontOfSize:16];
//    self.backgroundColor = kBtnAbleBgColor;
    [self setTitle:@"马上加入" forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self awakeFromNib];
    }
    
    return self;
}
- (void)setEnabled:(BOOL)enabled{
//    self.enabled = enabled;
    
    if (enabled) {
        NSMutableArray *colorArray = nil;
        CGFloat height;
#ifdef WALLET
        if ([CRFUtils normalUser]) {
            colorArray = [@[UIColorFromRGBValue(0xFF7F5C),
                            
                            kBtnAbleBgColor] mutableCopy];
            height = 48;
        } else {
            height = 54;
            colorArray = [@[kButtonNormalBackgroundColor,kButtonNormalBackgroundColor] mutableCopy];
        }
#else
        height = 48;
            colorArray = [@[UIColorFromRGBValue(0xFA6E73),
                            
                            UIColorFromRGBValue(0xFA5050)] mutableCopy];
#endif
        
        UIImage *bgImg = [UIImage bgImageFromColors:colorArray withFrame:CGRectMake(0, kScreenHeight-height, kScreenWidth, height)];
        [self setBackgroundImage:bgImg forState:UIControlStateNormal];
        [self setBackgroundImage:bgImg forState:UIControlStateHighlighted];
    } else {
        NSMutableArray *colorArray = [@[UIColorFromRGBValue(0xFDB1A0),
                                        
                                        UIColorFromRGBValue(0xFC9D98)] mutableCopy];
        UIImage *bgImg = [UIImage bgImageFromColors:colorArray withFrame:CGRectMake(0, kScreenHeight-48, kScreenWidth, 48)];
        [self setBackgroundImage:bgImg forState:UIControlStateNormal];
        [self setBackgroundImage:bgImg forState:UIControlStateHighlighted];
    }
}
- (void)setTimeInvter:(long long)timeInvter{
    _timeInvter = timeInvter;
//    [self crf_PopCountDown];
}
- (NSString *)formatTime {
    long long timeInter = (self.timeInvter - [CRFAppManager defaultManager].nowTime) / 1000;
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
- (void)crf_StartCountDown{
    if (!_crfTimerCD) {
        _crfTimerCD = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(crf_PopCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.crfTimerCD forMode:NSRunLoopCommonModes];
    }
    [_crfTimerCD fire];
}
//倒计时
- (void)crf_PopCountDown{
//    self.timeInvter = (self.timeInvter / 1000 - 1) * 1000;
    NSString *timeStr = [self formatTime];
    if (timeStr) {
        [self  setTitle:[NSString stringWithFormat:@"%@ 后开抢，敬请期待",timeStr] forState:UIControlStateNormal];
        self.buttonStatus = CRFDownButtonStatusWaitSale;
    }else{
        [_crfTimerCD invalidate];
        _crfTimerCD=nil;
        if (self.enabled) {
            self.buttonStatus = CRFDownButtonStatusInvest;
        } else {
            self.buttonStatus = CRFDownButtonStatusDisable;
        }
        
    }
}

- (void)crf_StopCountdown{
    
}

- (void)dealloc{
    [self cancelTimer];
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (void)setViewHide:(BOOL)hide {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = hide? 0: 1;
    } completion:^(BOOL finished) {
        self.hidden = hide;
    }];
}

- (void)cancelTimer {
    if (self.crfTimerCD && [self.crfTimerCD isValid]) {
        [self.crfTimerCD invalidate];
        self.crfTimerCD = nil;
    }
}

@end
