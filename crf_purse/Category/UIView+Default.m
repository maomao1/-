//
//  UIView+Default.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "UIView+Default.h"



@implementation UIView (Default)
UILabel *contentLabel;

- (void)showDefaultText:(NSString *)text {
    if (contentLabel && [self.subviews containsObject:contentLabel]) {
        contentLabel.text = text;
        return;
    }
    contentLabel = [UILabel new];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = UIColorFromRGBValue(0x666666);
    contentLabel.text = text;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(30);
        make.top.equalTo(self).with.offset(kTopSpace);
    }];
}


@end
