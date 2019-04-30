//
//  CRFMineHeaderView.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMineHeaderView.h"
#import "CRFStringUtils.h"
#import "UIImage+Color.h"
@interface CRFMineHeaderView()

@property (nonatomic, strong) UIButton *transformButton;
@property (nonatomic, strong) UIButton *rechargeButton;
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *explainBtn;
@property (nonatomic, strong) UIButton    *evalueTypeBtn;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *lineImage;


@end

@implementation CRFMineHeaderView

@synthesize accountInfo =_accountInfo;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configView];
        [self layoutViews];
        
        [self formatAttributedStringWithSecret:YES];
    }
    return self;
}

- (void)resourceDidUpdate {
    self.bgImageView.image = [CRFUtils loadImageResource:@"new_mine_header_bg"];
}

- (void)configView {
    self.bgImageView = [[UIImageView alloc] initWithImage:[CRFUtils loadImageResource:@"new_mine_header_bg"]];
    [self addSubview:self.bgImageView];
    self.lineImage = [[UIImageView alloc] initWithImage:[CRFUtils loadImageResource:@"new_mine_line"]];
    [self addSubview:self.lineImage];
//    self.imageView = bgImageView;
    _avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 35 / 2.0;
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.avatarImageView.image = [UIImage imageNamed:@"default_header"];
    [self addSubview:self.avatarImageView];
    _nameLabel = [UILabel new];
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.nameLabel.textColor = UIColorFromRGBValue(0xffffff);
    self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.numberOfLines = 0;
    
    [self addSubview:self.explainBtn];
    [self addSubview:self.evalueTypeBtn];
    
    [self addSubview:self.nameLabel];
    _totalAmountlabel = [UILabel new];
    self.totalAmountlabel.numberOfLines = 0;
    [self addSubview:self.totalAmountlabel];
    _profitLabel = [UILabel new];
    self.profitLabel.numberOfLines = 0;
    [self addSubview:self.profitLabel];
    _variableLabel = [UILabel new];
    self.variableLabel.numberOfLines = 0;
    [self addSubview:self.variableLabel];
    _secretButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_secretButton setImage:[UIImage imageNamed:@"mine_secret"] forState:UIControlStateNormal];
    [_secretButton setImage:[UIImage imageNamed:@"mine_unsecret"] forState:UIControlStateSelected];
    [_secretButton addTarget:self action:@selector(changedSecret:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.secretButton];
    if ([CRFAppManager defaultManager].login) {
        self.secretButton.selected = [CRFUserDefaultManager getUserAccountSecret];
    }
//    self.secretButton.selected = YES;
    _transformButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.transformButton addTarget:self action:@selector(transformMoney) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.transformButton];
    [self.transformButton setTitle:NSLocalizedString(@"button_roll_out", nil) forState:UIControlStateNormal];
    self.transformButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.transformButton setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateNormal];
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rechargeButton];
    [self.rechargeButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeButton setTitle:NSLocalizedString(@"button_recharge", nil) forState:UIControlStateNormal];
    self.rechargeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.rechargeButton setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateNormal];

    self.transformButton.layer.masksToBounds = YES;
    self.transformButton.layer.cornerRadius = 18.0f;
    self.transformButton.layer.borderColor  = UIColorFromRGBValue(0xffffff).CGColor;
    self.transformButton.layer.borderWidth = 1;
    
    self.rechargeButton.layer.masksToBounds = YES;
    self.rechargeButton.layer.cornerRadius = 18.0f;
    self.rechargeButton.layer.borderColor  = UIColorFromRGBValue(0xffffff).CGColor;
    self.rechargeButton.layer.borderWidth = 1;
//    [self loadImage];
}

- (void)transformMoney {
    if ([self.headerDelegate respondsToSelector:@selector(userTransform)]) {
        [self.headerDelegate userTransform];
    }
}

- (void)recharge {
    if ([self.headerDelegate respondsToSelector:@selector(userRecharge)]) {
        [self.headerDelegate userRecharge];
    }
}

- (void)layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(285 * kWidthRatio);
        make.bottom.top.left.right.equalTo(self);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(40 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSpace);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(68);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(5);
        make.top.equalTo(self.avatarImageView.mas_top);
