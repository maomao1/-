//
//  CRFCollectionHeader.m
//  crf_purse
//
//  Created by maomao on 2017/8/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCollectionHeader.h"
#import "CRFViewUtils.h"

@implementation CRFCollectionHeader
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"discover_list_dynmic"]];
        UILabel *title = [UILabel new];
        title.textColor = UIColorFromRGBValue(0x333333);
        title.font = [UIFont boldSystemFontOfSize:16];
        if ([CRFAppManager defaultManager].majiabaoFlag) {
             title.text = @"行业动态";
        } else {
             title.text = @"信而富动态";
        }
        UIButton *moreBtn = [CRFViewUtils buttonWithFont:[UIFont systemFontOfSize:12] norTitleColor:UIColorFromRGBValue(0xFB4D3A) norImg:@"discover_more" titleEdgeInset:UIEdgeInsetsMake(0, 0, 0, 10) imgEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        moreBtn.layer.masksToBounds = YES;
        moreBtn.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
        moreBtn.layer.borderWidth = 1.0f;
        moreBtn.layer.cornerRadius = 10.0f;
        moreBtn.crf_acceptEventInterval = 0.5;
        
        [moreBtn addTarget:self action:@selector(scanMore:) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kCellLineSeparatorColor;
        [self addSubview:line];
        [self addSubview:moreBtn];
        [self addSubview:title];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(kSpace);
            make.centerY.equalTo(self);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).with.mas_offset(8);
            make.centerY.equalTo(self);
        }];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-kSpace);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.right.equalTo(self);
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
- (void)scanMore:(UIButton*)btn{
    if ([self.crf_delegate respondsToSelector:@selector(crf_pushList)]) {
        [self.crf_delegate crf_pushList];
    }
}
@end
