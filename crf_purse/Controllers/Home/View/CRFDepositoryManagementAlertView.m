//
//  CRFDepositoryManagementAlertView.m
//  crf_purse
//
//  Created by mystarains on 2019/1/14.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFDepositoryManagementAlertView.h"

@interface CRFDepositoryManagementAlertView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation CRFDepositoryManagementAlertView

- (IBAction)close:(UIButton *)sender {
    
    [self hide];
    
}

- (IBAction)depositoryManagement:(UIButton *)sender {
    
    [self hide];
    
    if (self.goToDepositoryManagement) {
        self.goToDepositoryManagement();
    }
    
}

-(void)setContentUrl:(NSString *)contentUrl{
    _contentUrl = contentUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:contentUrl] placeholderImage:[UIImage imageNamed:@"depository_anagement_alert_bg"]];
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
