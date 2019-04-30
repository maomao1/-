//
//  CRFFunctionView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFFunctionView.h"


@interface CRFFunctionView() {
    NSArray *images;
}

@property (nonatomic, strong) UIImageView *leftImageView, *rightImageView;

@end

@implementation CRFFunctionView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        images = @[[UIImage imageNamed:@"old_function_icon"],[UIImage imageNamed:@"old_function_icon"]];
        [self create];
    }
    return self;
}

- (void)create {
    _leftImageView = [[UIImageView alloc] initWithImage:images[0]];
//    _leftImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.leftImageView];
    self.leftImageView.userInteractionEnabled = NO;
    _rightImageView = [[UIImageView alloc] initWithImage:images[1]];
//    self.rightImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.rightImageView];
    self.rightImageView.userInteractionEnabled = NO;
    [self.leftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.rightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.leftImageView.tag = 0;
    self.rightImageView.tag = 1;
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(35 * kWidthRatio);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(122);
        make.height.mas_equalTo(50);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(- 35 * kWidthRatio);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(122);
        make.height.mas_equalTo(50);
    }];
}

- (void)setFunctions:(NSArray<CRFAppHomeModel *> *)functions {
    _functions = functions;
    self.leftImageView.userInteractionEnabled = YES;
    self.rightImageView.userInteractionEnabled = YES;
    if (_functions && _functions.count > 0) {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:_functions[0].iconUrl] placeholderImage:images[0]];
        if (_functions.count>1) {
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:_functions[1].iconUrl] placeholderImage:images[1]];
        }
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.didSelected) {
        self.didSelected(tap.view.tag);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context1, UIColorFromRGBValue(0xEEEEEE).CGColor);
    CGContextSetLineWidth(context1, 1);
    CGContextMoveToPoint(context1, CGRectGetWidth(self.frame) / 2.0, 30);
    CGContextAddLineToPoint(context1, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 30);
    CGContextStrokePath(context1);
}

@end
