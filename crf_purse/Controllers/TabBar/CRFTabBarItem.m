//
//  CRFTabBarItem.m
//  crf_purse
//
//  Created by crf on 2017/7/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFTabBarItem.h"

static CGFloat const kDotViewHeight = 8.0f;

@interface CRFTabBarItem()


@end

@implementation CRFTabBarItem


- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor cyanColor];
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeCenter | UIViewContentModeBottom;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(5.5f);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    _contentLabel = [[UILabel alloc] init];
    [self addSubview:self.contentLabel];
    self.contentLabel.font = [UIFont systemFontOfSize:10.0f];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [UIColor grayColor];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(10);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(4.5);
    }];
}

- (void)setHasNewMessage:(BOOL)hasNewMessage {
    _hasNewMessage = hasNewMessage;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.imageView.image = _selected ? self.selectedImage : self.image;
    self.contentLabel.textColor = _selected ? self.selectedTextColor : self.textColor;
}

- (void)drawRect:(CGRect)rect {
    if (self.hasNewMessage) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetWidth(self.frame) / 2 + 5, 5, kDotViewHeight, kDotViewHeight) cornerRadius:kDotViewHeight / 2.0];
        [[UIColor redColor] setFill];
        [bezierPath fill];
    }
}


@end
