//
//  CRFButton.h
//  crf_purse
//
//  Created by maomao on 2018/6/25.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFButton : UIButton
@property(nonatomic,strong) NSTimer *timerCD;
@property (nonatomic, assign) long long timeTotal;
@property(nonatomic,assign)BOOL isEnable;
@property (nonatomic,strong)UIColor *backColor;
-(void)crfSetUnSelect;
-(void)crfSetSelect;
/**
 *倒计时开始
 */
-(void)crfStartCountDown;
-(void)crfStopCountdown;

@end
