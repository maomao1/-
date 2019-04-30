//
//  WMInvestProductCell.m
//  crf_purse
//
//  Created by maomao on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJProductTableViewCell.h"

@interface WMMJProductTableViewCell()
@property (nonatomic, strong) UILabel     *leftLabel;
@property (nonatomic, strong) UILabel     *rightLabel;
@property (nonatomic, strong) UILabel     *productTagLabel;
@property (nonatomic, strong) CRFCountDownLabel *downLabel;

//@property (nonatomic, strong) WMProductModel *productModel;

@end
@implementation WMMJProductTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setUI{
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.downLabel];
    [self addSubview:self.productTagLabel];
    self.leftLabel.numberOfLines = 0;
    self.rightLabel.numberOfLines =0;
    
    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth -( kTitleLabelWidth * kWidthRatio) - kSpace * 3);
    }];
    [self.productTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(48, 16));
        make.right.equalTo(self.leftLabel.mas_right).with.mas_offset(-20);
    }];
    [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(0);
        make.left.equalTo(self.rightLabel.mas_right).with.offset(kSpace);
        make.height.equalTo(self.rightLabel.mas_height);
    }];
}

- (void)setTips {
    if (_product.tipsStart && ![_product.tipsStart isEmpty]) {
        self.productTagLabel.hidden = NO;
        NSString *tips = self.product.tipsStart;
        if ([self.product.isFull integerValue] == 1) {
            tips = @"满标";
        }
        CGFloat width = [tips boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) fontNumber:12].width;
        self.productTagLabel.text = tips;
        [self.productTagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width > 48? width:48, 16));
        }];
        if ([self.product.isFull intValue] == 1) {
            [self setTagLabelBorder:4];
        } else {
            [self setTagLabelBorder:[_product.productType intValue]];
        }
    } else {
        if ([self.product.isFull integerValue] == 1) {
            self.productTagLabel.hidden = NO;
            NSString *tips = @"满标";
            self.productTagLabel.text = tips;
            [self setTagLabelBorder:4];
            [self.productTagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(48, 16));
            }];
        } else {
            self.productTagLabel.hidden = YES;
        }
    }
}


- (void)setProduct:(CRFProductModel *)product {
    _product = product;
    [self setTips];
    self.leftLabel.text = _product.others;
    self.rightLabel.text = [NSString stringWithFormat:@"%@\n%@",_product.name, _product.content];
    if ([self.product.isFull intValue] == 1) {
        [self.leftLabel setAttributedText:[self setTitleFullMutableString:self.leftLabel.text]];
        [self setFullContentMutableString];
    } else {
        [self.leftLabel setAttributedText:[self setTitleMutableString:self.leftLabel.text]];
        [self setContentMutableString];
    }
    CGFloat width = [self.product.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) fontNumber:16 * kWidthRatio].width;
    [self.downLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat margen = 13.0f;
        make.left.equalTo(self.leftLabel.mas_right).with.offset(width + kSpace);
        make.height.mas_equalTo(30);
        if (_product.tipsStart && ![_product.tipsStart isEmpty]) {
            margen = 16.0;
            if (kScreenWidth == 320) {
                margen = 15.0;
            }
        }
        if (kScreenWidth <= 320) {
            //            margen = margen + 1;
        }
        make.top.equalTo(self).with.offset(margen + 16 * (1-kWidthRatio));
        make.right.equalTo(self);
    }];
    if ([self.product.saleTime longLongValue] - [CRFAppManager defaultManager].nowTime > 0) {
        self.downLabel.beginTime = [CRFAppManager defaultManager].nowTime;
        self.downLabel.countDownTimer = [self.product.saleTime longLongValue];
        [self.downLabel startTimer];
    } else {
        self.downLabel.hidden = YES;
    }
}
- (NSMutableAttributedString *)setTitleFullMutableString:(NSString *)total {
    NSArray <NSString *>*a = [total componentsSeparatedByString:@"%"];
    NSString *totalString = [NSString stringWithFormat:@"%@ %%\n%@",[a firstObject],[a lastObject]];
    return [self setAttributedString:totalString lineSpace:5.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:26.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, [a firstObject].length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange([a firstObject].length + 1, 1) attributes3:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f * kWidthRatio],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range3:NSMakeRange(totalString.length - [a lastObject].length, [a lastObject].length) attributes4:nil range4:NSMakeRange(0, 0)];
}

