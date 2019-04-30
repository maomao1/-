//
//  CRFColorButton.m
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFColorButton.h"

@interface CRFGradientColor ()

- (void)setColors:(NSArray *)colors;

@end

@implementation CRFGradientColor

/**
 *  初始化渐变色对象
 *
 *  @param colors 颜色数组，从上到下的顺序
 *
 *  @return 渐变色对象
 */
+ (instancetype)gradientColorWithColors:(NSArray *)colors
{
    CRFGradientColor *gradientColor = [[CRFGradientColor alloc] init];
    [gradientColor setColors:colors];
    return gradientColor;
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
}

@end

@implementation CRFColorButton
{
    NSMutableDictionary *_dictBgColor;
    NSMutableDictionary *_dictGradientColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup
{
    _borderWidth = 0;
    _borderColor = nil;
    _corner = UIRectCornerAllCorners;
    _cornerRadius = 0;
}

#pragma mark - public
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setCorner:(UIRectCorner)corner
{
    _corner = corner;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

// ----------------- backgroundColor
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (!_dictBgColor) {
        _dictBgColor = [NSMutableDictionary dictionary];
        self.backgroundColor = [UIColor clearColor];
    }
    
    if (!backgroundColor) {
        backgroundColor = [UIColor clearColor];
    }
    _dictBgColor[@(state)] = backgroundColor;
    
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColorForState:(UIControlState)state
{
    UIColor *bgColor = nil;
    
    do {
        NSArray *keys = [_dictBgColor.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        for (NSNumber *key in keys) {
            UIControlState keyState = [key integerValue];
            if (state==keyState) {
                bgColor = _dictBgColor[key];
                break;
            }
        }
        
        if (bgColor) break;
        
        for (NSNumber *key in _dictBgColor.allKeys) {
            UIControlState keyState = [key integerValue];
            if (keyState&state) {
                bgColor = _dictBgColor[key];
                break;
            }
        }
        
        if (bgColor) break;
        
        //        bgColor = [UIColor clearColor];
    } while (NO);
    
    return bgColor;
}

// ----------------- gradientColor
- (void)setGradientColor:(CRFGradientColor *)gradientColor forState:(UIControlState)state
{
    if (!_dictGradientColor) {
        _dictGradientColor = [NSMutableDictionary dictionary];
        self.backgroundColor = [UIColor clearColor];
    }
    
    if (!gradientColor) {
        gradientColor = [CRFGradientColor gradientColorWithColors:@[[UIColor clearColor], [UIColor clearColor]]];
    }
    _dictGradientColor[@(state)] = gradientColor;
    
    [self setNeedsDisplay];
}

- (CRFGradientColor *)gradientColorForState:(UIControlState)state
{
    CRFGradientColor *gradientColor = nil;
    
    do {
        NSArray *keys = [_dictGradientColor.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        for (NSNumber *key in keys) {
            UIControlState keyState = [key integerValue];
            if (state==keyState) {
                gradientColor = _dictGradientColor[key];
                break;
            }
        }
        
        if (gradientColor) break;
        
        for (NSNumber *key in _dictBgColor.allKeys) {
            UIControlState keyState = [key integerValue];
            if (keyState&state) {
                gradientColor = _dictGradientColor[key];
                break;
            }
        }
        
        if (gradientColor) break;
        
        //        gradientColor = [CRFGradientColor gradientColorWithColors:@[[UIColor clearColor], [UIColor clearColor]]];
    } while (NO);
    
    return gradientColor;
}

#pragma mark - super methods
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
//    NSLog(@"%s, %zd", __FUNCTION__, self.state);
    UIColor *fillColor = [self backgroundColorForState:self.state];
    CRFGradientColor *gradientColor = [self gradientColorForState:self.state];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:_corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    [path addClip];
    CGContextAddPath(context, path.CGPath);
    
    if (gradientColor) {
        NSMutableArray *arrColor = [NSMutableArray array];
        NSInteger gradientCount = gradientColor.colors.count;
        for (NSInteger i=0; i<gradientCount; i++) {
            UIColor *color = gradientColor.colors[i];
            [arrColor addObject:(id)color.CGColor];
        }
        if (arrColor.count==1) {
            [arrColor addObject:(id)((UIColor *)gradientColor.colors[0]).CGColor];
        }
        CFArrayRef arrColorRef = (__bridge CFArrayRef)arrColor;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, arrColorRef, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, self.frame.size.height*0.5), CGPointMake(self.frame.size.width, self.frame.size.height*0.5), kCGGradientDrawsAfterEndLocation);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    else {
        if (!fillColor) {
            fillColor = [UIColor clearColor];
        }
        
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillPath(context);
    }
    
    if (_borderWidth>0 && _borderColor) {
        UIBezierPath *borderpath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, _borderWidth*0.5, _borderWidth*0.5) byRoundingCorners:_corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
        CGContextAddPath(context, borderpath.CGPath);
        CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
        CGContextSetLineWidth(context, _borderWidth);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextStrokePath(context);
    }
}

@end
