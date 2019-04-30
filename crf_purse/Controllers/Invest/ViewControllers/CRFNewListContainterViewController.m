//
//  CRFNewListContainterViewController.m
//  crf_purse
//
//  Created by maomao on 2018/9/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFNewListContainterViewController.h"
#import "CRFNewInvestListViewController.h"
#import "CRFSegmentHead.h"
#import "CRFDebtListViewController.h"
@interface CRFNewListContainterViewController ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView    *containerSc;
@property (nonatomic , strong) CRFSegmentHead  *rechargeHeader;

@property (nonatomic , strong) CRFNewInvestListViewController *investListVC;
@property (nonatomic , strong) CRFDebtListViewController *ListVC;

@end

@implementation CRFNewListContainterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self crfSetHeadItem];
    [self setSelectSegment:0];
    
}
-(void)crfSetHeadItem{
    NSArray *items = @[@"出借计划",@"债权转让"];
    weakSelf(self);
    self.rechargeHeader = [[CRFSegmentHead alloc] initInvestFrame:CGRectMake(0, 0, 200, 44) titles:items clickCallbak:^(NSInteger index) {
        [weakSelf setSelectSegment:index];
    }];
    self.rechargeHeader.titleFont = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = self.rechargeHeader;
//    [self.view addSubview:self.rechargeHeader];
    self.containerSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kNavHeight-49-kTabBarBottomMargen)];
    self.containerSc.showsHorizontalScrollIndicator = NO;
    self.containerSc.contentSize = CGSizeMake(items.count *kScreenWidth, self.view.frame.size.height-49-kNavHeight-kTabBarBottomMargen);
    self.containerSc.pagingEnabled = YES;
    self.containerSc.delegate = self;
    [self.view addSubview:self.containerSc];
}
-(void)setSelectSegment:(NSInteger)index{
    NSArray *items = @[@"出借计划",@"债权转让"];
    [CRFAPPCountManager setEventID:@"INVEST_TOP_TAB_EVENT" EventName:items[index]];//埋点
    switch (index) {
        case 0:
        {
            if (!self.investListVC) {
                self.investListVC = [CRFNewInvestListViewController new];
                self.investListVC.view.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.containerSc.bounds));
                [self.containerSc addSubview:self.investListVC.view];
                [self addChildViewController:self.investListVC];
            }
            [self.containerSc setContentOffset:CGPointMake(0, 0) animated:NO];
        }
            break;
        case 1:
        {
            if (!self.ListVC) {
                self.ListVC = [CRFDebtListViewController new];
                self.ListVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(self.containerSc.bounds));
                [self.containerSc addSubview:self.ListVC.view];
                [self addChildViewController:self.ListVC];
            }
            [self.containerSc setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
        }
            break;
            
        default:
            break;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.rechargeHeader.defaultIndex = scrollView.contentOffset.x / kScreenWidth;
    [self setSelectSegment:self.rechargeHeader.defaultIndex];
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
