//
//  CRFNumberKeyboardView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kKeyboardHeight = 216;

typedef NS_ENUM(NSInteger, CRFCustomKeyboardType) {
    CRFCustomKeyboardTypeX                  = 0,//主要用于输入身份证号
    CRFCustomKeyboardTypeNext               = 1,
    CRFCustomKeyboardTypeDone               = 2,
    CRFCustomKeyboardTypeNull               = 3,
    CRFCustomKeyboardTypeDot                = 4,
};

@protocol CRFNumberKeyboardViewDelegate;

@interface CRFNumberKeyboardView : UIView

@property(nonatomic, weak) id<CRFNumberKeyboardViewDelegate> delegate;

/**
*  初始化键盘
*
*  @param frame        键盘frame
*  @param numArray     键盘的按键数字（可实现乱序键盘功能）
*  @param keyboardType 键盘类型
*
*  @return 键盘的一个实例
*/
- (instancetype)initWithFrame:(CGRect)frame
                     andArray:(NSArray *)numArray
                 keyboardType:(CRFCustomKeyboardType)keyboardType;

@property(nonatomic, assign) CRFCustomKeyboardType keyboardType;

@end


@protocol CRFNumberKeyboardViewDelegate <NSObject>

@optional

- (void)numberKeyboardXBtnTapped:(CRFCustomKeyboardType)keyboardType;

- (void)numberKeyboardBackspace;

- (void)numberKeyboardInput:(NSInteger)number;

@end
