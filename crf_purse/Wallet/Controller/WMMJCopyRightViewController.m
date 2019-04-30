//
//  WMMJCopyRightViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJCopyRightViewController.h"

@interface WMMJCopyRightViewController ()

@end

@implementation WMMJCopyRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializationView];
    [super customNavigationBackForWhite];
}

- (void)initializationView {
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景"]];
    [self.view addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(205 * kWidthRatio);
    }];
    UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"版权信息"]];
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-130 * kWidthRatio);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300 * kWidthRatio, 202 * kWidthRatio));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
