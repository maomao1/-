//
//  CRFRechargeDetailCell.m
//  crf_purse
//
//  Created by maomao on 2018/8/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFRechargeDetailCell.h"
#import "CRFNewRechargeModel.h"
#import "CRFLabel.h"
@interface CRFRechargeDetailCell()
@property (nonatomic , strong) CRFLabel *titleLabel;
@property (nonatomic , strong) CRFLabel *contentLabel;
@end
@implementation CRFRechargeDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.titleLabel = [CRFLabel new];
    self.titleLabel.verticalAlignment = VerticalAlignmentTop;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = UIColorFromRGBValue(0x999999);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel = [CRFLabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.verticalAlignment = VerticalAlignmentTop;
    self.contentLabel.textColor = UIColorFromRGBValue(0x333333);
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(70);
        make.top.mas_equalTo(18);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).with.mas_offset(5);
        make.right.mas_equalTo(-kSpace);
        make.centerY.equalTo(self.mas_centerY);
        make.top.mas_equalTo(18);
    }];
}
-(void)crfSetContent:(id)item AndTitle:(NSString *)title{
    CRFNewRechargeModel *model = (CRFNewRechargeModel*)item;
    self.titleLabel.text = title;
    self.titleLabel.textColor = UIColorFromRGBValue(0x999999);
    self.contentLabel.textColor = UIColorFromRGBValue(0x333333);

    NSString *contentText;
    if ([title isEqualToString:@"充值码:"]) {
        contentText = model.chgCd;
        self.contentLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
        self.titleLabel.textColor = UIColorFromRGBValue(0xFB4D3A);
    }
    if ([title isEqualToString:@"充值金额:"]) {
        NSString* amount = [NSString stringWithFormat:@"%.2f",model.transferAmount.doubleValue/100];
//        return [NSString stringWithFormat:@"%@元",[amount formatMoney]];
        contentText = [NSString stringWithFormat:@"%@元",[amount formatMoney]];
    }
    if ([title isEqualToString:@"生成时间:"]) {
        contentText = model.chgDt;
    }
    if ([title isEqualToString:@"入账户名:"]) {
        contentText = model.fyAccNm;
    }
    if ([title isEqualToString:@"入账银行:"]) {
        contentText = model.fyBank;
    }
    if ([title isEqualToString:@"入账卡号:"]) {
        contentText = model.fyAccNo;
    }
    if ([title isEqualToString:@"支行信息:"]) {
        contentText = model.fyBankBranch;
    }
    self.contentLabel.text = contentText;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
