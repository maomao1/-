//
//  CRFADPagesView.m
//  crf_purse
//
//  Created by maomao on 2018/7/4.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFADPagesView.h"
@interface CRFADPagesView()<UIScrollViewDelegate>{
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    
    NSMutableArray *_pageCells;
    
    NSInteger _pageCount;
    NSInteger _currentPageNumber;
    
    NSTimer *_timer;
}
@end
@implementation CRFADPagesView
-(instancetype)init{
    assert(false);
    return nil;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)awakeFromNib{
    [self createUI];
}
-(void)createUI{
    
}
@end
