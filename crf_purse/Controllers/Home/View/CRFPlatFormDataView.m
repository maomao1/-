//
//  CRFPlatFormDataView.m
//  crf_purse
//
//  Created by maomao on 2018/8/28.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFPlatFormDataView.h"
#import "CRFTimeUtil.h"
#import "CRFStringUtils.h"
#import "CRFAppHomeModel.h"
@interface CRFPlatFormDataView()
@property  (nonatomic , strong)  UILabel  * titleLabel;
@property  (nonatomic , strong)  UILabel  * daysTitleLabel;

@property  (nonatomic , strong)  UILabel  * lineLabel;
@property  (nonatomic , strong)  UIImageView  * imageView;
@property  (nonatomic , strong)  UIImageView  * numberImg;
@property  (nonatomic , strong)  UIImageView  * moneyImg;
@property  (nonatomic , strong)  UIImageView  * dealImg;

@end
@implementation CRFPlatFormDataView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configPlatformView];
    }
    return self;
}
-(void)configPlatformView{
    self.titleLabel      = [self creatLabelTitle:@"平台数据" Color:UIColorFromRGBValue(0x333333) FontSize:15];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.daysTitleLabel  = [self creatLabelTitle:@"已安全运营8年" Color:UIColorFromRGBValue(0x999999) FontSize:11];
    
    self.lineLabel       = [self creatLabelTitle:@"" Color:UIColorFromRGBValue(0x333333) FontSize:15];
    self.lineLabel.backgroundColor = kCellLineSeparatorColor;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.daysTitleLabel];
    
    [self addSubview:self.lineLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.numberImg];
    [self addSubview:self.moneyImg];
    [self addSubview:self.dealImg];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.top.mas_equalTo(kSpace);
        make.size.mas_equalTo(CGSizeMake(70, 16));
    }];
    [self.daysTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSpace);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).with.mas_offset(0);
        
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.daysTitleLabel.mas_left).with.mas_offset(-5);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).with.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.numberImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.daysTitleLabel.mas_bottom).with.mas_offset(20);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberImg.mas_bottom).with.mas_offset(10);
        make.left.mas_equalTo(kSpace);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth/2-2*kSpace);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.moneyImg.mas_centerY);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(25);

    }];
    [self.dealImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyImg.mas_top).with.mas_offset(0);
        make.right.mas_equalTo(-kSpace);
        make.width.mas_equalTo(kScreenWidth/2-2*kSpace);
        make.height.mas_equalTo(50);
    }];

}
-(void)updateContent:(NSArray *)itemArr{
    NSString *currentYear = [CRFTimeUtil getCurrentDate:3];
    NSString *contentYear = [NSString stringWithFormat:@"%ld",currentYear.integerValue - 2010];
    NSString *contentStr = [NSString stringWithFormat:@"已安全运营%@年",contentYear];
    NSMutableAttributedString *attrbute = [CRFStringUtils setAttributedString:contentStr lineSpace:3 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:11.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, contentStr.length-1) attributes2:@{NSFontAttributeName:[CRFUtils fontWithSize:11.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[contentStr rangeOfString:contentYear] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
    [self.daysTitleLabel setAttributedText:attrbute];
    if (itemArr.count) {
        CRFAppHomeModel *model1 = itemArr[0];
        [_numberImg sd_setImageWithURL:[NSURL URLWithString:model1.iconUrl] placeholderImage:[UIImage imageNamed:@"platform_number@3x"]];
    }
    if (itemArr.count>1) {
        CRFAppHomeModel *model2 = itemArr[1];
        [_moneyImg sd_setImageWithURL:[NSURL URLWithString:model2.iconUrl] placeholderImage:[UIImage imageNamed:@"platform_money@3x"]];
    }
    if (itemArr.count>2) {
        CRFAppHomeModel *model3 = itemArr[2];
        [_dealImg sd_setImageWithURL:[NSURL URLWithString:model3.iconUrl] placeholderImage:[UIImage imageNamed:@"platform_deal@3x"]];
    }
}
-(UILabel *)creatLabelTitle:(NSString *)title Color:(UIColor*)color FontSize:(CGFloat)size{
    UILabel *commonLabel  = [[UILabel alloc]init];
    commonLabel.textColor = color;
    commonLabel.font = [UIFont systemFontOfSize:size];
    commonLabel.text = title;
    return commonLabel;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"safe_icon"]];
    }
    return _imageView;
}
-(UIImageView *)numberImg{
    if (!_numberImg) {
        _numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"platform_number@3x"]];
        _numberImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _numberImg;
}-(UIImageView *)moneyImg{
    if (!_moneyImg) {
        _moneyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"platform_money@3x"]];
        _moneyImg.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _moneyImg;
}-(UIImageView *)dealImg{
    if (!_dealImg) {
        _dealImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"platform_deal@3x"]];
        _dealImg.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _dealImg;
}
@end
