//
//  CRFBasicNavigationController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicNavigationController.h"
#import "CRFStaticWebViewViewController.h"
#import "CRFMineViewController.h"
#import "CRFHomePageViewController.h"
#import "CRFNewInvestListViewController.h"
#import "CRFNewDiscoveryViewController.h"
#import "CRFNewListContainterViewController.h"
@interface CRFBasicNavigationController ()

@end

@implementation CRFBasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    NSString *eventName = nil;
    if ([self.topViewController isKindOfClass:[CRFMineViewController class]]) {
        eventName = @"我";
    }
    if ([self.topViewController isKindOfClass:[CRFHomePageViewController class]]) {
        eventName = @"首页";
    }
    if ([self.topViewController isKindOfClass:[CRFNewDiscoveryViewController class]]) {
        eventName = @"发现";
    }
    if ([self.topViewController isKindOfClass:[CRFNewListContainterViewController class]]) {
        eventName = @"投资";
    }
    if (eventName.length) {
        [CRFAPPCountManager setEventID:@"HOME_TAB_EVENT" EventName:eventName];
    }
    return self.topViewController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![[super topViewController] isKindOfClass:[viewController class]]) {
        [super pushViewController:viewController animated:animated];
    } else if ([[super topViewController] isKindOfClass:NSClassFromString(@"CRFStaticWebViewViewController")] && [viewController isKindOfClass:NSClassFromString(@"CRFStaticWebViewViewController")]) {
        [super pushViewController:viewController animated:animated];
    } else if ([[super topViewController] isKindOfClass:NSClassFromString(@"CRFMessageDetailViewController")] && [viewController isKindOfClass:NSClassFromString(@"CRFMessageDetailViewController")]) {
        [super pushViewController:viewController animated:animated];
    }
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
