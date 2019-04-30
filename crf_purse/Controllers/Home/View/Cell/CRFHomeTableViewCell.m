//
//  CRFHomeTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeTableViewCell.h"
#import "CRFCountDownLabel.h"
#import "CRFStringUtils.h"

static CGFloat const kTitleLabelWidth = 100;

@interface CRFHomeTableViewCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *subLine;
@property (nonatomic, strong) UILabel *separateLine;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSubContentLabel;
@property (nonatomic, strong) CRFProductModel *product;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *subTapGesture;
@property (nonatomic, strong) CRFCountDownLabel *downLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UITapGestureRecognizer *leftTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *leftSubTapGesture;

@property (nonatomic, strong) UILabel *subTagLabel;

@property (nonatomic, strong) CRFCountDownLabel *subDownLabel;

@end

@implementation CRFHomeTableViewCell

- (UITapGestureRecognizer *)subTapGesture {
    if (!_subTapGesture) {
        _subTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subTap:)];
        _subTapGesture.delegate = self;
        _subTapGesture.cancelsTouchesInView = NO;
    }
    return _subTapGesture;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tapGesture.delegate = self;
        _tapGesture.cancelsTouchesInView = NO;
    }
    return _tapGesture;
}

- (UITapGestureRecognizer *)leftTapGesture {
    if (!_leftTapGesture) {
        _leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _leftTapGesture.delegate = self;
        _leftTapGesture.cancelsTouchesInView = NO;
    }
    return _leftTapGesture;
}

- (UITapGestureRecognizer *)leftSubTapGesture {
    if (!_leftSubTapGesture) {
        _leftSubTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subTap:)];
        _leftSubTapGesture.delegate = self;
        _leftSubTapGesture.cancelsTouchesInView = NO;
    }
    return _leftSubTapGesture;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.line];
    [self addSubview:self.subLine];
    [self addSubview:self.separateLine];
    [self addSubview:self.downLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.subDownLabel];
    [self addSubview:self.subTagLabel];
    [self layoutTaglabel];
    self.leftSubTitleLabel.hidden = YES;
    self.rightSubContentLabel.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.leftLabel addGestureRecognizer:self.leftTapGesture];
    [self.rightLabel addGestureRecognizer:self.tapGesture];
    [self.leftSubTitleLabel addGestureRecognizer:self.leftSubTapGesture];
    [self.rightSubContentLabel addGestureRecognizer:self.subTapGesture];
}

- (void)layoutTaglabel {
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 16));
        make.top.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.mas_offset(- (kScreenWidth - kTitleLabelWidth * kWidthRatio + 10));
    }];
    [self.subTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.tagLabel);
        make.right.equalTo(self.tagLabel);
        make.top.equalTo(self).with.offset(95);
    }];
}

- (CRFCountDownLabel *)downLabel {
    if (!_downLabel) {
        _downLabel = [[CRFCountDownLabel alloc] init];
    }
    return _downLabel;
}

- (CRFCountDownLabel *)subDownLabel {
    if (!_subDownLabel) {
        _subDownLabel = [[CRFCountDownLabel alloc] init];
    }
    return _subDownLabel;
}

- (UILabel *)subTagLabel {
    if (!_subTagLabel) {
        _subTagLabel = [UILabel new];
        _subTagLabel.hidden = YES;
        _subTagLabel.layer.masksToBounds = YES;
        _subTagLabel.layer.cornerRadius = 8.0f;
        _subTagLabel.textAlignment = NSTextAlignmentCenter;
        _subTagLabel.font = [UIFont systemFontOfSize:9.0f];
        _subTagLabel.textColor = UIColorFromRGBValue(0xFA844A);
        _subTagLabel.layer.borderWidth = 0.5f;
        _subTagLabel.layer.borderColor = UIColorFromRGBValue(0xFA844A).CGColor;
        
    }
    return _subTagLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel new];
        _tagLabel.hidden = YES;
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = 8.0f;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont systemFontOfSize:9.0f];
        _tagLabel.textColor = UIColorFromRGBValue(0xFA844A);
        _tagLabel.layer.borderWidth = 0.5f;
        _tagLabel.layer.borderColor = UIColorFromRGBValue(0xFA844A).CGColor;
    }
    return _tagLabel;
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = UIColorFromRGBValue(0xFCE0D0);
    }
    return _line;
}

- (UILabel *)separateLine {
    if (!_separateLine) {
        _separateLine = [UILabel new];
        _separateLine.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.1];
    }
    return _separateLine;
}

