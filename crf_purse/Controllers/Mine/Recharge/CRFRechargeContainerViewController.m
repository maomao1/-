//
//  CRFRechargeContainerViewController.m
//  crf_purse
//
//  Created by maomao on 2018/8/14.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRechargeContainerViewController.h"
#import "CRFRechargeViewController.h"
#import "CRFRecordViewController.h"
#import "CRFSupportBankInfoViewController.h"
@interface CRFRechargeContainerViewController ()<UIScrollViewDelegate>
@property (nonatomic , strong) CRFSegmentHead  *rechargeHeader;
@property (nonatomic , strong) UIScrollView    *containerSc;
@property (nonatomic , strong) CRFRechargeViewController *deRechargeVC;
@property (nonatomic , strong) CRFRechargeViewController *quickRechargeVC;
@property (nonatomic, assign) CGFloat contentOffY;

@end

@implementation CRFRechargeContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"充值"];
    [self crfSetHeadItem];
    [self setSelectSegment:0];
//    [self setRightNavItem];
}
- (void)setRightNavItem {
    [self setCustomRightBarBorderButtonWithTitle:@"限额说明" fontSize:12 target:self selector:@selector(supportBankList) titleColor:UIColorFromRGBValue(0x666666)];
}
- (void)back {
    if (self.popType == PopFrom_recharge) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
- (void)supportBankList {
    CRFSupportBankInfoViewController *controller = [CRFSupportBankInfoViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)crfSetHeadItem{
    NSArray *items = @[@"快捷充值",@"转账充值"];
    weakSelf(self);
    self.rechargeHeader = [[CRFSegmentHead alloc] initCommonWithFrame:CGRectMake(0, 0, kScreenWidth, 46) titles:items clickCallback:^(NSInteger index) {
        [weakSelf setSelectSegment:index];
    }];
    [self.view addSubview:self.rechargeHeader];
    self.containerSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, self.view.frame.size.height - 46)];
    self.containerSc.contentSize = CGSizeMake(items.count *kScreenWidth, self.view.frame.size.height+50);
    self.containerSc.pagingEnabled = YES;
    self.containerSc.delegate = self;
    [self.view addSubview:self.containerSc];
}
-(void)setSelectSegment:(NSInteger)index{
    if (!self.contentOffY) {
        self.contentOffY = 0;
    }
    switch (index) {
        case 0:
        {
//            [self setRightNavItem];
            if (!self.deRechargeVC) {
                self.deRechargeVC = [CRFRechargeViewController new];
                self.deRechargeVC.rechargeType = Default_recharge;
                self.deRechargeVC.bankInfo = self.bankInfo;
                self.deRechargeVC.view.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.containerSc.bounds));
                [self.containerSc addSubview:self.deRechargeVC.view];
                [self addChildViewController:self.deRechargeVC];
            }
            
            [self.containerSc setContentOffset:CGPointMake(0, self.contentOffY) animated:NO];
        }
            break;
        case 1:
        {
            if (!self.quickRechargeVC) {
                self.quickRechargeVC = [CRFRechargeViewController new];
                self.quickRechargeVC.rechargeType = Quick_recharge;
                self.quickRechargeVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(self.containerSc.bounds));
                [self.containerSc addSubview:self.quickRechargeVC.view];
                [self addChildViewController:self.quickRechargeVC];
            }
            [self.quickRechargeVC showQuickRechargeView];
            self.navigationItem.rightBarButtonItem = nil;
            [self.containerSc setContentOffset:CGPointMake(kScreenWidth, self.contentOffY) animated:NO];
        }
            break;
            
        default:
            break;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.rechargeHeader.defaultIndex = scrollView.contentOffset.x / kScreenWidth;
    self.contentOffY = scrollView.contentOffset.y;
    [self setSelectSegment:self.rechargeHeader.defaultIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.rechargeHeader scrollToContentsInSizeWithFloat:scrollView.contentOffset.x / kScreenWidth];
    
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
