//
//  WMMJTabBarViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJTabBarViewController.h"
#import "WMMJHomeViewController.h"
#import "WMMJMineViewController.h"
#import "WMMJViewController.h"
#import "CRFBasicNavigationController.h"


@interface WMMJTabBarViewController ()

@end

@implementation WMMJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setShadowImage:[UIImage imageNamed:@"tabbar_line"]];
    [self initializeView];
}

- (void)initializeView {
    WMMJHomeViewController *homeViewController = [WMMJHomeViewController new];
    CRFBasicNavigationController *homeNav = [[CRFBasicNavigationController alloc] initWithRootViewController:homeViewController];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabbar_home", nil) image:[[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} forState:UIControlStateSelected];
    WMMJViewController *newViewController = [WMMJViewController new];
    CRFBasicNavigationController *newNav = [[CRFBasicNavigationController alloc] initWithRootViewController:newViewController];
    newNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资讯" image:[[UIImage imageNamed:@"news"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"news_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [newNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [newNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} forState:UIControlStateSelected];
    WMMJMineViewController *mineViewController = [WMMJMineViewController new];
    CRFBasicNavigationController *mineNav = [[CRFBasicNavigationController alloc] initWithRootViewController:mineViewController];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [mineNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} forState:UIControlStateSelected];
    self.viewControllers = @[homeNav,newNav,mineNav];
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
