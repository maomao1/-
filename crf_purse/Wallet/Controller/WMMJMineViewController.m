//
//  WMMineViewController.m
//  WMWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJMineViewController.h"
#import "CRFProfileViewController.h"
#import "CRFMoreViewController.h"
#import "CRFLoginViewController.h"
#import "CRFRegisterViewController.h"
#import "CRFFeedbackViewController.h"
#import "CRFMessageScrollViewController.h"
#import "CRFIMViewController.h"
#import "WMMJMineHeaderView.h"
#import "CRFCreateAccountViewController.h"
#import "CRFRollOutViewController.h"
//#import "CRFRechargeViewController.h"
#import "CRFRechargeContainerViewController.h"
#import "CRFRewardViewController.h"
#import "CRFRelateAccountViewController.h"
#import "CRFMyInvestViewController.h"
#import "MJRefresh.h"
#import "CRFControllerManager.h"
#import "CRFAuthView.h"
#import "WMMJMineCollectionViewCell.h"

static NSString *const kMineHeaderViewIdentifier = @"headerView";
static NSString *const kMineCellIdentifier = @"mineCell";

@interface WMMJMineViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, HeaderViewDelegate> {
    NSArray <NSString *>*datas;
    NSArray <UIImage *>*images;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger unreadMessageCount;
@property (nonatomic, strong) WMMJMineHeaderView *headerView;
@property (nonatomic, strong) NSArray <CRFMyInvestProduct *>*products;

@property (nonatomic, assign) BOOL flag;

@end

@implementation WMMJMineViewController

- (void)initializeView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    [self.view addSubview:self.collectionView];
     [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
     }];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, kNavHeight + 230 * kWidthRatio);
    layout.itemSize = CGSizeMake((kScreenWidth - 1.5) / 3, 115 * kWidthRatio);
    layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = .5;
    [self.collectionView registerClass:[WMMJMineCollectionViewCell class] forCellWithReuseIdentifier:kMineCellIdentifier];
    [self.collectionView registerClass:[WMMJMineHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMineHeaderViewIdentifier];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([CRFAppManager defaultManager].login && [[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 2) {
        self.headerView.accountInfo = [CRFAppManager defaultManager].accountInfo;
        self.headerView.userStatus = On_line;
    } else {
        if (![CRFAppManager defaultManager].login) {
            self.headerView.userStatus = Off_line;
        } else {
            self.headerView.userStatus = On_line;
        }
    }
    [self.collectionView reloadData];
    NSString* cName = @"我";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnter:cName];
}
// 退出页面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = @"我";
    [[CRFAPPCountManager sharedManager] crf_pageViewEnd:cName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    datas = @[NSLocalizedString(@"cell_label_invest", nil),NSLocalizedString(@"cell_label_reward", nil),NSLocalizedString(@"cell_label_notify", nil),NSLocalizedString(@"cell_label_IM", nil),NSLocalizedString(@"cell_label_setting", nil)];
    images = @[[UIImage imageNamed:@"me_invest"],[UIImage imageNamed:@"me_redenvelope"],[UIImage imageNamed:@"me_mesage"],[UIImage imageNamed:@"me_customerservices"],[UIImage imageNamed:@"me_setting"]];
    [self tableHeaderView];
    [self getUserInfo];
//    [self refresh];
}

- (void)requestDatas {
    [CRFControllerManager loadingHomeUserAvatar];
    self.headerView.userStatus = On_line;
    [self getConfig];
}

- (void)getConfig {
    if ([[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 2) {
        [self getUserAssetsTotal];
    }
    [self refreshUnreadMessageCount];
    if ([[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 2) {
        [self getInvestInfo];
    }
}

- (void)getUserInfo {
    if (self.flag) {
        if ([CRFAppManager defaultManager].login) {
            [self requestDatas];
            //            self.flag = NO;
        }
    } else {
        self.flag = YES;
        [CRFRefreshUserInfoHandler defaultHandler].userInfo = [CRFAppManager defaultManager].userInfo;
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            if (success) {
                [self requestDatas];
            } else {
                if([CRFAppManager defaultManager].login) {
                    self.headerView.userStatus = On_line;
                } else {
                    self.headerView.userStatus = Off_line;
                }
            }
            [self.collectionView reloadData];
        }];
    }
    weakSelf(self);
    self.refreshUserAssertAccount = ^ {
        strongSelf(weakSelf);
        [strongSelf getUserAssetsTotal];
    };
    self.refreshInvestList = ^ {
        strongSelf(weakSelf);
        [strongSelf getInvestInfo];
    };
    self.refreshMineConfig = ^ {
        strongSelf(weakSelf);
        [strongSelf getConfig];
    };
}

- (void)tableHeaderView {
    weakSelf(self);
    self.refreshUserInfo = ^ {
        strongSelf(weakSelf);
        [strongSelf getUserInfo];
        if (![CRFAppManager defaultManager].login) {
            strongSelf.headerView.userStatus = Off_line;
        }
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMMJMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMineCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = images[indexPath.item];
    cell.titleLabel.text = datas[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return datas.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    _headerView = (WMMJMineHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMineHeaderViewIdentifier forIndexPath:indexPath];
    _headerView.headerDelegate = self;
    return _headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    switch (indexPath.item) {
            case 0: {
                if ([[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 1) {
                    viewController = [CRFCreateAccountViewController new];
                } else {
                viewController = [CRFMyInvestViewController new];
                [viewController setValue:@(1) forKey:@"selectedIndex"];
                }
            }
            break;
            case 1: {
                viewController = [CRFRewardViewController new];
                NSString *urlString = [NSString stringWithFormat:@"%@?%@",kRedAndCouponH5,kH5NeedHeaderInfo];
                [viewController setValue:urlString forKey:@"urlString"];
            }
            break;
            case 2: {
                viewController = [CRFMessageScrollViewController new];
            }
            break;
            case 3: {
                NSURL *callUrl = [NSURL
                                  URLWithString:[NSString stringWithFormat:@"tel:400-178-9898"]];
                if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                        [[UIApplication sharedApplication] openURL:callUrl options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:callUrl];
                    }
                }
                return;
            }
            break;
            case 4: {
                viewController = [CRFMoreViewController new];
            }
            break;
    }
    
    if (viewController) {
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark HeaderViewDelegate
- (void)userInfo {
    UIViewController *controller = nil;
    if ([CRFAppManager defaultManager].login) {
        controller = [CRFProfileViewController new];
    } else {
        controller = [CRFLoginViewController new];
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)userRecharge {
    UIViewController *controller = nil;
    if ([CRFAppManager defaultManager].login) {
        if ([[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 1) {
            [self checkUserAccountStatus];
        } else {
            controller = [CRFRechargeContainerViewController new];
        }
    } else {
        controller = [CRFLoginViewController new];
    }
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)userTransform {
    UIViewController *controller = nil;
    if ([CRFAppManager defaultManager].login) {
        CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
        if ([userInfo.accountStatus integerValue] == 1) {
            [self checkUserAccountStatus];
        } else {
            controller = [CRFRollOutViewController new];
            ((CRFRollOutViewController *)controller).bankInfo =  [NSString stringWithFormat:@"%@卡(%@)",[userInfo.bankCode getBankCode].bankName,[userInfo.openBankCardNo substringFromIndex:userInfo.openBankCardNo.length - 4]];
            ((CRFRollOutViewController *)controller).avaibleMoney = [CRFAppManager defaultManager].accountInfo.availableBalance;
        }
    } else {
        controller = [CRFLoginViewController new];
    }
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)refreshUnreadMessageCount {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUnreadMessagePath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            DLog(@"get un read message count success.");
            strongSelf.unreadMessageCount = [response[@"data"][@"count"] integerValue];
            [CRFAppManager defaultManager].unMessageCount = [NSString stringWithFormat:@"%ld",(long)strongSelf.unreadMessageCount];
        } else {
            DLog(@"get un read message count failed.");
        }
        
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)checkUserAccountStatus {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
                CRFRelateAccountViewController *controller = [CRFRelateAccountViewController new];
                controller.hidesBottomBarWhenPushed = YES;
                controller.relatePhone = [CRFAppManager defaultManager].userInfo.phoneNo;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            } else {
                CRFCreateAccountViewController *controller = [CRFCreateAccountViewController new];
                controller.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            }
        } else {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)getInvestInfo {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestListPath),[CRFAppManager defaultManager].userInfo.userId] paragrams:@{kPageSizeKey:@"100000",@"investStatusType":@"0"} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            DLog(@"get invest list count success.");
            strongSelf.products = [CRFResponseFactory myInvestList:response];
            //计息中1笔（共5笔）
            strongSelf.investInfo = [NSString stringWithFormat:@"计息中%@笔(共%@笔)",response[kDataKey][@"holdCount"],response[kDataKey][@"totalCount"]];
           
        } else {
            DLog(@"get invest list count failed.");
        }
        [strongSelf refreshUnreadMessageCount];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf refreshUnreadMessageCount];
    }];
}

- (void)getUserAssetsTotal {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUserAssetsTotalPath),[CRFAppManager defaultManager].userInfo.userId] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        NSLog(@"===============================");
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            DLog(@"get user assets success.");
            CRFAccountInfo *info = [CRFResponseFactory getAccountInfo:response];
            [CRFAppManager defaultManager].accountInfo = info;
            strongSelf.headerView.accountInfo = info;
        } else {
            DLog(@"get user assets failed.");
        }
        [strongSelf getInvestInfo];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf getInvestInfo];
    }];
}

- (void)refresh {
    weakSelf(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        if ([CRFAppManager defaultManager].login) {
            [strongSelf.headerView refreshImageView];
            if ([[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 2) {
                [strongSelf getUserAssetsTotal];
            } else {
                [self refreshUnreadMessageCount];
            }
        } else {
            
        }
    }];
    if ([CRFUtils isIPhoneXAll]) {
        
    }
}


@end

