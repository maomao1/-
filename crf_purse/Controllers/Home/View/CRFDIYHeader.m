//
//  DIYHeader.m
//  TabBarAnimation
//
//  Created by xu_cheng on 2017/7/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDIYHeader.h"

@interface CRFDIYHeader()

@property (nonatomic, strong) UILabel *refreshTitleLabel;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, assign) BOOL stopAnimation, finishGiveUp;


@end

@implementation CRFDIYHeader

- (void)prepare {
    [super prepare];
    self.backgroundColor = [UIColor whiteColor];
    self.mj_h = 50;
    _refreshTitleLabel = [[UILabel alloc] init];
    _refreshTitleLabel.text = NSLocalizedString(@"refresh_title_home", nil);
    self.stopAnimation = NO;
    [self addSubview:self.refreshTitleLabel];
    _loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
    [self addSubview:self.loadingImageView];
}

- (void)placeSubviews {
    [super placeSubviews];
    [self.refreshTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(30);
        make.top.equalTo(self).with.offset(kSpace);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.refreshTitleLabel.mas_left).with.offset(-5);
        make.top.equalTo(self.refreshTitleLabel.mas_top).with.offset(2.5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    if ([change[@"new"] integerValue] == 3 && (self.state == MJRefreshStateIdle || self.state == MJRefreshStateWillRefresh)) {
        if (self.resetStatus) {
            self.resetStatus();
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollViewContentOffSizeHandle) {
        self.scrollViewContentOffSizeHandle(change);
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
            case MJRefreshStateIdle:
            self.finishGiveUp = NO;
            [self endAnimation];
            break;
            case MJRefreshStatePulling:
                       self.stopAnimation = NO;
             self.finishGiveUp = NO;
             [self startAnimation];
            if (self.beginDraging) {
                self.beginDraging();
            }
            break;
            
            case MJRefreshStateRefreshing: {
                self.finishGiveUp = YES;
            }
            
            break;
            case MJRefreshStateWillRefresh:
             self.finishGiveUp = NO;
            break;
        default:
            break;
    }
    
}

- (void)startAnimation {
    __weak __typeof(self) weakSelf = self;
    if (!_stopAnimation) {
        [UIView animateWithDuration:0.01 animations:^{
            weakSelf.loadingImageView.transform = CGAffineTransformRotate(weakSelf.loadingImageView.transform, 0.04 * M_PI);
        } completion:^(BOOL finished) {
            [weakSelf startAnimation];
        }];
    }
}

- (void)endAnimation {
    _stopAnimation = YES;
    self.loadingImageView.transform = CGAffineTransformMakeRotation(0);
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    if (self.finishGiveUp) {
        return;
    }
    if (self.dragingPullScreenPercent) {
        self.dragingPullScreenPercent(pullingPercent);
    }
    
    
}

@end
