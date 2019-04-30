//
//  CRFHomePageViewController+Interface.h
//  crf_purse
//
//  Created by mystarains on 2019/1/4.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomePageViewController.h"
#import "CRFStaticWebViewViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRFHomePageViewController (Interface)

/**
 首页配置项
 */
- (void)requestDatas;

/**
 首页总资产
 */
- (void)getUserAssetsTotal;

/**
 首页产品接口
 */
- (void)getAppProducts;

/**
 检查用户开户状态
 */
- (void)checkUserAccountStatus;

/**
 获取未读消息数量
 */
- (void)refreshUnreadMessageCount;

/**
 设置首页callback
 */
- (void)setHomeHandler;

/**
 检测专属计划的条件
 */
- (void)validateExplanCondition;
- (void)getExplanData;

/**
 添加首页网络缺省图
 */
- (void)addHomeDefaultView;

/**
 去评测页面
 */
- (void)gotoEvaluation;

/**
 H5页加载
 
 @param webUrl url
 @param canGoBack backStyle
 @param rightStyle 右边按钮状态
 */
- (void)pushWebDetailWithUrlString:(NSString *)webUrl canGoBack:(BOOL)canGoBack rightStyle:(WebViewRightStyle)rightStyle;

@end

NS_ASSUME_NONNULL_END
