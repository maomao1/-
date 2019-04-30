//
//  CRFBannerMoreView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 首页导航栏更多展开的view
 */
@interface CRFBannerMoreView : UIView

/**
 点击第几个
 */
@property (nonatomic, copy) void (^(viewDidSeledted))(NSIndexPath *indexPath);

@end



/**
 新手引导类型

 - Register: 未注册
 - Create_account: 未开户
 - Invest: 未投资
 */
typedef NS_ENUM(NSUInteger, UserActivity) {
    Register            = 0,
    Create_account      = 1,
    Invest              = 2,
};


/**
 新手引导的view
 */
@interface CRFNewUserView : UIView

/**
 设置类型
 */
@property (nonatomic, assign) UserActivity activity;

/**
 model
 */
@property (nonatomic, strong) CRFAppHomeModel *homeModel;
@property (nonatomic, strong) CRFAppHomeModel *helpModel;//

/**
 选中的handler
 */
@property (nonatomic, copy) void (^(didSelectedCallback))(NSInteger index);

/**
 使用帮助
 */
@property (nonatomic, copy) void (^(helpHandler))(CRFAppHomeModel *model);
@end



/**
 自定义的导航栏
 */
@interface CRFCustomHeaderView : UIView

/**
 导航栏标题
 */
@property (nonatomic, strong) UILabel *titleLabel;


/**
 导航栏图片
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 是否隐藏导航栏下面的线
 */
@property (nonatomic, assign) BOOL hiddenLine;

@end
