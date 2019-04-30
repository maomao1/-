//
//  CRFButton.m
//  crf_purse
//
//  Created by maomao on 2018/6/25.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFButton.h"

@implementation CRFButton
-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    [self setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateNormal];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self setTitle:NSLocalizedString(@"button_verify_normal_title", nil) forState:UIControlStateNormal];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
-(void)crfStartCountDown{
    [self crfSetUnSelect];
    self.timeTotal=60;
    self.timerCD =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(crfPopCountDown) userInfo:nil repeats:YES];
}
//倒计时
-(void)crfPopCountDown{
    if (self.timeTotal==0) {
        [self.timerCD invalidate];
        self.timerCD=nil;
        [self crfSetSelect];
        [self setTitle:NSLocalizedString(@"button_verify_re_get_verify_code", nil) forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateNormal];
        self.layer.borderColor =UIColorFromRGBValue(0xFB4D3A).CGColor;
    }
    else {
        //        self.titleLabel.font=[UIFont systemFontOfSize:14];
        [self  setTitle:[NSString stringWithFormat:NSLocalizedString(@"button_re_get_verify_code",nil),(long)self.timeTotal] forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGBValue(0xBBBBBB) forState:UIControlStateNormal];
        self.layer.borderColor =UIColorFromRGBValue(0xBBBBBB).CGColor;
        self.timeTotal--;
    }
    
}
-(void)crfStopCountdown{
    self.timeTotal=0;
}

-(void)crfSetUnSelect{
    self.enabled=NO;
}

-(void)crfSetSelect{
    self.enabled=YES;
}
-(void)setBackColor:(UIColor *)backColor{
    self.backgroundColor=backColor;
    _backColor=backColor;
}
-(void)setIsEnable:(BOOL)isEnable{
    _isEnable=isEnable;
    self.enabled=isEnable;
    if (isEnable) {
        self.alpha=1.0;
    }else{
        self.alpha=0.5;
    }
}
-(void)dealloc{
    [self.timerCD invalidate];
    self.timerCD=nil;
}

@end
