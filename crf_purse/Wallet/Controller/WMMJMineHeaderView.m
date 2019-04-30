//
//  WMMineHeaderView.m
//  WMWallet
//
//  Created by xu_cheng on 2017/6/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJMineHeaderView.h"
#import "CRFStringUtils.h"

@interface WMMJMineHeaderView()

@property (nonatomic, strong) UIButton *transformButton;
@property (nonatomic, strong) UIButton *rechargeButton;

@end

@implementation WMMJMineHeaderView

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

- (void)configView {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_bg"]];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46*kScreenWidth/75);
        make.top.left.right.equalTo(self);
    }];
    _avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 35 / 2.0;
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.avatarImageView.image = [UIImage imageNamed:@"default_header"];
    [self addSubview:self.avatarImageView];
    _nameLabel = [UILabel new];
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.numberOfLines = 0;
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
    self.secretButton.selected = YES;
    _transformButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.transformButton addTarget:self action:@selector(transformMoney) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.transformButton];
    [self.transformButton setTitle:NSLocalizedString(@"button_roll_out", nil) forState:UIControlStateNormal];
    self.transformButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.transformButton setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
    [self.transformButton setImage:[UIImage imageNamed:@"me_recharge"] forState:UIControlStateNormal];
    [self.transformButton setImage:[UIImage imageNamed:@"me_recharge"] forState:UIControlStateSelected];
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rechargeButton];
    [self.rechargeButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeButton setTitle:NSLocalizedString(@"button_recharge", nil) forState:UIControlStateNormal];
    self.rechargeButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.rechargeButton setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
    [self.rechargeButton setImage:[UIImage imageNamed:@"me_withdraw"] forState:UIControlStateNormal];
    [self.rechargeButton setImage:[UIImage imageNamed:@"me_withdraw"] forState:UIControlStateSelected];
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
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(34 * kWidthRatio + ([CRFUtils isIPhoneXAll]?30:0));
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(5);
        make.centerY.equalTo(self.avatarImageView.mas_centerY);
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.totalAmountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self);
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(5);
    }];
    [self.secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kScreenWidth / 2 + 50 );
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.totalAmountlabel.mas_centerY).with.offset(-14 * kWidthRatio);
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
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2.0, kNavHeight));
    }];
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.size.equalTo(self.transformButton);
    }];
}

- (void)setAccountInfo:(CRFAccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    [CRFAppManager defaultManager].accountInfo = _accountInfo;
    [self formatAttributedStringWithSecret:!self.secretButton.selected];
}

- (void)setUserStatus:(UserStatus)userStatus {
    _userStatus = userStatus;
    if (_userStatus == On_line) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        DLog(@"on line");
        NSString *subString = [NSString stringWithFormat:@"%@(%@)",[[CRFAppManager defaultManager].userInfo formatUserName],[[CRFAppManager defaultManager].userInfo formatMobilePhone]];
        NSString *s = nil;
        if ([CRFAppManager defaultManager].userInfo.riskLevel && [[CRFAppManager defaultManager].userInfo.riskLevel integerValue] ==1 ) {
            s = @"保守型";
        } else if ([CRFAppManager defaultManager].userInfo.riskLevel && [[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 2) {
            s = @"平衡型";
        } else if ([CRFAppManager defaultManager].userInfo.riskLevel && [[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 3) {
            s = @"进取型";
        } else {
            if ([[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 1) {
                s = @"存管账户未开通";
            } else{
                s = @"风险承受能力未评估";
            }
        }
        NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"header_evaluate_risk", nil),subString,s];
        [self.nameLabel setAttributedText:[CRFStringUtils setAttributedString:totalString lineSpace:1.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, subString.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(subString.length, totalString.length - subString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"default_header"];
        DLog(@"off line");
        [self.nameLabel setAttributedText:[CRFStringUtils setAttributedString:NSLocalizedString(@"label_login", nil) lineSpace:.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_login", nil).length) attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
        [self formatAttributedStringWithSecret:YES];
    }
}

- (void)changedSecret:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([CRFAppManager defaultManager].login && [[CRFAppManager defaultManager].userInfo.accountStatus integerValue] == 2) {
        [self formatAttributedStringWithSecret:!sender.selected];
    } else {
        [self formatAttributedStringWithSecret:YES];
    }
}

- (void)formatAttributedStringWithSecret:(BOOL)secret {
    NSString *totalSubString = secret?@"****":self.accountInfo.accountAmount;
    NSString *totalString = [NSString stringWithFormat:NSLocalizedString(@"header_total_money_off_line", nil),totalSubString];
    [self.totalAmountlabel setAttributedText:[CRFStringUtils setAttributedString:totalString lineSpace:5 * kWidthRatio attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_total_amount", nil).length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(totalString.length - totalSubString.length, totalSubString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.totalAmountlabel.textAlignment = NSTextAlignmentCenter;
    NSString *profitSubString = secret?@"****":self.accountInfo.profits;
    NSString *profitString = [NSString stringWithFormat:NSLocalizedString(@"header_profit_money_off_line", nil),profitSubString];
    [self.profitLabel setAttributedText:[CRFStringUtils setAttributedString:profitString lineSpace:3 * kWidthRatio attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_profit", nil).length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(profitString.length - profitSubString.length, profitSubString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.profitLabel.textAlignment = NSTextAlignmentCenter;
    NSString *variableSubString = secret?@"****":self.accountInfo.availableBalance;
    NSString *variableString = [NSString stringWithFormat:NSLocalizedString(@"header_variable_money_off_lone", nil),variableSubString];
    [self.variableLabel setAttributedText:[CRFStringUtils setAttributedString:variableString lineSpace:3 * kWidthRatio attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range1:NSMakeRange(0, NSLocalizedString(@"label_variable", nil).length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFFFFFF)} range2:NSMakeRange(variableString.length - variableSubString.length, variableSubString.length) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.variableLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if ([self.headerDelegate respondsToSelector:@selector(userInfo)]) {
        [self.headerDelegate userInfo];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:.0f alpha:0.1].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - (kNavHeight - 28)/2 - 28);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) - (kNavHeight - 28)/2);
    CGContextStrokePath(context);
}
-(CRFAccountInfo *)accountInfo{
    if (!_accountInfo) {
        _accountInfo = [CRFAccountInfo new];
    }
    return _accountInfo;
}

- (void)refreshImageView {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:[UIImage imageNamed:@"默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            DLog(@"failed");
        } else {
            DLog(@"success");
            self.avatarImageView.image = image;
        }
    }];
}

@end

