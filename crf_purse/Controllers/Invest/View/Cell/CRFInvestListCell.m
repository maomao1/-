//
//  CRFInvestListCell.m
//  crf_purse
//
//  Created by maomao on 2017/11/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestListCell.h"
#import "CRFLabel.h"
#import "CRFStringUtils.h"

@interface CRFInvestListCell()
@property  (nonatomic , strong) CRFLabel  *profitLabel;
@property  (nonatomic , strong) CRFLabel  *profitMarkLabel;
@property  (nonatomic , strong) CRFLabel  *mainSeparateLine;
@property  (nonatomic , strong) CRFLabel  *productNameLabel;
@property  (nonatomic , strong) CRFLabel  *lowestAmountLabel;
@property  (nonatomic , strong) CRFLabel  *subSepatateLine;
@property  (nonatomic , strong) CRFLabel  *remainLabel;

@property  (nonatomic , strong) UIImageView *recommendImg;
@property  (nonatomic , strong) UIButton  *markButton;
@property (nonatomic ,strong) UIImageView* redImage;

@end
@implementation CRFInvestListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.profitLabel       = [self createLabelWithFont:CRFFONT(AkrobatZT, 22*kWidthRatio) Title:@"9.7%" titleColor:UIColorFromRGBValue(0xfb4d3a)];
    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0x999999)];
    
    self.mainSeparateLine  = [self createLabelWithFont:[UIFont systemFontOfSize:26*kWidthRatio] Title:@"" titleColor:kCellLineSeparatorColor];
    self.mainSeparateLine.backgroundColor = kCellLineSeparatorColor;
    UIColor *color = self.newBie ? kButtonNormalBackgroundColor : UIColorFromRGBValue(0x333333);
    self.productNameLabel  = [self createLabelWithFont:[UIFont systemFontOfSize:15*kWidthRatio] Title:@"幸福连盈20181015" titleColor:color];
    self.lowestAmountLabel = [self createLabelWithFont:[CRFUtils fontWithSize:12.0f * kWidthRatio] Title:@"1000元起投" titleColor:UIColorFromRGBValue(0x999999)];
    self.subSepatateLine   = [self createLabelWithFont:[UIFont systemFontOfSize:26*kWidthRatio] Title:@"" titleColor:UIColorFromRGBValue(0xfb4d3a)];
    self.subSepatateLine.backgroundColor = kCellLineSeparatorColor;
    self.remainLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"出借天数363天" titleColor:UIColorFromRGBValue(0x999999)];
    self.recommendImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invest_cell_recommend"]];
    self.markButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.markButton.userInteractionEnabled = NO;
    self.markButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.markButton setTitleColor:UIColorFromRGBValue(0xffa700) forState:UIControlStateNormal];
    self.markButton.layer.masksToBounds = YES;
    self.markButton.layer.borderColor   = UIColorFromRGBValue(0xffa700).CGColor;
    self.markButton.layer.borderWidth   = 0.5f;
    self.markButton.layer.cornerRadius  = 8;
    //
    [self addSubview:self.profitLabel];
    [self addSubview:self.redImage];
    [self addSubview:self.profitMarkLabel];
    [self addSubview:self.mainSeparateLine];
    [self addSubview:self.productNameLabel];
    [self addSubview:self.lowestAmountLabel];
    [self addSubview:self.subSepatateLine];
    [self addSubview:self.remainLabel];
    [self addSubview:self.recommendImg];
    [self addSubview:self.markButton];
    self.profitLabel.verticalAlignment = VerticalAlignmentTop;
    self.profitMarkLabel.verticalAlignment = VerticalAlignmentBottom;

    
    [self.mainSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(145*kWidthRatio);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 40));
        
    }];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.equalTo(self.mainSeparateLine.mas_left).with.mas_offset(10);
//        make.bottom.equalTo(self.mas_centerY).with.mas_offset(-3);
        make.height.mas_equalTo(21);
        make.top.equalTo(self.mainSeparateLine.mas_top);
    }];
    [self.redImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.profitLabel.mas_right).with.mas_offset(2);
        make.bottom.mas_equalTo(self.profitLabel.mas_bottom).with.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.profitMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profitLabel.mas_left);
