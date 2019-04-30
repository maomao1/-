//
//  CRFInvestDynamicTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/10/25.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFInvestEvent.h"


@interface CRFInvestDynamicTableViewCell : UITableViewCell

/**
 动态类型：e.g：已结束、已到期、计息中。。。
 */
@property (nonatomic, assign) NSInteger type;

/**
 产品信息
 */
@property (nonatomic, strong) CRFMyInvestProduct *product;

/**
 节点信息
 */
@property (nonatomic, strong) CRFInvestEvent *event;

/**
 字体是否加粗
 */
@property (nonatomic, assign) BOOL borderFont;

/**
 是否是当前节点
 */
@property (nonatomic, assign) BOOL currentPoint;

/**
 是否隐藏最上面的线
 */
@property (nonatomic, assign) BOOL hideTopLine;

/**
 是否隐藏最下面的线
 */
@property (nonatomic, assign) BOOL hideBottomLine;

@end
