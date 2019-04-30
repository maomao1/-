//
//  CRFVerifyCodeView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/5.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFVerifyCodeView.h"
static NSTimeInterval const kTimeInterval = 1;
NSInteger sumCount = 60;

@interface CRFVerifyCodeView()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *sendingTitle;

@property (nonatomic, copy) NSString *resetTitle;

@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong) UIColor *disableColor;

@end

@implementation CRFVerifyCodeView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.button];
        [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setNeedsDisplay];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.button];
        [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setNeedsDisplay];
    }
    return self;
}
-(void)setButtonType:(ButtonType)buttonType{
    _buttonType = buttonType;
    if (buttonType == Border_Have) {
        _button.layer.borderColor = UIColorFromRGBValue(0xFBB203).CGColor;
        _button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }else{
        _button.layer.borderColor = [UIColor clearColor].CGColor;
        _button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
}
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor whiteColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _button.layer.cornerRadius = 27.0 / 2.0;
        _button.layer.borderColor = UIColorFromRGBValue(0xFBB203).CGColor;
        _button.layer.borderWidth = 1.0f;
        
    }
    return _button;
}

- (void)buttonClick {
    self.button.userInteractionEnabled = NO;
    if (self.callback) {
        self.callback();
    }
}

- (void)titleNormalColor:(UIColor *)normalColor disableColor:(UIColor *)disableColor {
    self.normalColor = normalColor;
    self.disableColor = disableColor;
    [self.button setTitleColor:self.normalColor forState:UIControlStateNormal];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)timerAction {
    NSInteger count = sumCount --;
    if (count == 0) {
        [self.button setTitle:self.resetTitle forState:UIControlStateNormal];
        [self stopSendVerify];
        sumCount = 60;
        if (self.timeoutHandle) {
            self.timeoutHandle();
        }
    }  else {
        [self.button setTitle:[NSString stringWithFormat:self.sendingTitle,count] forState:UIControlStateNormal];
    }
}

- (void)startSendVerify {
    self.button.userInteractionEnabled = NO;
    [self.button setTitleColor:self.disableColor forState:UIControlStateNormal];
    if (_buttonType == Border_Have) {
        self.button.layer.borderColor = self.disableColor.CGColor;
    }else{
        self.button.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopSendVerify {
    self.button.userInteractionEnabled = YES;
    [self.button setTitleColor:self.normalColor forState:UIControlStateNormal];
    //    self.button.layer.borderColor = self.normalColor.CGColor;
    if (_buttonType == Border_Have) {
        self.button.layer.borderColor = self.normalColor.CGColor;
    }else{
        self.button.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)sendingTitle:(NSString *)title {
    self.sendingTitle = title;
    [self.button setTitle:title forState:UIControlStateDisabled];
}

- (void)resetTitle:(NSString *)title {
    self.resetTitle = title;
}

- (void)initialTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)titleFont:(UIFont *)font {
    self.button.titleLabel.font = font;
}

- (BOOL)enable {
    return self.button.userInteractionEnabled;
}

- (void)setEnable:(BOOL)enable {
    self.button.userInteractionEnabled = enable;
}

@end
