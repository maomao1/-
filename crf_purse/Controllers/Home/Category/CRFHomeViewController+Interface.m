//
//  CRFHomeViewController+Interface.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeViewController+Interface.h"
#import "CRFHomeConfigHendler.h"
#import "CRFDIYHeader.h"
#import "CRFRelateAccountViewController.h"
#import "CRFCreateAccountViewController.h"
#import "CRFEvaluatingViewController.h"
#import "CRFControllerManager.h"
#import "CRFAlertUtils.h"
#import "CRFStringUtils.h"
#import "CRFExplanOperateViewController.h"


@implementation CRFHomeViewController (Interface)

- (void)requestDatas {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kHomePageArea_key] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [[CRFHomeConfigHendler defaultHandler] parseHomeConfig:response];
        [strongSelf getUserInfo];
        [strongSelf getActivity];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf getActivity];
    }];
}

- (void)getActivity {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@/1",APIFormat(kHomeAnnouncementPath)] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        if (![CRFAppManager defaultManager].majiabaoFlag) {
             [[CRFHomeConfigHendler defaultHandler] parseActivity:response];
        }
        [strongSelf.productArray removeAllObjects];
        [strongSelf assignmentHome:[CRFHomeConfigHendler defaultHandler].homeDataDicM];
        [strongSelf getAppProducts];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        strongSelf(weakSelf);
        [strongSelf getAppProducts];
    }];
}

- (void)getAppProducts {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kHomeProductsListPath),kUserInfo.customerUid] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf parseProducts:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf.recommendTabView.mj_header endRefreshing];
//        strongSelf(weakSelf);
//        [strongSelf addHomeDefaultView];
    }];
}

- (void)getUserAssetsTotal {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUserAssetsTotalPath),kUuid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFAppManager defaultManager].accountInfo = [CRFResponseFactory getAccountInfo:response];
        if (strongSelf.refreshTopHeader.refreshType == Unlogin) {
            strongSelf.refreshTopHeader.refreshType = UserLogin;
        }
        strongSelf.refreshTopHeader.accountInfo = [CRFAppManager defaultManager].accountInfo;
        DLog(@"get user assets total success.");
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        DLog(@"get user assets total failed.");
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)parseProducts:(id)response {
    [self.recommendTabView.mj_header endRefreshing];
    [self.productArray removeAllObjects];
    NSArray *first = [[CRFResponseFactory handleProductDataForResult:response ForKey:newUserProduct_key] mutableCopy];
    NSArray *last = [[CRFResponseFactory handleProductDataForResult:response ForKey:oldUserProduct_key] mutableCopy];
    if (first.count > 0) {
        [self.productArray addObject:[NSArray arrayWithArray:first]];
        self.productFactory.noviceProducts = first;
    } else {
        self.productFactory.noviceProducts = nil;
    }
    if (last.count > 0) {
        [self.productArray addObject:[NSArray arrayWithArray:last]];
    }
    self.productFactory.products = self.productArray;
    [self.recommendTabView reloadData];
    [self setFooterView];
    [UIView animateWithDuration:.0f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)checkUserAccountStatus {
    weakSelf(self);
    [CRFLoadingView disableLoading];
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":kUserInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        if (!response[@"data"][@"hasAccount"]) {
            return;
        }
        strongSelf(weakSelf);
        if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
            CRFRelateAccountViewController *controller = [CRFRelateAccountViewController new];
            controller.relatePhone = kUserInfo.phoneNo;
            controller.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:controller animated:YES];
        } else {
            CRFCreateAccountViewController *controller = [CRFCreateAccountViewController new];
            controller.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:controller animated:YES];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)addHomeDefaultView {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] networkIsVisible:^(BOOL visible) {
        strongSelf(weakSelf);
        if (!visible && [CRFHomeConfigHendler defaultHandler].localizedHomeDatas.allKeys.count <= 0) {
            strongSelf.requestStatus = Status_Home_Net_Error;
            [strongSelf.view bringSubviewToFront:strongSelf.headerView];
            [strongSelf.view bringSubviewToFront:strongSelf.avatarImageView];
        } else if (visible) {
            strongSelf.requestStatus = Status_Normal;
            [[CRFHomeConfigHendler defaultHandler].homeDataDicM removeAllObjects];
            [strongSelf requestDatas];
        }
    }];
}

