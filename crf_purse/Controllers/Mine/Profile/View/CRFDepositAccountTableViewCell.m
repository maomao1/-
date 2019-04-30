//
//  CRFDepositAccountTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDepositAccountTableViewCell.h"

@interface CRFDepositAccountTableViewCell()

@property (nonatomic, strong) UILabel *line;

@end

@implementation CRFDepositAccountTableViewCell

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = UIColorFromRGBValueAndalpha(0x000000, .1f);
    }
    return _line;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kCellTitleTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
         _detailLabel.textColor = kCellDetailTextColor;
        _detailLabel.textAlignment = NSTextAlignmentRight;
         _detailLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _detailLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(kScreenWidth / 2.0);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-36);
        make.top.bottom.equalTo(self.titleLabel);
        make.width.mas_equalTo(kScreenWidth / 2.0);
    }];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.bottom.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = _hiddenLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect adjustedFrame = self.accessoryView.frame;
    adjustedFrame.origin.x += 3.0f;
    self.accessoryView.frame = adjustedFrame;
}

@end
