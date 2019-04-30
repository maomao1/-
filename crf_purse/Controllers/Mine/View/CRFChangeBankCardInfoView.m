//
//  CRFChangeBankCardInfoView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFChangeBankCardInfoView.h"
#import "CRFStringUtils.h"
#import "CRFLabel.h"
@interface CRFChangeBankCardInfoView ()


@end

@implementation CRFChangeBankCardInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    [self addSubview:self.bankBgImg];
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    CRFLabel *cardNoLabel = [CRFLabel new];
    cardNoLabel.font = [UIFont systemFontOfSize:18];
    cardNoLabel.verticalAlignment = VerticalAlignmentTop;
    //    cardNoLabel.font = [self getFont];
    cardNoLabel.numberOfLines = 0;
    cardNoLabel.textColor = UIColorFromRGBValue(0xffffff);
    [self addSubview:cardNoLabel];
    NSString *cardIDString = [NSString stringWithFormat:@"%@\n%@",[userInfo.bankCode getBankCode].bankName,userInfo.openBankCardNo];
    [cardNoLabel setAttributedText:[CRFStringUtils setAttributedString:cardIDString lineSpace:5 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range1:[cardIDString rangeOfString:[NSString stringWithFormat:@"%@",[userInfo.bankCode getBankCode].bankName]] attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range2:[cardIDString rangeOfString:[NSString stringWithFormat:@"%@",userInfo.openBankCardNo]] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    //    cardNoLabel.text = cardIDString;
    //
    
    
    CRFLabel *userNameLabel = [CRFLabel new];
    userNameLabel.font = [self getFont];
    userNameLabel.verticalAlignment =VerticalAlignmentBottom;
    userNameLabel.backgroundColor = [UIColor whiteColor];
    userNameLabel.textColor = UIColorFromRGBValue(0x333333);
    [self addSubview:userNameLabel];
    NSString *userNameString = [NSString stringWithFormat:@"     户      名：  %@",[userInfo formatChangeBankCardUserName]];
    [userNameLabel setAttributedText:[CRFStringUtils setAttributedString:userNameString lineSpace:0 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[userNameString rangeOfString:[userInfo formatChangeBankCardUserName]] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    UILabel *userIDLabel = [UILabel new];
    userIDLabel.font = [self getFont];
    userIDLabel.textColor = UIColorFromRGBValue(0x333333);
    [self addSubview:userIDLabel];
    NSString *userIdString = [NSString stringWithFormat:@"     身 份 证 ：  %@",[CRFAppManager defaultManager].userInfo.idNo];
    [userIDLabel setAttributedText:[CRFStringUtils setAttributedString:userIdString lineSpace:0 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[userIdString rangeOfString:userInfo.idNo] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [_bankBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(120*kWidthRatio);
    }];
    [cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(75 *kWidthRatio);
        make.top.mas_equalTo(18);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(70);
    }];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardNoLabel);
        make.left.mas_equalTo(0);
        make.bottom.equalTo(self.bankBgImg.mas_bottom).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    [userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(userNameLabel);
        make.height.mas_equalTo(30);
        make.top.equalTo(userNameLabel.mas_bottom).with.offset(5);
    }];
}
- (UIFont *)getFont {
    if (kScreenWidth == 320) {
        return [UIFont systemFontOfSize:13.0];
    }
    return [UIFont systemFontOfSize:14.0];
}
-(UIImageView *)bankBgImg{
    if (!_bankBgImg) {
        _bankBgImg = [[UIImageView alloc]init];
        _bankBgImg.contentMode = UIViewContentModeScaleToFill;
    }
    return _bankBgImg;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
