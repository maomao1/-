//
//  CRFNCPTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/15.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "WMNCPTableViewCell.h"
#import "CRFLabel.h"

@interface WMNCPTableViewCell()
@property (nonatomic ,strong) CRFLabel   * nameMarkLabel;
@property (nonatomic ,strong) CRFLabel   * productNameLabel;
@property (nonatomic ,strong) CRFLabel   * lineLabel;
@property (nonatomic ,strong) CRFLabel   * profitMarkLabel;
@property (nonatomic ,strong) CRFLabel   * remainLabel;
@property (nonatomic ,strong) CRFLabel   * lowestAmountLabel;
@property (nonatomic ,strong) CRFLabel   * profitLabel;
@property (nonatomic ,strong) UIButton   * recommendImg;
@property (nonatomic ,strong) UIButton   * markButton;
@property (nonatomic ,strong) UIImageView* redImage;
@end
@implementation WMNCPTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.nameMarkLabel     = [self createLabelWithFont:[UIFont systemFontOfSize:13] Title:@"" titleColor:UIColorFromRGBValue(0xf6aa26)];
    self.nameMarkLabel.backgroundColor = UIColorFromRGBValue(0xf6aa26);
    self.lineLabel         = [self createLabelWithFont:[UIFont systemFontOfSize:13] Title:@"" titleColor:UIColorFromRGBValue(0xf6aa26)];
    self.lineLabel.backgroundColor = kCellLineSeparatorColor;
    self.productNameLabel  = [self createLabelWithFont:[UIFont boldSystemFontOfSize:16] Title:@"" titleColor:UIColorFromRGBValue(0x666666)];
    self.profitLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:22] Title:@"0.00~0.00%" titleColor:UIColorFromRGBValue(0x6D66AF)];
    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0x999999)];
    self.remainLabel       = [self createLabelWithFont:[UIFont boldSystemFontOfSize:14] Title:@"出借天数" titleColor:UIColorFromRGBValue(0x6D66AF)];
    self.lowestAmountLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12] Title:@"元起投" titleColor:UIColorFromRGBValue(0x999999)];
    
    self.recommendImg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recommendImg.userInteractionEnabled = NO;
    self.recommendImg.layer.masksToBounds = YES;
    self.recommendImg.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.recommendImg setTitle:@"荐" forState:UIControlStateNormal];
    [self.recommendImg setTitleColor:UIColorFromRGBValue(0xf9901f) forState:UIControlStateNormal];
    self.recommendImg.layer.masksToBounds = YES;
    self.recommendImg.layer.borderColor   = UIColorFromRGBValue(0xf9901f).CGColor;
    self.recommendImg.layer.borderWidth   = 0.5f;
    self.recommendImg.layer.cornerRadius  = 2;
    
    self.markButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.markButton.userInteractionEnabled = NO;
    self.markButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.markButton setTitleColor:UIColorFromRGBValue(0xFF6903) forState:UIControlStateNormal];
    self.markButton.layer.masksToBounds = YES;
    self.markButton.layer.borderColor   = UIColorFromRGBValue(0xFF6903).CGColor;
    self.markButton.layer.borderWidth   = 0.5f;
    self.markButton.layer.cornerRadius  = 2;
    
    [self addSubview:self.nameMarkLabel];
    [self addSubview:self.productNameLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.profitLabel];
    [self addSubview:self.redImage];
    [self addSubview:self.profitMarkLabel];
    [self addSubview:self.remainLabel];
    [self addSubview:self.lowestAmountLabel];
    [self addSubview:self.recommendImg];
    [self addSubview:self.markButton];
    
    [self.nameMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.top.mas_equalTo(kSpace);
        make.size.mas_equalTo(CGSizeMake(3, 16));
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameMarkLabel.mas_right).with.mas_offset(5.5);
        make.top.equalTo(self.nameMarkLabel.mas_top);
        make.height.mas_equalTo(16);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo (self.productNameLabel.mas_bottom).with.mas_offset(kSpace);
        make.height.mas_equalTo(0.5);
    }];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameMarkLabel.mas_left);
        make.top.equalTo(self.lineLabel.mas_bottom).with.mas_offset(19);
        make.height.mas_equalTo(22);
    }];
    [self.redImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.profitLabel.mas_right).with.mas_offset(2);
        make.bottom.mas_equalTo(self.profitLabel.mas_bottom).with.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.profitMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameMarkLabel.mas_left);
        make.top.equalTo(self.profitLabel.mas_bottom).with.mas_offset(10);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(-20);
    }];
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).with.mas_offset(0);
        make.centerY.equalTo(self.profitLabel.mas_centerY);
        make.height.mas_equalTo(12);
    }];
    [self.lowestAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remainLabel.mas_left);
        make.top.equalTo(self.profitMarkLabel.mas_top);
        make.height.equalTo(self.profitMarkLabel.mas_height);
    }];
    
    [self.recommendImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(5);
        make.top.equalTo(self.productNameLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recommendImg.mas_right).with.mas_offset(5);
        make.centerY.equalTo(self.productNameLabel.mas_centerY);
        make.height.mas_equalTo(16);
        make.right.mas_lessThanOrEqualTo(-5);
    }];
    [self.recommendImg setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.markButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.productNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
//    self.profitLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:26*kWidthRatio] Title:@"9.7%" titleColor:kRegisterButtonBackgroundColor];
//    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0x999999)];
//
//    self.mainSeparateLine  = [self createLabelWithFont:[UIFont systemFontOfSize:26*kWidthRatio] Title:@"" titleColor:kCellLineSeparatorColor];
//    self.mainSeparateLine.backgroundColor = kCellLineSeparatorColor;
//    self.productNameLabel  = [self createLabelWithFont:[UIFont systemFontOfSize:16*kWidthRatio] Title:@"幸福连盈20181015" titleColor:UIColorFromRGBValue(0x333333)];
//    self.lowestAmountLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"1000元起投" titleColor:UIColorFromRGBValue(0x999999)];
//    self.subSepatateLine   = [self createLabelWithFont:[UIFont systemFontOfSize:26*kWidthRatio] Title:@"" titleColor:UIColorFromRGBValue(0xfb4d3a)];
//    self.subSepatateLine.backgroundColor = kCellLineSeparatorColor;
//    self.remainLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"出借天数363天" titleColor:UIColorFromRGBValue(0x999999)];
//    self.recommendImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invest_cell_recommend"]];
//    self.markButton   = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.markButton.userInteractionEnabled = NO;
//    self.markButton.titleLabel.font = [UIFont systemFontOfSize:10];
//    UIColor *color = kVerifyCodeBorderColor;
//    [self.markButton setTitleColor:color forState:UIControlStateNormal];
//    self.markButton.layer.masksToBounds = YES;
//    self.markButton.layer.borderColor   = color.CGColor;
//    self.markButton.layer.borderWidth   = 0.5f;
//    self.markButton.layer.cornerRadius  = 8;
//    //
//    [self addSubview:self.profitLabel];
//    [self addSubview:self.profitMarkLabel];
//    [self addSubview:self.mainSeparateLine];
//    [self addSubview:self.productNameLabel];
//    [self addSubview:self.lowestAmountLabel];
//    [self addSubview:self.subSepatateLine];
//    [self addSubview:self.remainLabel];
//    [self addSubview:self.recommendImg];
//    [self addSubview:self.markButton];
//    self.profitLabel.verticalAlignment = VerticalAlignmentTop;
//    self.profitMarkLabel.verticalAlignment = VerticalAlignmentBottom;
//
//
//    [self.mainSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(kScreenWidth - ( 130*kWidthRatio) - kSpace * 2);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(1, 40));
//    }];
//    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mainSeparateLine.mas_right).with.offset(kSpace);
//        make.right.equalTo(self).with.mas_offset(-2);
//        //        make.bottom.equalTo(self.mas_centerY).with.mas_offset(-3);
//        make.height.mas_equalTo(21);
//        make.top.equalTo(self.mainSeparateLine.mas_top);
//    }];
//    [self.profitMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.profitLabel.mas_left);
//        //        make.top.equalTo(self.profitLabel.mas_bottom).with.mas_offset(7);
//        make.right.equalTo(self.profitLabel.mas_right);
//        make.height.mas_equalTo(12);
//        make.bottom.equalTo(self.mainSeparateLine.mas_bottom);
//    }];
//    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.mas_offset(kSpace);
//        make.top.equalTo(self.mainSeparateLine.mas_top);
//        make.height.mas_equalTo(16);
//    }];
//    [self.lowestAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.productNameLabel.mas_left);
//        make.bottom.equalTo(self.mainSeparateLine.mas_bottom);
//        make.top.equalTo(self.profitMarkLabel.mas_top);
//    }];
//    [self.subSepatateLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lowestAmountLabel.mas_right).with.mas_offset(5);
//        make.width.mas_equalTo(1);
//        make.top.equalTo(self.lowestAmountLabel.mas_top);
//        make.bottom.equalTo(self.lowestAmountLabel.mas_bottom);
//    }];
//    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.subSepatateLine).with.mas_offset(5);
//        make.top.equalTo(self.lowestAmountLabel.mas_top);
//        make.bottom.equalTo(self.lowestAmountLabel.mas_bottom);
//        make.right.mas_lessThanOrEqualTo(-kSpace);
//    }];
//
//    [self.recommendImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(5);
//        make.top.equalTo(self.productNameLabel.mas_top);
//        make.size.mas_equalTo(CGSizeMake(16, 16));
//    }];
//    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.recommendImg.mas_right).with.mas_offset(5);
//        make.centerY.equalTo(self.productNameLabel.mas_centerY);
//        make.height.mas_equalTo(16);
//        make.right.mas_lessThanOrEqualTo(-kSpace);
//    }];
    
}
-(CRFLabel *) createLabelWithFont:(UIFont*)font Title:(NSString*)title titleColor:(UIColor*)color{
    CRFLabel *titleLabel = [[CRFLabel alloc]init];
    titleLabel.text = title;
    titleLabel.textColor = color;
    titleLabel.font = font;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    return titleLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setProductModel:(CRFProductModel *)productModel {
    //
    if (productModel.isNewBie.integerValue != 4) {
        NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(yInterStr.length-1, 1)];
        [self.profitLabel setAttributedText:attString];
    }else{
        NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(productModel.minYield.length, yInterStr.length-productModel.minYield.length)];
        [self.profitLabel setAttributedText:attString];
    }
    self.productNameLabel.text = productModel.productName;
    if ([productModel.productType isEqualToString:@"1"]) {
        self.nameMarkLabel.backgroundColor = kProductContinuColor;
        
    }else{
        self.nameMarkLabel.backgroundColor = kProductMonthColor;
        
    }
    if (productModel.isNewBie.integerValue == 1) {
        self.markButton.layer.borderColor  = UIColorFromRGBValue(0xfb4d3a).CGColor;
        [self.markButton setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateNormal];
    } else {
        self.markButton.layer.borderColor  = UIColorFromRGBValue(0xFF6903).CGColor;
        [self.markButton setTitleColor:UIColorFromRGBValue(0xFF6903) forState:UIControlStateNormal];
    }
    //是否为月标产品
    self.redImage.hidden = !(productModel.isNewBie.integerValue == 4);
    if ([productModel.lowestAmount formatPercent].length > 4){
        NSString *money = [[[productModel.lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [productModel.lowestAmount formatPercent].length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",money];
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[productModel.lowestAmount formatBeginMoney]];
    }
    NSMutableAttributedString *remainAttributeStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"出借天数%@天",productModel.remainDays]];
    [remainAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x444444) range:[[NSString stringWithFormat:@"出借天数%@天",productModel.remainDays] rangeOfString:@"出借天数"]];
    [self.remainLabel setAttributedText:remainAttributeStr];
    if (productModel.recommendedState.integerValue != 1) {
        [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(0);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }else{
        [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    if (productModel.tipsStart.length) {
        self.markButton.hidden = NO;
        [self.markButton setTitle:[NSString stringWithFormat:@"  %@  ",productModel.tipsStart] forState:UIControlStateNormal];
    }else{
        self.markButton.hidden = YES;
    }
    //
//    NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
//    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*kWidthRatio] range:NSMakeRange(yInterStr.length-1, 1)];
//    [self.profitLabel setAttributedText:attString];
//    self.productNameLabel.text = productModel.productName;
//    if ([productModel.lowestAmount formatPercent].length > 4){
//        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",[[[productModel.lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [productModel.lowestAmount formatPercent].length - 4)] formatBeginMoney]];
//    }else{
//        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[productModel.lowestAmount formatBeginMoney]];
//    }
//    self.remainLabel.text = [NSString stringWithFormat:@"出借天数%@天",productModel.remainDays];
//    if (![productModel.isNewBie isEqualToString:@"3"]) {
//        [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(0);
//            make.size.mas_equalTo(CGSizeZero);
//        }];
//    }else{
//        [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(5);
//            make.size.mas_equalTo(CGSizeMake(16*kWidthRatio, 16*kWidthRatio));
//        }];
//    }
//    if (productModel.tipsStart.length) {
//        self.markButton.hidden = NO;
//        [self.markButton setTitle:[NSString stringWithFormat:@"  %@  ",productModel.tipsStart] forState:UIControlStateNormal];
//    }else{
//        self.markButton.hidden = YES;
//    }
}

-(UIImageView *)redImage{
    if (!_redImage) {
        _redImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red packet"]];
    }
    return _redImage;
}
@end

