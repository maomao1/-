//
//  CRFMessageCell.m
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMessageTableViewCell.h"
#import "UIImage+Color.h"
@interface CRFMessageTableViewCell()
@property (strong, nonatomic)  UILabel *mesContentLabel;
@property (strong, nonatomic)  UILabel *mesTimeLabel;
@property (strong, nonatomic)  UILabel *mesTitleLabel;
@property (strong, nonatomic)  UIImageView *messageStatusImg;
//bankcell  item
@property (strong, nonatomic)  UILabel *bankNameLabel;///<银行名字
@property (strong, nonatomic)  UILabel *bankSingleLabel;///<单笔限额
@property (strong, nonatomic)  UILabel *bankDayLabel;///<单日限额
@property (strong, nonatomic)  UILabel *bankMonthLabel;///<单月限额
@property (strong, nonatomic)  UIImageView *bankIconImg;///<银行图标

@end
@implementation CRFMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([reuseIdentifier isEqualToString:CRFMessageCell_Identifier]) {
            [self setMessageCellUI];
        }else if([reuseIdentifier isEqualToString:CRFRecordCell_Identifier]){
            [self setRecordCellUI];
        }else{
            [self setBankCellUI];
        }
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            continue;
        }
        for (UIView * subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
            
            UIImageView *imageView = (UIImageView *)subView;
            if (self.selected||self.highlighted) {
                // KVC修改
                imageView.image = [UIImage imageNamed:@"message_selected"]; // 选中时的图片
            }
        }
    }
}
- (void)setBankCellUI{
    [self addSubview:self.bankIconImg];
    [self addSubview:self.bankNameLabel];
    [self addSubview:self.bankSingleLabel];
    [self addSubview:self.bankDayLabel];
    [self addSubview:self.bankMonthLabel];
    
    [self.bankIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(kSpace);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    CGFloat itemWidth = (kScreenWidth )/4.4f;
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankIconImg.mas_right).with.mas_offset(6);
        make.width.mas_equalTo(itemWidth*1.4-kSpace-6-22);
        make.centerY.equalTo(self.bankIconImg.mas_centerY);
    }];
    [self.bankSingleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankIconImg.mas_centerY);
        make.left.mas_equalTo(itemWidth*1.4);
        make.width.mas_equalTo(itemWidth);
    }];
    [self.bankDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankIconImg.mas_centerY);
        make.left.equalTo(self.bankSingleLabel.mas_right).with.mas_offset(0);
        make.width.mas_equalTo(itemWidth);
    }];
    [self.bankMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankIconImg.mas_centerY);
        make.left.equalTo(self.bankDayLabel.mas_right).with.mas_offset(0);
        make.width.mas_equalTo(itemWidth);
    }];

}
- (void)setRecordCellUI{
    [self addSubview:self.mesTimeLabel];
    [self addSubview:self.mesTitleLabel];
    [self addSubview:self.mesContentLabel];
    self.mesContentLabel.textAlignment = NSTextAlignmentRight;
    self.mesTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.mesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.top.mas_equalTo(kSpace);
        make.height.mas_equalTo(kSpace);
    }];
    [self.mesTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mesTitleLabel.mas_left);
        make.top.equalTo(self.mesTitleLabel.mas_bottom).with.mas_offset(10);
        make.bottom.mas_equalTo(-kSpace);
    }];
    [self.mesContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_equalTo(-kSpace);
        make.left.equalTo(self.mesTimeLabel.mas_right).with.mas_offset(kSpace);
        make.height.mas_equalTo(kSpace);
    }];
}
- (void)setMessageCellUI{
    [self.contentView addSubview:self.messageStatusImg];
    [self.contentView addSubview:self.mesTimeLabel];
    [self.contentView addSubview:self.mesTitleLabel];
    [self.contentView addSubview:self.mesContentLabel];
    [self.messageStatusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.left.mas_equalTo(kSpace);
        make.top.mas_equalTo(21);
    }];
    [self.mesTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(130);
    }];
    [self.mesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.equalTo(self.messageStatusImg.mas_right).with.mas_offset(10);
        make.height.mas_equalTo(15);
        make.right.equalTo(self.mesTimeLabel.mas_left).with.mas_offset(-5);
    }];
    [self.mesContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.top.equalTo(self.mesTitleLabel.mas_bottom).with.mas_offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(13);
    }];
}
- (void)crfSetContent:(id)item{
    if ([item isKindOfClass:[CRFMessageModel class]]) {
        CRFMessageModel *model = item;
        self.mesTitleLabel.text = model.subject;
        self.mesTimeLabel.text  = [CRFTimeUtil formatLongTime:model.pushTime.longLongValue pattern:@"yyyy-MM-dd HH:mm"];
        self.mesContentLabel.text = model.content;
       
        if ([model.isRead isEqualToString:@"2"]) {
            [self.messageStatusImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            self.isRead = YES;
            [self.mesTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageStatusImg.mas_right);
            }];
        } else {
            self.isRead = NO;
            [self.messageStatusImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(8, 8));
            }];
            [self.mesTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageStatusImg.mas_right).with.offset(10);
            }];
        }
    }else if ([item isKindOfClass:[CRFActivity class]]){
        self.isRead = YES;
        CRFActivity *model = item;
        self.mesTitleLabel.text = model.title;
        self.mesTimeLabel.text  = [CRFTimeUtil formatLongTime:model.publicTime.longLongValue pattern:@"yyyy-MM-dd HH:mm"];
        self.mesContentLabel.text = model.content;
//        if ([model.isRead isEqualToString:@"2"]) {
            [self.messageStatusImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [self.mesTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageStatusImg.mas_right);
            }];
