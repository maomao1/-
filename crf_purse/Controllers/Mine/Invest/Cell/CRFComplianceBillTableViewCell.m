//
//  CRFComplianceBillTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/11/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFComplianceBillTableViewCell.h"
#import "CRFStringUtils.h"

@interface CRFComplianceBillTableViewCell ()

@property (nonatomic, strong) UILabel *currentEstimateLabel;

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation CRFComplianceBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _currentEstimateLabel = [UILabel new];
    _currentEstimateLabel.font = [CRFUtils fontWithSize:14.0];
    _currentEstimateLabel.textColor = UIColorFromRGBValue(0x333333);
    [self addSubview:self.currentEstimateLabel];
    _valueLabel = [UILabel new];
    _valueLabel.textAlignment = NSTextAlignmentRight;
    _valueLabel.font = [CRFUtils fontWithSize:14.0];
    _valueLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    [self addSubview:_valueLabel];
    [self.currentEstimateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self).with.offset(kSpace);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.right.equalTo(self).with.offset(-kSpace);
    }];
}

- (void)configTitle:(NSString *)title value:(NSString *)value {
    self.currentEstimateLabel.text = title;
    if (self.hasAttributed) {
        [self.valueLabel setAttributedText:[CRFStringUtils setAttributedString:value highlightText:@"至" highlightColor:UIColorFromRGBValue(0x666666)]];
        [self.valueLabel setTextAlignment:NSTextAlignmentRight];
    } else {
        self.valueLabel.text = value;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
