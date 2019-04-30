//
//  CRFCommonResultViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

/**
 反馈页类型

 - CRFCommonResultFailed: 失败页面
 - CRFCommonResultSuccess: 成功页面
 - CRFCommonResultDoing: 进行中页面
 */
typedef NS_ENUM(NSInteger, CRFCommonResult) {
    CRFCommonResultFailed           = 0,
    CRFCommonResultSuccess          = 1,
    CRFCommonResultDoing            = 2,
};

/**
 通用的结果反馈页
 */
@interface CRFCommonResultViewController : CRFBasicViewController

/**
 反馈页类型
 */
@property (nonatomic, assign) CRFCommonResult commonResult;

/**
 结果说明，原因
 */
@property (nonatomic, copy) NSString *result, *reason;

/**
 当按钮只有一个时，自定义文字
 */
@property (nonatomic, copy) NSString *commonButtonTitle;

/**
 多个按钮（1-2）
 */
@property (nonatomic, strong) NSArray <NSString *>*commonButtonTitles;

/**
 按钮点击的回调
 */
@property (nonatomic, copy) void (^(commonButtonHandler))(NSInteger index, CRFCommonResultViewController *resultController);

/**
 pop返回的回调
 */
@property (nonatomic, copy) void (^(popHandler))(CRFCommonResultViewController *resultController);

@end
