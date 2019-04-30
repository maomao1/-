//
//  CRFManagerDeviceCell.m
//  crf_purse
//
//  Created by maomao on 2017/9/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFManagerDeviceTableViewCell.h"
@interface CRFManagerDeviceTableViewCell()
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *timeLabel;

@end
@implementation CRFManagerDeviceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.hasAccessoryView = YES;
    }
    return self;
}
- (void)setUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSpace);
        make.left.mas_equalTo(kSpace);
        make.height.mas_equalTo(15);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.mas_offset(6);
        make.left.equalTo(_titleLabel.mas_left);
        make.height.mas_equalTo(13);
    }];
    
}
- (void)crfSetContent:(CRFBindDevicesModel*)model{
    NSString *titleText;
    if ([model.deviceNo isEqualToString:[CRFAppManager defaultManager].clientInfo.deviceId]) {
        titleText = [NSString stringWithFormat:@"%@ 【本机】",model.deviceName];
    }else{
        titleText = model.deviceName;
    }
    _titleLabel.text = titleText;
    _timeLabel.text  =[NSString stringWithFormat:@"%@ %@",[CRFTimeUtil formatLongTime:model.updateTime.longLongValue pattern:@"YYYY-MM-dd HH:mm:ss"],model.model];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.font      = [UIFont systemFontOfSize:16.0f];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor  = UIColorFromRGBValue(0x888888);
        _timeLabel.font       = [UIFont systemFontOfSize:14.0f];
    }
    return _timeLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
