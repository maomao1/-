//
//  CRFActionSheetView.h
//  crf_purse
//
//  Created by maomao on 2018/9/25.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^completeAnimationBlock)(BOOL complete);
typedef void(^seletedButtonIndexBlock)(NSInteger index);
@interface CRFActionSheetView : UIView
@property (nonatomic,strong) seletedButtonIndexBlock selectButtonAtIndex;
/**
 *  自定义初始化leActionSheetView
 *
 *  @param str        取消按钮文字
 *  @param titles     所有按钮数组
 *  @param attchTitle 提示文子
 *
 *  @return 对象
 */
-(instancetype)initWithCancelStr:(NSString*)str otherButtonTitles:(NSArray *)titles attachTitle:(NSString *)attchTitle;
/**
 *  修改某一项的titleColor
 *
 *  @param color 颜色
 *  @param index 下标
 */
-(void)changeTitleColor:(UIColor*)color andIndex:(NSInteger)index;
-(void)changeImageIndex:(NSInteger)index ShowImage:(BOOL)isShow;
/**
 *  显示view
 */
-(void)show_leActionView;
@end
