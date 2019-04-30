//
//  CRFFunctionView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 首页老用户的view（按钮）
 */
@interface CRFFunctionView : UIView

/**
 models
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*functions;

/**
 选中的是第几个
 */
@property (nonatomic, copy) void (^(didSelected))(NSInteger index);

@end
