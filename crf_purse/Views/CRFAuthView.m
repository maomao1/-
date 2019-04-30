//
//  CRFAuthView.m
//  crf_purse
//
//  Created by maomao on 2017/11/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAuthView.h"
#import "CRFLabel.h"
#import "UILabel+YBAttributeTextTapAction.h"
@interface CRFAuthView()
@property (nonatomic ,strong) UILabel   *titleLabel;
@property (nonatomic ,strong) UIView    *bgView;
@property (nonatomic ,strong) UITextView   *contentLabel;
//@property (nonatomic ,strong) CRFTextViewLabel *contentLabel
@property (nonatomic ,strong) UIButton  *closeBtn;
@property (nonatomic ,strong) UIButton  *authBtn;
@property (nonatomic ,strong) UIButton  *agreenBtn;
//@property (nonatomic ,strong) UIButton  *potocolBtn;
@property (nonatomic ,strong) CRFLabel  *potocolLabel;
@property (nonatomic ,strong)NSArray<CRFAppHomeModel *>*userInfoArr;
@property (nonatomic ,strong) NSMutableArray *nameArr;
@property (nonatomic ,strong) NSMutableArray *linkArr;
@end
@implementation CRFAuthView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentUI];
    }
    return self;
}
- (void)setContentUI{
    self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.agreenBtn];
//    [self addSubview:self.potocolBtn];
    [self addSubview:self.authBtn];
    [self addSubview:self.potocolLabel];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.mas_offset(- 20);
        make.left.mas_equalTo(70*kWidthRatio);
        make.right.mas_equalTo(-70*kWidthRatio);
        make.height.mas_equalTo(220);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLabel.mas_top).with.mas_offset(-20);
        make.left.equalTo(self.contentLabel.mas_left);
        make.height.mas_equalTo(20);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.mas_offset(-65*kWidthRatio);
        make.centerY.equalTo(self.titleLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.agreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).with.mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
