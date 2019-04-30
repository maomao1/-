//
//  CRFHomeInvestListCell.m
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomeInvestListCell.h"
#import "CRFLabel.h"
#import "CRFStringUtils.h"
#import "CRFColorButton.h"

@interface CRFHomeInvestListCell()

@property (nonatomic ,strong) CRFLabel   * productNameLabel;
@property (nonatomic ,strong) CRFLabel   * profitLabel;
@property (nonatomic ,strong) CRFLabel   * profitMarkLabel;
@property (nonatomic ,strong) CRFLabel   * remainLabel;
@property (nonatomic ,strong) CRFLabel   * lowestAmountLabel;

@property (nonatomic ,strong) UIButton   * recommendImg;
@property (nonatomic ,strong) UIButton   * markButton;
@property  (nonatomic , strong) CRFColorButton  *investButton;

@end

@implementation CRFHomeInvestListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    self.contentView.backgroundColor = UIColorFromRGBValue(0xFAFAFA);
    
    self.productNameLabel  = [self createLabelWithFont:[UIFont systemFontOfSize:16*kWidthRatio] Title:@"" titleColor:UIColorFromRGBValue(0x333333)];
    self.profitLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:24*kWidthRatio] Title:@"0.0%" titleColor:UIColorFromRGBValue(0xFC514D)];
    
    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0x999999)];
    self.remainLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"出借天数" titleColor:UIColorFromRGBValue(0x333333)];
    self.lowestAmountLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"元起投" titleColor:UIColorFromRGBValue(0x999999)];
    
    self.recommendImg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recommendImg.userInteractionEnabled = NO;
    self.recommendImg.layer.masksToBounds = YES;
    self.recommendImg.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.recommendImg setTitle:@"荐" forState:UIControlStateNormal];
    [self.recommendImg setTitleColor:UIColorFromRGBValue(0xF5A623) forState:UIControlStateNormal];
    self.recommendImg.layer.masksToBounds = YES;
    self.recommendImg.layer.borderColor   = UIColorFromRGBValue(0xF5A623).CGColor;
    self.recommendImg.layer.borderWidth   = 0.5f;
    self.recommendImg.layer.cornerRadius  = 2;
    
    self.markButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.markButton.userInteractionEnabled = NO;
    self.markButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.markButton setTitle:@" 限时特供 " forState:UIControlStateNormal];
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
    
    [self addSubview:self.productNameLabel];
    [self addSubview:self.profitLabel];
    [self addSubview:self.profitMarkLabel];
    [self addSubview:self.remainLabel];
    [self addSubview:self.lowestAmountLabel];
    [self addSubview:self.recommendImg];
    [self addSubview:self.markButton];
    [self addSubview:self.investButton];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.mas_offset(10);
        make.top.equalTo(self).with.mas_offset(20);
        make.height.mas_equalTo(16);
    }];
    
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.top.equalTo(self.productNameLabel.mas_bottom).with.mas_offset(18);
        make.height.mas_equalTo(24);
    }];
    
    [self.profitMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
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
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-25);
        make.height.mas_equalTo(30*kWidthRatio);
        make.width.mas_equalTo(70*kWidthRatio);
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

-(void)setProductModel:(CRFProductModel *)productModel{
    
    _productModel = productModel;
    
    NSString *yInterStr = [[productModel rangeOfYInterstRate] stringByAppendingString:@"%"];
    [self.profitLabel setAttributedText:[CRFStringUtils setAttributedString:yInterStr lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont fontWithName:@"Akrobat" size:24*kWidthRatio]} range1:NSMakeRange(0, yInterStr.length-1) attributes2:@{NSFontAttributeName:[UIFont fontWithName:@"Akrobat" size:14*kWidthRatio]} range2:NSMakeRange(yInterStr.length-1, 1) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    
    self.productNameLabel.text = productModel.productName;
    
    //是否为月标产品
    if ([productModel.lowestAmount formatPercent].length > 4){
        NSString *money = [[[productModel.lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [productModel.lowestAmount formatPercent].length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@万元起投",money];
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"%@元起投",[productModel.lowestAmount formatBeginMoney]];
    }
    NSMutableAttributedString *remainAttributeStr =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"出借天数%@天",productModel.remainDays]];
    [remainAttributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Akrobat" size:20*kWidthRatio] range:[[NSString stringWithFormat:@"出借天数%@天",productModel.remainDays] rangeOfString:[NSString stringWithFormat:@"%@",productModel.remainDays]]];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
