//
//  CRFFirstVC.m
//  crf_purse
//
//  Created by maomao on 2017/8/23.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFFirstVC.h"
#import "CRFSettingData.h"
#import "CRFTabBarViewController.h"
#import "CRFLoginViewController.h"
#import "CRFControllerManager.h"
#import "CRFBasicNavigationController.h"
#import "CRFGestureManager.h"
#ifdef WALLET
#import "WMMJLoginViewController.h"
#endif

@interface CRFFirstVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl*pageControl;
@property (nonatomic, assign) NSInteger     count;
@end

@implementation CRFFirstVC
- (instancetype)crfInit {
    NSString *versionStr = [CRFUserDefaultManager getLocalVersionValue];
    if (versionStr == nil || ![versionStr isEqualToString:[CRFAppManager defaultManager].clientInfo.versionCode]) {
        [CRFSettingData setShowAppGuide:YES];
    } else {
        [CRFSettingData setShowAppGuide:NO];
    }
    if ([CRFSettingData isShowAppGuide]) {
        CRFFirstVC *firstVc=[[CRFFirstVC alloc] init];
        return firstVc;
    }
    return nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setContentUI];
}
- (void)setContentUI {
    _count = 4;
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight-63*kHeightRatio-8, kScreenWidth, 8)];
    self.pageControl.pageIndicatorTintColor = UIColorFromRGBValue(0xe2e2e2);
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGBValue(0xFB4D3A);
    [self.view addSubview:self.pageControl];
    NSArray <UIImage *>*images = nil;
    if ([CRFUtils isIPhoneXAll]) {
        images = [CRFAppManager defaultManager].majiabaoFlag? @[[UIImage imageNamed:@"welcome_02_X"],[UIImage imageNamed:@"welcome_03_X"],[UIImage imageNamed:@"welcome_04_X"]] : @[[UIImage imageNamed:@"welcome_01_X"],[UIImage imageNamed:@"welcome_02_X"],[UIImage imageNamed:@"welcome_03_X"],[UIImage imageNamed:@"welcome_04_X"]];
    } else {
        images = [CRFAppManager defaultManager].majiabaoFlag? @[[UIImage imageNamed:@"launch_image1"],[UIImage imageNamed:@"launch_image2"],[UIImage imageNamed:@"launch_image3"]] : @[[UIImage imageNamed:@"launch_image0"],[UIImage imageNamed:@"launch_image1"],[UIImage imageNamed:@"launch_image2"],[UIImage imageNamed:@"launch_image3"]];
    }
    
    _count = images.count;
     self.pageControl.numberOfPages = _count;
     [_scrollView setContentSize:CGSizeMake(kScreenWidth*_count, kScreenHeight)];
    for (int i = 0; i < _count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        imageView.image = images[i];
//        [imageView setContentMode:UIViewContentModeCenter];
        [_scrollView addSubview:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth * (_count - 1), kScreenHeight * 4 / 5, kScreenWidth, kScreenHeight / 5);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(crfFinishLaunch:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
//        if (i==count-1) {
////            imageView.userInteractionEnabled=YES;
//            
////            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(crfFinishLaunch:)];
////            [imageView addGestureRecognizer:tap];
//            
//        }
    }
    
    
//    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(scrollView.mas_centerX);
//        make.top.equalTo(scrollView.mas_bottom).with.offset(63*kHeightRatio);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 8));
//    }];
}
- (void)crfFinishLaunch:(UIButton *)btn {
    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha=0.1;
//        self.transform=CGAffineTransformMakeScale(2,2);
    } completion:^(BOOL finished) {
        //清楚缓存
//        [self removeFromSuperview];
        [CRFUserDefaultManager setLocalVersionValue:[CRFAppManager defaultManager].clientInfo.versionCode];
        [CRFSettingData setShowAppGuide:NO];
        [self pushNext];
    }];
}
- (void)pushNext{
#ifdef WALLET
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        WMMJLoginViewController *viewController = [WMMJLoginViewController new];
        CRFBasicNavigationController *nav = [[CRFBasicNavigationController alloc] initWithRootViewController:viewController];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    }
#else
    if ([self.crf_ladelegate respondsToSelector:@selector(Crf_GetUpVersion)]) {
        [self.crf_ladelegate Crf_GetUpVersion];
    }
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
        NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
        if (!success) {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    }];
    weakSelf(self);
    [self presentViewController:[CRFTabBarViewController new] animated:YES completion:^{
         [CRFGestureManager coolStartVerifyGesture];
    }];;
#endif
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = _scrollView.contentOffset.x / kScreenWidth;
    if (page == _count - 1) {
        _pageControl.hidden = YES;
    }else{
        _pageControl.hidden = NO;
    }
    _pageControl.currentPage = page;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