- (UILabel *)subLine {
    if (!_subLine) {
        _subLine = [UILabel new];
        _subLine.backgroundColor = UIColorFromRGBValue(0xFCE0D0);
    }
    return _subLine;
}

- (void)setProductType:(ProductType)productType {
    _productType = productType;
    if (_productType == Old_Product) {
        self.separateLine.hidden = YES;
        self.line.hidden = YES;
        self.subLine.hidden = YES;
        [self.oldUserTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset([self showTipLabelWithText:self.tipText]?6:0);
            make.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(kSpace);
            make.width.mas_equalTo(kTitleLabelWidth * kWidthRatio);
        }];
        [self.oldUserContentlabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset([self showTipLabelWithText:self.tipText]?6:0);
            make.bottom.right.equalTo(self);
            make.left.equalTo(self.oldUserTitleLabel.mas_right).with.offset(kSpace);
        }];
    } else {
        self.line.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(kSpace);
            make.top.equalTo(self).with.offset(10);
            make.height.mas_equalTo(20);
            make.right.equalTo(self);
        }];
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right);
            make.top.equalTo(self).with.offset(60);
            make.height.mas_equalTo(38);
            make.width.mas_equalTo(1);
        }];
        if (self.variableStyle == Simple) {
            self.subLine.hidden = YES;
            self.separateLine.hidden = NO;
            [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(kSpace);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.bottom.equalTo(self);
                make.width.mas_equalTo(kTitleLabelWidth * kWidthRatio);
            }];
            [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.left.equalTo(self.leftLabel.mas_right).with.offset(kSpace);
                make.right.equalTo(self);
                make.bottom.equalTo(self.leftLabel.mas_bottom);
            }];
        } else {
            self.leftLabel.userInteractionEnabled = YES;
            self.leftSubTitleLabel.userInteractionEnabled = YES;
            self.rightLabel.userInteractionEnabled = YES;
            self.rightSubContentLabel.userInteractionEnabled = YES;
            self.subLine.hidden = NO;
            self.separateLine.hidden = NO;
            [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(kSpace);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.height.mas_equalTo(90);
                make.width.mas_equalTo(kTitleLabelWidth * kWidthRatio);
            }];
            [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.left.equalTo(self.leftLabel.mas_right).with.offset(kSpace);
                make.right.equalTo(self);
                make.bottom.equalTo(self.leftLabel.mas_bottom);
            }];
            
            [self.leftSubTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(kSpace);
                make.bottom.equalTo(self);
                make.width.mas_equalTo(kTitleLabelWidth * kWidthRatio);
                make.height.mas_equalTo(90);
            }];
            [self.subLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftSubTitleLabel.mas_right);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self).with.offset(-22);
                make.height.mas_equalTo(38);
            }];
            [self.rightSubContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self);
                make.bottom.equalTo(self);
                make.left.equalTo(self.leftSubTitleLabel.mas_right).with.offset(kSpace);
                make.height.mas_equalTo(90);
            }];
            [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(kSpace);
                make.bottom.equalTo(self).with.offset(-85);
                make.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
        }
    }
    [self setNeedsDisplay];
}

- (void)setSupportGesture:(BOOL)supportGesture {
    _supportGesture = supportGesture;
    self.leftLabel.userInteractionEnabled = _supportGesture;
    self.leftSubTitleLabel.userInteractionEnabled = _supportGesture;
    self.rightSubContentLabel.userInteractionEnabled = _supportGesture;
    self.rightLabel.userInteractionEnabled = _supportGesture;
}

/**
 设置tag 标签字体颜色 1:幸福联营。2:幸福月盈。3:现金贷共赢
 
 @param flag flag
 */
- (void)setTagLabelBorder:(int)flag showSubTag:(BOOL)show {
    UIColor *textColor = nil;
    switch (flag) {
        case 1: {
            textColor = UIColorFromRGBValue(0xFA844A);
        }
            break;
            
        case 2: {
            textColor = UIColorFromRGBValue(0xA88AE5);
        }
            break;
        case 3: {
            textColor = UIColorFromRGBValue(0xFFA700);
        }
            break;
        case 4: {
            textColor = UIColorFromRGBValue(0x999999);
        }
            break;
        default:
            break;
    }
    self.tagLabel.layer.borderColor = textColor.CGColor;
    self.tagLabel.textColor = textColor;
    if (show) {
        self.subTagLabel.layer.borderColor = textColor.CGColor;
        self.subTagLabel.textColor = textColor;
    }
}

