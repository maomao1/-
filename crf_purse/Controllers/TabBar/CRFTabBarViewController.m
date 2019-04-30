//
//  CRFTabBarViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFTabBarViewController.h"
#import "CRFHomePageViewController.h"
#import "CRFMineViewController.h"
#import "CRFDiscoveryViewController.h"
//#import "CRFInvestViewController.h"
#import "CRFTabBarItem.h"
#import "UIImage+Color.h"
#import "CRFBasicNavigationController.h"
#import "CRFControllerManager.h"
#import "JPUSHService.h"
#import "CRFInvestListViewController.h"
#import "CRFNewInvestListViewController.h"
#import "CRFNewDiscoveryViewController.h"

#import "CRFNewListContainterViewController.h"
#import "CRFLocationManager.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFUtils.h"
#import "CRFMessageDetailViewController.h"

@interface CRFTabBarViewController () {
    NSArray *itemNames;
    CGAffineTransform trans;
    BOOL  _isLocalPush;
    
}

@end

@implementation CRFTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(reloadResource:) name:kReloadResourceNotificationName];
    [UITabBar appearance].translucent = NO;
    //    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    //
    //    effectview.frame = CGRectMake(0, kScreenHeight - kTabBarHeight, kScreenWidth, kTabBarHeight);
    //    effectview.alpha = 1.0f;
    //    [self.view insertSubview:effectview atIndex:1];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setShadowImage:[UIImage imageNamed:@"tabbar_line"]];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    itemNames = @[NSLocalizedString(@"tabbar_home", nil),NSLocalizedString(@"tabbar_invest", nil),NSLocalizedString(@"tabbar_discovery", nil),NSLocalizedString(@"tabbar_mine", nil)];
    [self childController];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(receiveRemoteNotification:) name:kReceiveRemoteNotificationName];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:@"local_push_info"];
    if (userInfo) {
        _isLocalPush  = YES;
        [CRFUtils delayAfert:0.5 handle:^{
            [self manageJpushUserInfo:userInfo isLocal:_isLocalPush];
        }];
    } else {
        _isLocalPush = NO;
    }
}

- (void)clickIndex:(UITapGestureRecognizer *)tap {
    if (((CRFTabBarItem *)tap.view).selected) {
        return;
    }
    NSInteger index = tap.view.tag;
    [self selectedView:index];
    CRFTabBarItem *tabBar = [_tabBarView.subviews objectAtIndex:index];
    [UIView animateWithDuration:0.6 animations:^{
        [UIView animateWithDuration:0.3 animations:^{
            tabBar.imageView.transform = CGAffineTransformMakeScale(2, 2);
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            tabBar.imageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    self.selectedIndex = index;
}

- (void)move:(UIPanGestureRecognizer *)longGesture {
}

- (void)selectedView:(NSInteger)index {
    for (CRFTabBarItem *tabBar in _tabBarView.subviews) {
        if (tabBar.tag == index) {
            tabBar.selected = !tabBar.selected;
        } else {
            tabBar.selected = NO;
        }
    }
}

- (void)childController {
    CRFBasicNavigationController *mainNav = [self getVistableNav:[CRFHomePageViewController new]];
    CRFNewListContainterViewController *investViewController = [[CRFNewListContainterViewController alloc]init];
    //    CRFNewInvestListViewController *investViewController = [[CRFNewInvestListViewController alloc]init];
    
    CRFBasicNavigationController *investNav = [self getVistableNav:investViewController];
    [self loadResource:mainNav title:NSLocalizedString(@"tabbar_home", nil) image:@"tabbar_home_unselected" selectedImage:@"tabbar_home_selected"];
    //    CRFDiscoveryViewController *discoverViewController = [[CRFDiscoveryViewController alloc] init];
    CRFNewDiscoveryViewController *discoverViewController = [[CRFNewDiscoveryViewController alloc] init];
    CRFBasicNavigationController *discoverNav = [self getVistableNav:discoverViewController];
    CRFBasicNavigationController *mineNav = [self getVistableNav:[CRFMineViewController new]];
    [self loadResource:investNav title:NSLocalizedString(@"tabbar_invest", nil) image:@"tabbar_invest_unselected" selectedImage:@"tabbar_invest_selected"];
    [self loadResource:discoverNav title:NSLocalizedString(@"tabbar_discovery", nil) image:@"tabbar_discovery_unselected" selectedImage:@"tabbar_discovery_selected"];
    [self loadResource:mineNav title:NSLocalizedString(@"tabbar_mine", nil) image:@"tabbar_mine_unselected" selectedImage:@"tabbar_mine_selected"];
    self.viewControllers = @[mainNav,investNav,discoverNav,mineNav];
}

- (CRFBasicNavigationController *)getVistableNav:(UIViewController *)controller {
    CRFBasicNavigationController *nav = [[CRFBasicNavigationController alloc] initWithRootViewController:controller];
    return nav;
}

- (void)hideTabarView:(BOOL)isHideen  animated:(BOOL)animated {
    if (isHideen == YES) {
        if (animated) {
            [UIView animateWithDuration:0.6 animations:^{
                _tabBarView.transform = CGAffineTransformRotate(_tabBarView.transform, M_PI);
                _tabBarView.alpha = 0;
            }];
        } else {
            _tabBarView.alpha = 0;
        }
    } else {
        if (animated) {
            [UIView animateWithDuration:0.6 animations:^{
                _tabBarView.alpha = 1.0;
                _tabBarView.transform = trans;
            }];
        } else {
            _tabBarView.alpha = 1.0;
            _tabBarView.transform = trans;
        }
    }
}

- (void)loadResource:(CRFBasicNavigationController *)nav title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    UIImage *image = [CRFUtils loadImageResource:imageName];
    UIImage *selectedImage = [CRFUtils loadImageResource:selectedImageName];
    if ([CRFAppManager defaultManager].needReloadIcon) {
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    } else {
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xEE5250)} forState:UIControlStateSelected];
}

- (void)reloadResource:(NSNotification *)notification {
    NSArray <NSString *> *names = @[NSLocalizedString(@"tabbar_home", nil),NSLocalizedString(@"tabbar_invest", nil),NSLocalizedString(@"tabbar_discovery", nil),NSLocalizedString(@"tabbar_mine", nil)];
    NSArray <NSString *> *imageNames = @[@"tabbar_home_unselected",@"tabbar_invest_unselected",@"tabbar_discovery_unselected",@"tabbar_mine_unselected"];
    NSArray <NSString *> *selectedImageNames = @[@"tabbar_home_selected",@"tabbar_invest_selected",@"tabbar_discovery_selected",@"tabbar_mine_selected"];
    for (CRFBasicNavigationController *nav in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:nav];
        [self loadResource:nav title:names[index] image:imageNames[index] selectedImage:selectedImageNames[index]];
    }
}

