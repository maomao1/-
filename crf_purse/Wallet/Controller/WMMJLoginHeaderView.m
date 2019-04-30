//
//  WMMJLoginHeaderView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJLoginHeaderView.h"

@implementation WMMJLoginHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.logoImg = [[UIImageView alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.logoImg];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-5 * kWidthRatio);
            make.left.right.top.equalTo(self);
        }];
            self.logoImg.image = [UIImage imageNamed:@"majiabao_login_bg"];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