//        }
    }
    
}
- (void)crfSetRecordCellContent:(CRFCashRecordModel *)item{
    self.mesTitleLabel.text = item.title;
    self.mesTimeLabel.text  = item.jyTime;
    self.mesContentLabel.text = item.amount;
}

- (void)setIsRead:(BOOL)isRead {
    _isRead = isRead;
    self.mesTitleLabel.font = _isRead?[UIFont systemFontOfSize:16.0]:[UIFont boldSystemFontOfSize:16.0];
}

- (void)crfSetBankCellContent:(CRFBankListModel*)item{
    self.bankNameLabel.text = item.bankName;
    [self.bankIconImg sd_setImageWithURL:[NSURL URLWithString:item.bankUrl] placeholderImage:[UIImage imageNamed:@"bank_icon_default"] completed:nil];
    self.bankSingleLabel.text = item.bankSigle;
    self.bankDayLabel.text = item.bankDay;
    self.bankMonthLabel.text = item.bankMonth;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (UILabel *)mesContentLabel{
    if (!_mesContentLabel) {
        _mesContentLabel = [[UILabel alloc]init];
        _mesContentLabel.font = [UIFont systemFontOfSize:14.0f];
        _mesContentLabel.textColor = UIColorFromRGBValue(0x888888);
        _mesContentLabel.numberOfLines = 1;
        _mesContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _mesContentLabel;
}
- (UILabel *)mesTitleLabel{
    if (!_mesTitleLabel) {
        _mesTitleLabel = [[UILabel alloc]init];
        _mesTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        _mesTitleLabel.textColor = UIColorFromRGBValue(0x333333);
        _mesTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _mesTitleLabel;
}
- (UILabel *)mesTimeLabel{
    if (!_mesTimeLabel) {
        _mesTimeLabel = [[UILabel alloc]init];
        _mesTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _mesTimeLabel.textColor = UIColorFromRGBValue(0x666666);
        _mesTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _mesTimeLabel;
}
- (UIImageView*)messageStatusImg{
    if (!_messageStatusImg) {
        _messageStatusImg = [[UIImageView alloc]init];
        _messageStatusImg.image = [UIImage imageWithColor:UIColorFromRGBValue(0xFB4D3A)];
//        _messageStatusImg.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
        _messageStatusImg.layer .masksToBounds = YES;
        _messageStatusImg.layer.cornerRadius   = 4.f;
    }
    return _messageStatusImg;
}
//bankcell item
- (UIImageView *)bankIconImg{
    if (!_bankIconImg) {
        _bankIconImg = [[UIImageView alloc]init];
        _bankIconImg.image = [UIImage imageNamed:@"bank_icon_default"];
    }
    return _bankIconImg;
}
- (UILabel *)bankDayLabel{
    if (!_bankDayLabel) {
        _bankDayLabel = [[UILabel alloc]init];
        _bankDayLabel.font = [UIFont systemFontOfSize:15*kWidthRatio];
        _bankDayLabel.textColor = UIColorFromRGBValue(0x333333);
        _bankDayLabel.numberOfLines = 0;
        _bankDayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bankDayLabel;
}
- (UILabel *)bankNameLabel{
    if (!_bankNameLabel) {
        _bankNameLabel = [[UILabel alloc]init];
        _bankNameLabel.font = [UIFont systemFontOfSize:15*kWidthRatio];
        _bankNameLabel.textColor = UIColorFromRGBValue(0x333333);
        _bankNameLabel.numberOfLines = 0;
        _bankNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bankNameLabel;
}
- (UILabel *)bankMonthLabel{
    if (!_bankMonthLabel) {
        _bankMonthLabel = [[UILabel alloc]init];
        _bankMonthLabel.font = [UIFont systemFontOfSize:15*kWidthRatio];
        _bankMonthLabel.textColor = UIColorFromRGBValue(0x333333);
        _bankMonthLabel.numberOfLines = 0;
        _bankMonthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bankMonthLabel;
}
- (UILabel *)bankSingleLabel{
    if (!_bankSingleLabel) {
        _bankSingleLabel = [[UILabel alloc]init];
        _bankSingleLabel.font = [UIFont systemFontOfSize:15*kWidthRatio];
        _bankSingleLabel.textColor = UIColorFromRGBValue(0x333333);
        _bankSingleLabel.numberOfLines = 0;
        _bankSingleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bankSingleLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
