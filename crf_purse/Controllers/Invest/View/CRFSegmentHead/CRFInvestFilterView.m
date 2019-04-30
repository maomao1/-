//
//  CRFInvestFilterView.m
//  crf_purse
//
//  Created by maomao on 2017/11/9.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//
#define  NormalColor   UIColorFromRGBValue(0x666666)
#define  SelectedColor UIColorFromRGBValue(0xFB4D3A)
#import "CRFInvestFilterView.h"
@interface CRFInvestFilterView()
@property (nonatomic , strong) UILabel *line;
@property (nonatomic , strong) UILabel *topLine;
@end
@implementation CRFInvestFilterView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
-(void)createUI{
    [self addSubview:self.profitButton];
    [self addSubview:self.daysButton];
    [self addSubview:self.line];
    [self addSubview:self.topLine];
    [self addSubview:self.payExpireBtn];
    [self addSubview:self.payMonthBtn];
    [self.profitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth/2 - kSpace)/2, 44));
    }];
    [self.daysButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profitButton.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth/2 - kSpace)/2, 44));
    }];
    [self.payExpireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSpace);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 20));
        
    }];
    [self.payMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payExpireBtn.mas_left).with.mas_offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    
}
-(void)crfTopLineHidden:(BOOL)isHidden{
    self.topLine.hidden = isHidden;
}
-(void)filterConditionEvent:(UIButton*)btn{
    btn.selected =!btn.selected;
    if ([btn isEqual:self.payExpireBtn]) {
        self.payExpireBtn.selected = btn.selected;
        self.payExpireBtn.layer.borderColor = btn.selected?SelectedColor.CGColor:NormalColor.CGColor;
        self.payMonthBtn.layer.borderColor  = NormalColor.CGColor;
        self.payMonthBtn.selected = NO;
        _payMonthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _payMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (btn.selected) {
            _payExpireBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            _payExpireBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 57, 0, 0);
        }else{
            _payExpireBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            _payExpireBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }else{
        self.payMonthBtn.layer.borderColor = btn.selected?SelectedColor.CGColor:NormalColor.CGColor;
        self.payExpireBtn.layer.borderColor = NormalColor.CGColor;
        self.payExpireBtn.selected = NO;
        self.payMonthBtn.selected = btn.selected;
        _payExpireBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _payExpireBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (btn.selected) {
            _payMonthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            _payMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 57, 0, 0);
        }else{
            _payMonthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            _payMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    if ([self.filterDelegate respondsToSelector:@selector(filterProductPayType:IsMonthSelected:AndBedueSelected:)]) {
        [self.filterDelegate filterProductPayType:btn.titleLabel.text IsMonthSelected:self.payMonthBtn.selected AndBedueSelected:self.payExpireBtn.selected];
    }
//    if (btn.selected) {
//        
//    }
    
}
-(void)filterWithProfitEvent:(CRFStatusButton*)btn{
    NSString *typeStr,*seqStr;
    if ([btn isEqual:_profitButton]) {
        _daysButton.statusType = UnSelected;
        typeStr = @"Profit_";
    }else{
        _profitButton.statusType = UnSelected;
        typeStr = @"Remain_";
    }
    switch (btn.statusType) {
        case UnSelected:{
            btn.statusType = SelectedUp;
            seqStr = @"asc";
        }
            break;
        case SelectedUp:{
            btn.statusType = SelectedDown;
            seqStr = @"dec";
        }
            break;
        case SelectedDown:
        {
            btn.statusType = SelectedUp;
            seqStr = @"asc";
        }
            break;
        default:
            break;
    }
    self.filterType = [NSString stringWithFormat:@"%@%@",typeStr,seqStr];
    if ([self.filterDelegate respondsToSelector:@selector(filterProductWithType:)]) {
        [self.filterDelegate filterProductWithType:self.filterType];
    }
}
-(CRFStatusButton *)profitButton{
    if (!_profitButton) {
        _profitButton = [CRFStatusButton buttonWithType:UIButtonTypeCustom];
        [_profitButton setTitle:@"收益率" forState:UIControlStateNormal];
        _profitButton.statusType =SelectedDown;
        _profitButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _profitButton.imageEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 0);
        _profitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_profitButton addTarget:self action:@selector(filterWithProfitEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _profitButton;
}
-(CRFStatusButton *)daysButton{
    if (!_daysButton) {
        _daysButton = [CRFStatusButton buttonWithType:UIButtonTypeCustom];
        [_daysButton setTitle:@"出借天数" forState:UIControlStateNormal];
        _daysButton.statusType = UnSelected;
        _daysButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _daysButton.imageEdgeInsets = UIEdgeInsetsMake(0, 63, 0, 0);
        _daysButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_daysButton addTarget:self action:@selector(filterWithProfitEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _daysButton;
}
-(UIButton *)payMonthBtn{
    if (!_payMonthBtn) {
        _payMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payMonthBtn setTitle:@"按月付息" forState:UIControlStateNormal];
        [_payMonthBtn setTitle:@"按月付息" forState:UIControlStateSelected];
        [_payMonthBtn setTitleColor:NormalColor forState:UIControlStateNormal];
        [_payMonthBtn setImage:[UIImage imageNamed:@"invest_filter_delete"] forState:UIControlStateSelected];
        [_payMonthBtn setTitleColor:SelectedColor forState:UIControlStateSelected];
        _payMonthBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_payMonthBtn addTarget:self action:@selector(filterConditionEvent:) forControlEvents:UIControlEventTouchUpInside];
        _payMonthBtn.layer.masksToBounds = YES;
        _payMonthBtn.layer.cornerRadius = 10;
        _payMonthBtn.layer.borderWidth = 1.f;
        _payMonthBtn.layer.borderColor = NormalColor.CGColor;

    }
    return _payMonthBtn;
}
-(UIButton *)payExpireBtn{
    if (!_payExpireBtn) {
        _payExpireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payExpireBtn setTitle:@"到期付息" forState:UIControlStateNormal];
        [_payExpireBtn setTitle:@"到期付息" forState:UIControlStateSelected];
        [_payExpireBtn setTitleColor:NormalColor forState:UIControlStateNormal];
        [_payExpireBtn setTitleColor:SelectedColor forState:UIControlStateSelected];
        [_payExpireBtn setImage:[UIImage imageNamed:@"invest_filter_delete"] forState:UIControlStateSelected];
        _payExpireBtn.titleLabel.font = [UIFont systemFontOfSize:12];

        [_payExpireBtn addTarget:self action:@selector(filterConditionEvent:) forControlEvents:UIControlEventTouchUpInside];
        _payExpireBtn.layer.masksToBounds = YES;
        _payExpireBtn.layer.cornerRadius = 10;
        _payExpireBtn.layer.borderWidth = 1.f;
        _payExpireBtn.layer.borderColor = NormalColor.CGColor;

    }
    return _payExpireBtn;
}
-(UILabel *)line{
    if (!_line) {
        _line = [[UILabel alloc]init];
        _line.backgroundColor = kCellLineSeparatorColor;
    }
    return _line;
}
-(UILabel *)topLine{
    if (!_topLine) {
        _topLine = [[UILabel alloc]init];
        _topLine.backgroundColor = kCellLineSeparatorColor;
    }
    return _topLine;
}
@end
@implementation CRFStatusButton

- (void)setStatusType:(StatusType)statusType {
    _statusType = statusType;
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    switch (_statusType) {
        case UnSelected:
        {
            [self setTitleColor:NormalColor forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"invest_filter_unselected"] forState:UIControlStateNormal];
        }
            break;
        case SelectedUp:
        {
//            self.titleLabel.textColor = SelectedColor;
//            self.imageView.image      = [UIImage imageNamed:@"invest_filter_up"];
            [self setTitleColor:SelectedColor forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"invest_filter_up"] forState:UIControlStateNormal];

        }
            break;
        case SelectedDown:
        {
//            self.titleLabel.textColor = SelectedColor;
//            self.imageView.image      = [UIImage imageNamed:@"invest_filter_down"];
            [self setTitleColor:SelectedColor forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"invest_filter_down"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

@end
