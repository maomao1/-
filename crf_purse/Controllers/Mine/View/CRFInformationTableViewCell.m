//
//  CRFInformationTableViewCell.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInformationTableViewCell.h"

@interface CRFInformationTableViewCell()
@property (nonatomic, strong) UIImageView *authImageView;

@end

@implementation CRFInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 35 / 2.0f;
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.textColor = UIColorFromRGBValue(0x333333);
    self.contentlabel.textColor = UIColorFromRGBValue(0x666666);
    self.contentlabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createImageView {
    _authImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_already_auth"]];
    _authImageView.hidden = YES;
    [self addSubview:self.authImageView];
    [self.authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-kSpace);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)setAlreadyAuth:(BOOL)alreadyAuth {
    self.authImageView.hidden = !alreadyAuth;
}

@end
