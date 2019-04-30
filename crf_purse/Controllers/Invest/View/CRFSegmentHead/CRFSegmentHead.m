//
//  CRFSegmentHead.m
//  crf_purse
//
//  Created by maomao on 2017/7/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#define MAX_TitleNumInWindow  4

#define PadLineTopSpace   9.5
#define PadLineHeight     21
#define PadLineWidth      0.5
#define PadLineColor      UIColorFromRGBValueAndalpha(0x000000, 0.1)

#import "CRFSegmentHead.h"
#import "CRFProductType.h"
@interface CRFSegmentHead()
@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,assign) CGFloat btn_w;
@property (nonatomic, assign) BOOL noLine;
@property (nonatomic, assign) BOOL isInvest;

//标题中间有分割线
//@property (nonatomic ,strong)UIView *padLine;///<标题分割线
@end
@implementation CRFSegmentHead

- (instancetype)initCommonInvestWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickCallback:(btnClickBlock)callBack {
    self.noLine = YES;
    return [self initCommonWithFrame:frame titles:titleArray clickCallback:callBack];
}

- (instancetype)initCommonWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickCallback:(btnClickBlock)callBack{
    self = [super initWithFrame:frame];
    if (self) {
        _btn_w = 0.0;
        if (titleArray.count<MAX_TitleNumInWindow) {
            _btn_w = kScreenWidth/titleArray.count;
        }else{
            _btn_w=kScreenWidth/MAX_TitleNumInWindow;
        }
        _titles=titleArray;
        _defaultIndex=0;
        _titleFont=[UIFont systemFontOfSize:14];
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        _titleNomalColor=UIColorFromRGBValue(0x666666);
        _titleSelectColor=kButtonNormalBackgroundColor;
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count, self.frame.size.height);
        [self addSubview:_bgScrollView];
        
        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, _btn_w, 2)];
        _selectLine.backgroundColor=_titleSelectColor;
        [_bgScrollView addSubview:_selectLine];
        for (int i = 0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
            btn.tag=i;
            [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];

            btn.titleLabel.font=_titleFont;
            btn.crf_acceptEventInterval = 0.5;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==0) {
                _titleBtn=btn;
                btn.selected=YES;
            }
            if (!self.noLine) {
            //加分割线
                if (i<titleArray.count&&i>0) {
                UIView *btwLine = [[UIView alloc]initWithFrame:CGRectMake(_btn_w*i, PadLineTopSpace, PadLineWidth, PadLineHeight)];
                btwLine.backgroundColor = PadLineColor;
                [_bgScrollView addSubview:btwLine];
                }
            }
            self.block=callBack;
        }
    }
    return self;
}
-(instancetype)initInvestFrame:(CGRect)frame titles:(NSArray *)titleArray clickCallbak:(btnClickBlock)callBack{
    if (self = [super initWithFrame:frame]) {
        _isInvest = YES;
        _btn_w = (self.frame.size.width - 40)/2;
        _titles=titleArray;
        _defaultIndex=0;
        _titleFont=[UIFont boldSystemFontOfSize:18];
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        _titleNomalColor=UIColorFromRGBValue(0x666666);
        _titleSelectColor=UIColorFromRGBValue(0xFB4D3A);
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*(titleArray.count)+40, self.frame.size.height);
        [self addSubview:_bgScrollView];
        
        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(_btn_w*_defaultIndex+_btn_w/4, self.frame.size.height-3, _btn_w/2, 3)];
        _selectLine.backgroundColor=_titleSelectColor;
        [_bgScrollView addSubview:_selectLine];
        for (int i = 0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i==0?_btn_w*i:_btn_w*i+40, 0, _btn_w, self.frame.size.height-2);
            btn.tag=i;
            [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            
            btn.titleLabel.font=_titleFont;
            btn.crf_acceptEventInterval = 0.5;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==0) {
                _titleBtn=btn;
                btn.selected=YES;
            }
        }
        self.block=callBack;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray SelectedIndex:(NSInteger)index clickBlock:(btnClickBlock)block{
    if (self = [super initWithFrame:frame]) {
        _btn_w=0.0;
        if (titleArray.count<MAX_TitleNumInWindow) {
            _btn_w=kScreenWidth/(titleArray.count);
        }else{
            _btn_w=kScreenWidth/MAX_TitleNumInWindow;
        }
        
        _titles=titleArray;
        _defaultIndex=index;
        _titleFont=[UIFont systemFontOfSize:14];
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        _titleNomalColor=UIColorFromRGBValue(0x666666);
        _titleSelectColor=kButtonNormalBackgroundColor;
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*(titleArray.count), self.frame.size.height);
        [self addSubview:_bgScrollView];
        
        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(_btn_w*_defaultIndex, self.frame.size.height-2, _btn_w, 2)];
        _selectLine.backgroundColor=_titleSelectColor;
        [_bgScrollView addSubview:_selectLine];
        if (titleArray ) {
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
            btn.tag=i;
            btn.titleLabel.numberOfLines = 2;
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [btn setBackgroundColor:[UIColor whiteColor]];
//            if (i == 0) {
//                [btn setTitle:NSLocalizedString(@"button_all", nil) forState:UIControlStateNormal];
//            }else{
                id product =titleArray[i];
                if ([product isKindOfClass:[CRFProductType class]]) {
                    CRFProductType *item = product;
                    [btn setTitle:item.productTypeName forState:UIControlStateNormal];
                }else{
                    [btn setTitle:titleArray[i] forState:UIControlStateNormal];
                }
//            }
            btn.titleLabel.font=_titleFont;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==_defaultIndex) {
                _titleBtn=btn;
                btn.selected=YES;
                CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
                if (offsetX<0) {
                    offsetX=0;
                }
                CGFloat maxOffsetX= _bgScrollView.contentSize.width-kScreenWidth;
                if (offsetX>maxOffsetX) {
                    offsetX=maxOffsetX;
                }
                [_bgScrollView setContentOffset:CGPointMake(offsetX, 0)];
            }
            self.block=block;
            
        }
        }
    }
    
    return self;
}

