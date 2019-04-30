//
//  CRFInfoTableViewCell.m
//  crf_purse
//
//  Created by maomao on 2018/6/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFInfoTableViewCell.h"
@interface CRFInfoTableViewCell()
@property (nonatomic , strong) UILabel *mainLabel;
@property (nonatomic , strong) UILabel *nameLabel;
@end
@implementation CRFInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.mainLabel = [[UILabel alloc]init];
        self.nameLabel = [[UILabel alloc]init];
        [self addSubview:self.mainLabel];
        [self addSubview:self.nameLabel];
        
        self.mainLabel.font = [UIFont systemFontOfSize:16];
        self.mainLabel.textColor = UIColorFromRGBValue(0x666666);
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = UIColorFromRGBValue(0x999999);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(17);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainLabel.mas_right).with.mas_offset(kSpace);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(17);
            //            make.right.mas_equalTo(-kSpace);
        }];
        
        [self.mainLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}
-(void)setMainLabelStr:(NSString *)mainLabelStr{
    _mainLabelStr = mainLabelStr;
    _mainLabel.text = mainLabelStr;
}
-(void)setNameLabelStr:(NSString *)nameLabelStr{
    _nameLabelStr = nameLabelStr;
    _nameLabel.text = nameLabelStr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
