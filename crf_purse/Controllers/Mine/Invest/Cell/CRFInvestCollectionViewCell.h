//
//  CRFInvestCollectionViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFMyInvestProduct.h"

typedef NS_ENUM(NSUInteger, CellType) {
    HasHeader           = 0,
    None                = 1,
};

@interface CRFInvestCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL needRefresh;

@property (nonatomic, assign) CellType type;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger sortIndex;

@property (nonatomic, copy) void (^(blackSpaceHandler))(NSIndexPath *indexPath);

/**
 帮助的callback
 */
@property (nonatomic, copy) void (^(helpHandler))(void);

/**
 cell点击事件的回调
 */
@property (nonatomic, copy) void (^(investChooseHandler))(NSInteger section, CRFMyInvestProduct *product);

/**
 获取产品分类的个数
 */
@property (nonatomic, copy) void (^ (getInvestListAmount))(NSInteger unBearingCount, NSInteger bearingCount, NSInteger finishedCount);

/**
 更新约束
 */
@property (nonatomic, copy) void (^ (updateLayout))(void);

@end
