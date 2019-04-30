//
//  CRFBankNoTextField.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBankNoTextField.h"

@implementation CRFBankNoTextField

- (void)paste:(id)sender {
    DLog(@"%@",sender);
    self.pasteFlag = YES;
    [super paste:sender];
    self.pasteFlag = NO;
    if (self.pasteHandler) {
        weakSelf(self);
        [CRFUtils getMainQueue:^{
            strongSelf(weakSelf);
             strongSelf.pasteHandler(strongSelf);
        }];
    }
}

@end
