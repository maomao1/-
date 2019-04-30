//
//  CRFNewDiscoverCell.m
//  crf_purse
//
//  Created by maomao on 2018/7/4.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFNewDiscoverCell.h"
#import "CRFAppHomeModel.h"
@implementation CRFNewDiscoverCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageViewFirst];
        [self addSubview:self.imageViewSecond];
        [self addSubview:self.imageViewThree];
        [self.imageViewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.top.mas_equalTo(5);
//            make.width.mas_equalTo((kScreenWidth-35)/2);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth-35)/2, (kScreenWidth-35)/2.8));
        }];
        [self.imageViewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.imageViewFirst.mas_width);
            make.top.equalTo(self.imageViewFirst.mas_top);
            make.left.equalTo(self.imageViewFirst.mas_right).with.mas_offset(5);
            make.height.mas_equalTo((kScreenWidth-35)/5.6 - 2);
        }];
        [self.imageViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.imageViewSecond.mas_width);
            make.height.equalTo(self.imageViewSecond.mas_height);
            make.bottom.equalTo(self.imageViewFirst.mas_bottom);
            make.left.equalTo(self.imageViewSecond.mas_left);
        }];
    }
    return self;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count) {
        CRFAppHomeModel *model= [_dataArray objectAtIndex:0];
        [self.imageViewFirst sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"discovery_top_default"]];
    }
    if (_dataArray.count>1) {
        CRFAppHomeModel *model= [_dataArray objectAtIndex:1];
        [self.imageViewSecond sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"discovery_top_default"]];
    }
    if (_dataArray.count>2) {
        CRFAppHomeModel *model= [_dataArray objectAtIndex:2];
        [self.imageViewThree sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"discovery_top_default"]];
    }
}
-(void)tapImageFirst{
    if (self.callImageClick) {
        self.callImageClick(0);
    }
}
-(void)tapImageSecond{
    if (self.callImageClick) {
        self.callImageClick(1);
    }
}
-(void)tapImageThree{
    if (self.callImageClick) {
        self.callImageClick(2);
    }
}
-(UIImageView *)imageViewFirst{
    if (!_imageViewFirst) {
        _imageViewFirst = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diccovery_new_default"]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageFirst)];
        _imageViewFirst.userInteractionEnabled = YES;
        [_imageViewFirst addGestureRecognizer:tap];
    }
    return _imageViewFirst;
}
-(UIImageView *)imageViewSecond{
    if (!_imageViewSecond) {
        _imageViewSecond = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diccovery_new_default"]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageSecond)];
        _imageViewSecond.userInteractionEnabled = YES;
        [_imageViewSecond addGestureRecognizer:tap];
    }
    return _imageViewSecond;
}
-(UIImageView *)imageViewThree{
    if (!_imageViewThree) {
        _imageViewThree = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diccovery_new_default"]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageThree)];
        _imageViewThree.userInteractionEnabled = YES;
        [_imageViewThree addGestureRecognizer:tap];
    }
    return _imageViewThree;
}
@end
