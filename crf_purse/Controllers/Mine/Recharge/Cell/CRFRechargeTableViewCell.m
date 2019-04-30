//
//  CRFRechargeTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/17.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRechargeTableViewCell.h"

@interface CRFRechargeTableViewCell()

@property (nonatomic, strong) UILabel *line;

@end

@implementation CRFRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = kCellLineSeparatorColor;
    }
    return _line;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = kCellTitleTextColor;
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.font = [UIFont systemFontOfSize:16.0];
        _textField.textColor = kTextDefaultColor;
        _textField.tintColor = kButtonNormalBackgroundColor;
    }
    return _textField;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.line];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(kSpace);
        
//        make.width.mas_greaterThanOrEqualTo(20);
                make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(kSpace);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(kScreenWidth - 3 * kSpace - CGRectGetWidth(self.titleLabel.frame));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.left.equalTo(self).with.offset(kSpace);
        make.height.mas_equalTo(1);
    }];
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    self.textField.enabled = _edit;
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = _hiddenLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
