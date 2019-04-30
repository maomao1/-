//
//  CRFInvestHelpView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestHelpView.h"


@interface CRFInvestHelpView()

@property (nonatomic, strong) UIVisualEffectView *effectview;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *margen;

@end

@implementation CRFInvestHelpView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.margen.constant = 140 * kHeightRatio;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
}

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        
        _effectview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _effectview.alpha = 1;
    }
    return _effectview;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = .0f;
        self.effectview.alpha = .0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.effectview removeFromSuperview];
    }];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self.effectview];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1;
        self.effectview.alpha = 1;
    }];
}


@end
