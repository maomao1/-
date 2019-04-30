//
//  CRFNewInvestListCell.m
//  crf_purse
//
//  Created by maomao on 2018/7/3.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFNewInvestListCell.h"
#import "CRFStringUtils.h"
#import "CRFColorButton.h"
@interface CRFNewInvestListCell()

@property (nonatomic ,strong) CRFLabel   * nameMarkLabel;
@property (nonatomic ,strong) CRFLabel   * productNameLabel;
@property (nonatomic ,strong) CRFLabel   * profitMarkLabel;
@property (nonatomic ,strong) CRFLabel   * remainLabel;
@property (nonatomic ,strong) CRFLabel   * lowestAmountLabel;
@property (nonatomic ,strong) CRFLabel   * profitLabel;
@property (nonatomic ,strong) UIButton   * recommendImg;
@property (nonatomic ,strong) UIButton   * markButton;
@property (nonatomic ,strong) UIImageView* redImage;

@property (nonatomic ,strong) UIImageView* statusImage;
@property  (nonatomic , strong) CRFColorButton  *investButton;

@end
@implementation CRFNewInvestListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([reuseIdentifier isEqualToString:CRFNewInvestListCellId]) {
            [self createUI];
        }else{
            [self initConfigerView];
        }
    }
    return self;
}
-(void)initConfigerView{
    self.productNameLabel  = [self createLabelWithFont:[UIFont boldSystemFontOfSize:16] Title:@"转Z00120180525789" titleColor:UIColorFromRGBValue(0x666666)];
    self.lineLabel         = [self createLabelWithFont:[UIFont systemFontOfSize:13] Title:@"" titleColor:UIColorFromRGBValue(0xf6aa26)];
    self.lineLabel.backgroundColor = kCellLineSeparatorColor;
    self.profitLabel       = [self createLabelWithFont:CRFFONT(AkrobatZT, 26*kWidthRatio) Title:@"0.00~0.00%" titleColor:UIColorFromRGBValue(0xfb4d3a)];
    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0x999999)];
    self.remainLabel       = [self createLabelWithFont:CRFFONT(AkrobatZT, 20*kWidthRatio) Title:@"1000元" titleColor:UIColorFromRGBValue(0x333333)];
    self.lowestAmountLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12] Title:@"转让价格" titleColor:UIColorFromRGBValue(0x999999)];
    [self addSubview:self.productNameLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.profitLabel];
    [self addSubview:self.statusImage];
    [self addSubview:self.profitMarkLabel];
    [self addSubview:self.remainLabel];
    [self addSubview:self.lowestAmountLabel];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.top.mas_equalTo(kSpace);
        make.height.mas_equalTo(16);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo (self.productNameLabel.mas_bottom).with.mas_offset(kSpace);
        make.height.mas_equalTo(0.5);
    }];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.top.equalTo(self.lineLabel.mas_bottom).with.mas_offset(19);
        make.height.mas_equalTo(22);
    }];
    [self.profitMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.top.equalTo(self.profitLabel.mas_bottom).with.mas_offset(10);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(-20);
    }];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
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
}
-(void)createUI{
    self.nameMarkLabel     = [self createLabelWithFont:[UIFont systemFontOfSize:13] Title:@"" titleColor:UIColorFromRGBValue(0xf6aa26)];
    self.nameMarkLabel.backgroundColor = UIColorFromRGBValue(0xf6aa26);
    self.lineLabel         = [self createLabelWithFont:[UIFont systemFontOfSize:13] Title:@"" titleColor:UIColorFromRGBValue(0xf6aa26)];
    self.lineLabel.backgroundColor = kCellLineSeparatorColor;
    self.productNameLabel  = [self createLabelWithFont:[UIFont boldSystemFontOfSize:16] Title:@"" titleColor:UIColorFromRGBValue(0x666666)];
    self.profitLabel       = [self createLabelWithFont:[UIFont fontWithName:@"Akrobat" size:25*kWidthRatio] Title:@"0.00~0.00%" titleColor:UIColorFromRGBValue(0xfb4d3a)];
    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0x999999)];
    self.remainLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"出借天数" titleColor:UIColorFromRGBValue(0x333333)];
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
    [self.markButton setTitleColor:UIColorFromRGBValue(0xFC514D) forState:UIControlStateNormal];
    self.markButton.layer.masksToBounds = YES;
    self.markButton.layer.borderColor   = UIColorFromRGBValue(0xFC514D).CGColor;
    self.markButton.layer.borderWidth   = 0.5f;
    self.markButton.layer.cornerRadius  = 2;
    
    self.investButton   = [CRFColorButton buttonWithType:UIButtonTypeCustom];
    self.investButton.titleLabel.font = [UIFont systemFontOfSize:12*kWidthRatio];
    self.investButton.cornerRadius  = 15*kWidthRatio;
    [self.investButton setTitle:@"立即加入" forState:UIControlStateNormal];
    [self.investButton setGradientColor:[CRFGradientColor gradientColorWithColors:@[UIColorFromRGBValue(0xFA696F),UIColorFromRGBValue(0xFE4A48)]] forState:UIControlStateDisabled];
    self.investButton.enabled = NO;
    
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
    [self addSubview:self.investButton];
    
    [self.nameMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(3, 16));
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameMarkLabel.mas_right).with.mas_offset(5.5);
        make.top.equalTo(self.nameMarkLabel.mas_top);
        make.height.mas_equalTo(16);
    }];
    
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameMarkLabel.mas_left);
        make.top.equalTo(self.productNameLabel.mas_bottom).with.mas_offset(19);
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
        make.left.equalTo(self).with.mas_offset(140*kWidthRatio);
        make.bottom.equalTo(self.profitLabel.mas_bottom);
        make.height.mas_equalTo(20);
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
    [self.investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20);
        make.bottom.equalTo(self).with.offset(-25);
        make.height.mas_equalTo(30*kWidthRatio);
        make.width.mas_equalTo(70*kWidthRatio);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameMarkLabel.mas_left);
        make.right.equalTo(self.investButton.mas_right);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    [self.recommendImg setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.markButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.productNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}