//        make.top.equalTo(self.profitLabel.mas_bottom).with.mas_offset(7);
        make.right.equalTo(self.profitLabel.mas_right);
        make.height.mas_equalTo(12);
        make.bottom.equalTo(self.mainSeparateLine.mas_bottom);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainSeparateLine.mas_right).with.mas_offset(10);
        make.top.equalTo(self.mainSeparateLine.mas_top);
        make.height.mas_equalTo(16);
    }];
    [self.lowestAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.bottom.equalTo(self.mainSeparateLine.mas_bottom);
        make.top.equalTo(self.profitMarkLabel.mas_top);
    }];
    [self.subSepatateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lowestAmountLabel.mas_right).with.mas_offset(5);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.lowestAmountLabel.mas_top);
        make.bottom.equalTo(self.lowestAmountLabel.mas_bottom);
    }];
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subSepatateLine.mas_right).with.mas_offset(5);
        make.top.equalTo(self.lowestAmountLabel.mas_top);
        make.bottom.equalTo(self.lowestAmountLabel.mas_bottom);
        make.right.mas_lessThanOrEqualTo(-kSpace);
    }];
    
    [self.recommendImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(5);
        make.top.equalTo(self.productNameLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(16*kWidthRatio, 16*kWidthRatio));
    }];
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recommendImg.mas_right).with.mas_offset(5);
        make.centerY.equalTo(self.productNameLabel.mas_centerY);
        make.height.mas_equalTo(16);
//        make.right.mas_greaterThanOrEqualTo(-kSpace);
        make.right.mas_lessThanOrEqualTo(-5);
    }];
    [self.recommendImg setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.markButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.productNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
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

-(void)setProductModel:(CRFProductModel *)productModel{
    self.redImage.hidden = !(productModel.isNewBie.integerValue == 4);
    if (productModel.isNewBie.integerValue != 4) {
        NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
        [attString addAttribute:NSFontAttributeName value:CRFFONT(AkrobatZT, 14*kWidthRatio) range:NSMakeRange(yInterStr.length-1, 1)];
        [self.profitLabel setAttributedText:attString];
        [self.profitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
//            make.right.equalTo(self.mainSeparateLine.mas_left).with.mas_offset(10);
            //        make.bottom.equalTo(self.mas_centerY).with.mas_offset(-3);
            make.height.mas_equalTo(21);
            make.top.equalTo(self.mainSeparateLine.mas_top);
        }];
    }else{
        NSString *yInterStr = [NSString stringWithFormat:@"%@%%+%@%%",productModel.minYield,productModel.maxYield];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*kWidthRatio] range:NSMakeRange(productModel.minYield.length, yInterStr.length-productModel.minYield.length)];
        [self.profitLabel setAttributedText:attString];
        [self.profitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
//            make.right.equalTo(self.mainSeparateLine.mas_left).with.mas_offset(-15);
            //        make.bottom.equalTo(self.mas_centerY).with.mas_offset(-3);
            make.height.mas_equalTo(21);
            make.top.equalTo(self.mainSeparateLine.mas_top);
        }];
    }
