//
//  WMMJLoginFooterView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJLoginFooterView.h"

@interface WMMJLoginFooterView()
@property  (nonatomic , copy) void(^(loginCallback))(UIButton *loginBtn);
@property  (nonatomic , copy) void(^(registerCallback))(UIButton *registerBtn);
@property  (nonatomic , copy) void(^(forgetCallback))(UIButton *forgetBtn);

@property  (nonatomic ,strong)  UIButton  *loginBtn;
@property  (nonatomic ,strong)  UIButton  *registerBtn;
@property  (nonatomic ,strong)  UIButton  *forgetBtn;


@end

@implementation WMMJLoginFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginBtn setTitle:NSLocalizedString(@"button_login", nil) forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        self.loginBtn.enabled = NO;
        
        self.loginBtn.backgroundColor = UIColorFromRGBValue(0x8F87DB);
        //(0xEE5250);
        
        self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.registerBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.registerBtn setTitle:NSLocalizedString(@"button_register", nil) forState:UIControlStateNormal];
        self.registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.registerBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        
        self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.forgetBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.forgetBtn setTitle:NSLocalizedString(@"button_forget_password", nil) forState:UIControlStateNormal];
        self.forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.forgetBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        //
        self.loginBtn.crf_acceptEventInterval = 0.5;
        self.registerBtn.crf_acceptEventInterval = 0.5;
        self.forgetBtn.crf_acceptEventInterval = 0.5;
        
        [self addSubview:self.loginBtn];
        [self addSubview:self.registerBtn];
        [self addSubview:self.forgetBtn];
        
        self.loginBtn.layer.masksToBounds = YES;
        self.loginBtn.layer.cornerRadius  = 5.0;
        
        [self.forgetBtn setTitleColor:UIColorFromRGBValue(0x6D66AF) forState:UIControlStateNormal];
        [self.registerBtn setTitleColor:UIColorFromRGBValue(0x6D66AF) forState:UIControlStateNormal];
        self.forgetBtn.titleLabel.font= [UIFont systemFontOfSize:14];
        self.registerBtn.titleLabel.font= [UIFont systemFontOfSize:14];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(20);
            make.trailing.mas_equalTo(-20);
            make.height.mas_equalTo(kRegisterButtonHeight);
        }];
        
        [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.loginBtn.mas_left);
            make.top.equalTo(self.loginBtn.mas_bottom).mas_offset(20);
            make.size.mas_equalTo(CGSizeMake(100, 34));
        }];
        
        [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.loginBtn.mas_trailing);
            make.top.equalTo(self.loginBtn.mas_bottom).mas_offset(20);
            make.size.mas_equalTo(CGSizeMake(100, 34));
        }];
    }
    return self;
}

- (void)customBtnClick:(UIButton*)btn {
    //    btn.enabled = NO;
    if ([btn isEqual:_loginBtn]) {
        if (self.loginCallback) {
            self.loginCallback(btn);
        }
    }else if ([btn isEqual:_registerBtn]){
        if (self.registerCallback) {
            self.registerCallback(btn);
        }
    }else if ([btn isEqual:_forgetBtn]){
        if (self.forgetCallback) {
            self.forgetCallback(btn);
        }
    }
}

- (void)footLoginBtnCallback:(void(^)(UIButton*loginBtn))loginCallback registerCallback:(void(^)(UIButton *registerBtn))registerCallback forgetCallback:(void (^)(UIButton *forgetBtn))forgetCallback {
    self.loginCallback = loginCallback;
    self.registerCallback = registerCallback;
    self.forgetCallback = forgetCallback;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
