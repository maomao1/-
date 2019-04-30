//
//  CRFCouponCell.m
//  crf_purse
//
//  Created by maomao on 2017/9/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCouponCell.h"
#import "CRFStringUtils.h"
#import "CRFTimeUtil.h"

@interface CRFCouponCell()
@property (nonatomic ,strong)  UIImageView  *leftImg;
@property (nonatomic ,strong)  UIImageView  *rightImg;
@property (nonatomic ,strong)  UIImageView  *lineImg;

@property (nonatomic ,strong) UILabel       *leftLabel;
@property (nonatomic ,strong) UILabel       *mainLabel;
@property (nonatomic ,strong) UILabel       *conditionLabel;
@property (nonatomic ,strong) UILabel       *timeLabel;
@property (nonatomic ,strong) UIButton      *selectBtn;
@property (nonatomic ,strong) UIButton      *regionBtn;


@end
@implementation CRFCouponCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    [self addSubview:self.leftImg];
    [self addSubview:self.rightImg];
    [self addSubview:self.leftLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.mainLabel];
    [self addSubview:self.conditionLabel];
    [self addSubview:self.selectBtn];
    [self addSubview:self.lineImg];
//    [self addSubview:self.regionBtn];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(84*kWidthRatio);
    }];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).with.mas_offset(0);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImg.mas_top).with.mas_offset(4);
        make.bottom.equalTo(self.leftImg.mas_bottom).with.mas_offset(-4);
        make.left.equalTo(self.leftImg.mas_right).with.mas_offset(0);
        make.width.mas_equalTo(1);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self.leftImg.mas_width);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(-kSpace+5);
    }];
//    [self.regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.selectBtn);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImg.mas_left).with.mas_offset(kSpace);
        make.right.equalTo(self.selectBtn.mas_left).with.mas_offset(-kSpace+5);
        make.centerY.equalTo(self);
        
    }];
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.conditionLabel.mas_left);
        make.right.equalTo(self.conditionLabel.mas_right);
        make.bottom.equalTo(self.conditionLabel.mas_top).with.mas_offset(-8);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.conditionLabel.mas_left);
        make.right.equalTo(self.conditionLabel.mas_right);
        make.top.equalTo(self.conditionLabel.mas_bottom).with.mas_offset(8);
    }];
    
}
- (void)btnClick:(UIButton*)btn{
    btn.selected =!btn.selected;
//    _selectBtn.selected = btn.selected;
    if (self.couponDidSelectedHandler) {
        self.couponDidSelectedHandler(self);
    }
    
}
- (UIImageView *)leftImg{
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coupon_left_bg"]];
    }
    return _leftImg;
}
- (UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coupon_right_bg"]];
    }
    return _rightImg;
}
- (UIImageView *)lineImg{
    if (!_lineImg) {
        _lineImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coupon_line"]];
    }
    return _lineImg;
}
- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.numberOfLines = 1;
        _leftLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    }
    return _leftLabel;
}
- (UILabel *)mainLabel{
    if (!_mainLabel) {
        _mainLabel = [UILabel new];
        _mainLabel.font = [UIFont boldSystemFontOfSize:18];
        _mainLabel.textColor = UIColorFromRGBValue(0x333333);
        _mainLabel.numberOfLines = 1;
    }
    return _mainLabel;
}
- (UILabel *)conditionLabel{
    if (!_conditionLabel) {
        _conditionLabel = [UILabel new];
        _conditionLabel.font = [UIFont systemFontOfSize:12];
        _conditionLabel.textColor = UIColorFromRGBValue(0x333333);
    }
    return _conditionLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGBValue(0x999999);
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"coupon_unselected"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"coupon_selected"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
//- (UIButton *)regionBtn{
//    if(!_regionBtn ){
//        _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_regionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _regionBtn.backgroundColor = [UIColor clearColor];
//    }
//    return _regionBtn;
//}

- (void)setCoupon:(CRFCouponModel *)coupon {
    _coupon = coupon;
    [self setTextColor];
    
    NSString *value = coupon.giftType.integerValue == 3 ?[NSString stringWithFormat:@"%@%%",_coupon.giftValue]:[NSString stringWithFormat:@"¥ %@",_coupon.giftValue];
    UIColor *contentColor = nil;
    if ([_coupon.couponIsUse integerValue] == 1) {
        contentColor = UIColorFromRGBValue(0xFB4D3A);
    } else {
        contentColor = UIColorFromRGBValue(0x999999);
    }
    [self.leftLabel setAttributedText:[CRFStringUtils setAttributedString:value lineSpace:0 attributes1:@{NSForegroundColorAttributeName:contentColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} range1:[value rangeOfString:_coupon.giftValue] attributes2:@{NSForegroundColorAttributeName:contentColor,NSFontAttributeName:[UIFont systemFontOfSize:18]} range2:[value rangeOfString:@"¥"] attributes3:@{NSForegroundColorAttributeName:contentColor,NSFontAttributeName:[UIFont systemFontOfSize:18]} range3:[value rangeOfString:@"%"] attributes4:nil range4:NSRangeZero]];
    self.conditionLabel.text = [NSString stringWithFormat:@"使用条件：%@",_coupon.useInfo];
    self.timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@",[CRFTimeUtil formatLongTime:[_coupon.createTime longLongValue] pattern:@"yyyy.MM.dd"],[CRFTimeUtil formatLongTime:[_coupon.invalidTime longLongValue] pattern:@"yyyy.MM.dd"]];
    self.mainLabel.text = _coupon.giftName;
}

- (void)setTextColor {
    UIColor *textColor = nil;
    UIColor *conditionColor = nil;
    if ([self.coupon.couponIsUse integerValue] == 1) {
        textColor = UIColorFromRGBValue(0x333333);
        conditionColor = UIColorFromRGBValue(0x333333);
        self.selectBtn.userInteractionEnabled = YES;
    } else {
        self.selectBtn.userInteractionEnabled = NO;
        textColor = UIColorFromRGBValue(0x999999);
        conditionColor = UIColorFromRGBValue(0x999999);
        }
    self.mainLabel.textColor = textColor;
    self.conditionLabel.textColor = conditionColor;
}

- (void)resetUI {
    self.selectBtn.selected = NO;
}

- (void)selected {
    self.selectBtn.selected = YES;
}

- (BOOL)couponSelected {
    return self.selectBtn.selected;
}

@end