- (void)setTips {
    if (self.productType == Old_Product) {
        self.tagLabel.hidden = NO;
        [self setTipContentWithProduct:self.product subProduct:nil];
        self.subTagLabel.hidden = YES;
    } else {
        if (self.products.count > 1) {
            [self setTipContentWithProduct:[self.products firstObject] subProduct:[self.products objectAtIndex:1]];
        } else {
            [self setTipContentWithProduct:self.product subProduct:nil];
            self.subTagLabel.hidden = YES;
        }
    }
}

- (void)setTipContentWithTag:(UILabel *)tagLabel product:(CRFProductModel *)product isFirst:(BOOL)value {
    if (product.tipsStart && product.tipsStart.length > 0) {
        tagLabel.hidden = NO;
        NSString *tips = product.tipsStart;
        if ([product.isFull integerValue] == 1) {
            tips = @"满标";
        }
        CGFloat width = [tips boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) fontNumber:12].width;
        tagLabel.text = tips;
        [tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (!value) {
                make.top.equalTo(self).with.offset(125);
            } else {
                if (self.productType == Old_Product) {
                    make.top.equalTo(self).with.offset(5);
                } else {
                    make.top.equalTo(self).with.offset(35);
                }
            }
            make.size.mas_equalTo(CGSizeMake(width > 48? width:48, 16));
        }];
        if ([product.isFull intValue] == 1) {
            [self setTagLabelBorder:4 showSubTag:!value];
        } else {
            [self setTagLabelBorder:[product.productType intValue] showSubTag:!value];
        }
    } else {
        if ([product.isFull integerValue] == 1) {
            tagLabel.hidden = NO;
            NSString *tips = @"满标";
            tagLabel.text = tips;
            [self setTagLabelBorder:4 showSubTag:value];
        } else {
            tagLabel.hidden = YES;
        }
    }
    
}

- (void)setTipContentWithProduct:(CRFProductModel *)product subProduct:(CRFProductModel *)subProduct {
    if (subProduct) {
        [self setTipContentWithTag:self.subTagLabel product:subProduct isFirst:NO];
    }
    [self setTipContentWithTag:self.tagLabel product:product isFirst:YES];
}

- (void)setDownLabelContentWithLabel:(CRFCountDownLabel *)label product:(CRFProductModel *)product isLast:(BOOL)value {
    label.hidden = NO;
    CGFloat width = [product.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) fontNumber:16 * kWidthRatio].width;
    if (kScreenWidth == 414) {
        width = width + 20;
    }
    if (kScreenWidth == 375) {
        width = width + 10;
    }
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        CGFloat margen = 12.0f;
        if ((product.tipsStart && ![product.tipsStart isEmpty]) || [product.isFull integerValue] == 1) {
            margen = 18.0;
            if (kScreenWidth == 320) {
                margen = 15.0;
            }
            if (kScreenWidth == 414) {
                margen = 20;
            }
        } else {
            if (kScreenWidth == 414) {
                margen = 13;
            }
        }
        if (self.productType == Old_Product) {
            make.left.equalTo(self.oldUserTitleLabel.mas_right).with.offset(width + kSpace);
            if (![product.tipsStart isEmpty] || [product.isFull integerValue] == 1) {
                if (kScreenWidth == 320) {
                    make.top.equalTo(self).with.offset(margen + 2 + 16 * (1-kWidthRatio));
                } else {
                    make.top.equalTo(self).with.offset(margen + 16 * (1-kWidthRatio));
                }
                
            } else {
                make.top.equalTo(self).with.offset(margen + 16 * (1-kWidthRatio));
            }
        } else {
            if (self.products.count > 1 && value) {
                make.left.equalTo(self.leftLabel.mas_right).with.offset(width + kSpace);
                if (![product.tipsStart isEmpty] || [product.isFull integerValue] == 1) {
                    if (kScreenWidth == 414) {
                        make.top.equalTo(self).with.offset(margen + 122 + 16 * (1-kWidthRatio));
                    } else {
                        make.top.equalTo(self).with.offset(margen + 124 + 16 * (1-kWidthRatio));
                    }
                } else {
                    make.top.equalTo(self).with.offset(margen + 115 + 16 * (1-kWidthRatio));
                }
            } else {
                make.left.equalTo(self.leftSubTitleLabel.mas_right).with.offset(width + kSpace);
                if (![product.tipsStart isEmpty] || [product.isFull integerValue] == 1) {
                    if (kScreenWidth == 320) {
                        make.top.equalTo(self).with.offset(margen + 38 * kWidthRatio + 16 * (1-kWidthRatio));
                    } else {
                        make.top.equalTo(self).with.offset(margen + 30 + 16 * (1-kWidthRatio));
                    }
                } else {
                    make.top.equalTo(self).with.offset(margen + 25 + 16 * (1-kWidthRatio));
                }
            }
        }
        make.right.equalTo(self);
    }];
    if ([product.saleTime longLongValue] - [CRFAppManager defaultManager].nowTime > 0) {
        label.beginTime = [CRFAppManager defaultManager].nowTime;
        label.countDownTimer = [product.saleTime longLongValue];
        [label startTimer];
    } else {
        label.hidden = YES;
    }
}

