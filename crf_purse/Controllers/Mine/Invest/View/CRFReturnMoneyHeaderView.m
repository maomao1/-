//
//  CRFReturnMoneyHeaderView.m
//  crf_purse
//
//  Created by maomao on 2019/4/25.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import "CRFReturnMoneyHeaderView.h"
#import "CRFStringUtils.h"
@interface CRFReturnMoneyHeaderView()
@property (nonatomic , strong) UILabel *totalMoneyLabel;
@property (nonatomic , strong) UILabel *receiveMoneylabel;
@property (nonatomic , strong) UILabel *lineLabel;
@end
@implementation CRFReturnMoneyHeaderView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.totalMoneyLabel];
        [self addSubview:self.receiveMoneylabel];
        [self addSubview:self.lineLabel];
        [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.equalTo(self);
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(kSpace/2);
        }];
        [self.receiveMoneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(self.totalMoneyLabel.mas_bottom).with.mas_offset(32);
        }];
    }
    return self;
}
-(void)setCashModel:(CRFReceiveCashModel *)cashModel{
    if (!cashModel) {
        return;
    }
    _cashModel = cashModel;
    NSString *totalStr = [NSString stringWithFormat:@"%@\n%@",_cashModel.uncollectedcash,@"待收金额（元）"];
    [self.totalMoneyLabel setAttributedText:[CRFStringUtils setAttributedString:totalStr lineSpace:5 attributes1:@{NSFontAttributeName:CRFFONT(AkrobatZT, 22),NSForegroundColorAttributeName:UIColorFromRGBValue(0xfb4d3a)} range1:[totalStr rangeOfString:_cashModel.uncollectedcash] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    _totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    NSString *receiveStr = [NSString stringWithFormat:@"%@%@元",@"已收金额：",_cashModel.receivedcash];
    [self.receiveMoneylabel setAttributedText:[CRFStringUtils setAttributedString:receiveStr lineSpace:5 attributes1:@{NSFontAttributeName:CRFFONT(AkrobatZT, 14),NSForegroundColorAttributeName:kTextDefaultColor} range1:[receiveStr rangeOfString:_cashModel.receivedcash] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
}
-(UILabel *)totalMoneyLabel{
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [UILabel new];
        _totalMoneyLabel.text = @"待收金额（元）";
        _totalMoneyLabel.numberOfLines = 0;
        _totalMoneyLabel.textColor = kTextEnableColor;
        _totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _totalMoneyLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _totalMoneyLabel;
}
-(UILabel *)receiveMoneylabel{
    if (!_receiveMoneylabel) {
        _receiveMoneylabel = [UILabel new];
        _receiveMoneylabel.text = @"已收金额：";
        _receiveMoneylabel.textAlignment = NSTextAlignmentCenter;
        _receiveMoneylabel.textColor = kTextEnableColor;
        _receiveMoneylabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _receiveMoneylabel;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    }
    return _lineLabel;
}
@end
