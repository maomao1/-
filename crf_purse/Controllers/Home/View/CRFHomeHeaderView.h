//
//  CRFHomeHeaderView.h
//  crf_purse
//
//  Created by mystarains on 2019/1/4.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFAppHomeModel.h"

#define kFunctionViewHeight ((kScreenWidth - kFunctionViewSpace*2)*16/67)
#define kActionViewHeight ((kScreenWidth - 25*2)*12/65)
static CGFloat const kFunctionViewTop = 160.f;

@protocol CRFHomeHeaderViewDelegate;
@interface CRFHomeHeaderView : UIView

@property (nonatomic, copy) NSDictionary *homeHeaderViewDic;
@property (nonatomic, weak) id <CRFHomeHeaderViewDelegate> delegate;

@end

@protocol CRFHomeHeaderViewDelegate <NSObject>

/**
 功能按钮的事件回调
 
 @param indexPath indexPath
 */
- (void)functionDidSelected:(NSIndexPath *)indexPath url:(NSString *)urlString;

/**
 banner 被点击了的回调
 
 @param linkUrl linkURL
 */
- (void)bannerDidSelected:(NSString *)linkUrl;

/**
 新手注册的按钮点击事件
 
 @param index index
 */
- (void)userToFinishFromRegister:(NSInteger)index;

/**
 使用帮助
 */
- (void)userHelp:(CRFAppHomeModel *)helpItem;

@end
