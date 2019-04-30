//
//  CRFMineInvestTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMineInvestTableViewCell.h"
#import "CRFStringUtils.h"
#import "YYAnimatedImageView.h"
#import "CRFLabel.h"

static CGFloat const kRightLabelWidth = 90;

@interface CRFMineInvestTableViewCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) CRFLabel *titleLabel;
@property (nonatomic, strong) CRFLabel *dateLabel;
@property (nonatomic, strong) UILabel *middleLine;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) YYLabel *rightLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *productMarkLabel;
//@property (nonatomic, strong) UILabel *closeDateLabel;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIImageView *applyLogoutImageView;


@end

@implementation CRFMineInvestTableViewCell

- (UIImageView *)applyLogoutImageView {
    if (!_applyLogoutImageView) {
        _applyLogoutImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag_quit"]];
    }
    return _applyLogoutImageView;
}
- (UIFont *)titleFont {
    if (kScreenWidth == 320) {
        return [UIFont boldSystemFontOfSize:13.0];
    }
    return [UIFont boldSystemFontOfSize:15.0];;
}

- (UIFont *)textFont {
    return CRFFONT(AkrobatZT, 18* kWidthRatio);
//    return [CRFUtils fontWithSize:16* kWidthRatio];
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [CRFLabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.verticalAlignment = VerticalAlignmentBottom;
        if (kScreenWidth == 320) {
            _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [CRFLabel new];
        _dateLabel.verticalAlignment = VerticalAlignmentBottom;
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = UIColorFromRGBValue(0x666666);
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.numberOfLines = 2;
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [_leftLabel sizeToFit];
    }
    return _leftLabel;
}

- (YYLabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [YYLabel new];
        _rightLabel.numberOfLines = 2;
        _rightLabel.textAlignment = NSTextAlignmentRight;
//        _rightLabel.userInteractionEnabled = YES;
        weakSelf(self);
        [_rightLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            strongSelf(weakSelf);
            if (CGRectGetWidth(rect) == 20 && CGRectGetHeight(rect) == 20) {
                if (strongSelf.helpHandler) {
                    strongSelf.helpHandler(YES, nil);
                }
            } else {
                if (strongSelf.helpHandler) {
                    strongSelf.helpHandler(NO,strongSelf.indexPath);
                }
            }
        }];
        [_rightLabel sizeToFit];
    }
    return _rightLabel;
}

- (UILabel *)middleLine {
    if (!_middleLine) {
        _middleLine = [UILabel new];
        _middleLine.backgroundColor = [UIColor colorWithWhite:.0 alpha:0.1];
    }
    return _middleLine;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [UILabel new];
        _middleLabel.numberOfLines = 2;
    }
    return _middleLabel;
}

- (UILabel *)productMarkLabel {
    if (!_productMarkLabel) {
        _productMarkLabel = [UILabel new];
        _productMarkLabel.backgroundColor = kProductMonthColor;
    }
    return _productMarkLabel;
}

//- (UILabel *)closeDateLabel {
//    if (!_closeDateLabel) {
//        _closeDateLabel = [UILabel new];
//        _closeDateLabel.font = [UIFont systemFontOfSize:10.0f];
//        _closeDateLabel.textColor = kVerifyCodeBorderColor;
//        _closeDateLabel.layer.cornerRadius = 8;
//        _closeDateLabel.layer.masksToBounds = YES;
//        _closeDateLabel.layer.borderColor = kVerifyCodeBorderColor.CGColor;
//        _closeDateLabel.layer.borderWidth = 1.0f;
//        _closeDateLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _closeDateLabel;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
        [self layoutViews];
    }
    return self;
}

- (void)addSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.productMarkLabel];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.middleLabel];

    [self.contentView addSubview:self.middleLine];
    [self addSubview:self.applyLogoutImageView];
}

- (void)layoutViews {
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-kSpace);
        make.top.equalTo(self).with.offset(kSpace+3);
        make.height.mas_equalTo(15);
    }];
    [self.productMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self.dateLabel.mas_top);
        make.width.mas_equalTo(3);
        make.bottom.equalTo(self.dateLabel.mas_bottom);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productMarkLabel.mas_right).with.offset(5);
        make.bottom.equalTo(self.dateLabel.mas_bottom);
        make.right.equalTo(self.dateLabel.mas_left).with.mas_offset(-5);
        
    }];
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.right.equalTo(self);
        make.top.equalTo(self).with.offset(45);
        make.height.mas_equalTo(.5f);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(- kRightLabelWidth);
        make.width.mas_equalTo([self getMiddleLabelWidth]);
        make.bottom.equalTo(self);
        make.top.equalTo(self.middleLine.mas_bottom);
    }];
