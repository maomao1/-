//
//  CRFNewMineCell.m
//  crf_purse
//
//  Created by maomao on 2018/8/30.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFNewMineCell.h"

@implementation CRFNewMineCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        [self initializeView];
    }
    return self;
}
-(void)initializeView{
    _imageView = [[UIImageView alloc]init];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.textColor = UIColorFromRGBValue(0x333333);
    _secondLabel = [[UILabel alloc]init];
    _secondLabel.font = [UIFont systemFontOfSize:10.0f];
    _secondLabel.textColor = UIColorFromRGBValue(0x999999);
    _secondLabel.numberOfLines = 0;
    [self addSubview:_imageView];
    [self addSubview:_titleLabel];
    [self addSubview:_secondLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.mas_offset(0);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.mas_offset(10);
        make.top.equalTo(self.imageView.mas_top);
        make.right.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.mas_offset(10);
        make.bottom.equalTo(self.imageView.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo(11);
    }];
}
//-(void)updateLayout{
//    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.imageView.mas_right).with.mas_offset(10);
//        make.centerY.equalTo(self.imageView.mas_centerY);
//        make.right.equalTo(self);
//        make.height.mas_equalTo(15);
//    }];
//    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.imageView.mas_right).with.mas_offset(10);
//        make.bottom.equalTo(self.imageView.mas_bottom);
//        make.right.equalTo(self);
//        make.height.mas_equalTo(0);
//    }];
//}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}
-(void)setSecondTitle:(NSString *)secondTitle{
    _secondTitle = secondTitle;
    self.secondLabel.text = _secondTitle;
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    if (_secondTitle.length>0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).with.mas_offset(5);
            make.top.equalTo(self.imageView.mas_top);
            make.right.equalTo(self);
            make.height.mas_equalTo(15);
        }];
        [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).with.mas_offset(5);
            make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(3);
            make.right.equalTo(self);
//            make.height.mas_equalTo(11);
        }];
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).with.mas_offset(5);
            make.centerY.equalTo(self.imageView.mas_centerY);
            make.right.equalTo(self);
            make.height.mas_equalTo(15);
        }];
        [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).with.mas_offset(5);
            make.bottom.equalTo(self.imageView.mas_bottom);
            make.right.equalTo(self);
            make.height.mas_equalTo(0);
        }];
    }
}
@end
