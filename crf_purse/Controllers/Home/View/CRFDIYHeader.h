//
//  CRFDIYHeader.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

/**
 自定义下拉刷新
 */
@interface CRFDIYHeader : MJRefreshHeader

/**
 contentSize发生改变的回调
 */
@property (nonatomic, copy) void (^(scrollViewContentOffSizeHandle))(NSDictionary *changed);

/**
 拖拽比例的回调
 */
@property (nonatomic, copy) void (^(dragingPullScreenPercent))(CGFloat percent);

/**
 重置MJ刷新的状态
 */
@property (nonatomic, copy) void (^(resetStatus))(void);

/**
 开始拖拽的回调
 */
@property (nonatomic, copy) void (^(beginDraging))(void);

@end
