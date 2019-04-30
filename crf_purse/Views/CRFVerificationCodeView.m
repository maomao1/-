//
//  CRFVerificationCodeView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFVerificationCodeView.h"
#import "UIButton+CRFRepeatClick.h"

@interface CRFVerificationCodeView ()

/**
 验证码按钮
 */
@property (nonatomic, strong) UIButton *codeButton;

/**
 timer
 */
@property (nonatomic, strong) dispatch_source_t timer;

/**
 倒计时时间
 */
@property (nonatomic, assign) NSUInteger timerInterval;

@end

@implementation CRFVerificationCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeView];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initializeView];
    }
    return self;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _codeButton.crf_acceptEventInterval = 1.5;
    }
    return _codeButton;
}

- (void)createTimer {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // new timer
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(_timer, start, interval, 0);
//         dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
        //定时器的回调
        weakSelf(self);
        @try {
            dispatch_source_set_event_handler(_timer, ^{
                [CRFUtils getMainQueue:^{
                    strongSelf(weakSelf);
                    if (strongSelf.timerInterval <= 0) {
                        strongSelf.codeButton.enabled = YES;
                        [strongSelf cancelTimer];
                        strongSelf.timerInterval = 60;
                        [strongSelf.codeButton setTitle:strongSelf.initializeText?strongSelf.initializeText:strongSelf.againInitializeText forState:UIControlStateNormal];
                    } else {
                        [strongSelf.codeButton setTitle:[NSString stringWithFormat:strongSelf.sendingText,strongSelf.timerInterval] forState:UIControlStateDisabled];
                        
                    }
                    strongSelf.timerInterval --;
                }];
            });
        } @catch (NSException *exception) {
            DLog(@"==%@===",exception);
        } @finally {
            
        }
}

- (void)cancelTimer {
    if (self.timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

- (void)initializeView {
    [self addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(kSpace);
        make.right.equalTo(self).with.offset(-kSpace);
    }];
    self.timerInterval = 60;
    [self.codeButton addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    [self.codeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(_contentEdgeInsets.left);
        make.top.equalTo(self).with.offset(_contentEdgeInsets.top);
        make.bottom.equalTo(self).with.offset(- _contentEdgeInsets.bottom);
        make.right.equalTo(self).with.offset(- _contentEdgeInsets.right);
    }];
}

- (void)buttonClick {
    if (self.beginSendCode) {
        self.beginSendCode();
    }
}

- (void)setInitializeText:(NSString *)initializeText {
    _initializeText = initializeText;
    [self.codeButton setTitle:initializeText forState:UIControlStateNormal];
}

- (void)timerStart {
    [self createTimer];
    self.codeButton.enabled = NO;
    [self.codeButton setTitle:_initializeText forState:UIControlStateDisabled];
    dispatch_resume(self.timer);
}

- (void)resetTimer {
    if (self.timer) {
        [self cancelTimer];
    }
    self.timerInterval = 60;
    self.codeButton.enabled = YES;
    self.codeButton.layer.borderColor = self.normalBorderColor.CGColor;
    [self.codeButton setTitle:_initializeText forState:UIControlStateDisabled];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.codeButton.layer.borderWidth = _borderWidth;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self.codeButton setTitleColor:normalColor forState:UIControlStateNormal];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.codeButton.layer.cornerRadius = _cornerRadius;
}

- (void)setDisableColor:(UIColor *)disableColor {
    _disableColor = disableColor;
    [self.codeButton setTitleColor:_disableColor forState:UIControlStateDisabled];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.codeButton.titleLabel.font = _textFont;
}

- (void)setNormalBorderColor:(UIColor *)normalBorderColor {
    _normalBorderColor = normalBorderColor;
    self.codeButton.layer.borderColor = _normalBorderColor.CGColor;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    BOOL enabled = [change[@"new"] boolValue];
    self.codeButton.layer.borderColor = enabled?self.normalBorderColor.CGColor:self.disableBorderColor.CGColor;
}

- (void)dealloc {
    @try {
        [self.codeButton removeObserver:self forKeyPath:@"enabled"];
        [self cancelTimer];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (void)setEnable:(BOOL)enable {
    self.codeButton.enabled = enable;
}

- (void)destory {
    @try {
        [self cancelTimer];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
