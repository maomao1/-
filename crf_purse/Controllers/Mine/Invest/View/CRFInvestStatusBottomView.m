//
//  CRFInvestStatusBottomView.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFInvestStatusBottomView.h"
#import "UIImage+Color.h"

@interface CRFInvestStatusBottomView()

@property (nonatomic, strong) UIButton *redeemButton;

@property (nonatomic, strong) UIButton *forwardButton;

@property (nonatomic, assign) CRFProductStatus productStatus;

@property (nonatomic, copy) void (^(eventHandler))(CRFProductStatus status, NSInteger index);

@end

@implementation CRFInvestStatusBottomView

- (UIButton *)redeemButton {
    if (!_redeemButton) {
        _redeemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redeemButton setTitle:@"退出" forState:UIControlStateNormal];
        [_redeemButton setTitle:@"退出" forState:UIControlStateDisabled];
        [_redeemButton setTitle:@"退出" forState:UIControlStateHighlighted];
        _redeemButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_redeemButton setTitleColor:kCellTitleTextColor forState:UIControlStateDisabled];
        [_redeemButton setTitleColor:kCellTitleTextColor forState:UIControlStateNormal];
        [_redeemButton setTitleColor:kCellTitleTextColor forState:UIControlStateHighlighted];
        [_redeemButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [_redeemButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
        [_redeemButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_redeemButton addTarget:self action:@selector(redeem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redeemButton;
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardButton setTitle:@"转投" forState:UIControlStateNormal];
        [_forwardButton setTitle:@"转投" forState:UIControlStateDisabled];
        [_forwardButton setTitle:@"转投" forState:UIControlStateHighlighted];
        _forwardButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_forwardButton setBackgroundImage:[UIImage imageWithColor:kTextRedHighLightColor] forState:UIControlStateHighlighted];
        [_forwardButton setBackgroundImage:[UIImage imageWithColor:kTextRedDisableColor] forState:UIControlStateDisabled];
        [_forwardButton setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
        [_forwardButton addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardButton;
}

- (instancetype)initWithProductStatus:(CRFProductStatus)productStatus eventHandler:(void (^)(CRFProductStatus, NSInteger))eventHandler {
    if (self = [super init]) {
        _productStatus = productStatus;
        _eventHandler = eventHandler;
        [self initializeView];
    }
    return self;
}

- (void)forward {
    if (self.eventHandler) {
        self.eventHandler(self.productStatus,1);
    }
}

- (void)redeem {
    if (self.eventHandler) {
        self.eventHandler(self.productStatus,0);
    }
}

- (void)initializeView {
    if (self.productStatus == CRFProductStatusCanRedeemAndShiftInInvestment || self.productStatus == CRFProductStatusAutoInvest) {
        [self addSubview:self.forwardButton];
        [self addSubview:self.redeemButton];
        [self.redeemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self);
            make.width.mas_equalTo(kScreenWidth / 2.0);
        }];
        [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self);
            make.width.mas_equalTo(kScreenWidth / 2.0);
        }];
        if (self.productStatus == CRFProductStatusAutoInvest) {
            [self.forwardButton setTitle:@"立即转投" forState:UIControlStateNormal];
            [self.forwardButton setTitle:@"立即转投" forState:UIControlStateDisabled];
            [self.forwardButton setTitle:@"立即转投" forState:UIControlStateHighlighted];
            [self.redeemButton setTitle:@"申请债转退出" forState:UIControlStateNormal];
            [self.redeemButton setTitle:@"申请债转退出" forState:UIControlStateDisabled];
            [self.redeemButton setTitle:@"申请债转退出" forState:UIControlStateHighlighted];
        }
    } else if (self.productStatus == CRFProductStatusAppointmentInShiftInInvestment || self.productStatus == CRFProductStatusViewAppointmentInShiftInInvestmentInfo || self.productStatus == CRFProductStatusViewAutoInvestInfo) {
        [self.redeemButton setBackgroundImage:[UIImage imageWithColor:kTextRedHighLightColor] forState:UIControlStateHighlighted];
        [self.redeemButton setBackgroundImage:[UIImage imageWithColor:kTextRedDisableColor] forState:UIControlStateDisabled];
        [self.redeemButton setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
        [self addSubview:self.redeemButton];
        [self.redeemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        NSString *text = nil;
        if (self.productStatus == CRFProductStatusAppointmentInShiftInInvestment) {
            text = @"预约转投";
        } else {
            if (self.productStatus == CRFProductStatusViewAutoInvestInfo) {
                text = @"已申请转投";
            } else {
                text = @"已预约转投";
            }
            [self.redeemButton setImage:[UIImage imageNamed:@"btn_icon_reserved"] forState:UIControlStateNormal];
             [self.redeemButton setImage:[UIImage imageNamed:@"btn_icon_reserved"] forState:UIControlStateHighlighted];
            self.redeemButton.imageView.contentMode = UIViewContentModeCenter;
            CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) fontNumber:16.0].width;
            self.redeemButton.titleEdgeInsets = UIEdgeInsetsMake(0, - 14 * 2 - 2, 0, 0);
            self.redeemButton.imageEdgeInsets = UIEdgeInsetsMake(0, width * 2 + 3, 0, 0);
        }
        self.redeemButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.redeemButton setTitle:text forState:UIControlStateNormal];
        [self.redeemButton setTitle:text forState:UIControlStateHighlighted];
        [self.redeemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.redeemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
}

- (void)setEnable:(BOOL)enable {
    self.redeemButton.enabled = enable;
    self.forwardButton.enabled = enable;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.productStatus == CRFProductStatusAppointmentInShiftInInvestment || self.productStatus == CRFProductStatusViewAppointmentInShiftInInvestmentInfo) {
        [self.redeemButton setBackgroundImage:[UIImage gradientImage:@[kGraglientBeginColor,kGraglientEndColor] location:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))] forState:UIControlStateNormal];
        [self.redeemButton setBackgroundImage:[UIImage gradientImage:@[kGraglientBeginColor,kGraglientEndColor] location:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))] forState:UIControlStateHighlighted];
    }
}

@end
