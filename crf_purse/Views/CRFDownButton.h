//
//  CRFDownButton.h
//  crf_purse
//
//  Created by maomao on 2017/8/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CRFDownButtonStatus) {
    CRFDownButtonStatusInvest               = 0,
    CRFDownButtonStatusRecharge             = 1,
    CRFDownButtonStatusLogin                = 2,
    CRFDownButtonStatusOpen                 = 3,
    CRFDownButtonStatusEvalue               = 4,
    CRFDownButtonStatusDisable              = 5,
    CRFDownButtonStatusWaitSale             = 6,
    CRFDownButtonStatusAppointmentForward   = 7,
    CRFDownButtonStatusComfirm              = 8,
    CRFDownButtonStatusExclusive            = 9,
    CRFDownButtonStatusAutoInvest           = 10,
    CRFDownButtonStatusNewcomer             = 11,
};

@interface CRFDownButton : UIButton
@property (nonatomic, strong) NSTimer *crfTimerCD;
@property (nonatomic, assign) long long beginTime;
@property (nonatomic, assign) long long timeInvter;
@property (nonatomic,assign) BOOL       isFull;

@property (nonatomic, assign) BOOL newcomer;

@property (nonatomic, assign) CRFDownButtonStatus buttonStatus;
/**
 *倒计时开始
 */
- (void)crf_StartCountDown;
- (void)crf_StopCountdown;

/**
 <#Description#>
 */
- (void)cancelTimer;

- (void)setViewHide:(BOOL)hide;
@end