//        make.right.mas_equalTo(self.explainBtn.mas_left).with.mas_offset(-5);
        make.height.mas_equalTo(20);
    }];
    [self.evalueTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).with.mas_offset(2);
        make.height.mas_equalTo(18);
    }];
    [self.totalAmountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(60* kWidthRatio);
        make.left.right.equalTo(self);
        make.top.equalTo(self.avatarImageView.mas_bottom).with.mas_offset(15);
    }];
    [self.secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kScreenWidth / 2 + 50 );
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.totalAmountlabel.mas_top).with.offset(2);
    }];
    [self.variableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(30 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2 - 20 * kWidthRatio, 50* kWidthRatio));
        make.top.equalTo(self.totalAmountlabel.mas_bottom).with.offset(3 * kWidthRatio);
    }];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-30 * kWidthRatio);
        make.size.equalTo(self.variableLabel);
        make.top.equalTo(self.variableLabel);
    }];
    [self.transformButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).with.mas_offset(-35);
        make.left.mas_equalTo((kScreenWidth-180)/4);
        make.size.mas_equalTo(CGSizeMake(90, 36));
    }];
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.transformButton.mas_top);
        make.right.mas_equalTo(-(kScreenWidth-180)/4);
        make.size.equalTo(self.transformButton);
    }];
    
    [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(1);
        make.centerY.equalTo(self.rechargeButton.mas_centerY);
        make.top.equalTo(self.rechargeButton.mas_top).with.mas_offset(4);
    }];
    
}

- (void)setAccountInfo:(CRFAccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    self.secretButton.selected = [CRFUserDefaultManager getUserAccountSecret];
    [CRFAppManager defaultManager].accountInfo = _accountInfo;
    [self formatAttributedStringWithSecret:!self.secretButton.selected];
}

- (void)setUserStatus:(UserStatus)userStatus {
    _userStatus = userStatus;
    if (_userStatus == On_line) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:[UIImage imageNamed:@"login_default_avatar"]];
        DLog(@"on line");
        NSString *subString = [NSString stringWithFormat:@"%@(%@)",[[CRFAppManager defaultManager].userInfo formatUserName],[[CRFAppManager defaultManager].userInfo formatMobilePhone]];
        
        NSString *s = nil;
        if ([CRFAppManager defaultManager].userInfo.riskLevel && [[CRFAppManager defaultManager].userInfo.riskLevel integerValue] ==1 ) {
            s = @" 保守型 ";
        } else if ([CRFAppManager defaultManager].userInfo.riskLevel && [[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 2) {
            s = @" 平衡型 ";
        } else if ([CRFAppManager defaultManager].userInfo.riskLevel && [[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 3) {
            s = @" 进取型 ";
        } else {
            if (![CRFAppManager defaultManager].accountStatus) {
                 s = @" 存管账户未开通 ";
            } else{
              s = @" 风险承受能力未评估> ";
            }
        }
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).with.offset(5);
            make.top.equalTo(self.avatarImageView.mas_top);
            make.right.mas_equalTo(self.explainBtn.mas_left).with.mas_offset(-5);
            make.height.mas_equalTo(16);
        }];
        [self.evalueTypeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).with.mas_offset(2);
            make.height.mas_equalTo(16);
        }];
        self.nameLabel.text = subString;
        [self.evalueTypeBtn setTitle:s forState:UIControlStateNormal];
        [self layoutIfNeeded];
        [self setBtnBgImageColor:self.evalueTypeBtn.frame];

    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"default_header"];
        DLog(@"off line");
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).with.offset(5);
            make.centerY.equalTo(self.avatarImageView.mas_centerY);
            make.right.mas_equalTo(self.explainBtn.mas_left).with.mas_offset(-5);
            make.height.mas_equalTo(20);
        }];
        [self.evalueTypeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).with.mas_offset(2);
            make.height.mas_equalTo(0);
        }];
        self.nameLabel.text =NSLocalizedString(@"label_login", nil);
//        [self.nameLabel setAttributedText:[CRFStringUtils setAttributedString:NSLocalizedString(@"label_login", nil) lineSpace:.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_login", nil).length) attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self formatAttributedStringWithSecret:YES];
    }
}
-(void)setBtnBgImageColor:(CGRect)frame{
    NSMutableArray *colorArray = [@[UIColorFromRGBValue(0xF8D64A),
                                    UIColorFromRGBValue(0xFFB540)] mutableCopy];
    UIImage *bgImg = [UIImage bgImageFromColors:colorArray withFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width/2, frame.size.height)];
    [_evalueTypeBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    [_evalueTypeBtn setBackgroundImage:bgImg forState:UIControlStateSelected];
}
- (void)changedSecret:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([CRFAppManager defaultManager].login) {
        [CRFUserDefaultManager setUserAccountSecret:sender.selected];
    }
    if ([CRFAppManager defaultManager].login && [CRFAppManager defaultManager].accountStatus) {
        [self formatAttributedStringWithSecret:!sender.selected];
    } else {
        [self formatAttributedStringWithSecret:YES];
    }
}

