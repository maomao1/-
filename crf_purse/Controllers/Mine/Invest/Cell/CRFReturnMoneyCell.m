//
//  CRFReturnMoneyCell.m
//  crf_purse
//
//  Created by maomao on 2019/4/25.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import "CRFReturnMoneyCell.h"
@interface CRFReturnMoneyCell()
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *moneyLabel;
@property (nonatomic ,strong) UILabel *lineLabel;
@end
@implementation CRFReturnMoneyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.lineLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(kSpace);
            make.height.mas_equalTo(15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).with.mas_offset(10);
            make.height.mas_equalTo(13);
            make.bottom.mas_equalTo(-20);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSpace);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(15);
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
-(void)setCashModel:(CRFReceiveCashDetail *)cashModel{
    _cashModel = cashModel;
    self.timeLabel.text = _cashModel.endDate;
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",_cashModel.cashAmount];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"已收金额";
        _nameLabel.textColor = kTextDefaultColor;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _nameLabel;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.text = @"2019-07-15 11:20";
        _timeLabel.textColor = kTextEnableColor;
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLabel;
}
-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.text = @"+1000.00";
        _moneyLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
        _moneyLabel.font = CRFFONT(AkrobatZT, 14);
    }
    return _moneyLabel;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = kCellLineSeparatorColor;
    }
    return _lineLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