-(void)setProductModel:(CRFProductModel *)productModel{
    if (productModel.isNewBie.integerValue != 4) {
        NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Akrobat" size:14*kWidthRatio] range:NSMakeRange(yInterStr.length-1, 1)];
        [self.profitLabel setAttributedText:attString];
    }else{
        NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:yInterStr];
        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Akrobat" size:14*kWidthRatio] range:NSMakeRange(productModel.minYield.length, yInterStr.length-productModel.minYield.length)];
        [self.profitLabel setAttributedText:attString];
    }
    self.productNameLabel.text = productModel.productName;
    if ([productModel.productType isEqualToString:@"2"]) {
        self.nameMarkLabel.backgroundColor = kProductMonthColor;
    }else{
        self.nameMarkLabel.backgroundColor = kProductContinuColor;
    }
//    if (productModel.isNewBie.integerValue == 1) {
//        self.markButton.layer.borderColor  = UIColorFromRGBValue(0xfb4d3a).CGColor;
//        [self.markButton setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateNormal];
//    } else {
//        self.markButton.layer.borderColor  = UIColorFromRGBValue(0xFF6903).CGColor;
//        [self.markButton setTitleColor:UIColorFromRGBValue(0xFF6903) forState:UIControlStateNormal];
//    }
    //是否为月标产品
    self.redImage.hidden = !(productModel.isNewBie.integerValue == 4);
    if ([productModel.lowestAmount formatPercent].length > 4){
        NSString *money = [[[productModel.lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [productModel.lowestAmount formatPercent].length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",money];
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[productModel.lowestAmount formatBeginMoney]];
    }
    NSMutableAttributedString *remainAttributeStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"出借天数%@天",productModel.remainDays]];
    [remainAttributeStr addAttribute:NSFontAttributeName value:CRFFONT(AkrobatZT, 20*kWidthRatio) range:[[NSString stringWithFormat:@"出借天数%@天",productModel.remainDays] rangeOfString:[NSString stringWithFormat:@"%@",productModel.remainDays]]];
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
}
-(void)setDebtModel:(CRFDebtModel *)debtModel{
    _debtModel = debtModel;
    self.productNameLabel.text = _debtModel.rightsNo;
    NSString *amountStr = [NSString stringWithFormat:@"%@元",[_debtModel dealTransAmount]];
    NSString *rateStr = [[_debtModel formatRate] stringByAppendingString:@"%"];
    [self.remainLabel setAttributedText:[CRFStringUtils setAttributedString:amountStr lineSpace:1.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x444444)} range1:[amountStr rangeOfString:@"元"] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.profitLabel setAttributedText:[CRFStringUtils setAttributedString:rateStr lineSpace:1.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range1:[rateStr rangeOfString:@"%"] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    if ([_debtModel.transferStatus integerValue] == 10) {
        _statusImage.image = [UIImage imageNamed:@"invest_debt_zhuanranging"];
    }else{
        _statusImage.image = [UIImage imageNamed:@"invest_debt_zhuanranged"];
    }
}
-(CRFLabel *) createLabelWithFont:(UIFont*)font Title:(NSString*)title titleColor:(UIColor*)color{
    CRFLabel *titleLabel = [[CRFLabel alloc]init];
    titleLabel.text = title;
    titleLabel.textColor = color;
    titleLabel.font = font;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    return titleLabel;
}
-(UIImageView *)redImage{
    if (!_redImage) {
        _redImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red packet"]];
    }
    return _redImage;
}
-(UIImageView *)statusImage{
    if (!_statusImage) {
        _statusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invest_debt_zhuanranging"]];
    }
    return _statusImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
