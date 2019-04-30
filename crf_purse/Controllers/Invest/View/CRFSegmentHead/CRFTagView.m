//
//  CRFTagView.m
//  crf_purse
//
//  Created by maomao on 2018/7/5.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFTagView.h"

@implementation CRFTagView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selectedBtnList = [[NSMutableArray alloc]init];
        self.clickBackgroundColor = [UIColor whiteColor];
        self.clickTitleColor = UIColorFromRGBValue(0xFB4D3A);
        self.clickArray = nil;
        self.clickbool = YES;
        self.borderSize = 0.5;
        self.clickborderSize =0.5;
    }
    return self;
}
-(void)setTagsFrame:(CRFTagFrame *)tagsFrame{
    _tagsFrame = tagsFrame;
    for (NSInteger i = 0; i<tagsFrame.tagsArray.count; i++) {
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:tagsFrame.tagsArray[i] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:DefaultTextColor forState:UIControlStateNormal];
        tagsBtn.titleLabel.font = TagTitleFont;
        tagsBtn.tag = i;
        tagsBtn.backgroundColor = [UIColor whiteColor];
        [self makeCorner:self.borderSize view:tagsBtn color:UIColorFromRGBValue(0x999999)];
        tagsBtn.frame = CGRectFromString(tagsFrame.tagsFrames[i]);
        [tagsBtn addTarget:self action:@selector(TagsBtn:) forControlEvents:UIControlEventTouchDown];
        tagsBtn.enabled = _clickbool;
        tagsBtn.crf_acceptEventInterval = 0.5;
        [self addSubview:tagsBtn];
    }
}
#pragma mark 选中背景颜色
-(void)setClickBackgroundColor:(UIColor *)clickBackgroundColor{
    
    if (_clickBackgroundColor != clickBackgroundColor) {
        _clickBackgroundColor = clickBackgroundColor;
    }
}
#pragma makr 选中字体颜色
-(void)setClickTitleColor:(UIColor *)clickTitleColor{
    if (_clickTitleColor != clickTitleColor) {
        _clickTitleColor = clickTitleColor;
    }
}
#pragma makr 能否被选中
-(void)setClickbool:(BOOL)clickbool{
    _clickbool = clickbool;
}
#pragma makr 未选中边框大小
-(void)setBorderSize:(CGFloat)borderSize{
    
    if (_borderSize!=borderSize) {
        _borderSize = borderSize;
    }
}
#pragma makr 选中边框大小
-(void)setClickborderSize:(CGFloat)clickborderSize{
    
    if (_clickborderSize!= clickborderSize) {
        _clickborderSize = clickborderSize;
    }
}
#pragma makr 默认选择 单选
-(void)setClickString:(NSString *)clickString{
    
    if (_clickString != clickString) {
        _clickString = clickString;
    }
    if ([_tagsFrame.tagsArray containsObject:_clickString]) {
        
        NSInteger index = [_tagsFrame.tagsArray indexOfObject:_clickString];
        [self ClickString:index];
    }
}
-(void)TagsBtn:(UIButton*)btn{
    if (self.clickStart == 0) {
        //单选
        [self ClickString:btn.tag];
        
    }else{
        //多选 待实现
    }
}
#pragma makr 单选
-(void)ClickString:(NSInteger )index{
    
    UIButton *btn;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)obj;
            if (btn.tag == index){
                
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:_clickTitleColor forState:UIControlStateNormal];
                [self makeCorner:_clickborderSize view:btn color:_clickTitleColor];
                [_delegate crfTagViewIndex:index  tagView:self];
                
            }else{
                
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:DefaultTextColor forState:UIControlStateNormal];
                [self makeCorner:_borderSize view:btn color:UIColorFromRGBValue(0x999999)];
                
            }
        }
    }
}
-(void)makeCorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color{
    
    CALayer * fileslayer = [view layer];
    fileslayer.borderColor = [color CGColor];
    fileslayer.borderWidth = corner;
    fileslayer.masksToBounds = YES;
    fileslayer.cornerRadius = 3.0f;
    
}
-(void)crfShowInView:(UIView *)view{
    [view addSubview:self];
    [view addSubview:self.shadowBtn];
    [view addSubview:self.shadowNavBtn];
    self.shadowBtn.alpha = 0;
    self.shadowNavBtn.alpha = 0;
    [self setSubviewsAlpha:0];
    self.shadowBtn.frame = CGRectMake(0, kNavHeight+self.tagsFrame.tagsHeight+52, kScreenWidth, kScreenHeight-self.tagsFrame.tagsHeight-52);
    self.shadowNavBtn.frame = CGRectMake(0, 0, kScreenWidth, kNavHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kNavHeight+1+52, kScreenWidth, self.tagsFrame.tagsHeight);
        self.shadowBtn.alpha = 0.5;
        self.shadowNavBtn.alpha = 0.5;
    } completion:^(BOOL finished) {
        [self setSubviewsAlpha:1];
        self.isShow = YES;
    }];
}
-(void)crfDismissView:(void (^)(void))completion{
    self.shadowBtn.alpha = 0;
    self.shadowNavBtn.alpha = 0;
    [self setSubviewsAlpha:0];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kNavHeight+52, kScreenWidth, 0);
//        self.shadowBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.isShow = NO;
        if (completion) {
            completion();
        }
        [self removeFromSuperview];
        [self.shadowBtn removeFromSuperview];
        [self.shadowNavBtn removeFromSuperview];
    }];
}
-(void)crfshadowAction{
    [self crfDismissView:nil];
    if ([self.delegate respondsToSelector:@selector(crfhitShadowView)]) {
        [self.delegate crfhitShadowView];
    }
}
-(void)setSubviewsAlpha:(CGFloat)value{
    UIButton *btn;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)obj;
            btn.alpha = value;
        }
    }
}
-(UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shadowBtn.alpha = 0.5;
        _shadowBtn.backgroundColor = UIColorFromRGBValueAndalpha(0x110D0D, 0.5);
        [_shadowBtn addTarget:self action:@selector(crfshadowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}
-(UIButton *)shadowNavBtn{
    if (!_shadowNavBtn) {
        _shadowNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shadowNavBtn.alpha = 0.5;
        _shadowNavBtn.backgroundColor = [UIColor clearColor];
        [_shadowNavBtn addTarget:self action:@selector(crfshadowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowNavBtn;
}
@end
