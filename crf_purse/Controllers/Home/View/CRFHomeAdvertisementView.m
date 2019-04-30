//
//  CRFADView.m
//  crf_purse
//
//  Created by maomao on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeAdvertisementView.h"
#import "CRFAppHomeModel.h"
#import "CRFUpdateView.h"
#import "CRFHomePageViewController.h"

static  const CGFloat  viewHeight = 360;
static  const CGFloat  viewWidth  = 275;

@interface CRFHomeAdvertisementView()<UIScrollViewDelegate> {
    UIPageControl  *_pageControl;
    UIButton       *_closeBtn;
    UIScrollView   *_scrollView;
    NSArray        *_imageArray;
}
@end

@implementation CRFHomeAdvertisementView

- (instancetype)initWithframe:(CGRect)frame images:(NSArray *)imageArray {
    self = [super initWithFrame:frame];
    _imageArray = imageArray;
    if (self) {
        [self setUI];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return self;
}

- (void)setUI {
    _scrollView=[[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(kScreenWidth*_imageArray.count, viewHeight*kWidthRatio)];
    _closeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _pageControl = [[UIPageControl alloc] init];
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    [self addSubview:_closeBtn];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, viewHeight*kWidthRatio));
    }];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.mas_centerX);
        make.top.equalTo(_scrollView.mas_bottom).with.offset(25*kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 5));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pageControl.mas_bottom).with.offset(30);
        make.centerX.equalTo(_scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    CGFloat padding = 50;
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(padding * kWidthRatio + kScreenWidth * i, 0, viewWidth * kWidthRatio, viewHeight * kWidthRatio);
        [_scrollView addSubview:imageView];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 8;
        imageView.userInteractionEnabled = YES;
        CRFAppHomeModel *imageModel = _imageArray[i];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.iconUrl] placeholderImage:[UIImage imageNamed:@"AD_default"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.iconUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                imageView.image = [UIImage imageNamed:@"AD_default"];
            }
        }];
        
        imageView.tag = 1000 + i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        
    }
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(removeViewClick) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.layer.masksToBounds = YES;
    _closeBtn.layer.cornerRadius = 20;
    _pageControl.hidden = NO;
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.hidesForSinglePage = YES;
}

- (void)imageClick:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 1000;
    if ([self.pushDelegate respondsToSelector:@selector(pushAdvertisementDetail:)]) {
        [self removeFromSuperview];
        CRFAppHomeModel *model = _imageArray[index];
        [self.pushDelegate pushAdvertisementDetail:model.jumpUrl];
        [CRFAPPCountManager setEventID:@"HOME_AD_EVENT" EventName:model.name];
    }
}

- (void)showAdView:(UIView *)containerView {
    if (![[CRFUtils getVisibleViewController] isKindOfClass:[CRFHomePageViewController class]]) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[CRFUpdateView class]] || [view isKindOfClass:NSClassFromString(@"CRFSupervisionInfoView")]) {
            [window insertSubview:self belowSubview:view];
            return;
        }
    }
    [window addSubview:self];
}

- (void)removeViewClick {
    [CRFAPPCountManager setEventID:@"HOME_AD_EVENT" EventName:@"首页广告弹框关闭按钮"];
    [self removeFromSuperview];
    if ([self.pushDelegate respondsToSelector:@selector(close)]) {
        [self.pushDelegate close];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _scrollView.contentOffset.x/kScreenWidth;
    _pageControl.currentPage = page;
}
@end
