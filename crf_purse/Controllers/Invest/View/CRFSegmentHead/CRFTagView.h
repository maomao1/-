//
//  CRFTagView.h
//  crf_purse
//
//  Created by maomao on 2018/7/5.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFTagFrame.h"

#define DefaultTextColor UIColorFromRGBValue(0x666666)
#define SelectedTextColor UIColorFromRGBValue(0xFB4D3A)

@protocol CRFTagViewDelegate<NSObject>
-(void)crfTagViewIndex:(NSInteger)index tagView:(UIView*)crftagview;
-(void)crfhitShadowView;
@end
@interface CRFTagView : UIView
//储存选中按钮的tag
@property (nonatomic , copy) NSMutableArray *selectedBtnList;
@property (nonatomic , weak) id<CRFTagViewDelegate>delegate;
/** 是否能选中 需要在 CRFTagFrame 前调用  default is YES*/
@property (assign, nonatomic) BOOL clickbool;

/** 未选中边框大小 需要在 CRFTagFrame 前调用 default is 0.5*/
@property (assign, nonatomic) CGFloat borderSize;

/** CRFTagFrame */
@property (nonatomic, strong) CRFTagFrame *tagsFrame;

/** 选中背景颜色 default is whiteColor */
@property (strong, nonatomic) UIColor *clickBackgroundColor;

/** 选中字体颜色 default is TextColor */
@property (strong, nonatomic) UIColor *clickTitleColor;

/** 多选选中 default is 未选中*/
@property (strong, nonatomic) NSArray *clickArray;

/** 单选选中 default is 未选中*/
@property (strong, nonatomic) NSString *clickString;
/** 选中边框大小 default is 0.5*/
@property (assign, nonatomic) CGFloat clickborderSize;

/** 1-多选 0-单选 default is 0-单选*/
@property (assign, nonatomic) NSInteger clickStart;
//
@property (nonatomic,strong) UIButton  *shadowBtn;
@property (nonatomic,strong) UIButton  *shadowNavBtn;

@property (nonatomic,assign) BOOL isShow;
-(void)crfShowInView:(UIView*)view;
-(void)crfDismissView:(void (^)(void))completion;
@end
