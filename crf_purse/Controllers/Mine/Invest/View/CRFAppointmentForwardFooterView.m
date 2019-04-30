//
//  CRFAppointmentForwardFooterView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFAppointmentForwardFooterView.h"
#import "UIImage+Color.h"

@interface CRFAppointmentForwardFooterView()

@property (nonatomic, strong) UIButton *button;

@end

@implementation CRFAppointmentForwardFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initializeView {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(appointmentForwardEvent) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"查找" forState:UIControlStateNormal];
    [_button setTitle:@"查找" forState:UIControlStateHighlighted];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_button setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
    _button.layer.cornerRadius = 5.0f;
    _button.layer.masksToBounds = YES;
    [_button setBackgroundImage:[UIImage imageWithColor:kButtonBorderNormalBackgroundColor] forState:UIControlStateHighlighted];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.bottom.equalTo(@(-47));
        make.top.equalTo(@(30));
    }];
}

- (void)appointmentForwardEvent {
    if (self.eventHandler) {
        self.eventHandler();
    }
}


@end
