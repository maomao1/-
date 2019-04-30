//
//  CRFAddressTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAddressTableViewCell.h"

@interface CRFAddressTableViewCell()

@property (nonatomic, strong) UIImageView *addImageView;

@end

@implementation CRFAddressTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = UIColorFromRGBValue(0x333333);
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.textField];
        [self addSubview:self.addImageView];
        [self layoutView];
        self.addContact = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.textColor = UIColorFromRGBValue(0x333333);
        [_textField setValue:UIColorFromRGBValue(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont boldSystemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];

    }
    return _textField;
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit_address"]];
        _addImageView.userInteractionEnabled = YES;
        [_addImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGesture)]];
    }
    return _addImageView;
}

- (void)setAddContact:(BOOL)addContact {
    self.addImageView.hidden = !addContact;
//    self.textField.hidden = !addContact;
}

- (void)layoutView {
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).with.offset(-15);
        make.left.equalTo(self).with.offset(80);
    }];
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)addGesture {
    if (self.addContactHandler) {
        self.addContactHandler();
    }
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
