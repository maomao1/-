//
//  CRFInvestConfirmView.m
//  crf_purse
//
//  Created by maomao on 2017/11/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestConfirmView.h"
#import "CRFStringUtils.h"
@interface CRFInvestConfirmView()
@property (nonatomic , strong) UIView  *bgView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *contentLabel;
@property (nonatomic , strong) UIButton *againChose;
@property (nonatomic , strong) UIButton *confirmChose;
@end
@implementation CRFInvestConfirmView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.againChose];
    [self addSubview:self.confirmChose];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.mas_equalTo(70*kWidthRatio);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentLabel);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.contentLabel.mas_top).with.mas_offset(-20);
    }];
    [self.againChose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).with.mas_offset(25);
    }];
    [self.confirmChose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLabel);
        make.top.equalTo(self.againChose);
        make.height.width.equalTo(self.againChose);
        make.left.equalTo(self.againChose.mas_right).with.mas_offset(20);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).with.mas_offset(-20);
        make.bottom.equalTo(self.againChose.mas_bottom).with.mas_offset(20);
        make.left.equalTo(self.contentLabel.mas_left).with.mas_offset(-20);
        make.right.equalTo(self.contentLabel.mas_right).with.mas_equalTo(20);
    }];
}
-(void)rechangeChoose{
    [self dismiss];
    if (self.againChoseBlock) {
        self.againChoseBlock();
    }
}
-(void)confirmInvest{
    [self dismiss];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [UIView animateWithDuration:.2f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [view layoutIfNeeded];
    }];
}
- (void)dismiss{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = .0f;
         [self removeFromSuperview];
    } completion:^(BOOL finished) {
//        [self.superview layoutIfNeeded];
    }];
}
-(void)setRiskLimitContent{
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"风险提示";
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    NSString *riskStr;
    if (userInfo.riskLevel.integerValue == 1) {
        riskStr = @"【保守型】";
    }
    if (userInfo.riskLevel.integerValue == 2) {
        riskStr = @"【平衡型】";
    }
    if (userInfo.riskLevel.integerValue == 3) {
        riskStr = @"【进取型】";
    }
    NSString *contentStr = [NSString stringWithFormat:@"您在平台的加入总额不能超过您当前风险等级%@的出借上限额度，如与您实际风险承受能力不符，请重新测评。",riskStr];
    [_contentLabel setAttributedText:[CRFStringUtils setAttributedString:contentStr lineSpace:3 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[contentStr rangeOfString:riskStr] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];

}
-(void)setContentWithModel:(CRFProductModel *)item AndInvestAmount:(NSString *)amount{
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:16];

    _titleLabel.text = @"尊敬的用户：";
    NSString *contentStr;
    if ([item.productType isEqualToString:@"2"]) {
        contentStr = [NSString stringWithFormat:@"您本次申请出借%@元，%@到期，期望年化收益率%@%%。\n您选择的是月盈计划，每月预先支付部分收益，实际出借收益以到期后统一结算为准。\n请合理安排资金使用需求。",amount,[item formatterCloseTimeTag:2] ,[item rangeOfYInterstRate]];
    }else{
        contentStr = [NSString stringWithFormat:@"您本次申请出借%@元，%@到期，期望年化收益率%@%%。\n您选择的是连盈计划，到期后，您实际收回的本金和收益，将会根据协议约定统一结算和划付。\n请合理安排资金使用需求。",amount,[item formatterCloseTimeTag:2] ,[item rangeOfYInterstRate]];
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    NSMutableParagraphStyle *paragra = [[NSMutableParagraphStyle alloc]init];
    [paragra setLineSpacing:3];
    [paragra setParagraphSpacing:5.0];
    [attributedStr addAttributes:@{NSParagraphStyleAttributeName:paragra} range:NSMakeRange(0,contentStr.length)];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x151515)} range:[contentStr rangeOfString:amount]];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x151515)} range:[contentStr rangeOfString:@"90"]];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x151515)} range:[contentStr rangeOfString:[item formatterCloseTimeTag:2]]];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x151515)} range:[contentStr rangeOfString:[item rangeOfYInterstRate]]];
    
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x151515),NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[contentStr rangeOfString:[item.productType isEqualToString:@"2"]?@"到期后统一结算为准":@"到期后统一结算支付"]];
    
    [_contentLabel setAttributedText:attributedStr];
}
-(void)setBtnTitles:(NSArray *)btnTitles{
    _btnTitles = btnTitles;
    [_againChose setTitle:btnTitles[0] forState:UIControlStateNormal];
    [_confirmChose setTitle:btnTitles[1] forState:UIControlStateNormal];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"尊敬的用户：";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = UIColorFromRGBValue(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:14];
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
-(UIButton *)againChose{
    if (!_againChose) {
        _againChose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_againChose addTarget:self action:@selector(rechangeChoose) forControlEvents:UIControlEventTouchUpInside];
        [_againChose setTitle:@"重新选择" forState:UIControlStateNormal];
        _againChose.titleLabel.font = [UIFont systemFontOfSize:16];
        [_againChose setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateNormal];
        _againChose.layer.masksToBounds = YES;
        _againChose.layer.cornerRadius = 5.f;
        _againChose.layer.borderColor =UIColorFromRGBValue(0xFB4D3A).CGColor;
        _againChose.layer.borderWidth = 1.f;
    }
    return _againChose;
}
-(UIButton *)confirmChose{
    if (!_confirmChose) {
        _confirmChose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmChose addTarget:self action:@selector(confirmInvest) forControlEvents:UIControlEventTouchUpInside];
        _confirmChose.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmChose setTitle:@"确认出借" forState:UIControlStateNormal];
        [_confirmChose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmChose.backgroundColor =UIColorFromRGBValue(0xFB4D3A);
        _confirmChose.layer.masksToBounds = YES;
        _confirmChose.layer.cornerRadius = 5.f;
    }
    return _confirmChose;
}
@end
