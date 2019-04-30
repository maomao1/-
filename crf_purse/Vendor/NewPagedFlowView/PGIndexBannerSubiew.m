//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 2);
//        self.layer.shadowOpacity = 0.25f;
//        self.layer.shadowRadius = 2.5f;
//        self.layer.cornerRadius = 6.0;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(self.tag, self);
    }
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    CGRect rect = superViewBounds;
//    rect.size.width = rect.size.width - 8;
//    rect.size.height = rect.size.height - 6;
//    rect.origin.x = 4;
//    rect.origin.y = 2;
    if (CGRectEqualToRect(self.mainImageView.frame, rect)) {
        return;
    }
    self.mainImageView.frame = rect;
    self.coverView.frame = self.bounds;
}

- (UIImageView *)mainImageView {
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) , CGRectGetHeight(self.frame))];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.layer.cornerRadius = 8.0f;
        _mainImageView.clipsToBounds = YES;
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.mainImageView sd_setImageWithURL:_url placeholderImage:[UIImage imageNamed:@"banner_default"]];
}

@end
