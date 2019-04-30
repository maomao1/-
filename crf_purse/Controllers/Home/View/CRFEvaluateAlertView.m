//
//  CRFEvaluateAlertView.m
//  crf_purse
//
//  Created by mystarains on 2019/1/11.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFEvaluateAlertView.h"

@implementation CRFEvaluateAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)evaluate:(UIButton *)sender {
    
    [self hide];
    if (self.goToEvaluate) {
        self.goToEvaluate();
    }
    
}

- (void)show{
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    self.alpha = 1;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
}

- (void)hide{
 
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end