- (void)btnClick:(UIButton *)btn{
    NSArray *messageArr = @[@"消息",@"系统公告"];
    NSArray *recordArr  = @[@"充值",@"提现"];
    if ([messageArr containsObject:btn.titleLabel.text]) {
        [CRFAPPCountManager setEventID:@"MESSAGE_CENTER_TAP_EVENT" EventName:btn.titleLabel.text];//埋点
    }
    if ([recordArr containsObject:btn.titleLabel.text]) {
        [CRFAPPCountManager setEventID:@"RECORD_TAP_SELECTED_EVENT" EventName:btn.titleLabel.text];//埋点
    }
//
    if (self.block) {
        self.block(btn.tag);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-kScreenWidth;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    if (self.isInvest) {
        offsetX = 0;
    }
    [self setIndicatorAnimation:offsetX button:btn];
    
}

- (void)setIndicatorAnimation:(CGFloat)offset button:(UIButton *)btn {
    weakSelf(self);
    [UIView animateWithDuration:.2 animations:^{
        strongSelf(weakSelf);
        [strongSelf.bgScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
        if (strongSelf.isInvest) {
            strongSelf.selectLine.frame=CGRectMake(btn.frame.origin.x+_btn_w/4, strongSelf.frame.size.height-3, btn.frame.size.width/2, 3);
        }else{
          strongSelf.selectLine.frame=CGRectMake(btn.frame.origin.x, strongSelf.frame.size.height-2, btn.frame.size.width, 2);
        }
    } completion:^(BOOL finished) {
        
    }];

}



- (void)setTitleNomalColor:(UIColor *)titleNomalColor{
    _titleNomalColor=titleNomalColor;
    [self updateView];
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor=titleSelectColor;
    [self updateView];
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont=titleFont;
    [self updateView];
}

- (void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex=defaultIndex;
    [self updateView];
    weakSelf(self);
    [UIView animateWithDuration:.2 animations:^{
        strongSelf(weakSelf);
        if (strongSelf.isInvest) {
            strongSelf.selectLine.frame=CGRectMake(_btn_w * strongSelf.defaultIndex + (strongSelf.defaultIndex == 0 ?0:40) +_btn_w/4, CGRectGetHeight(strongSelf.frame)-3, _btn_w/2, 3);
        }else{
           strongSelf.selectLine.frame=CGRectMake(kScreenWidth / strongSelf.btns.count * strongSelf.defaultIndex, CGRectGetHeight(strongSelf.frame)-2, kScreenWidth / strongSelf.btns.count, 2);
        }
        
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)updateView{
    for (UIButton *btn in _btns) {
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font=_titleFont;
        _selectLine.backgroundColor=_titleSelectColor;
        
        if (btn.tag ==_defaultIndex) {
            _titleBtn=btn;
            btn.selected=YES;
        }else{
            btn.selected=NO;
        }
    }
}

- (void)setCommonTitles:(NSArray *)commonTitles {
    _commonTitles = commonTitles;
    for (UIButton *btn in _btns) {
        [btn setTitle:_commonTitles[[_btns indexOfObject:btn]] forState:UIControlStateNormal];
    }
}

- (void)scrollToContentsInSizeWithFloat:(CGFloat)offSize {
    weakSelf(self);
    [UIView animateWithDuration:.2 animations:^{
        strongSelf(weakSelf);
//        strongSelf.selectLine.frame=CGRectMake(kScreenWidth / strongSelf.btns.count * offSize, CGRectGetHeight(strongSelf.frame)-2, kScreenWidth / strongSelf.btns.count, 2);
        if (strongSelf.isInvest) {
            strongSelf.selectLine.frame=CGRectMake(_btn_w *offSize+_btn_w/4 + strongSelf.defaultIndex == 0 ?0:40+_btn_w, CGRectGetHeight(strongSelf.frame)-3, _btn_w/2, 3);
        }else{
            strongSelf.selectLine.frame=CGRectMake(kScreenWidth / strongSelf.btns.count * offSize, CGRectGetHeight(strongSelf.frame)-2, kScreenWidth / strongSelf.btns.count, 2);
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
