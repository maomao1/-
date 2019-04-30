//
//  CRFSectionHeaderView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSectionHeaderView.h"

@implementation CRFSectionHeaderView

- (instancetype)initWithSectionStyle:(CRFSectionHeaderStyle)style {
    if (self = [super init]) {
        if (style == CRFSectionHeaderStyleTopMargen) {
            [self initializeTopMargenView];
        } else if (style == CRFSectionHeaderStyleTopMargenAndContent) {
            [self initializeTopMargenAndContentView];
        } else if (style == CRFSectionHeaderStyleContent) {
            [self initializeContentView];
        }
    }
    return self;
}

- (void)initializeTopMargenView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kTopSpace / 2.0);
    self.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
}

- (void)initializeTopMargenAndContentView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kCellHeight + kTopSpace / 2);
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, kTopSpace / 2.0, kScreenWidth - kSpace, kCellHeight)];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopSpace / 2.0)];
    topView.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
    [self addSubview:topView];
    label.text = NSLocalizedString(@"header_old_user_product", nil);
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.textColor = UIColorFromRGBValue(0x333333);
    [self addSubview:label];
}

- (void)initializeContentView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kCellHeight);
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpace,  0, kScreenWidth - kSpace, kCellHeight)];
    label.text = NSLocalizedString(@"header_old_user_product", nil);
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.textColor = UIColorFromRGBValue(0x333333);
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
