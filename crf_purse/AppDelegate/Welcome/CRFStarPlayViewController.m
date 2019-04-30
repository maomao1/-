//
//  CRFStarPlayViewController.m
//  crf_purse
//
//  Created by maomao on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFStarPlayViewController.h"
#import "CRFWelcomeViewController.h"
#import "CRFTabBarViewController.h"
#import "CRFLoginViewController.h"
#import "CRFSettingData.h"
#import "AppDelegate.h"
#import "CRFFilePath.h"
//#import "CRFFirstLaunchV.h"
@interface CRFStarPlayViewController ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer      *player;

@property (nonatomic,copy) void(^enterBlock)();
@end

@implementation CRFStarPlayViewController

+ (instancetype)newFeatureVCWithPlayerURL:(NSURL *)URL enterBlock:(void(^)())enterBlock configuration:(void (^)(AVPlayerLayer *playerLayer))configurationBlock {
    NSString *versionStr = [CRFUserDefaultManager getLocalVersionValue];
    if (versionStr == nil || [versionStr isEqualToString:[CRFAppManager defaultManager].clientInfo.versionCode]) {
        CRFStarPlayViewController *newFeatureVC = [[CRFStarPlayViewController alloc] init];
        [newFeatureVC setUpNotification];
        configurationBlock([newFeatureVC playerWith:URL]);
        newFeatureVC.enterBlock = enterBlock;
        return newFeatureVC;
    } else {
        return nil;
    }
}

- (void)setUpNotification {
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(dismiss) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification];
}

- (void)dealloc {
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    if (_player) {
        [_player play];
    }
}

- (void)applicationDidEnterBackground:(NSNotification*)notification {
    if (_player) {
        [_player pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.enterButton];
    
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(kScreenWidth - 75, kStatusBarHeight + 5, 60, 30);
        _enterButton.opaque = YES;
        [_enterButton setTitle:@"跳过" forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_enterButton addTarget:self action:@selector(chickEnterButton) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.backgroundColor = UIColorFromRGBValueAndalpha(0x000000, 0.4);
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius  = 15;
    }
    return _enterButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    AVAsset *currentPlayerAsset = playerItem.asset;
    NSURL* playUrl;
    if ([currentPlayerAsset isKindOfClass:[AVURLAsset class]]) {
        playUrl = ((AVURLAsset *)currentPlayerAsset).URL;
    }
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
            [self dismiss];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:[CRFFilePath getFilePath:playUrl.absoluteString] error:nil];
        }
    }
}

#pragma mark - 初始化播放器
- (AVPlayerLayer *)playerWith:(NSURL *)URL {
    if (_playerLayer == nil) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
        _player = [AVPlayer playerWithPlayerItem:item];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        _playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view.layer addSublayer:_playerLayer];
        [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        NSError *error;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        [session setActive:YES error:&error];
        DLog(@"begin set session is %@",error);
        [_player play];
    }
    return _playerLayer;
}

- (void)chickEnterButton {
    [self.player pause];
    [self clearPlayer];
    if ([self.crf_delegate respondsToSelector:@selector(clickJumpBtn)]) {
        [self.crf_delegate clickJumpBtn];
    }
}

- (void)clearPlayer {
    [CRFNotificationUtils removeObserver:self];
    [self.playerLayer.player.currentItem cancelPendingSeeks];
    [self.playerLayer.player.currentItem.asset cancelLoading];
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    DLog(@"clear error: %@",error);
}

- (void)applicationWillTerminate {
    DLog(@"app terminate");
    [self clearPlayer];
}

- (void)dismiss {
    [self clearPlayer];
    if(self.enterBlock != nil) _enterBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.enterButton];
    if (_player) {
        [_player play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
