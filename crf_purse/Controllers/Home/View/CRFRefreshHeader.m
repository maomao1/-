//
//  CRFRefreshHeader.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRefreshHeader.h"

#define AnimationDISTANCE 0

@interface CRFRefreshHeader()

@property (nonatomic, assign) CGFloat offSet_Y;
@property (nonatomic, assign, getter = isEndAnimation) BOOL endAniamtion;
@property (nonatomic, strong) CAShapeLayer *elasticShaperLayer;
@property (nonatomic, strong) UIImageView *defaultImageView;
@property (nonatomic, strong) UILabel *totalLabel, *aviableLabel, *increaseLabel, *line;

@end


@implementation CRFRefreshHeader

@synthesize accountInfo = _accountInfo;

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.numberOfLines = 0;
    }
    return _totalLabel;
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = kCellLineSeparatorColor;
    }
    return _line;
}

- (UILabel *)aviableLabel {
    if (!_aviableLabel) {
        _aviableLabel = [UILabel new];
        _aviableLabel.textAlignment = NSTextAlignmentCenter;
        _aviableLabel.numberOfLines = 0;
    }
    return _aviableLabel;
}

- (UILabel *)increaseLabel {
    if (!_increaseLabel) {
        _increaseLabel = [UILabel new];
        _increaseLabel.textAlignment = NSTextAlignmentCenter;
        _increaseLabel.numberOfLines = 0;
    }
    return _increaseLabel;
}

- (UIImageView *)defaultImageView {
    if (!_defaultImageView) {
        _defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_refresh_header"]];
        _defaultImageView.contentMode = UIViewContentModeCenter;
    }
    return _defaultImageView;
}

- (instancetype)initWithBindingScrollView:(UIScrollView *)bindingScrollView {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.bindingScrollView = bindingScrollView;
        [self configSubViews];
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.defaultImageView];
    [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(32);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(48);
    }];
    [self addSubview:self.totalLabel];
    [self addSubview:self.aviableLabel];
    [self addSubview:self.increaseLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(30);
        make.height.mas_offset(50);
    }];
    [self.aviableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.totalLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, 50));
    }];
    [self.increaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.totalLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, 50));
    }];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 25));
    }];
}

- (void)configSubViews {
    self.elasticShaperLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    self.elasticShaperLayer.fillRule = kCAFillRuleEvenOdd;
    self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:0];
    self.elasticShaperLayer.fillColor = UIColorFromRGBValue(0xf4f4f4).CGColor;
    [self.layer addSublayer:self.elasticShaperLayer];
}

- (void)observerScrollView:(NSDictionary *)change {
    self.offSet_Y = self.bindingScrollView.contentOffset.y;
    if (self.offSet_Y > 0) {
        return;
    }
    if (self.bindingScrollView.dragging || self.offSet_Y > AnimationDISTANCE) {
        self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:-self.offSet_Y];
    }
    if (self.offSet_Y == 0) {
        self.endAniamtion = NO;
    }
    [self changeScrollViewProperty];
}

- (void)changeScrollViewProperty {
    if (self.offSet_Y <= AnimationDISTANCE) {
        if (!self.bindingScrollView.dragging && !self.endAniamtion) {
            [self elasticLayerAnimation];
        }
    } else {
        [self.elasticShaperLayer removeAllAnimations];
    }
}

- (void)setRefreshType:(RefreshType)refreshType {
    _refreshType = refreshType;
    [self setUserInfo];
    [self setNeedsDisplay];
}

