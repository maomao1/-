//
//  CRFRollOutTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/18.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRollOutTableViewCell.h"

@interface CRFRollOutTableViewCell()



@end

@implementation CRFRollOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//    }
//    return self;
//}

- (void)initializeView {
    [super initializeView];
    _allInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allInButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_allInButton setTitle:@"全部" forState:UIControlStateNormal];
    UIColor *color = kButtonBorderNormalBackgroundColor;
    [_allInButton setTitleColor:color forState:UIControlStateNormal];
    [self addSubview:self.allInButton];
    self.allInButton.layer.masksToBounds = YES;
    self.allInButton.layer.cornerRadius = 14.0f;
    self.allInButton.layer.borderWidth = 1.0f;
    self.allInButton.layer.borderColor = color.CGColor;
    [self.allInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-kSpace);
        make.size.mas_equalTo(CGSizeMake(52, 28));
    }];
    [self.allInButton addTarget:self action:@selector(allIn) forControlEvents:UIControlEventTouchUpInside];
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150 * kWidthRatio);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 85 - 70);
    }];
}

- (void)allIn {
    if (self.allInHandler) {
        self.allInHandler();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
