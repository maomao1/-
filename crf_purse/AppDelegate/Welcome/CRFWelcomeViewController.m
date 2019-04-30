//
//  CRFWelcomeViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFWelcomeViewController.h"
#import "CRFTabBarViewController.h"
#import "CRFLoginViewController.h"
#import "CRFSettingData.h"
#import "CRFFirstVC.h"
#import "CRFStarPlayViewController.h"
#import "CRFFilePath.h"
#import "UIImage+Color.h"
#import "AppDelegate+UpdateVersion.h"
#import "CRFControllerManager.h"
#import "CRFBasicNavigationController.h"
#import "CRFGestureManager.h"
#ifndef WAllET
#import "WMMJLoginViewController.h"
#else

#endif

@interface CRFWelcomeViewController () <CRFPlayerDelegate,CRFFirstVCDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic,strong) CRFStarPlayViewController * starPlayVC;
@property (nonatomic,strong) CRFFirstVC *firstV;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation CRFWelcomeViewController

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#ifdef WALLET
     NSString *url =[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),@"",kHomePageArea_key,@"packageInfo"];
#else
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.imageView.image = [UIImage imageNamed:@"launchimage12422208"];
        if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))) {
            self.placeholderImage = [UIImage imageNamed:@"launch6401136"];
    }
    //6、6s、7、7s
    if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667))) {
        self.placeholderImage = [UIImage imageNamed:@"launch7501134"];
    }
    //6p、6sp、7p、7sp
    if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))) {
        self.placeholderImage = [UIImage imageNamed:@"launch12422208"];
    }
    if ([CRFUtils isIPhoneXAll]) {
        self.placeholderImage = [UIImage imageNamed:@"launch11252436"];
    }
    self.imageView.image = self.placeholderImage;
     NSString *url =[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),@"",kHomePageArea_key,@"app_open_page"];
//    [NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),@"app_open_page"];
    
#endif
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:url success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf paserResponseSuccess:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf close];
    }];
}

- (void)close {
#ifdef WALLET
    if ([CRFAppManager defaultManager].majiabaoFlag) {
         [self pushNext];
    } else {
        [self operaFactory];
    }
#else
    [self operaFactory];
#endif
}

- (void)operaFactory {
    _firstV = [[CRFFirstVC alloc] crfInit];
    if (_firstV) {
        _firstV.crf_ladelegate = self;
        [self presentViewController:_firstV animated:YES completion:nil];
    }else{
        [self pushNext];
    }
}

- (void)pushNext {
#ifdef WALLET
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        WMMJLoginViewController *viewController = [WMMJLoginViewController new];
        CRFBasicNavigationController *nav = [[CRFBasicNavigationController alloc] initWithRootViewController:viewController];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    } else {
        [self goNativeRoot];
    }
#else
    [self goNativeRoot];
#endif
}

- (void)goNativeRoot {
    if (self.callBack) {
        self.callBack();
    }
    CRFTabBarViewController *rootViewController = [CRFTabBarViewController new];
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
        NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
        if (!success) {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    }];
    [self presentViewController:rootViewController animated:YES completion:^{
        [CRFGestureManager coolStartVerifyGesture];
    }];
}

- (void)paserResponseSuccess:(id)response {
#ifdef WALLET
    NSArray *array = [CRFResponseFactory handleBannerDataForResult:response ForKey:@"packageInfo"];
    if (array.count <= 0) {
        [self close];
        return;
    }
    BOOL jump = NO;
    for (CRFAppHomeModel *model in array) {
        if ([model.urlKey isEqualToString:[NSString getAppId]]) {
            [CRFAppManager defaultManager].majiabaoFlag = [model.iconUrl boolValue];
            [self pushNext];
             jump = YES;
            break;
        }
    }
    if (!jump) {
        [self close];
    }
#else
    NSInteger markVideo = [CRFUtils isReturnFileVideo:[CRFResponseFactory getPageUrl:response]];
    [self createStarScreen:markVideo AndIconString:[CRFResponseFactory getPageUrl:response]];
#endif

}

- (void)createStarScreen:(NSInteger)tag AndIconString:(NSString*)urlStr{
    if (tag == 1) {
        //加载视频
//        if ([CRFFilePath isFileIsExist:[CRFFilePath getFilePath:[[urlStr componentsSeparatedByString:@"/"] lastObject]]]) {
//            weakSelf(self);
//            self.starPlayVC = [CRFStarPlayViewController newFeatureVCWithPlayerURL:[NSURL fileURLWithPath:[CRFFilePath getFilePath:[[urlStr componentsSeparatedByString:@"/"] lastObject]]] enterBlock:^{
//                [weakSelf removePlayView];
//            } configuration:^(AVPlayerLayer *playerLayer) {
//                
//            }];
//            self.starPlayVC.crf_delegate = self;
//            [self.view addSubview:self.starPlayVC.view];
//            self.starPlayVC.view.frame = [UIScreen mainScreen].bounds;
//            [self addChildViewController:self.starPlayVC];
//        }else
//        {
            weakSelf(self);
            [[CRFStandardNetworkManager defaultManager] addObserverNetworkStatus:^(AFNetworkReachabilityStatus status) {
                strongSelf(weakSelf);
                if (status != AFNetworkReachabilityStatusNotReachable) {
                    strongSelf.starPlayVC = [CRFStarPlayViewController newFeatureVCWithPlayerURL:[NSURL URLWithString:urlStr] enterBlock:^{
                        [strongSelf removePlayView];
                    } configuration:^(AVPlayerLayer *playerLayer) {
                    }];
                    if (strongSelf.starPlayVC) {
                        strongSelf.starPlayVC.crf_delegate = strongSelf;
                        [strongSelf.view addSubview:strongSelf.starPlayVC.view];
                        [strongSelf addChildViewController:strongSelf.starPlayVC];
                    } else {
                       [strongSelf close];
                    }
                } else {
                    
                }
            }];
//        }
    } else if(tag == 2) {
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(close) userInfo:nil repeats:NO];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:self.placeholderImage options:SDWebImageScaleDownLargeImages];
    } else {
        [self close];
    }
}

- (void)removePlayView {
    [self.starPlayVC.view removeFromSuperview];
    [self.starPlayVC removeFromParentViewController];
    [self close];
    
}
- (void)clickJumpBtn {
    [self.starPlayVC.view removeFromSuperview];
    [self.starPlayVC removeFromParentViewController];
    [self close];
}

- (void)Crf_GetUpVersion {
    if (self.callBack) {
        self.callBack();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    DLog(@"%@ is dealloc",NSStringFromClass([self class]));
}

@end
