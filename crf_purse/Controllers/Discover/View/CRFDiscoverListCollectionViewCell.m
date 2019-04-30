//
//  CRFDiscoverListCollectionViewCell.m
//  crf_purse
//
//  Created by maomao on 2017/8/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDiscoverListCollectionViewCell.h"
@interface CRFDiscoverListCollectionViewCell()

@property (nonatomic, strong) UIView *line;

@end
@implementation CRFDiscoverListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.line];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSpace);
            make.top.mas_equalTo(kSpace);
            make.size.mas_equalTo(CGSizeMake(105*kWidthRatio, 70*kWidthRatio));
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.bottom.equalTo(_imageView.mas_bottom);
            make.right.equalTo(_titleLabel.mas_right);
            make.height.mas_equalTo(16);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.top.mas_equalTo(kSpace);
            make.right.equalTo(self.imageView.mas_left).with.mas_offset(-kSpace);
            make.bottom.equalTo(self.timeLabel.mas_top).with.offset(-5);
        }];
       
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (CRFLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[CRFLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.verticalAlignment = VerticalAlignmentTop;
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = UIColorFromRGBValue(0x999999);
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kCellLineSeparatorColor;
    }
    return _line;
}

- (void)setTitleStr:(NSString*)titleStr {
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributes addAttribute:NSParagraphStyleAttributeName
                       value:paragraphStyle
                       range:NSMakeRange(0, titleStr.length)];
    [_titleLabel setAttributedText:attributes];
    _titleLabel.numberOfLines = 2;
}

@end
