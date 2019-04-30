//
//  CRFCreditorTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFCreditorTableViewCell.h"


@interface CRFCreditorTableViewCell()


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *borrowLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *lastLabel;
@property (nonatomic, strong) UIImageView *idenimageView;


@end

@implementation CRFCreditorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
        [self layoutViews];
    }
    return self;
}

- (UIImageView *)idenimageView {
    if (!_idenimageView) {
        _idenimageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_accessory"]];
    }
    return _idenimageView;
}

- (void)setCreditor:(CRFCreditor *)creditor {
    _creditor = creditor;
    if (self.source == 1) {
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        self.nameLabel.text = _creditor.loanerName;
        self.moneyLabel.text = _creditor.rightAmount;
        self.borrowLabel.hidden = YES;
        self.lastLabel.hidden = YES;
        [self.idenimageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-27 * kWidthRatio);
        }];
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.idenimageView.mas_left).with.offset(-kSpace);
            make.width.mas_equalTo(300);
        }];
    } else {
        self.nameLabel.text = _creditor.borrowerName;
        self.borrowLabel.text = [_creditor formatPayTerm];
        self.moneyLabel.text = _creditor.dueinCapital;
        self.lastLabel.text = [_creditor formatDueinTerm];
    }
}

- (void)addSubviews {
    [self addSubview:self.indexLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.borrowLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.lastLabel];
    [self addSubview:self.idenimageView];
}

- (void)layoutViews {
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(17 + 20 * kWidthRatio);
        make.left.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.indexLabel.mas_right).with.offset(10 * kWidthRatio);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(80);
    }];
    [self.idenimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        CGFloat margen = 27 * kWidthRatio;
        if (kScreenWidth == 320) {
            margen = kSpace;
        }
        make.right.equalTo(self).with.offset(-margen);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.idenimageView.mas_left).with.offset(-7.5);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(35);
    }];
    
    [self.borrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.idenimageView.mas_left).with.offset(-65 * kWidthRatio);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(123 * kWidthRatio);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(100);
    }];
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [UILabel new];
        _indexLabel.textColor = UIColorFromRGBValue(0x999999);
        _indexLabel.font = [UIFont systemFontOfSize:13.0];
        _indexLabel.textAlignment = NSTextAlignmentRight;
    }
    return _indexLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = UIColorFromRGBValue(0x333333);
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _nameLabel;
}

- (UILabel *)borrowLabel {
    if (!_borrowLabel) {
        _borrowLabel = [UILabel new];
        _borrowLabel.textColor = UIColorFromRGBValue(0x333333);
        _borrowLabel.textAlignment = NSTextAlignmentRight;
        _borrowLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _borrowLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = UIColorFromRGBValue(0x333333);
        _moneyLabel.font = [CRFUtils fontWithSize:13.0];
    }
    return _moneyLabel;
}

- (UILabel *)lastLabel {
    if (!_lastLabel) {
        _lastLabel = [UILabel new];
        _lastLabel.textColor = UIColorFromRGBValue(0x333333);
        _lastLabel.textAlignment = NSTextAlignmentRight;
        _lastLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _lastLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
