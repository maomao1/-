//
//  CRFLoadingView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/6.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFLoadingView.h"
#import "UIImage+Color.h"


@interface CRFLoadingView ()

@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, strong) UIView *loadingView;


@property (nonatomic, strong) UIWindow *rootWindow;

@property (nonatomic, strong) UIView *disableView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation CRFLoadingView

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _activityIndicatorView;
}

- (UIWindow *)rootWindow {
    if (!_rootWindow) {
        _rootWindow = [UIApplication sharedApplication].delegate.window;
    }
    return _rootWindow;
}
//{85,85}
- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIView alloc] init];
        _loadingView.layer.masksToBounds = YES;
        _loadingView.layer.cornerRadius = 15.0f;
        _loadingView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.3f];
    }
    return _loadingView;
}
//{50,50}
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.image = [UIImage imageWithGIFNamed:@"request_loading"];
    }
    return _contentImageView;
}

- (UIView *)disableView {
    if (!_disableView) {
        _disableView = [UIView new];
        _disableView.backgroundColor = [UIColor clearColor];
    }
    return _disableView;
}

+ (instancetype)sharedInstance {
    static CRFLoadingView *loadingUitls = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        loadingUitls = [[self alloc] init];
    });
    return loadingUitls;
}

- (void)show {
    if ([self containSelf]) {
        return;
    }
    [self.rootWindow addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rootWindow);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    if (self.loadingView.subviews.count >= 1) {
        return;
    }
    [self.loadingView addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadingView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)showMajiabaoLoading {
    [self.rootWindow addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rootWindow);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    if (self.loadingView.subviews.count >= 1) {
        return;
    }
    [self.loadingView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadingView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.activityIndicatorView startAnimating];
}

+ (void)loading {
#ifdef WALLET
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        [[self sharedInstance] showMajiabaoLoading];
    } else {
        [[CRFLoadingView sharedInstance] show];
    }
#else
     [[CRFLoadingView sharedInstance] show];
#endif
}

+ (void)dismiss {
    [[self sharedInstance] removeDisableView];
    [CRFUtils delayAfert:.3f handle:^{
        [UIView animateWithDuration:.3f animations:^{
             [[CRFLoadingView sharedInstance].loadingView removeFromSuperview];
        }];
    }];
}

+ (void)setWindowDisable {
    [[self sharedInstance] addDisableView];
}

- (void)addDisableView {
    [self.rootWindow addSubview:self.disableView];
    [self.rootWindow bringSubviewToFront:self.loadingView];
    UIView *contentView = [self.rootWindow.subviews firstObject];
    [self.disableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(contentView);
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).with.offset(kNavHeight);
        make.bottom.equalTo(contentView).with.offset(-kTabBarHeight);
    }];
}

- (void)removeDisableView {
    [self.disableView removeFromSuperview];
}

+ (void)disableLoading {
    [self loading];
    [self setWindowDisable];
}

- (BOOL)containSelf {
    NSArray *views = self.rootWindow.subviews;
    for (UIView *view in views) {
        if ([view isEqual:self.loadingView]) {
            return YES;
        }
    }
    return NO;
}

@end