- (void)pushWebDetailWithUrlString:(NSString *)webUrl canGoBack:(BOOL)canGoBack rightStyle:(WebViewRightStyle)rightStyle {

    if ([webUrl isEmpty]) {
        return;
    }
    CRFStaticWebViewViewController *webVc = [CRFStaticWebViewViewController new];
    webVc.urlString = webUrl;
    webVc.backType = canGoBack ? WebViewGoBack : WebViewClose;
    webVc.rightStyle = rightStyle;
    if ([webUrl containsString:@"global_index.html"]||[webUrl containsString:@"global_invite"]||[webUrl containsString:@"global"]) {
        webVc.statusBarIsWhite = YES;
        webVc.backViewStyle = WebViewBackViewStyle_White;
        webVc.haveDelegate = YES;
        webVc.popGestureDisable = YES;
        [webVc setBlackBarColor];
    }
    webVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)setHomeHandler {
    weakSelf(self);
    self.userLoginCallback = ^ {
        strongSelf(weakSelf);
        [strongSelf.recommendTabView.mj_header endRefreshing];
        if (![CRFAppManager defaultManager].login) {
            strongSelf.avatarImageView.image = [UIImage imageNamed:@"default_header"];
            strongSelf.refreshTopHeader.refreshType = Unlogin;
        } else {
            if (kUserInfo.headUrl) {
                [strongSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:kUserInfo.headUrl] placeholderImage:[UIImage imageNamed:@"login_default_avatar"]];
            }
            strongSelf.refreshTopHeader.refreshType = [CRFAppManager defaultManager].accountStatus? UserLogin:Unlogin;
            if ([CRFAppManager defaultManager].accountStatus) {
                [strongSelf getUserAssetsTotal];
            }
        }
        [[CRFHomeConfigHendler defaultHandler].homeDataDicM removeAllObjects];
        [strongSelf requestDatas];
    };
    self.changeUserHeaderImage = ^ {
        strongSelf(weakSelf);
        if ([CRFAppManager defaultManager].login) {
            [strongSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:kUserInfo.headUrl] placeholderImage:[UIImage imageNamed:@"login_default_avatar"]];
        } else {
            strongSelf.avatarImageView.image = [UIImage imageNamed:@"default_header"];
        }
    };
    self.refreshUserAssert = ^ {
        if ([CRFAppManager defaultManager].accountStatus) {
            strongSelf(weakSelf);
            [strongSelf getUserAssetsTotal];
        }
    };
    
}

- (void)getUserInfo {
    if ([CRFAppManager defaultManager].login && kUserInfo.protocolValidation.integerValue == 1 && kUserInfo.accountStatus.integerValue == 2) {
        if ([self containAuthView]) {
            return;
        }
        weakSelf(self);
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
            strongSelf(weakSelf);
            if (success) {
                [strongSelf authAuthorizedSignatoryView];
            } else {
                 [CRFUtils showMessage:response[kMessageKey]];
            }
        }];
    }
}

- (BOOL)containAuthView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[NSClassFromString(@"CRFSupervisionInfoView") class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)authToPotocolValidationStatus {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kAuthProtocolPath),kUserInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf.signatoryView dismiss];
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            NSLog(success?@"刷新用户信息成功":@"刷新用户信息失败");
            if (!success) {
                [CRFUtils showMessage:response[kMessageKey]];
            }
        }];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)getExplanData{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),exclusive_key] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        NSArray *dataSource = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:exclusive_key];
        [strongSelf parseDataArray:dataSource];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)parseDataArray:(NSArray*)dataArray{
    if (dataArray.count) {
        CRFAppHomeModel *model = dataArray[0];
        CRFExclusiveModel *exculsiveModel =[CRFExclusiveModel yy_modelWithDictionary:[CRFUtils dictionaryWithJsonString:model.content]];
        self.exclusiveItem = exculsiveModel;
        [self.helpView drawContent:exculsiveModel.content];
    }
}
- (void)validateExplanCondition {
    
    if (![CRFAppManager defaultManager].login) {
        [CRFControllerManager pushLoginViewControllerFrom:self popType:PopFrom];
        return;
    }
    if (![CRFAppManager defaultManager].accountStatus) {
        [self checkUserAccountStatus];
        return;
    }
    //判断用户投资风险承受能力测评。非进取型用户弹窗提示无法进入
    if ([[CRFAppManager defaultManager].userInfo.riskLevel isEmpty]) {
        [CRFAlertUtils showAlertLeftTitle:@"尊敬的客户:" AttributedMessage:[CRFStringUtils changedLineSpaceWithTotalString:@"您需完成《投资风险承受能力测评》" lineSpace:3] container:self cancelTitle:@"取消" confirmTitle:@"去测评" cancelHandler:^{
            
        } confirmHandler:^{
            [self gotoEvaluation];
        }];
        return;
    }
    if ([[CRFAppManager defaultManager].userInfo.riskLevel integerValue] != 3 ){
        NSString *messageStr ;
        if ([CRFAppManager defaultManager].userInfo.riskLevel.integerValue ==1) {
            messageStr = @"保守型";
        }
        if ([CRFAppManager defaultManager].userInfo.riskLevel.integerValue ==2) {
            messageStr = @"平衡型";
        }
        [CRFAlertUtils showAlertLeftTitle:@"尊敬的客户:" AttributedMessage:[CRFStringUtils changedLineSpaceWithTotalString:[NSString stringWithFormat:@"此计划为进取型用户专享,您的《投资风险承受能力测评》结果为%@,暂无法进入",messageStr] lineSpace:3] container:self cancelTitle:@"取消" confirmTitle:@"重新测评" cancelHandler:^{
            
        } confirmHandler:^{
            [self gotoEvaluation];
        }];
        return;
    }
    
    CRFExplanOperateViewController *explanOperateVC = [[CRFExplanOperateViewController alloc]init];
    explanOperateVC.exclusiveItem = self.exclusiveItem;
    explanOperateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:explanOperateVC animated:YES];
}

- (void)gotoEvaluation {
    CRFEvaluatingViewController *evaluaVC = [CRFEvaluatingViewController new];
    evaluaVC.urlString = [NSString stringWithFormat:@"%@?%@",kInvestTestH5,kH5NeedHeaderInfo];
    evaluaVC.hidesBottomBarWhenPushed = YES;
    [evaluaVC setBackHandler:^{
        [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
            if (!success) {
                [CRFUtils showMessage:response[kMessageKey]];
            }
            NSLog(success?@"刷新信息成功":@"刷新信息失败");
        }];
    }];
    [self.navigationController pushViewController:evaluaVC animated:YES];
}

@end
