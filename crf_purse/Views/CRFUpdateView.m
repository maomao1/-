//
//  CRFUpdateView.m
//  crf_purse
//
//  Created by maomao on 2017/7/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUpdateView.h"
static  const CGFloat  viewHeight = 315;
static  const CGFloat  viewWidth  = 275;
@interface CRFUpdateView()
@property (nonatomic , copy) UpdateVersionBlock clickCallBack;
@property (nonatomic , copy) CancelVersionBlock cancelBack;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , copy) NSString *level;

@property (nonatomic , assign) BOOL  isHome;
//@property (nonatomic ,copy) UIVisualEffectView *effectView;
//@property (nonatomic , strong) UIView *bgView;

@end
@implementation CRFUpdateView
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Content:(NSString *)content IsForce:(NSString *)level ClickCallBack:(UpdateVersionBlock)callBack CancelCallBack:(CancelVersionBlock)cancelBack IsHome:(BOOL)isHome{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColorFromRGBValueAndalpha(0x000000, 0.6);
//        self.alpha = 0.6;
        _clickCallBack = callBack;
        _cancelBack    =cancelBack;
        _title = title;
        _content = content;
        _level = level;
        _isHome = isHome;
        [self setUpdateViewUI];
    }
    return self;
}
- (void)setUpdateViewUI{
    UIView *bgView = [[UIView alloc]init];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.alpha = 0.6;
    [self addSubview:bgView];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"UpdateView_bgImg"];
    [self addSubview:bgImage];
    //
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.layer.masksToBounds = YES;
    updateBtn.layer.cornerRadius = 5.0f;
    updateBtn.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
    [updateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [updateBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:updateBtn];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = _title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.textColor = UIColorFromRGBValue(0x333333);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UITextView *contentText = [[UITextView alloc]init];
    contentText.editable = NO;
//    contentText.text = _content;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_content];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
//    [paragraph setLineBreakMode:<#(NSLineBreakMode)#>];
    [paragraph setLineSpacing:10];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, _content.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x666666) range:NSMakeRange(0, _content.length)];
    contentText.font = [UIFont systemFontOfSize:13.0f];
//    contentText.textColor = UIColorFromRGBValue(0x666666);
    contentText.textAlignment = NSTextAlignmentLeft;
    [contentText setContentOffset:CGPointZero];
    [contentText setAttributedText:attribute];
    [self addSubview:contentText];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(viewWidth*kWidthRatio, viewHeight*kHeightRatio));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_top).with.mas_offset(118*kHeightRatio);
        make.centerX.equalTo(bgImage.mas_centerX);
        make.height.mas_equalTo(15);
    }];
    
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage.mas_centerX);
        make.width.equalTo(contentText);
        make.bottom.equalTo(bgImage.mas_bottom).with.mas_offset(-20*kHeightRatio);
        make.height.mas_equalTo(40*kHeightRatio);
    }];
    [contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).with.mas_offset(10*kHeightRatio);
        make.bottom.equalTo(updateBtn.mas_top).with.mas_equalTo(-20*kHeightRatio);
        make.width.mas_equalTo(235*kWidthRatio);
    }];
    if ([_level isEqualToString:@"0"]) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(removeViewClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.cornerRadius = 19;
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgImage.mas_bottom).with.mas_offset(30*kHeightRatio);
            make.centerX.equalTo(bgImage.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
    }
    if (_isHome) {
        UIColor *colorOne = UIColorFromRGBValueAndalpha(0x000000, 0.6);
        
        UIColor *colorTwo = UIColorFromRGBValueAndalpha(0x000000, 1.0);
        
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.startPoint = CGPointMake(0, 0);
        
        gradient.endPoint = CGPointMake(0, 1);
        
        gradient.colors = colors;
        
        gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        [bgView.layer insertSublayer:gradient atIndex:0];
    }else{
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    }
    
    
    
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
}
- (void)removeViewClick{
    [self removeFromSuperview];
    if (self.cancelBack) {
        self.cancelBack();
    }
}
- (void)btnClick{
    if (self.clickCallBack) {
        self.clickCallBack();
    }
}
@end