- (void)formatAttributedStringWithSecret:(BOOL)secret {
    NSString *totalSubString = secret?@"****":self.accountInfo.accountAmount;
    NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"header_total_money_off_line", nil),totalSubString];
    [self.totalAmountlabel setAttributedText:[CRFStringUtils setAttributedString:totalString lineSpace:3 * kWidthRatio attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_total_amount", nil).length) attributes2:@{NSFontAttributeName:CRFFONT(AkrobatZT, 24),NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(totalString.length - totalSubString.length, totalSubString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.totalAmountlabel.textAlignment = NSTextAlignmentCenter;
     NSString *profitSubString = secret?@"****":self.accountInfo.profits;
    NSString *profitString = [NSString stringWithFormat:NSLocalizedString(@"header_profit_money_off_line", nil),profitSubString];
    [self.profitLabel setAttributedText:[CRFStringUtils setAttributedString:profitString lineSpace:3 * kWidthRatio attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_profit", nil).length) attributes2:@{NSFontAttributeName:CRFFONT(AkrobatZT, 18),NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(profitString.length - profitSubString.length, profitSubString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.profitLabel.textAlignment = NSTextAlignmentCenter;
    NSString *variableSubString = secret?@"****":self.accountInfo.availableBalance;
    NSString *variableString = [NSString stringWithFormat:NSLocalizedString(@"header_variable_money_off_lone", nil),variableSubString];
    [self.variableLabel setAttributedText:[CRFStringUtils setAttributedString:variableString lineSpace:3 * kWidthRatio attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_variable", nil).length) attributes2:@{NSFontAttributeName:CRFFONT(AkrobatZT, 18),NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(variableString.length - variableSubString.length, variableSubString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.variableLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if ([self.headerDelegate respondsToSelector:@selector(userInfo)]) {
        [self.headerDelegate userInfo];
    }
}
-(void)explainEvent{
    if ([self.headerDelegate respondsToSelector:@selector(explainHelpView)]) {
        [self.headerDelegate explainHelpView];
    }
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:0.1].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 18 - 28);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - 18);
    CGContextStrokePath(context);
}
- (CRFAccountInfo *)accountInfo{
    if (!_accountInfo) {
        _accountInfo = [CRFAccountInfo new];
    }
    return _accountInfo;
}

- (void)refreshImageView {
    NSString *imageStr;
    if ([CRFAppManager defaultManager].login) {
        imageStr = @"login_default_avatar";
    }else{
        imageStr = @"default_header";
    }
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:[UIImage imageNamed:imageStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            DLog(@"failed");
        } else {
            DLog(@"success");
            self.avatarImageView.image = image;
        }
    }];
}
-(UIButton *)evalueTypeBtn{
    if (!_evalueTypeBtn) {
        _evalueTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_evalueTypeBtn setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateNormal];
        [_evalueTypeBtn setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateSelected];
        [_evalueTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
        _evalueTypeBtn.layer.masksToBounds = YES;
        _evalueTypeBtn.layer.cornerRadius = 8.0f;
        
    }
    return _evalueTypeBtn;
}
-(UIButton *)explainBtn{
    if (!_explainBtn) {
        _explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_explainBtn setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateNormal];
        [_explainBtn setTitleColor:UIColorFromRGBValue(0xffffff) forState:UIControlStateSelected];
        [_explainBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_explainBtn setTitle:@" 金额说明" forState:UIControlStateNormal];
        [_explainBtn setTitle:@" 金额说明" forState:UIControlStateSelected];
        [_explainBtn setImage:[UIImage imageNamed:@"new_mine_jine"] forState:UIControlStateNormal];
        [_explainBtn setImage:[UIImage imageNamed:@"new_mine_jine"] forState:UIControlStateSelected];
        [_explainBtn addTarget:self action:@selector(explainEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _explainBtn;
}
@end
