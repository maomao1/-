//
//  CRFSectionFooterView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSectionFooterView.h"

@implementation CRFSectionFooterView


/*
 if ([self.productFactory hasNewProduct]) {
 if (section == 0) {
 UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopSpace / 2.0)];
 view1.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
 return view1;
 }
 }
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
 label.backgroundColor = [UIColor whiteColor];
 label.text = NSLocalizedString(@"footer_home_more", nil);
 label.font = [UIFont systemFontOfSize:13.0];
 label.textAlignment = NSTextAlignmentCenter;
 label.textColor = UIColorFromRGBValue(0x999999);
 [view addSubview:label];
 [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookupMore)]];
 UIView *otherView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight, kScreenWidth, 8)];
 otherView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
 
 [view addSubview:otherView];
 return view;
 */

- (instancetype)initWithStyle:(CRFSectionStyle)style {
    if (self = [super init]) {
        if (style == CRFSectionStyleNovice) {
            [self initializeNoviceView];
        } else {
            [self initializeOldView];
        }
    }
    return self;
}

- (void)initializeNoviceView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kTopSpace / 2.0);
    self.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
}

- (void)initializeOldView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kCellHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"footer_home_more", nil);
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGBValue(0x999999);
    [self addSubview:label];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookupMore)]];
    UIView *otherView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight, kScreenWidth, 8)];
    otherView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [self addSubview:otherView];
    self.userInteractionEnabled = YES;
}

- (void)lookupMore {
    if (self.tapHandler) {
        self.tapHandler();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
