//
//  CRFActionSheetView.m
//  crf_purse
//
//  Created by maomao on 2018/9/25.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFActionSheetView.h"
#define kCollectionViewHeight 178.0f
#define kSubTitleHeight 65.0f
#define kHcdSheetCellHeight  50.0f
#define kHcdScreenHeight  kScreenHeight
#define kHcdScreenWidth   kScreenWidth
#define kHcdCellSpacing 8.0f
@interface CRFActionSheetView()<UIGestureRecognizerDelegate>
@property (nonatomic, copy  )      NSString  *cancelStr;
@property (nonatomic, strong)      NSArray   *titles;
@property (nonatomic, weak  )      UIView    *buttomView;
@property (nonatomic, assign)      CGFloat   actionSheetHeight;
@end
@implementation CRFActionSheetView
-(instancetype)initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)titles attachTitle:(NSString *)attchTitle
{
    self = [super init];
    if (self) {
//        _attachTitle = attchTitle;
        _cancelStr = str;
        _titles = titles;
        [self setUI];
    }
    return self;
    
}
-(void)setUI
{
    /*self*/
    [self setFrame:CGRectMake(0, 0, kHcdScreenWidth, kHcdScreenHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    /*end*/
    
    /*buttomView*/
    UIView *buttomView = [[UIView alloc] init];
    
    buttomView.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
    
    _actionSheetHeight = _titles.count * kHcdSheetCellHeight;

    if (_cancelStr) {
        _actionSheetHeight += (kHcdSheetCellHeight+kHcdCellSpacing);
    }
    
    [buttomView setFrame:CGRectMake(0, kHcdScreenHeight, kHcdScreenWidth, _actionSheetHeight)];
    _buttomView = buttomView;
    [self addSubview:_buttomView];
    /*end*/
    
    /*CanceBtn*/
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancleBtn setBackgroundColor:[UIColor whiteColor]];
    [cancleBtn setFrame:CGRectMake(0, CGRectGetHeight(buttomView.bounds) - kHcdSheetCellHeight, kHcdScreenWidth, kHcdSheetCellHeight)];
    [cancleBtn setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateNormal];
    [cancleBtn setTitle:_cancelStr forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(selectedButtons:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTag:100];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    if (_cancelStr) {
        [cancleBtn setFrame:CGRectMake(0, CGRectGetHeight(buttomView.bounds) - kHcdSheetCellHeight, kHcdScreenWidth, kHcdSheetCellHeight)];
        [_buttomView addSubview:cancleBtn];
    }
    
    /*end*/
    
    /*Items*/
    for (NSString *title in _titles) {
        
        NSInteger index = [_titles indexOfObject:title];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat hei = 0;
        CGFloat y = 0;
        
        if (_cancelStr) {
            hei = (50 * _titles.count) + kHcdCellSpacing;
            y = (CGRectGetMinY(cancleBtn.frame) + (index * (kHcdSheetCellHeight))) - hei;
        }
        else {
            hei = (50 * (_titles.count - 1));
            y = (CGRectGetMinY(cancleBtn.frame) + (index * (kHcdSheetCellHeight))) - hei;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [btn setFrame:CGRectMake(0, y, kHcdScreenWidth, kHcdSheetCellHeight-0.5)];
        
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.image.size.width, 0, btn.imageView.image.size.width)];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
        [btn setTag:(index + 100)+1];
        [btn setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedButtons:) forControlEvents:UIControlEventTouchUpInside];
        [_buttomView addSubview:btn];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CGRectGetMidX(btn.frame)+40, CGRectGetMidY(btn.frame)-8, 16, 16);
        imageView.tag = index + 1000+1;
        [_buttomView addSubview:imageView];
        
    }
    /*END*/
    
//    if (_attachTitle) {
//
//        UILabel *attachTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kHcdScreenWidth, kSubTitleHeight)];
//        attachTitleView.backgroundColor = [UIColor whiteColor];
//        attachTitleView.font = [UIFont systemFontOfSize:12.0f];
//        attachTitleView.textColor = [UIColor grayColor];
//        attachTitleView.text = _attachTitle;
//        attachTitleView.textAlignment = 1;
//        attachTitleView.numberOfLines = 0;
//
//
//        [_buttomView addSubview:attachTitleView];
//
//    }
    
}
- (void)selectedButtons:(UIButton *)btns{
    
    typeof(self) __weak weak = self;
    [self dismissBlock:^(BOOL complete) {
        if (weak.selectButtonAtIndex) {
            weak.selectButtonAtIndex(btns.tag - 100);
        }
    }];
    
    
}

//修改某一项的titleColor
- (void)changeTitleColor:(UIColor *)color andIndex:(NSInteger )index{
    
    UIButton *btn = (UIButton *)[_buttomView viewWithTag:index + 100];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
}
-(void)changeImageIndex:(NSInteger)index ShowImage:(BOOL)isShow{
    UIImageView *imageView = (UIImageView *)[_buttomView viewWithTag:index + 1000];
    for (UIView *view in _buttomView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView* selectedImg = (UIImageView*)view;
            if (selectedImg.tag == imageView.tag) {
                imageView.image =  isShow?[UIImage imageNamed:@"debt_selected"]:nil;
            }
        }
    }
}
//隐藏
-(void)dismiss:(UITapGestureRecognizer *)tap{
    
    if( CGRectContainsPoint(self.frame, [tap locationInView:_buttomView])) {
 
    } else{
        
        [self dismissBlock:^(BOOL complete) {
            
        }];
    }
}
//隐藏ActionSheet的Block
-(void)dismissBlock:(completeAnimationBlock)block{
    
    
    typeof(self) __weak weak = self;
    CGFloat height = ((kHcdSheetCellHeight+0.5f)+kHcdCellSpacing) + (_titles.count * (kHcdSheetCellHeight+0.5f)) + kCollectionViewHeight;
    
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        [_buttomView setFrame:CGRectMake(0, kHcdScreenHeight, kHcdScreenWidth, height)];
        
    } completion:^(BOOL finished) {
        
        block(finished);
        [self removeFromSuperview];
        
    }];
    
}

/**
 *  显示ActionSheet
 */
- (void)show_leActionView
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [_buttomView setFrame:CGRectMake(0, kHcdScreenHeight - _actionSheetHeight, kHcdScreenWidth, _actionSheetHeight)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak action:@selector(dismiss:)];
        tap.delegate = self;
        [weak addGestureRecognizer:tap];
        
        [_buttomView setFrame:CGRectMake(0, kHcdScreenHeight - _actionSheetHeight, kHcdScreenWidth, _actionSheetHeight)];
    }];
}
@end
