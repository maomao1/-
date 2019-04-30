//
//  CRFTextField.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/8.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFTextField.h"
@interface CRFTextField()<UITextFieldDelegate>
@end
@implementation CRFTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.hiddenMenu) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    }
        return YES;
}


@end
