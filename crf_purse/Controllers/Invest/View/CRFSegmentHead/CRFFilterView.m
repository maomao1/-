//
//  CRFFilterView.m
//  crf_purse
//
//  Created by maomao on 2017/7/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//
#define  NormalColor   UIColorFromRGBValue(0x666666)
#define  SelectedColor UIColorFromRGBValue(0xFB4D3A)
#define  ItemWidth     66*kWidthRatio
#define  ItemHeight    25*kHeightRatio
#define  ItemPadding   23*kWidthRatio

#import "CRFFilterView.h"
@interface CRFFilterView()
@property  (nonatomic , strong)  UIButton  * longTermBtn;
@property  (nonatomic , strong)  UIButton  * midTermBtn;
@property  (nonatomic , strong)  UIButton  * shortTermBtn;
@end
@implementation CRFFilterView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
        self.backgroundColor = [UIColor clearColor];
//        self.userInteractionEnabled = YES;
        
    }
    return self;
}
- (void)customUI{
    self.longTermBtn  = [self createRadiusBtnWithTitle:@"长期"];
    self.longTermBtn.tag = 1;
    self.midTermBtn   = [self createRadiusBtnWithTitle:@"中期"];
    self.midTermBtn.tag = 2;
    self.shortTermBtn = [self createRadiusBtnWithTitle:@"短期"];
    self.shortTermBtn.tag = 3;
    [self addSubview:self.longTermBtn];
    [self addSubview:self.midTermBtn];
    [self addSubview:self.shortTermBtn];
    
    [self.midTermBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(ItemWidth);
        make.top.bottom.equalTo(self);
        
        
    }];
    [self.longTermBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midTermBtn.mas_centerY);
        make.size.equalTo(self.midTermBtn);
        make.right.equalTo(self.midTermBtn.mas_left).with.mas_offset(-ItemPadding);
    }];
    [self.shortTermBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midTermBtn.mas_centerY);
        make.size.equalTo(self.midTermBtn);
        make.left.equalTo(self.midTermBtn.mas_right).with.mas_offset(ItemPadding);
    }];
    
}
- (UIButton *)createRadiusBtnWithTitle:(NSString*)title{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(title, nil) forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:NormalColor forState:UIControlStateNormal];
    [btn setTitleColor:SelectedColor forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"cancel_btnImg"] forState:UIControlStateSelected];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius  = 25*kHeightRatio/2;
    btn.layer.borderWidth   = 1.f;
    btn.layer.borderColor   = NormalColor.CGColor;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}



- (void)btnClick:(UIButton*)btn {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *viewBtn = (UIButton *)view;
            if (viewBtn.tag != btn.tag) {
                viewBtn.selected = NO;
                viewBtn.layer.borderColor = NormalColor.CGColor;
                viewBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                viewBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.layer.borderColor = SelectedColor.CGColor;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22*kWidthRatio);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 43*kWidthRatio, 0, 0);
    } else {
        btn.layer.borderColor = NormalColor.CGColor;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([self.delegate respondsToSelector:@selector(filterResult:)]) {
        [self.delegate filterResult:btn];
    }
    [CRFAPPCountManager setEventID:@"INVEST_PRODUCT_CYCLE_FILTER" EventName:btn.titleLabel.text];
}
- (void)resetButtonStatus{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *viewBtn = (UIButton *)view;
            viewBtn.selected = NO;
            viewBtn.layer.borderColor = NormalColor.CGColor;
            viewBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            viewBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
}
@end
