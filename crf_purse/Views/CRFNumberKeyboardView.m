//
//  CRFNumberKeyboardView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFNumberKeyboardView.h"

#define kNumFont 28.0f
#define kLineWidth 0.5
#define kButtonWidth (kScreenWidth - 2 * kLineWidth)/3
#define kKeyBoardButtonHeight (216 - 3 * kLineWidth)/4
#define kArrowWidth 36

#define kKeyboardGrayColor [UIColor colorWithRed:169/255.0f green:181/255.0f blue:192/255.0f alpha:1.0f]

#define kKeyboardButtonGaryColor [UIColor colorWithRed:187/255.0f green:190/255.0f blue:195/255.0f alpha:1.0f]

#define kKeyboardNormalButtonColor [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f]

@interface CRFNumberKeyboardView ()

@property (nonatomic, strong) NSArray *numArray;

@end

@implementation CRFNumberKeyboardView


- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)numArray keyboardType:(CRFCustomKeyboardType)keyboardType {
    if(self = [super initWithFrame:frame]) {
        self.numArray = numArray;
        self.keyboardType = keyboardType;
        self.bounds = CGRectMake(0, 0, kScreenWidth, 216);
        for(int i =0; i < 4; i++) {
            for(int j = 0; j < 3; j++) {
                UIButton *button = [self createButtonWithX:i Y:j];
                if(i == 3 && j == 0) {
                    if(self.keyboardType == CRFCustomKeyboardTypeNull) {
                        [button setEnabled:NO];
                    }
                }
                [self addSubview:button];
            }
        }
        UIColor *color = kKeyboardGrayColor;//RGB(169, 181, 192, 1.0f);
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kButtonWidth, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(2 * kButtonWidth + kLineWidth, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kKeyBoardButtonHeight*(i+1) + kLineWidth * i, kScreenWidth, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
    }
    return self;
}

- (UIButton *)createButtonWithX:(NSInteger)x Y:(NSInteger)y {
    UIButton *button = nil;
    CGFloat frameX = (kButtonWidth + kLineWidth) * y;
    CGFloat frameY = (kKeyBoardButtonHeight + kLineWidth) * x;
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, kButtonWidth, kKeyBoardButtonHeight)];
    NSInteger num = y + 3 * x + 1;
    if(num < 10) {
        button.tag = [[self.numArray objectAtIndex:num - 1] intValue];
    } else if (num == 11) {
        button.tag = [[self.numArray lastObject] intValue];
    } else {
        button.tag = num;
    }
    if(x == 3 && y== 2) {
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIColor *colorNormal = kKeyboardNormalButtonColor;
    UIColor *colorHighlighted = kKeyboardButtonGaryColor;//RGB(187, 190, 195, 1.0f);
    if(num == 10 || num == 12) {
        colorNormal = kKeyboardGrayColor;//RGB(187, 1git90, 195, 1.0f);
        colorHighlighted = kKeyboardButtonGaryColor;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(kButtonWidth, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHighlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    if(num < 10) {
        UILabel *labelNum = [[ UILabel alloc] initWithFrame:CGRectMake(0, 15, kButtonWidth, 24)];
        labelNum.text = [NSString stringWithFormat:@"%d",[[self.numArray objectAtIndex:num - 1] intValue]];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = [UIFont systemFontOfSize:kNumFont];
        [button addSubview:labelNum];
    } else if (num == 11) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kButtonWidth, 28)];
        label.text = [NSString stringWithFormat:@"%d",[[self.numArray lastObject] intValue]];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:kNumFont];
        [button addSubview:label];
    } else if (num == 10) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kButtonWidth, 28)];
          label.font = [UIFont systemFontOfSize:24];
        if(self.keyboardType == CRFCustomKeyboardTypeX) {
            label.text = @"X";
        } else if (self.keyboardType == CRFCustomKeyboardTypeNext) {
            label.text = @"Next";
        } else if (self.keyboardType == CRFCustomKeyboardTypeDone){
            label.text = @"Done";
        } else  if(self.keyboardType == CRFCustomKeyboardTypeDot) {
            label.text = @"·";
            label.font = [UIFont boldSystemFontOfSize:35];
        } else {
            label.text = nil;
        }
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    } else {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((kButtonWidth - kArrowWidth)/2, (kKeyBoardButtonHeight - kArrowWidth)/2, kArrowWidth, kArrowWidth)];
        arrow.image = [UIImage imageNamed:@"iconfont-delete"];
        [button addSubview:arrow];
    }
    return button;
}

- (void)clickButton:(UIButton *)sender {
    if(sender.tag == 10) {
        [self.delegate numberKeyboardXBtnTapped:self.keyboardType];
    } else if (sender.tag == 12) {
        [self.delegate numberKeyboardBackspace];
    } else {
        NSInteger num = sender.tag;
        if(sender.tag == 0) {
            num = 0;
        }
        [self.delegate numberKeyboardInput:num];
    }
}

@end
