//
//  CRFLoginHeaderView.m
//  CRFWallet
//
//  Created by SHLPC1321 on 2017/6/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFLoginHeaderView.h"

@interface CRFLoginHeaderView()


@end

@implementation CRFLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.logoImg = [[UIImageView alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.logoImg];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-5 * kWidthRatio);
            make.left.right.top.equalTo(self);
        }];
#ifdef WALLET
        if ([CRFAppManager defaultManager].majiabaoFlag) {
            self.logoImg.image = [UIImage imageNamed:@"majiabao_login_bg"];
        } else {
            [self configImageView];
        }
#else
        [self configImageView];
#endif
    }
    return self;
}

- (void)configImageView {
    self.logoImg.image = [UIImage imageNamed:@"login_header"];
    UIImageView *loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_header_logo"]];
    [self addSubview:loginImageView];
    loginImageView.contentMode = UIViewContentModeCenter;
    [loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.logoImg);
    }];
}

@end
