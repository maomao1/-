//
//  UITableView+Custom.m
//  CRFWallet
//
//  Created by SHLPC1321 on 2017/6/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "UITableView+Custom.h"

@implementation UITableView (Custom)
//文本编辑
- (void)setTextEidt:(BOOL)textEidt {
    if (textEidt) {
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:gestureRecognizer];
    }
}
#pragma mark 隐藏键盘
- (void)hideKeyboard {
    [self endEditing:YES];
}
@end
