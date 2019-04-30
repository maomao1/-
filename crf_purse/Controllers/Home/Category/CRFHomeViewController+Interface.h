//
//  CRFHomeViewController+Interface.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeViewController.h"
#import "CRFStaticWebViewViewController.h"

@interface CRFHomeViewController (Interface)

/**
 首页产品接口
 */
- (void)getAppProducts;

/**
 首页总资产
 */
- (void)getUserAssetsTotal;

/**
 首页活动信息
 */
- (void)getActivity;

/**
 首页配置项
 */
- (void)requestDatas;

/**
 添加首页网络缺省图
 */
- (void)addHomeDefaultView;

/**
 检查用户开户状态
 */
- (void)checkUserAccountStatus;

/**
 设置首页callback
 */
- (void)setHomeHandler;

/**
 H5页加载

 @param webUrl url
 @param canGoBack backStyle
 @param rightStyle 右边按钮状态
 */
- (void)pushWebDetailWithUrlString:(NSString *)webUrl canGoBack:(BOOL)canGoBack rightStyle:(WebViewRightStyle)rightStyle;


/**
 <#Description#>
 */
-(void)authToPotocolValidationStatus;

/**
 检测专属计划的条件
 */
- (void)validateExplanCondition;
-(void)getExplanData;
@end