//    [self.yearRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(100);
//        make.top.equalTo(self).with.offset(kSpace);
//        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(20);
//    }];
//    [self.closeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).with.offset(kSpace);
//        make.height.mas_equalTo(16);
//        make.left.equalTo(self.yearRateLabel.mas_right).with.offset(5);
//        make.width.mas_equalTo(20);
//    }];
    [self.applyLogoutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.equalTo(@(0));
    }];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.dateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setProduct:(CRFMyInvestProduct *)product {
    _product = product;
    self.titleLabel.text = _product.productName;
    //
    if (_product.proType.integerValue == 2) {
        self.productMarkLabel.backgroundColor = kProductMonthColor;
    }else{
        self.productMarkLabel.backgroundColor = kProductContinuColor;
    }
    //
    [self updateSubViews];
    if (self.type == 0) {
        if (_product.investStatus.integerValue == 1) {
            self.dateLabel.text = [product applyTime];
            self.applyLogoutImageView.hidden = NO;
            self.rightLabel.hidden = YES;
            self.applyLogoutImageView.image = [UIImage imageNamed:@"invest_record_bearing"];
        }else{
            self.dateLabel.text = [product frezzTime];
            self.rightLabel.hidden = [self canLogout];
            self.applyLogoutImageView.hidden = ![self canLogout];
            self.applyLogoutImageView.image = [UIImage imageNamed:@"invest_record_apply_quit"];
        }
        [self.rightLabel setAttributedText:[CRFStringUtils setAttributedString:[product expireTime] lineSpace:6 attributes1:@{NSFontAttributeName:[self textFont],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range1:NSMakeRange(0, [_product getDay].length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[[product expireTime] rangeOfString:@"剩余天数(天)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self.rightLabel setTextAlignment:NSTextAlignmentCenter];
        [self.middleLabel setAttributedText:[CRFStringUtils setAttributedString:[product currentRangeOfRate] lineSpace:6 attributes1:@{NSFontAttributeName:[self textFont],NSForegroundColorAttributeName:kButtonNormalBackgroundColor} range1:NSMakeRange(0, [_product formatRangeOfRate].length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[[product currentRangeOfRate] rangeOfString:@"期望年化收益率"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self.middleLabel setTextAlignment:NSTextAlignmentCenter];
    } else if (self.type == 1) {
        self.dateLabel.text = [product frezzTime];
        self.applyLogoutImageView.hidden = NO;
        self.rightLabel.hidden = YES;
        if (product.investStatus.integerValue == 5&& product.redeemType.integerValue ==1) {
            self.applyLogoutImageView.image = [UIImage imageNamed:@"invest_zhuanrang"];
        }else{
            self.applyLogoutImageView.image = [UIImage imageNamed:@"invest_record_verb"];
        }
        [self.middleLabel setAttributedText:[CRFStringUtils setAttributedString:[product currentRangeOfRate] lineSpace:6 attributes1:@{NSFontAttributeName:[self textFont],NSForegroundColorAttributeName:kButtonNormalBackgroundColor} range1:NSMakeRange(0, [_product formatRangeOfRate].length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[[product currentRangeOfRate] rangeOfString:@"期望年化收益率"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
         [self.middleLabel setTextAlignment:NSTextAlignmentCenter];
    } else {
        self.applyLogoutImageView.hidden = YES;
        self.dateLabel.text = [product frezzTime];
        [self.rightLabel setAttributedText:[CRFStringUtils setAttributedString:[product getProfit] lineSpace:6 attributes1:@{NSFontAttributeName:[self textFont],NSForegroundColorAttributeName:kButtonNormalBackgroundColor} range1:NSMakeRange(0, _product.expectedBenefitAmount.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[[product getProfit] rangeOfString:@"累计收益(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
         [self.rightLabel setTextAlignment:NSTextAlignmentCenter];
    }
    [self.leftLabel setAttributedText:[CRFStringUtils setAttributedString:[product capital] lineSpace:6 attributes1:@{NSFontAttributeName:[self textFont],NSForegroundColorAttributeName:kButtonNormalBackgroundColor} range1:NSMakeRange(0, _product.amount.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:[[product capital] rangeOfString:@"期初出借本金(元)"] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)updateSubViews {
    if (self.type == 1||self.type == 0) {
        [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(kSpace);
            make.width.mas_equalTo([self getMiddleLabelWidth]);
            make.bottom.equalTo(self);
            make.top.equalTo(self.middleLine.mas_bottom);
        }];
        self.middleLabel.hidden = NO;
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-kSpace);
            make.width.mas_equalTo(kRightLabelWidth);
            make.bottom.equalTo(self.leftLabel.mas_bottom);
            make.top.equalTo(self.leftLabel);
        }];
    } else {
        self.middleLabel.hidden = YES;
        [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(kSpace);
            make.width.mas_equalTo(kScreenWidth / 2.0);
            make.bottom.equalTo(self);
            make.top.equalTo(self.middleLine.mas_bottom);
        }];
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-kSpace);
            make.width.mas_equalTo(kScreenWidth / 2.0);
            make.bottom.equalTo(self.leftLabel.mas_bottom);
            make.top.equalTo(self.middleLine.mas_bottom);
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (CGFloat)getMiddleLabelWidth {
    return (kScreenWidth - kSpace  - kRightLabelWidth) / 2.0;
}

- (BOOL)canLogout {
    return (self.product.forwardType.integerValue == 2 && self.product.investStatus.integerValue == 6) || self.product.isAbleFlexibleredeem.integerValue == 2 ||self.product.redeemType.integerValue == 2;
}
@end
