//
//  CRFHomePageViewController+Interface.m
//  crf_purse
//
//  Created by mystarains on 2019/1/4.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomePageViewController+Interface.h"
#import "CRFHomeConfigHendler.h"
#import "CRFRelateAccountViewController.h"
#import "CRFCreateAccountViewController.h"
#import "CRFControllerManager.h"
#import "CRFAlertUtils.h"
#import "CRFExplanOperateViewController.h"
#import "CRFEvaluatingViewController.h"


@implementation CRFHomePageViewController (Interface)

- (void)requestDatas{
    //获取首页配置
    [self getHomeConfig];
    //特供计划信息
    [self getExplanData];
    //消息数量
    [self refreshUnreadMessageCount];
}

- (void)getHomeConfig{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kHomePageArea_key] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [[CRFHomeConfigHendler defaultHandler] parseHomeConfig:response];
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
    }];
}

- (void)getExplanData{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),exclusive_key] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        NSArray *dataSource = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:exclusive_key];
        [strongSelf parseDataArray:dataSource];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)refreshUnreadMessageCount{
    weakSelf(self);
    if (![CRFAppManager defaultManager].login) {
        return;
    }
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetUnreadMessagePath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        
        NSInteger unreadMessageCount = [response[@"data"][@"count"] integerValue];
        [CRFAppManager defaultManager].unMessageCount = [NSString stringWithFormat:@"%ld",unreadMessageCount];
        [strongSelf refreshMessageCount:[CRFAppManager defaultManager].unMessageCount];
        
    } failed:^(CRFNetworkCompleteType errorType, id response) {
  
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
    NSArray *newUserProductArr = [[CRFResponseFactory handleProductDataForResult:response ForKey:newUserProduct_key] mutableCopy];
    NSArray *oldUserProductArr = [[CRFResponseFactory handleProductDataForResult:response ForKey:oldUserProduct_key] mutableCopy];
    NSArray *recommendProductArr = [[CRFResponseFactory handleProductDataForResult:response ForKey:recommendProduct_key] mutableCopy];
    self.productFactory.noviceProducts = newUserProductArr;
    self.productFactory.oldUserProducts = oldUserProductArr;
    self.productFactory.recommendProduct = recommendProductArr;
    [self.recommendTabView reloadData];
}

- (void)addHomeDefaultView {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] networkIsVisible:^(BOOL visible) {
        strongSelf(weakSelf);
        if (!visible && [CRFHomeConfigHendler defaultHandler].localizedHomeDatas.allKeys.count <= 0) {
            strongSelf.requestStatus = Status_Home_Net_Error;
        
        } else if (visible) {
            strongSelf.requestStatus = Status_Normal;
            [[CRFHomeConfigHendler defaultHandler].homeDataDicM removeAllObjects];
            [strongSelf requestDatas];
        }
    }];
}

- (void)setHomeHandler {
    weakSelf(self);
    self.userLoginCallback = ^ {
        strongSelf(weakSelf);
        [strongSelf.recommendTabView.mj_header endRefreshing];
        if (![CRFAppManager defaultManager].login) {
            strongSelf.refreshTopHeader.refreshType = Unlogin;
        } else {
            strongSelf.refreshTopHeader.refreshType = [CRFAppManager defaultManager].accountStatus? UserLogin:Unlogin;
            if ([CRFAppManager defaultManager].accountStatus) {
                [strongSelf getUserAssetsTotal];
            }
        }
        [[CRFHomeConfigHendler defaultHandler].homeDataDicM removeAllObjects];
        [strongSelf requestDatas];
        
    };
    
    self.refreshUserAssert = ^ {
        if ([CRFAppManager defaultManager].accountStatus) {
            strongSelf(weakSelf);
            [strongSelf getUserAssetsTotal];
        }
    };
}

- (void)parseDataArray:(NSArray*)dataArray{
    if (dataArray.count) {
        CRFAppHomeModel *model = dataArray[0];
        CRFExclusiveModel *exculsiveModel =[CRFExclusiveModel yy_modelWithDictionary:[CRFUtils dictionaryWithJsonString:model.content]];
        self.exclusiveItem = exculsiveModel;
        [self.helpView drawContent:exculsiveModel.content];
    }
}

- (void)pushWebDetailWithUrlString:(NSString *)webUrl canGoBack:(BOOL)canGoBack rightStyle:(WebViewRightStyle)rightStyle {
    
    if ([webUrl isEmpty]) {
        return;
    }
    CRFStaticWebViewViewController *webVc = [CRFStaticWebViewViewController new];
    webVc.urlString = webUrl;
    webVc.backType = canGoBack ? WebViewGoBack : WebViewClose;
    webVc.rightStyle = rightStyle;
    if ([webUrl containsString:@"global_index.html"]||[webUrl containsString:@"global_invite"]) {
        webVc.statusBarIsWhite = YES;
        webVc.backViewStyle = WebViewBackViewStyle_White;
        webVc.haveDelegate = YES;
        webVc.popGestureDisable = YES;
        [webVc setBlackBarColor];
    }
    webVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
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
    evaluaVC.urlString = [NSString stringWithFormat:@"%@?%@",kRiskRevealH5,kH5NeedHeaderInfo];
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
