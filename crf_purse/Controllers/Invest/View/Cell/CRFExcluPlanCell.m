//
//  CRFExcluPlanCell.m
//  crf_purse
//
//  Created by maomao on 2018/3/22.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFExcluPlanCell.h"
@interface CRFExcluPlanCell()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
//@property (nonatomic, strong) UILabel *placeholderLabel;
@property (strong, nonatomic)  UITextField *moneyField;
@property (strong, nonatomic) UIButton  *scanExclu;

@end
@implementation CRFExcluPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setUI{
    _iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textColor = kCellTitleTextColor;
    [self addSubview:self.titleLabel];
    _line = [UIView new];
    _line.backgroundColor = kCellLineSeparatorColor;
    [self addSubview:self.line];
//    _placeholderLabel = [[UILabel alloc]init];
//    _placeholderLabel.textColor = UIColorFromRGBValue(0x999999);
//    _placeholderLabel.font = [UIFont systemFontOfSize:12];
//    _placeholderLabel.text = @"1,000元起,且为1,000元的整数倍";
//    [self addSubview:self.placeholderLabel];
    _scanExclu  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanExclu setTitle:@"查看特供计划" forState:UIControlStateNormal];
    [_scanExclu setBackgroundColor:kBtnAbleBgColor];
    [_scanExclu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanExclu addTarget:self action:@selector(scanExclusivePlan:) forControlEvents:UIControlEventTouchUpInside];
    _scanExclu.titleLabel.font = [UIFont systemFontOfSize:16];
    _scanExclu.layer.masksToBounds = YES;
    _scanExclu.layer.cornerRadius  = 5;
    [self addSubview:_scanExclu];
    //
    self.moneyField = [[UITextField alloc]init];
    self.moneyField.keyboardType = UIKeyboardTypeNumberPad;
    self.moneyField.layer.masksToBounds = YES;
    self.moneyField.layer.borderWidth = 1.0f;
    self.moneyField.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    self.moneyField.layer.cornerRadius=20.0f;
    self.moneyField.leftViewMode = UITextFieldViewModeAlways;
    self.moneyField.rightViewMode = UITextFieldViewModeAlways;
    
    //
    self.moneyField.font = [UIFont systemFontOfSize:15.0];
    self.moneyField.placeholder = @"1000元起投";
    self.moneyField.textAlignment =NSTextAlignmentCenter;
    [self.moneyField setValue:UIColorFromRGBValue(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [self.moneyField setValue:[UIFont systemFontOfSize:13.0f] forKeyPath:@"_placeholderLabel.font"];
    self.moneyField.delegate = self;
    [self addSubview:self.moneyField];
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65*kWidthRatio, 40)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 65*kWidthRatio, 40);
    [btn setImage:[UIImage imageNamed:@"operation_reduce"] forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGBValue(0xFEF0EC);
    [btn addTarget:self action:@selector(reduceMoneyAccount) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    
    [left addSubview:btn];
    self.moneyField.leftView = left;
    
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldContentChange) name:UITextFieldTextDidChangeNotification];
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65*kWidthRatio, 40)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame =CGRectMake(0, 0, 65*kWidthRatio, 40);
    [rightBtn setImage:[UIImage imageNamed:@"operation_plus"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addMoneyAccount) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.backgroundColor = UIColorFromRGBValue(0xFEF0EC);
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderWidth = 1.0f;
    rightBtn.layer.borderColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    [right addSubview:rightBtn];
    self.moneyField.rightView = right;
    //
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(kSpace);
        make.size.mas_equalTo(CGSizeMake(kSpace, kSpace));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(kSpace);
        make.right.equalTo(self);
        make.height.mas_equalTo(kSpace);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).with.offset(44);
        make.height.mas_equalTo(1);
        make.left.equalTo(self).with.offset(40);
    }];
//    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.right.equalTo(self);
//        make.top.equalTo(self.line.mas_bottom).with.mas_offset(11);
//    }];
    [self.moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).with.mas_offset(20);
        make.left.equalTo(self.titleLabel.mas_left).with.mas_offset(kSpace);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
//        make.bottom.mas_equalTo(-20);
    }];
    [self.scanExclu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.top.equalTo(self.moneyField.mas_bottom).with.mas_offset(40);
        make.height.mas_equalTo(kRegisterButtonHeight);
        make.bottom.mas_equalTo(-20);
    }];
}
- (void)addMoneyAccount{
    if (self.moneyField.text&&self.excModel.investUnit.length) {
        self.moneyField.text = [NSString stringWithFormat:@"%lld",[self.moneyField.text longLongValue]+self.excModel.investUnit.longLongValue];
        if ([self.moneyField.text longLongValue]<self.excModel.lowestAmount.longLongValue) {
            self.moneyField.text = self.excModel.lowestAmount;
        }
    }else{
        self.moneyField.text = self.excModel.lowestAmount;
    }
    [self setBtnStatusForResult:self.moneyField.text];
}
- (void)reduceMoneyAccount{
    if (self.moneyField.text) {
        if ([self.moneyField.text longLongValue] - self.excModel.investUnit.longLongValue >=self.excModel.lowestAmount.longLongValue) {
            self.moneyField.text = [NSString stringWithFormat:@"%lld",[self.moneyField.text longLongValue]-self.excModel.investUnit.longLongValue];
        }else{
            [CRFUtils showMessage:[NSString stringWithFormat:@"起投金额为%@元",[self.excModel.lowestAmount formatBeginMoney]]];
            self.moneyField.text = self.excModel.lowestAmount;
        }
    }else{
        [CRFUtils showMessage:[NSString stringWithFormat:@"起投金额为%@元",[self.excModel.lowestAmount formatBeginMoney]]];
        self.moneyField.text = self.excModel.lowestAmount;
    }
    [self setBtnStatusForResult:self.moneyField.text];

}
-(void)setBtnStatusForResult:(NSString*)amountStr{
    if ([amountStr doubleValue]>[[CRFAppManager defaultManager].accountInfo.availableBalance getOriginString].doubleValue) {
        self.btnStatus = buttonRecharge;
    }else{
        self.btnStatus = buttonScanExclusive;
    }
}
-(void)scanExclusivePlan:(UIButton*)btn{
    if (self.scanCallBack) {
        self.scanCallBack(self.moneyField.text,self.btnStatus);
    }
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}
- (void)setIconNamed:(NSString *)iconNamed {
    _iconNamed = iconNamed;
    self.iconImageView.image = [UIImage imageNamed:_iconNamed];
}
-(void)setBtnStatus:(buttonStatus)btnStatus{
    _btnStatus = btnStatus;
    if (btnStatus == buttonRecharge) {
        [_scanExclu setTitle:@"余额不足,去充值" forState:UIControlStateNormal];
    }else{
        [_scanExclu setTitle:@"查看特供计划" forState:UIControlStateNormal];
    }
}
-(void)setExcModel:(CRFExclusiveModel *)excModel{
    if (!excModel) {
        return;
    }
    _excModel = excModel;
//    self.moneyField.text =excModel.lowestAmount;
    self.moneyField.placeholder = [NSString stringWithFormat:@"%@元起投",[excModel.lowestAmount formatPlaceholderMoney]];
    [self setBtnStatusForResult:self.moneyField.text];
}
#pragma mark ----
- (void)textFieldContentChange {
    [self setBtnStatusForResult:self.moneyField.text];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self setBtnStatusForResult:newText];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
