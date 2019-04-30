//
//  CRFQAView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFQAView.h"
#import "CRFStringUtils.h"
@interface CRFQAView()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *margen;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottonMargen;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *label1Margen;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *label3Margen;
@property (nonatomic, strong) UIVisualEffectView *effectview;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle1;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle3;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end

@implementation CRFQAView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        
        _effectview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _effectview.alpha = 0;
    }
    return _effectview;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImage.hidden = YES;
    self.contentTitle3.hidden = YES;
    self.contentLabel3.hidden = YES;
    self.closeBtn.hidden = YES;
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    if ([[NSString getCurrentDeviceModel] isEqualToString:@"iPhone5"]||[[NSString getCurrentDeviceModel] isEqualToString:@"iPhone5s"]||[[NSString getCurrentDeviceModel] isEqualToString:@"iPhone5c"]) {
//         self.margen.constant = 10 * kHeightRatio + 64;
//        self.bottonMargen.constant = 10 * kHeightRatio;
//        self.label3Margen.constant = 85;
        self.label1Margen.constant = 85;
    }
}

- (IBAction)closeView:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = .0f;
        self.effectview.alpha = .0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.effectview removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.qaStyle != CRFQAExplain) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = .0f;
            self.effectview.alpha = .0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.effectview removeFromSuperview];
        }];
    }
    
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self.effectview];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1;
        self.effectview.alpha = 1;
    }];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}
-(void)setTitle1:(NSString *)title1{
    _title1 = title1;
    _contentTitle1.text = _title1;
}
-(void)setTitle2:(NSString *)title2{
    _title2 = title2;
    _contentTitle2.text = _title2;
}
-(void)setTitle3:(NSString *)title3{
    _contentTitle3.hidden = NO;
    _title3 = title3;
    _contentTitle3.text = _title3;
}
-(void)setContent1:(NSString *)content1{
    _content1 = content1;
    if ([[NSString getCurrentDeviceModel] isEqualToString:@"iPhone5"]||[[NSString getCurrentDeviceModel] isEqualToString:@"iPhone5s"]||[[NSString getCurrentDeviceModel] isEqualToString:@"iPhone5c"]) {
        self.label1Margen.constant = 30;
        self.bottonMargen.constant = 10;
    }else{
        self.bottonMargen.constant = 30;
        self.label1Margen.constant = 20;
    }
    NSMutableAttributedString *attrbute = [CRFStringUtils setAttributedString:_content1 lineSpace:5 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:14.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range1:[_content1 rangeOfString:_content1] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
    [self.contentlabel1 setAttributedText:attrbute];
}
-(void)setContent2:(NSString *)content2{
    _content2 = content2;
    NSMutableAttributedString *attrbute = [CRFStringUtils setAttributedString:_content2 lineSpace:5 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:14.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range1:[_content2 rangeOfString:_content2] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
    [self.contentLabel2 setAttributedText:attrbute];
}
-(void)setContent3:(NSString *)content3{
    _contentLabel3.hidden = NO;
    _titleImage.hidden = NO;
    _closeBtn.hidden = NO;
    _content3 = content3;
    NSMutableAttributedString *attrbute = [CRFStringUtils setAttributedString:_content3 lineSpace:5 attributes1:@{NSFontAttributeName:[CRFUtils fontWithSize:14.0],NSForegroundColorAttributeName:UIColorFromRGBValue(0x666666)} range1:[_content3 rangeOfString:_content3] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero];
    [self.contentLabel3 setAttributedText:attrbute];
}
@end