//    [self.potocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.agreenBtn.mas_right).with.mas_offset(-10);
//        make.top.equalTo(self.agreenBtn.mas_top);
//        make.right.mas_equalTo(-70*kWidthRatio);
//    }];
    [self.potocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreenBtn.mas_right).with.mas_offset(-10);
        make.top.equalTo(self.agreenBtn.mas_top);
        make.right.mas_equalTo(-70*kWidthRatio);
    }];
    [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.potocolLabel.mas_bottom).with.mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).with.mas_offset(-20);
        make.bottom.equalTo(self.authBtn.mas_bottom).with.mas_offset(20);
        make.left.equalTo(self.titleLabel.mas_left).with.mas_offset(-20);
        make.right.equalTo(self.authBtn.mas_right).with.mas_equalTo(20);
    }];
}
- (void)showInView:(UIView *)view{
    self.alpha = .0f;
    
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"CRFSupervisionInfoView")]) {
            [view insertSubview:self belowSubview:subView];
        }
    }
    [UIView animateWithDuration:.1f animations:^{
        self.alpha = 1;
    }];
}
- (void)dismiss{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = .0f;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}
- (void)closeEvent{
//    [self removeFromSuperview];
    [self dismiss];
}
- (void)authEvent{
    if (!self.agreenBtn.selected) {
        if (self.nameArr.count) {
            NSString *str = [self.nameArr componentsJoinedByString:@"、"];
            [CRFUtils showMessage:[NSString stringWithFormat:@"请阅读并同意%@",str?str:@""]];
        }
        
    }else{
        if ([self.crf_delegate respondsToSelector:@selector(crf_agreeAuthBank)]) {
            [self.crf_delegate crf_agreeAuthBank];
        }
    }
}
- (void)agreeEvent:(UIButton*)btn{
    btn.selected = !btn.selected;
}
- (void)potocolEvent{
//    if ([self.crf_delegate respondsToSelector:@selector(crf_pushPotocol:)]) {
//        [self removeFromSuperview];
//        [self.crf_delegate crf_pushPotocol:self.userInfo.jumpUrl];
//    }
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"尊敬的用户：";
    }
    return _titleLabel;
}
- (UITextView *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UITextView alloc]init];
        _contentLabel.textColor = UIColorFromRGBValue(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.editable = NO;
//        _contentLabel.numberOfLines = 0;
//        _contentLabel.text = @"信而富已接入上海银行资金存管，请您立即激活您的交易结算资金管理账户。如未激活，将影响您的后续操作";
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
        [_closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_closeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    }
    return _closeBtn;
}
- (UIButton *)authBtn{
    if (!_authBtn) {
        _authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authBtn setTitle:@"同意协议并激活" forState:UIControlStateNormal];
        [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _authBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_authBtn setBackgroundColor:UIColorFromRGBValue(0xFB4D3A)];
        [_authBtn addTarget:self action:@selector(authEvent) forControlEvents:UIControlEventTouchUpInside];
        _authBtn.layer.masksToBounds = YES;
        _authBtn.layer.cornerRadius = 5;
        
    }
    return _authBtn;
}
- (UIButton *)agreenBtn{
    if (!_agreenBtn) {
        _agreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreenBtn setImage:[UIImage imageNamed:@"auth_agree_unselected"] forState:UIControlStateNormal];
        [_agreenBtn setImage:[UIImage imageNamed:@"auth_agree_selected"] forState:UIControlStateSelected];
        [_agreenBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_agreenBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_agreenBtn addTarget:self action:@selector(agreeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreenBtn;
}
//- (UIButton *)potocolBtn{
//    if (!_potocolBtn) {
//        _potocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_potocolBtn setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateNormal];
//        _potocolBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        _potocolBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        [_potocolBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_potocolBtn addTarget:self action:@selector(potocolEvent) forControlEvents:UIControlEventTouchUpInside];
////        [_potocolBtn setTitle:@"《上海银行网贷交易资金存管三方协议》" forState:UIControlStateNormal];
//        _potocolBtn.titleLabel.numberOfLines = 0;
//    }
//    return _potocolBtn;
//}
-(CRFLabel *)potocolLabel{
    if (!_potocolLabel) {
        _potocolLabel = [[CRFLabel alloc] init];
        _potocolLabel.verticalAlignment = VerticalAlignmentTop;
        _potocolLabel.textColor =UIColorFromRGBValue(0xFB4D3A);
        _potocolLabel.font = [UIFont systemFontOfSize:14.0];
        _potocolLabel.numberOfLines = 0;
    }
    return _potocolLabel;
}
- (void)crfSetContent{
    self.userInfoArr = [CRFHomeConfigHendler defaultHandler].authInfoArr;
    self.nameArr = [NSMutableArray new];
    self.linkArr = [NSMutableArray new];
    if (self.userInfoArr.count) {
        for (int i = 0; i<self.userInfoArr.count; i++) {
            CRFAppHomeModel *model = [self.userInfoArr objectAtIndex:i];
            [self.nameArr addObject:model.name];
            [self.linkArr addObject:model.jumpUrl];
            
        }
        strongSelf(self);
        NSString *potoclStr = [self.nameArr componentsJoinedByString:@"、"];
        NSMutableAttributedString *attString_potocl = [[NSMutableAttributedString alloc] initWithString:potoclStr];
        [attString_potocl addAttributes:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, potoclStr.length)];
//        self.potocolLabel.text = [self.nameArr componentsJoinedByString:@","];
        [self.potocolLabel setAttributedText:attString_potocl];
        [self.potocolLabel yb_addAttributeTapActionWithStrings:self.nameArr tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            if ([strongSelf.crf_delegate respondsToSelector:@selector(crf_pushPotocol:)]) {
                [strongSelf removeFromSuperview];
                NSString *jumpUrlStr = [self.linkArr objectAtIndex:index];
                [strongSelf.crf_delegate crf_pushPotocol:jumpUrlStr];
            }
            
        }];
//        [_potocolBtn setTitle:_userInfo.name forState:UIControlStateNormal];
        //        self.contentLabel.text = model.content;
        CRFAppHomeModel *appModel = [self.userInfoArr firstObject];
        NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc]initWithString:appModel.content];
        NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributes addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, appModel.content.length)];
        [attributes addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGBValue(0x666666)
                           range:NSMakeRange(0, appModel.content.length)];
        [attributes addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:14]
                           range:NSMakeRange(0, appModel.content.length)];
        [self.contentLabel setAttributedText:attributes];
        [self.contentLabel setScrollsToTop:YES];
        [self.contentLabel layoutIfNeeded];
        CGFloat height = [self.contentLabel.text textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 2 * 70 *kWidthRatio, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
        
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height>220?220:height);
        }];
       
        DLog(@"user info %@",appModel);
        
    }
    
}

@end