- (void)setDownlabelStatusWithProduct:(CRFProductModel *)product subProduct:(CRFProductModel *)subProduct {
    if (subProduct) {
        [self setDownLabelContentWithLabel:self.subDownLabel product:subProduct isLast:YES];
    }
    [self setDownLabelContentWithLabel:self.downLabel product:product isLast:NO];
}

- (void)setProducts:(NSArray<CRFProductModel *> *)products {
    _products = products;
    if (self.productType == Old_Product) {
        self.product = [_products firstObject];
        [self setDownlabelStatusWithProduct:_product subProduct:nil];
        [self setTips];
        self.oldUserTitleLabel.text = _product.others;
        self.oldUserContentlabel.text = [NSString stringWithFormat:@"%@\n%@",_product.name, _product.content];
        if ([self.product.isFull intValue] == 1) {
            [self.oldUserTitleLabel setAttributedText:[self setTitleFullMutableString:self.oldUserTitleLabel.text]];
            [self setFullContentMutableString];
        } else {
            [self.oldUserTitleLabel setAttributedText:[self setTitleMutableString:self.oldUserTitleLabel.text]];
            [self setContentMutableString];
        }
        
    } else {
        //        self.tagLabel.hidden = YES;
        [self setTips];
        self.titleLabel.text = NSLocalizedString(@"cell_new_user_enjoy_product", nil);
        if (self.variableStyle == Simple) {
            self.product = [_products firstObject];
            [self setDownlabelStatusWithProduct:_product subProduct:nil];
            self.leftLabel.text = _product.others;
            self.rightLabel.text = [NSString stringWithFormat:@"%@\n%@",_product.name, _product.content];
            [self.leftLabel setAttributedText:[self setTitleMutableString:self.leftLabel.text]];
            [self.rightLabel setAttributedText:[self setDefaultContentMutableString:self.rightLabel.text subString:_product.content product:_product]];
        } else {
            CRFProductModel *firstP = [_products firstObject];
            CRFProductModel *lastP = [_products objectAtIndex:1];
            [self setDownlabelStatusWithProduct:firstP subProduct:lastP];
            if (![lastP.tipsStart isEmpty] || [lastP.isFull integerValue] == 1) {
                [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self).with.offset(-95);
                }];
            } else {
                [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self).with.offset(-85);
                }];
            }
            if (![firstP.tipsStart isEmpty] || [firstP.isFull integerValue] == 1) {
                [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                }];
                [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
                }];
                if (![lastP.tipsStart isEmpty] || [lastP.isFull integerValue] == 1) {
                    [self.subLine mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                    }];
                }
            }
            self.leftLabel.text = firstP.others;
            self.rightLabel.text = [NSString stringWithFormat:@"%@\n%@",firstP.name, firstP.content];
            [self.leftLabel setAttributedText:[self setTitleMutableString:self.leftLabel.text]];
            [self.rightLabel setAttributedText:[self setDefaultContentMutableString:self.rightLabel.text subString:firstP.content product:firstP]];
            self.leftSubTitleLabel.text = lastP.others;
            self.rightSubContentLabel.text = [NSString stringWithFormat:@"%@\n%@",lastP.name, lastP.content];
            [self.leftSubTitleLabel setAttributedText:[self setTitleMutableString:self.leftSubTitleLabel.text]];
            [self.rightSubContentLabel setAttributedText:[self setDefaultContentMutableString:self.rightSubContentLabel.text subString:lastP.content product:lastP]];
        }
    }
}

- (NSMutableAttributedString *)setTitleFullMutableString:(NSString *)total {
    NSArray <NSString *>*a = [total componentsSeparatedByString:@"%"];
    NSString *totalString = [NSString stringWithFormat:@"%@ %%\n%@",[a firstObject],[a lastObject]];
    return [CRFStringUtils setAttributedString:totalString lineSpace:5.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:26.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, [a firstObject].length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange([a firstObject].length + 1, 1) attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range3:NSMakeRange(totalString.length - [a lastObject].length, [a lastObject].length) attributes4:nil range4:NSMakeRange(0, 0)];
}

