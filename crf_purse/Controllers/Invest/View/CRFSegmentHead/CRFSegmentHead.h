//
//  CRFSegmentHead.h
//  crf_purse
//
//  Created by maomao on 2017/7/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^btnClickBlock)(NSInteger index);
@interface CRFSegmentHead : UIView
/**
 *  未选中时的文字颜色,默认黑色
 */
@property (nonatomic,strong) UIColor *titleNomalColor;

/**
 *  选中时的文字颜色,默认红色
 */
@property (nonatomic,strong) UIColor *titleSelectColor;

/**
 *  字体大小，默认15
 */
@property (nonatomic,strong) UIFont  *titleFont;

/**
 *  默认选中的index=0，即第一个
 */
@property (nonatomic,assign) NSInteger defaultIndex;

/**
 *  点击后的block
 */
@property (nonatomic,copy)btnClickBlock block;

@property (nonatomic, strong) NSArray *commonTitles;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray 传入数组
 *  @param block      点击后的回调
 *
 *  @return segmentView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray SelectedIndex:(NSInteger)index clickBlock:(btnClickBlock)block;

- (instancetype)initCommonWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickCallback:(btnClickBlock)callBack;

- (instancetype)initCommonInvestWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickCallback:(btnClickBlock)callBack;

- (void)scrollToContentsInSizeWithFloat:(CGFloat)offSize;

-(instancetype)initInvestFrame:(CGRect)frame titles:(NSArray *)titleArray clickCallbak:(btnClickBlock)callBack;
@end
