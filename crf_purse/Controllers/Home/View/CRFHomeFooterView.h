//
//  CCRFHomeFooterView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 首页tableView footerView
 */
@interface CRFHomeFooterView : UIView

/**
 菜单models
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*menuArray;
/**
 平台models
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*platformArray;
/**
 底部关于的回调
 */
@property (nonatomic, copy) void (^(aboutCallback))(void);

/**
 菜单选中的回调
 */
@property (nonatomic, copy) void (^(itemDidSelected))(CRFAppHomeModel*model);

/**
 需要添加的tableView
 */
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIImageView    *footerImg;
-(void)reloadFooterImg;
@end