- (NSMutableAttributedString *)setTitleMutableString:(NSString *)total {
    NSArray <NSString *>*a = [total componentsSeparatedByString:@"%"];
    NSString *totalString = [NSString stringWithFormat:@"%@ %%\n%@",[a firstObject],[a lastObject]];
    return [CRFStringUtils setAttributedString:totalString lineSpace:5.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:26.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:NSMakeRange(0, [a firstObject].length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range2:NSMakeRange([a firstObject].length + 1, 1) attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range3:NSMakeRange(totalString.length - [a lastObject].length, [a lastObject].length) attributes4:nil range4:NSMakeRange(0, 0)];
}

- (NSMutableAttributedString *)setDefaultContentMutableString:(NSString *)total subString:(NSString *)subString product:(CRFProductModel *)product {
    NSMutableAttributedString *mutableS = [self setDefaultContentMutableString:total subString:subString];
    [mutableS addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xFB4D3A) range:[total rangeOfString:product.lowestAmount]];
    [mutableS addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xFB4D3A) range:[total rangeOfString:product.freezePeriod]];
    [mutableS addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xFB4D3A) range:[total rangeOfString:product.alreadyInvestPercent]];
    return mutableS;
}

- (NSMutableAttributedString *)setDefaultContentMutableString:(NSString *)total subString:(NSString *)subString {
    return [CRFStringUtils setAttributedString:total lineSpace:15.0f attributes1:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:NSMakeRange(0, total.length - subString.length) attributes2:@{NSFontAttributeName:[CRFUtils fontWithSize:12.0 * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(total.length - subString.length, subString.length) attributes3:nil range3:NSMakeRange(0, 0) attributes4:nil range4:NSMakeRange(0, 0)];
}

- (void)setFullContentMutableString {
    [self.oldUserContentlabel setAttributedText:[CRFStringUtils setAttributedString:self.oldUserContentlabel.text lineSpace:15.0f attributes1:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, self.product.name.length) attributes2:@{NSFontAttributeName:[CRFUtils fontWithSize:12.0 * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(self.oldUserContentlabel.text.length - self.product.content.length, self.product.content.length) attributes3:nil range3:NSMakeRange(0, 0) attributes4:nil range4:NSMakeRange(0, 0)]];
}

- (void)setContentMutableString {
    [self.oldUserContentlabel setAttributedText:[CRFStringUtils setAttributedString:self.oldUserContentlabel.text lineSpace:15.0f attributes1:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:NSMakeRange(0, self.product.name.length) attributes2:@{NSFontAttributeName:[CRFUtils fontWithSize:12.0 * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(self.oldUserContentlabel.text.length - self.product.content.length, self.product.content.length) attributes3:nil range3:NSMakeRange(0, 0) attributes4:nil range4:NSMakeRange(0, 0)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)drawRect:(CGRect)rect {
    if (self.productType == New_Product) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 238.0 / 255.0, 238.0 / 255.0, 238.0 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kTitleLabelWidth * kWidthRatio + kSpace,[self showTipLabelWithText:self.product.tipsStart]?28: 22);  //起点坐标
    CGContextAddLineToPoint(context, kTitleLabelWidth * kWidthRatio + kSpace, ([self showTipLabelWithText:self.product.tipsStart]? 89: 83) - 23);   //终点坐标
    CGContextStrokePath(context);
}

- (BOOL)showTipLabelWithText:(NSString *)text {
    return (text && ![text isEmpty]);
}

- (void)setVariableStyle:(Product_Variable)variableStyle {
    _variableStyle = variableStyle;
    if (_variableStyle == Simple) {
        self.leftSubTitleLabel.hidden = YES;
        self.rightSubContentLabel.hidden = YES;
    } else {
        self.leftSubTitleLabel.hidden = NO;
        self.rightSubContentLabel.hidden = NO;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.clickHandler) {
        self.clickHandler(0);
    }
}

- (void)subTap:(UITapGestureRecognizer *)tap {
    if (self.clickHandler) {
        self.clickHandler(1);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGesture || gestureRecognizer == self.subTapGesture || gestureRecognizer == self.leftTapGesture || gestureRecognizer == self.leftSubTapGesture) {
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)dealloc {
    DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

@end