- (NSMutableAttributedString *)setTitleMutableString:(NSString *)total {
    NSArray <NSString *>*a = [total componentsSeparatedByString:@"%"];
    NSString *totalString = [NSString stringWithFormat:@"%@ %%\n%@",[a firstObject],[a lastObject]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.0f];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.0f * kWidthRatio] range:NSMakeRange(0, [a firstObject].length)];
    [attString addAttribute:NSForegroundColorAttributeName value:kRegisterButtonBackgroundColor range:NSMakeRange(0, [a firstObject].length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f * kWidthRatio] range:NSMakeRange([a firstObject].length + 1, 1)];
    [attString addAttribute:NSForegroundColorAttributeName value:kRegisterButtonBackgroundColor range:NSMakeRange([a firstObject].length + 1, 1)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f * kWidthRatio] range:NSMakeRange(totalString.length - [a lastObject].length, [a lastObject].length)];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x999999) range:NSMakeRange(totalString.length - [a lastObject].length, [a lastObject].length)];
    
    //    [self.oldUserTitleLabel setAttributedText:attString];
    return attString;
}
- (void)setFullContentMutableString {
    [self.rightLabel setAttributedText:[self setAttributedString:self.rightLabel.text lineSpace:15.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, self.product.name.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f * kWidthRatio], NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(self.rightLabel.text.length - self.product.content.length, self.product.content.length) attributes3:nil range3:NSMakeRange(0, 0) attributes4:nil range4:NSMakeRange(0, 0)]];
}
- (void)setContentMutableString {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.rightLabel.text];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:15.0f * kWidthRatio];
    [attString addAttribute:NSParagraphStyleAttributeName
                      value:paragraphStyle
                      range:NSMakeRange(0, self.rightLabel.text.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f * kWidthRatio] range:NSMakeRange(0, self.product.name.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x333333) range:NSMakeRange(0, self.product.name.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f * kWidthRatio] range:NSMakeRange(self.rightLabel.text.length - self.product.content.length, self.product.content.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x999999) range:NSMakeRange(self.rightLabel.text.length - self.product.content.length, self.product.content.length)];
    //    CGFloat alreadyCount =[self.product.finishAmount getOriginString].floatValue/self.product.planAmount.floatValue*100;
    if ( [self.product.alreadyInvestPercent floatValue]>79) {
        [attString addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBValue(0xFB4D3A)} range:[self.rightLabel.text rangeOfString:[self.product.alreadyInvestPercent formatPercent] options:NSBackwardsSearch]];
    }
    //本需求 只有 2个 “|”，所以本地是写死的，如需求变化 ，需要改动
    [attString addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBValue(0xDDDDDD)} range:[self.rightLabel.text rangeOfString:@"|" options:NSBackwardsSearch]];
    [attString addAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBValue(0xDDDDDD)} range:[self.rightLabel.text rangeOfString:@"|"]];
    [self.rightLabel setAttributedText:attString];
}
- (NSMutableAttributedString *)setAttributedString:(NSString *)totalString lineSpace:(CGFloat)lineSpace attributes1:(NSDictionary <NSString *, id>*)attributes1 range1:(NSRange)range1 attributes2:(NSDictionary <NSString *, id>*)attributes2 range2:(NSRange)range2 attributes3:(NSDictionary <NSString *, id>*)attributes3 range3:(NSRange)range3 attributes4:(NSDictionary <NSString *, id>*)attributes4 range4:(NSRange)range4{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attString addAttribute:NSParagraphStyleAttributeName
                      value:paragraphStyle
                      range:NSMakeRange(0, totalString.length)];
    [attString addAttributes:attributes1 range:range1];
    if (attributes2) {
        [attString addAttributes:attributes2 range:range2];
    }
    if (attributes3) {
        [attString addAttributes:attributes3 range:range3];
    }
    if (attributes4) {
        [attString addAttributes:attributes4 range:range4];
    }
    return attString;
}

/**
 设置tag 标签字体颜色 1:幸福联营。2:幸福月盈。3:现金贷共赢
 
 @param flag flag
 */
- (void)setTagLabelBorder:(int)flag {
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
                textColor = kRegisterButtonBackgroundColor;
            }
            break;
            case 4: {
                textColor = UIColorFromRGBValue(0x999999);
            }
            break;
        default:
            break;
    }
    self.productTagLabel.layer.borderColor = textColor.CGColor;
    self.productTagLabel.textColor = textColor;
}

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
    }
    return _rightLabel;
}
-(UILabel *)productTagLabel{
    if (!_productTagLabel) {
        _productTagLabel = [UILabel new];
        _productTagLabel.font = [UIFont systemFontOfSize:9.0f];
        _productTagLabel.layer.masksToBounds = YES;
        _productTagLabel.layer.cornerRadius  = 16*kHeightRatio/2;
        _productTagLabel.layer.borderWidth   = 0.5f;
        _productTagLabel.textAlignment = NSTextAlignmentCenter;
        _productTagLabel.textColor = UIColorFromRGBValue(0xFA844A);
        _productTagLabel.layer.borderColor = UIColorFromRGBValue(0xFA844A).CGColor;
    }
    return _productTagLabel;
}
- (CRFCountDownLabel *)downLabel {
    if (!_downLabel) {
        _downLabel = [[CRFCountDownLabel alloc] init];
    }
    return _downLabel;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.1);  //线的颜色
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, (kScreenWidth - kSpace * 2 - kTitleLabelWidth * kWidthRatio ), CGRectGetMinY(self.rightLabel.frame)+4);  //起点坐标
    CGContextAddLineToPoint(context, (kScreenWidth - kSpace * 2 - kTitleLabelWidth * kWidthRatio ), CGRectGetMaxY(self.rightLabel.frame)-2);   //终点坐标
    CGContextStrokePath(context);
}
@end

