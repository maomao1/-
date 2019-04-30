//
//  CRFVersionTabCell.m
//  crf_purse
//
//  Created by maomao on 2017/8/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFVersionTableViewCell.h"
#import "CRFUtils.h"
@interface CRFVersionTableViewCell()
@property (nonatomic , strong) CRFLabel * countLabel;
@property (nonatomic ,strong)  CRFLabel * contentLabel;
@end
@implementation CRFVersionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self addSubview:self.countLabel];
    [self addSubview:self.contentLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
//        make.width.mas_lessThanOrEqualTo(52*kWidthRatio);
        make.width.mas_equalTo(52*kWidthRatio);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).with.mas_offset(2);
        make.top.equalTo(self.countLabel.mas_top);
        make.right.mas_equalTo(-kSpace);
        make.bottom.mas_equalTo(-5);
    }];
}
- (void)setContentForModel:(CRFVersionContentModel *)item{
    _countLabel.text = item.title;
    _contentLabel.text = item.content;
    CGFloat width = [item.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) fontNumber:20].width;
    if (item.title.length) {
        [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countLabel.mas_right).with.mas_offset(2);
        }];
    }else{
        [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countLabel.mas_right).with.mas_offset(0);
        }];
    }
}
- (CRFLabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [CRFLabel new];
        _countLabel.textColor = UIColorFromRGBValue(0x666666);
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        _countLabel.numberOfLines = 1;
        _countLabel.verticalAlignment = VerticalAlignmentTop;
        
    }
    return _countLabel;
}
- (CRFLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [CRFLabel new];
        _contentLabel.textColor = UIColorFromRGBValue(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.verticalAlignment = VerticalAlignmentTop;

    }
    return _contentLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
