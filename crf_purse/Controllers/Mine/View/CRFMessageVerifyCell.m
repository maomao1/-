//
//  CRFMessageVerifyCell.m
//  crf_purse
//
//  Created by maomao on 2018/6/15.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFMessageVerifyCell.h"
#import "CRFLabel.h"

@interface CRFMessageVerifyCell()
@property (nonatomic, strong) CRFLabel      * numberLabel;
@property (nonatomic, strong) CRFLabel      * leftLabel;
@end
@implementation CRFMessageVerifyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.leftLabel];
        
        if ([reuseIdentifier isEqualToString:CRFMessageVerifyId_first]) {
            [self addSubview:self.numberLabel];
//            [self addSubview:self.verifyCodeView];
            [self addSubview:self.codeButton];
            [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kSpace);
                make.centerY.equalTo(self);
                make.height.mas_equalTo(16);
                //                make.width.mas_lessThanOrEqualTo(115);
            }];
//            [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-kSpace);
//                make.size.mas_equalTo(CGSizeMake(95, 16));
//                make.centerY.equalTo(self.leftLabel.mas_centerY);
//            }];
            [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-kSpace);
//                make.size.mas_equalTo(CGSizeMake(95, 16));
                make.top.equalTo(self);
                make.centerY.equalTo(self.leftLabel.mas_centerY);
            }];
            [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftLabel.mas_right).with.mas_offset(kSpace/3 *kWidthRatio);
                //                make.right.equalTo(self.verifyCodeView.mas_left).with.mas_offset(-5);
                make.height.mas_equalTo(16);
                make.centerY.equalTo(self.leftLabel.mas_centerY);
            }];
            
        }else{
            [self addSubview:self.textField];
            [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kSpace);
                make.centerY.equalTo(self);
                make.height.mas_equalTo(16);
                make.width.mas_lessThanOrEqualTo(50*kWidthRatio);
            }];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftLabel.mas_right).with.mas_offset(kSpace/3*kWidthRatio);
                make.right.mas_greaterThanOrEqualTo(-kSpace);
                make.centerY.equalTo(self.leftLabel.mas_centerY);
                
            }];
            self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
    }
    return self;
}
-(void)getCodeEvent:(CRFButton*)btn{
    btn.enabled = NO;
    if (self.codeBack) {
        self.codeBack(btn);
    }
}
-(void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    _leftLabel.text = leftTitle;
}
-(void)setNumberStr:(NSString *)numberStr{
    _numberStr = numberStr;
    self.numberLabel.text = numberStr;
}
-(void)setPlaceHoderStr:(NSString *)placeHoderStr{
    _placeHoderStr = placeHoderStr;
    [_textField setPlaceholder:placeHoderStr];
}
-(CRFVerifyCodeView *)verifyCodeView{
    if (!_verifyCodeView) {
        _verifyCodeView = [[CRFVerifyCodeView alloc]init];
        _verifyCodeView.buttonType = Border_None;
        [_verifyCodeView initialTitle:NSLocalizedString(@"button_verify_normal_title", nil)];
        [_verifyCodeView titleNormalColor:UIColorFromRGBValue(0xFB4D3A) disableColor:UIColorFromRGBValue(0xBBBBBB)];
        [_verifyCodeView sendingTitle:NSLocalizedString(@"button_re_get_verify_code", nil)];
        [_verifyCodeView resetTitle:NSLocalizedString(@"button_verify_re_get_verify_code", nil)];
    }
    return _verifyCodeView;
}
-(CRFButton *)codeButton{
    if (!_codeButton) {
        _codeButton = [CRFButton buttonWithType:UIButtonTypeCustom];
        [_codeButton addTarget:self action:@selector(getCodeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}
-(CRFTextField *)textField{
    if (!_textField) {
        _textField = [[CRFTextField alloc]init];
        [_textField setValue:UIColorFromRGBValue(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont systemFontOfSize:16.0*kWidthRatio] forKeyPath:@"_placeholderLabel.font"];
        _textField.textColor = UIColorFromRGBValue(0x333333);
        _textField.font = [UIFont systemFontOfSize:16.0*kWidthRatio];
    }
    return _textField;
}
-(CRFLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[CRFLabel alloc]init];
        _leftLabel.font = [UIFont systemFontOfSize:16.0*kWidthRatio];
        _leftLabel.textColor = UIColorFromRGBValue(0x666666);
    }
    return _leftLabel;
}
-(CRFLabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[CRFLabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:16.0*kWidthRatio];
        _numberLabel.textColor = UIColorFromRGBValue(0x333333);
    }
    return _numberLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