//    NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
//    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*kWidthRatio] range:NSMakeRange(yInterStr.length-1, 1)];
//    [self.profitLabel setAttributedText:attString];
    self.productNameLabel.text = productModel.productName;
    if (self.newBie) {
        self.productNameLabel.textColor = kButtonNormalBackgroundColor;
    } else {
        self.productNameLabel.textColor = kTextDefaultColor;
    }
    if (productModel.isNewBie.integerValue == 1) {
        [self.markButton setTitleColor:UIColorFromRGBValue(0xFA844A) forState:UIControlStateNormal];
        self.markButton.layer.borderColor = UIColorFromRGBValue(0xFA844A).CGColor;
    } else {
        [self.markButton setTitleColor:UIColorFromRGBValue(0xffa700) forState:UIControlStateNormal];
        self.markButton.layer.borderColor = UIColorFromRGBValue(0xffa700).CGColor;
    }
    if ([productModel.lowestAmount formatPercent].length > 4){
        NSString *money = [[[productModel.lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [productModel.lowestAmount formatPercent].length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",money];
        if (self.newBie) {
            [self.lowestAmountLabel setAttributedText:[CRFStringUtils setAttributedString:self.lowestAmountLabel.text highlightText:money highlightColor:kButtonNormalBackgroundColor]];
        }
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[productModel.lowestAmount formatBeginMoney]];
        if (self.newBie) {
            [self.lowestAmountLabel setAttributedText:[CRFStringUtils setAttributedString:self.lowestAmountLabel.text highlightText:[productModel.lowestAmount formatBeginMoney] highlightColor:kButtonNormalBackgroundColor]];
        }
    }
    self.remainLabel.text = [NSString stringWithFormat:@"出借天数%@天",productModel.remainDays];
    if (self.newBie) {
        [self.remainLabel setAttributedText:[CRFStringUtils setAttributedString:self.remainLabel.text highlightText:productModel.remainDays highlightColor:kButtonNormalBackgroundColor]];
    }
    if (productModel.recommendedState.integerValue != 1) {
        [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(0);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }else{
        [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(16*kWidthRatio, 16*kWidthRatio));
        }];
    }
    if (productModel.tipsStart.length) {
        self.markButton.hidden = NO;
        [self.markButton setTitle:[NSString stringWithFormat:@"  %@  ",productModel.tipsStart] forState:UIControlStateNormal];
    }else{
        self.markButton.hidden = YES;
    }
}

-(void)setExclusiveProductInfo:(CRFAppintmentForwardProductModel *)exclusiveProductInfo{
    self.redImage.hidden = YES;
    NSString *yInterStr = [exclusiveProductInfo formatYInterestRate];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
    [attString addAttribute:NSFontAttributeName value:CRFFONT(AkrobatZT, 14*kWidthRatio) range:NSMakeRange(yInterStr.length-1, 1)];
    [self.profitLabel setAttributedText:attString];
    self.productNameLabel.textColor = kTextDefaultColor;
    self.productNameLabel.text = exclusiveProductInfo.productName;
    NSString *string = [NSString stringWithFormat:@"%lld",exclusiveProductInfo.lowestAmount];
    if (string.length > 4){
        NSString *money = [[string substringWithRange:NSMakeRange(0, string.length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",money];
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[string formatBeginMoney]];
    }
    [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(0);
        make.size.mas_equalTo(CGSizeZero);
    }];
    self.remainLabel.text = [NSString stringWithFormat:@"出借天数%ld天",exclusiveProductInfo.remainDays];
    self.markButton.hidden = YES;
}

- (void)setAppointmentAssignProductInfo:(CRFAppintmentForwardProductModel *)appointmentAssignProductInfo {
    self.redImage.hidden = YES;
    _appointmentAssignProductInfo = appointmentAssignProductInfo;
    NSString *yInterStr = [_appointmentAssignProductInfo formatYInterestRate];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
    [attString addAttribute:NSFontAttributeName value:CRFFONT(AkrobatZT, 14*kWidthRatio) range:NSMakeRange(yInterStr.length-1, 1)];
    [self.profitLabel setAttributedText:attString];
    self.productNameLabel.textColor = kTextDefaultColor;
    self.productNameLabel.text = _appointmentAssignProductInfo.productName;
    NSString *string = [NSString stringWithFormat:@"%lld",_appointmentAssignProductInfo.lowestAmount];
    if (string.length > 4){
        NSString *money = [[string substringWithRange:NSMakeRange(0, string.length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",money];
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[string formatBeginMoney]];
    }
    [self.recommendImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_right).with.mas_offset(0);
        make.size.mas_equalTo(CGSizeZero);
    }];
    self.remainLabel.hidden = YES;
    self.markButton.hidden = YES;
    self.subSepatateLine.hidden = YES;
}
-(UIImageView *)redImage{
    if (!_redImage) {
        _redImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red packet"]];
    }
    return _redImage;
}
@end
