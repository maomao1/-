//
//  CRFShowSwitchAlert.m
//  crf_purse
//
//  Created by maomao on 2018/6/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFShowSwitchAlert.h"
#import "CRFStringUtils.h"
@interface CRFShowSwitchAlert()
@property (nonatomic ,strong) UIButton * closeBtn;
@property (nonatomic ,strong) UILabel  * titleLabel;
@property (nonatomic ,strong) UILabel  * contentLabel;
@property (nonatomic ,strong) UILabel  * line;
@property (nonatomic ,strong) UIButton * confirmBtn;
@property (nonatomic ,strong) UIView   *bgView;
@end
@implementation CRFShowSwitchAlert
-(instancetype)initWithFrame:(CGRect)frame AlertTitle:(NSString *)title content:(NSString *)content dismissHandler:(dismissBlock)dismiss confirmHandler:(confirmHandler)confirmHandler{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.bgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.confirmBtn];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.left.mas_equalTo(70*kWidthRatio);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentLabel.mas_top).with.mas_offset(-kSpace);
            make.centerX.equalTo(self.contentLabel.mas_centerX);
            make.height.mas_equalTo(18);
        }];
        if (dismiss) {
            [self addSubview:self.closeBtn];
            [self addSubview:self.line];
            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_right).with.mas_offset(-5);
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.centerY.equalTo(self.titleLabel.mas_centerY).with.mas_offset(-5);
            }];
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left).with.mas_offset(-20);
                make.centerX.equalTo(self.mas_centerX);
                make.height.mas_equalTo(0.5);
                make.top.equalTo(self.contentLabel.mas_bottom).with.mas_offset(kSpace);
            }];
            [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.line.mas_left);
                make.height.mas_equalTo(kRegisterButtonHeight);
                make.top.equalTo(self.line.mas_bottom);
                make.centerX.equalTo(self.mas_centerX);
            }];
            [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.line.mas_left);
                make.right.equalTo(self.line.mas_right);
                make.top.equalTo(self.titleLabel.mas_top).with.mas_offset(-20);
                make.bottom.equalTo(self.confirmBtn.mas_bottom);
            }];
            self.confirmBtn.backgroundColor = [UIColor clearColor];
            _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            [_confirmBtn setTitleColor:kBtnAbleBgColor forState:UIControlStateNormal];
        }else{
            [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left);
                make.height.mas_equalTo(kRegisterButtonHeight);
                make.top.equalTo(self.contentLabel.mas_bottom).with.mas_offset(25);
                make.centerX.equalTo(self.mas_centerX);
            }];
            [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left).with.mas_offset(-20);
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(self.titleLabel.mas_top).with.mas_offset(-20);
                make.bottom.equalTo(self.confirmBtn.mas_bottom).with.mas_offset(20);
            }];
            _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            _confirmBtn.backgroundColor = kBtnAbleBgColor;
            [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        self.dismiss = dismiss;
        self.confirmHandler=confirmHandler;
        self.titleLabel.text = title;
        [self.contentLabel setAttributedText:[CRFStringUtils changedLineSpaceWithTotalString:content lineSpace:5 ParagrapSpace:10]];
    }
    
    return self;
}
-(void)changeButtonTitle:(NSString *)btnTitle Content:(NSString*)content{
    [_confirmBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.contentLabel setAttributedText:[CRFStringUtils changedLineSpaceWithTotalString:content lineSpace:5 ParagrapSpace:10]];
}
- (void)showInView:(UIView *)view{
    self.alpha = .0f;
    [view addSubview:self];
    [UIView animateWithDuration:.1f animations:^{
        self.alpha = 1;
    }];
}
- (void)dismissView{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = .0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)closeEvent{
    [self dismissView];
    if (self.dismiss) {
        self.dismiss();
    }
    
}
-(void)confirmEvent{
    [self dismissView];
    if (self.confirmHandler) {
        self.confirmHandler();
    }
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = UIColorFromRGBValue(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8.f;
    }
    return _bgView;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"auth_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_closeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
    }
    return _closeBtn;
}
- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn addTarget:self action:@selector(confirmEvent) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 5.0f;
        
    }
    return _confirmBtn;
}
-(UILabel *)line{
    if (!_line) {
        _line = [[UILabel alloc]init];
        _line.backgroundColor = kCellLineSeparatorColor;
    }
    return _line;
}
@end