- (void)setUserInfo {
    if (self.refreshType == UserLogin) {
        self.defaultImageView.hidden = YES;
        self.totalLabel.hidden = NO;
        self.aviableLabel.hidden = NO;
        self.increaseLabel.hidden = NO;
        self.line.hidden = NO;
        [self setTotalLabelAttributedString];
        NSString *subString = NSLocalizedString(@"refresh_aviable_money", nil);
        NSString *totalString = [NSString stringWithFormat:@"%@\n%@",self.accountInfo.availableBalance,subString];
        [self.aviableLabel setAttributedText:[self formatAttributedString:totalString subString:subString]];
        NSString *increaseSubString = NSLocalizedString(@"refresh_receive_money", nil);
        NSString *increaseTotalString = [NSString stringWithFormat:@"%@\n%@",self.accountInfo.profits,increaseSubString];
        [self.increaseLabel setAttributedText:[self formatAttributedString:increaseTotalString subString:subString]];
        self.aviableLabel.textAlignment = NSTextAlignmentCenter;
        self.increaseLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.defaultImageView.hidden = [CRFAppManager defaultManager].majiabaoFlag;
        self.totalLabel.hidden = YES;
        self.line.hidden = YES;
        self.aviableLabel.hidden = YES;
        self.increaseLabel.hidden = YES;
    }
}

- (void)setAccountInfo:(CRFAccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    [self setUserInfo];
}

- (void)elasticLayerAnimation {
    self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE)];
}

- (CGPathRef)calculateAnimaPathWithOriginY:(CGFloat)originY {
    CGPoint topLeftPoint = CGPointMake(0,0);
    CGPoint bottomLeftPoint = CGPointMake(0, self.offSet_Y <= -AnimationDISTANCE ? -AnimationDISTANCE : originY);
    if (originY < - AnimationDISTANCE) {
        originY = - AnimationDISTANCE;
    }
    if (originY > - AnimationDISTANCE) {
        originY = (originY + AnimationDISTANCE) * 2 - AnimationDISTANCE;
    }
    CGPoint controlPoint = CGPointMake(self.bindingScrollView.bounds.size.width * .5, originY);
    CGPoint bottomRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, self.offSet_Y <= -AnimationDISTANCE ? -AnimationDISTANCE : originY);
    CGPoint topRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, 0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:topLeftPoint];
    [bezierPath addLineToPoint:bottomLeftPoint];
    [bezierPath addQuadCurveToPoint:bottomRightPoint controlPoint:controlPoint];
    [bezierPath addLineToPoint:topRightPoint];
    [bezierPath addLineToPoint:topLeftPoint];
    return bezierPath.CGPath;
}

//- (void)drawRect:(CGRect)rect {
//    if (self.refreshType != UserLogin) {
//        return;
//    }
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, 1);  //线宽
//    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetRGBStrokeColor(context, 238.0 / 255.0, 238.0 / 255.0, 238.0 / 255.0, 1.0);  //线的颜色
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, kScreenWidth / 2.0, 80);  //起点坐标
//    CGContextAddLineToPoint(context, kScreenWidth / 2.0 , 100);   //终点坐标
//    CGContextStrokePath(context);
//}

- (NSMutableAttributedString *)formatAttributedString:(NSString *)totalString subString:(NSString *)subString {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f];
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                      value:paragraphStyle
                      range:NSMakeRange(0, totalString.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[CRFUtils fontWithSize:16.0] range:NSMakeRange(0, totalString.length - subString.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xEE5250) range:NSMakeRange(0, totalString.length - subString.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0f] range:NSMakeRange(totalString.length - subString.length, subString.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x666666) range:NSMakeRange(totalString.length - subString.length, subString.length)];
    return attributedStr;
}

- (void)setTotalLabelAttributedString {
    NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"header_total_money", nil),self.accountInfo.accountAmount];
    NSString *subString = self.accountInfo.accountAmount;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.0f];
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, totalString.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, totalString.length - subString.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x666666) range:NSMakeRange(0, totalString.length - subString.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[CRFUtils fontWithSize:20.0] range:NSMakeRange(totalString.length - subString.length, subString.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xEE5250) range:NSMakeRange(totalString.length - subString.length, subString.length)];
    [self.totalLabel setAttributedText:attributedStr];
    self.totalLabel.textAlignment = NSTextAlignmentCenter;
}

- (CRFAccountInfo *)accountInfo {
    if (!_accountInfo) {
        _accountInfo = [CRFAccountInfo new];
    }
    return _accountInfo;
}

@end
