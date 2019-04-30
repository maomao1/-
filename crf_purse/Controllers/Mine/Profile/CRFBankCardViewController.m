//
//  CRFBankCardViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBankCardViewController.h"
#import "CRFChangeBankCardViewController.h"
#import "CRFBankCardAuditView.h"
#import "CRFBankCardApplyErrorView.h"

@interface CRFBankCardViewController () <UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CRFBankCardApplyErrorView *errorView;

@property (nonatomic, strong) NSArray <CRFBankInfo *>*bankList;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/**
 换卡申请状态 0、正常（换卡成功及没有换卡）1、审核中 2、审核失败 
 */
@property (nonatomic, assign) NSInteger bankStatuType;

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation CRFBankCardViewController

- (CRFBankCardApplyErrorView *)errorView {
    if (!_errorView) {
        _errorView = [CRFBankCardApplyErrorView new];
        weakSelf(self);
        [_errorView setCloseHandler:^{
            strongSelf(weakSelf);
            [strongSelf.errorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            strongSelf.errorView.hidden = YES;
            [strongSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(strongSelf.view);
            }];
            [UIView animateWithDuration:.5 animations:^{
                [strongSelf.view layoutIfNeeded];
            }];
        }];
    }
    return _errorView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _flowLayout.itemSize = CGSizeMake(345 * kWidthRatio, 120 * kWidthRatio);
        _flowLayout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, 0, kSpace);
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CRFCardInfoCollectionViewCell class] forCellWithReuseIdentifier:@"cardInfo"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_bank_card_info", nil);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [self rightBarButton];
    [self getBankCardList];
    weakSelf(self);
    [self addRequestNotificationStatus:Status_Off_Line handler:^{
        strongSelf(weakSelf);
        [strongSelf getBankCardList];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    self.updateBankStatus = ^ {
        strongSelf(weakSelf);
        [strongSelf getBankCardList];
    };
}

- (void)getBankCardList {
    weakSelf(self);
    [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetBankCardListPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf handlerReponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        strongSelf(weakSelf);
        strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
        strongSelf.requestStatus = Status_Off_Line;
        strongSelf.requestStatusOperationHandler = ^ {
            [weakSelf getBankCardList];
        };
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
    }];
}

- (void)rightBarButton {
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"更换银行卡" forState:UIControlStateNormal];
    [_rightButton setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
    [_rightButton setTitleColor:UIColorFromRGBValue(0xB3B3B3) forState:UIControlStateDisabled];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _rightButton.layer.masksToBounds = YES;
    _rightButton.layer.cornerRadius = 12.0;
    _rightButton.frame = CGRectMake(0, 0, 74, 24);
    _rightButton.layer.borderWidth = 1.0f;
    _rightButton.layer.borderColor = UIColorFromRGBValue(0x999999).CGColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [_rightButton addTarget:self action:@selector(changeBankCard) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.rightBarButtonItem addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)changeBankCard {
    CRFChangeBankCardViewController *bankCardVC = [CRFChangeBankCardViewController new];
    bankCardVC.bankInfo = [self.bankList objectAtIndex:0];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFCardInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardInfo" forIndexPath:indexPath];
    CRFBankInfo *bankInfo = self.bankList[indexPath.item];
    cell.imageUrl = bankInfo.bankPicUrl;
    cell.cardName = [bankInfo.bankCode getBankCode].bankName;
    cell.cardNo = bankInfo.openBankCardNo;
    cell.cardType = @"借记卡";
    if (self.bankStatuType == 1) {
        //原卡
        if ([bankInfo.cardFlag integerValue] == 0) {
            cell.bankCardStatus = CRFBankCardStatus_Pause;
        } else {
            //新卡
            cell.bankCardStatus = CRFBankCardStatus_Audit;
        }
    } else {
        cell.bankCardStatus = CRFBankCardStatus_Normal;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bankList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.bankStatuType != 1) {
        return nil;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CRFBankCardAuditView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"auditView" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --AFNetworking
- (void)handlerReponse:(id)response {
    if (!response[kDataKey][@"status"]) {
        return;
    }
    self.bankStatuType = [response[kDataKey][@"status"] integerValue];
    DLog(@"bankcard list is %@",response);
    //需要注册collectionView的header
    if (self.bankStatuType == 1) {
        _flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 174);
        [_collectionView registerClass:[CRFBankCardAuditView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"auditView"];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.bankList = [CRFResponseFactory handlerBankInfo:response];
    [self.collectionView reloadData];
    [UIView animateWithDuration:.0f animations:^{
        [self.view layoutIfNeeded];
    }];
    if (self.bankStatuType == 2) {
        //加个flag，这个错误提示只会提示一次
        [CRFUserDefaultManager setBankAuditStatus:NO];
        if (![CRFUserDefaultManager getBankCardAuthErrorFlag]) {
            [self.errorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([self.errorView getThisHeight]);
            }];
            self.errorView.hidden = NO;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset([self.errorView getThisHeight]);
            }];
            [UIView animateWithDuration:.5 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    } else if (self.bankCardStatus == 1) {
        [CRFUserDefaultManager setBankAuditStatus:YES];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    BOOL value = [change[@"new"] boolValue];
    self.rightButton.enabled = value;
    if (value) {
        self.rightButton.layer.borderColor = UIColorFromRGBValue(0x999999).CGColor;
    } else {
        self.rightButton.layer.borderColor = UIColorFromRGBValue(0xB3B3B3).CGColor;
    }
}

- (void)dealloc {
    @try {
        [self.navigationItem.rightBarButtonItem removeObserver:self forKeyPath:@"enabled"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
    [CRFLoadingView dismiss];
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