#pragma mark - PushNotification methods
- (void)receiveRemoteNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    [self manageJpushUserInfo: userInfo isLocal:_isLocalPush];
}
- (void)manageJpushUserInfo:(NSDictionary *)userInfo isLocal:(BOOL)isLocal{
    [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[CRFAppManager defaultManager] setUnMessageCount:@"0"];
    if (userInfo == nil) {
        return;
    }
    
    CRFJPushModel *model = [CRFResponseFactory handleDataWithDic:userInfo forClass:[CRFJPushModel class]];
    
    if ([model.intent isEqualToString:kJPushChangeDevice]) {
        if (isLocal) {
            _isLocalPush = NO;
            [CRFControllerManager receivePushMessageGotoLogin];
        } else {
            if (![CRFAppManager defaultManager].login) {
                return;
            }
            CRFJPushMessageModel *messageItem = [CRFResponseFactory handleDataWithDic:userInfo[@"aps"] forClass:[CRFJPushMessageModel class]];
            [CRFControllerManager receivePushMessage:messageItem.alert confirmTitle:@"重新登录"];
        }
    }else if (model.intent.intValue == 1) {
        //intent 通知类型：0.打开应用 1.打开 H5 2.打开消息详情 3.打开公告详情
        CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
        webViewController.urlString = model.pageUrl;
        webViewController.hidesBottomBarWhenPushed = YES;
        [[CRFUtils getVisibleViewController].navigationController pushViewController:webViewController animated:YES];
    }else if (model.intent.intValue == 2||model.intent.intValue == 3){
        //intent 通知类型：0.打开应用 1.打开 H5 2.打开消息详情 3.打开公告详情
        
        UIViewController *controller = nil;
        if ([CRFAppManager defaultManager].login) {
            controller = [CRFMessageDetailViewController new];
            ((CRFMessageDetailViewController *)controller).mesType = model.intent.intValue - 2;
            ((CRFMessageDetailViewController *)controller).batchNo = model.batchNo;
            
        } else {
            controller = [CRFLoginViewController new];
        }
        controller.hidesBottomBarWhenPushed = YES;
        [[CRFUtils getVisibleViewController].navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
