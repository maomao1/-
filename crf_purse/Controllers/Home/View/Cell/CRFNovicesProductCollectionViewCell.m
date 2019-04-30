//
//  CRFNovicesProductCollectionViewCell.m
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFNovicesProductCollectionViewCell.h"
#import "CRFLabel.h"
#import "CRFColorButton.h"

@interface CRFNovicesProductCollectionViewCell()

@property  (nonatomic , strong) CRFLabel  *profitLabel;
@property  (nonatomic , strong) CRFLabel  *profitMarkLabel;
@property  (nonatomic , strong) CRFLabel  *separateLine;
@property  (nonatomic , strong) CRFLabel  *lowestAmountLabel;
@property  (nonatomic , strong) CRFLabel  *remainLabel;

@property  (nonatomic , strong) UIImageView *backgroundImageView;
@property  (nonatomic , strong) CRFColorButton  *investButton;
@property  (nonatomic , strong) CRFColorButton  *promptButton;

@end


@implementation CRFNovicesProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.profitLabel       = [self createLabelWithFont:[UIFont fontWithName:@"Akrobat" size:30*kWidthRatio] Title:@"" titleColor:UIColorFromRGBValue(0xFC514D)];
    self.profitLabel.textAlignment = NSTextAlignmentCenter;
    
    self.profitMarkLabel   = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"期望年化收益率" titleColor:UIColorFromRGBValue(0xFC514D)];
    self.profitMarkLabel.textAlignment = NSTextAlignmentCenter;
    
    self.separateLine  = [self createLabelWithFont:[UIFont systemFontOfSize:0] Title:@"" titleColor:kCellLineSeparatorColor];
    self.separateLine.backgroundColor = kCellLineSeparatorColor;
    
    self.lowestAmountLabel = [self createLabelWithFont:[CRFUtils fontWithSize:12.0f * kWidthRatio] Title:@"起投金额 1000元" titleColor:UIColorFromRGBValue(0xAE8E78)];
    
    self.remainLabel       = [self createLabelWithFont:[UIFont systemFontOfSize:12*kWidthRatio] Title:@"出借天数 102天" titleColor:UIColorFromRGBValue(0xAE8E78)];
    
    self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_novices_bg"]];
    
    self.investButton   = [CRFColorButton buttonWithType:UIButtonTypeCustom];
    self.investButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.investButton.cornerRadius  = 20*kWidthRatio;
    [self.investButton setTitle:@"立即加入" forState:UIControlStateNormal];
    self.investButton.layer.shadowColor = UIColorFromRGBValueAndalpha(0xFF3F00, 0.2).CGColor;
    self.investButton.layer.shadowOffset = CGSizeMake(0, 5);
    self.investButton.layer.shadowRadius = 5;
    self.investButton.layer.shadowOpacity = 1;
    [self.investButton setGradientColor:[CRFGradientColor gradientColorWithColors:@[UIColorFromRGBValue(0xFA696F),UIColorFromRGBValue(0xFE4A48)]] forState:UIControlStateDisabled];
    self.investButton.enabled = NO;

    self.promptButton   = [CRFColorButton buttonWithType:UIButtonTypeCustom];
    self.promptButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.promptButton.cornerRadius  = 10;
    self.promptButton.corner = UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight;
    [self.promptButton setTitle:@"" forState:UIControlStateNormal];
    [self.promptButton setGradientColor:[CRFGradientColor gradientColorWithColors:@[UIColorFromRGBValue(0xFFF7C664),UIColorFromRGBValue(0xFFFFAE29)]] forState:UIControlStateNormal];
    self.promptButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.separateLine];
    [self addSubview:self.profitLabel];
    [self addSubview:self.profitMarkLabel];
    [self addSubview:self.lowestAmountLabel];
    [self addSubview:self.remainLabel];
    [self addSubview:self.investButton];
    [self addSubview:self.promptButton];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.mas_offset(3);
        make.size.mas_equalTo(CGSizeMake(1, 12));
    }];
    
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30*kWidthRatio);
        make.top.equalTo(self).with.mas_offset(28*kWidthRatio);
    }];
    
    [self.promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profitLabel.mas_right).with.mas_offset(10);
        make.top.equalTo(self.profitLabel.mas_top).with.mas_offset(-2);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(74);//限制长度
        make.right.lessThanOrEqualTo(self).with.mas_offset(-10);
    }];
    
    [self.profitMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(12);
        make.top.equalTo(self.profitLabel.mas_bottom).mas_offset(12*kWidthRatio);
    }];
    
    [self.lowestAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.separateLine.mas_left).mas_offset(-5);
        make.centerY.equalTo(self.separateLine);
        make.height.mas_equalTo(12);
    }];
    
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separateLine.mas_left).mas_offset(5);
        make.centerY.equalTo(self.separateLine);
        make.height.mas_equalTo(12);
    }];
    
    [self.investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-30*kWidthRatio);
        make.height.mas_equalTo(40*kWidthRatio);
        make.width.mas_equalTo(230*kWidthRatio);
    }];
    
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
    [self.profitLabel setAttributedText:[CRFStringUtils setAttributedString:yInterStr lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont fontWithName:@"Akrobat" size:30*kWidthRatio]} range1:NSMakeRange(0, yInterStr.length-1) attributes2:@{NSFontAttributeName:[UIFont fontWithName:@"Akrobat" size:18*kWidthRatio]} range2:NSMakeRange(yInterStr.length-1, 1) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    
    if ([productModel.lowestAmount formatPercent].length > 4){
        NSString *money = [[[productModel.lowestAmount formatPercent] substringWithRange:NSMakeRange(0, [productModel.lowestAmount formatPercent].length - 4)] formatBeginMoney];
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"起投金额 %@万元",money];
    }else{
        self.lowestAmountLabel.text = [NSString stringWithFormat:@"起投金额 %@元",[productModel.lowestAmount formatBeginMoney]];
    }
    self.remainLabel.text = [NSString stringWithFormat:@"出借天数 %@天",productModel.remainDays];
   
    if (productModel.tipsStart.length) {
        self.promptButton.hidden = NO;
        [self.promptButton setTitle:[NSString stringWithFormat:@"  %@  ",productModel.tipsStart] forState:UIControlStateNormal];
    }else{
        self.promptButton.hidden = YES;
    }
    self.promptButton.cornerRadius  = 10;
    
    CGSize lowestAmountSize = [self.lowestAmountLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) fontNumber:self.lowestAmountLabel.font.pointSize];
    CGSize remainSize = [self.remainLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) fontNumber:self.remainLabel.font.pointSize];
    
    [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.mas_offset((lowestAmountSize.width - remainSize.width)/2);
//        make.centerY.equalTo(self).with.mas_offset(3);
//        make.size.mas_equalTo(CGSizeMake(1, 12));
    }];
    
}


@end
