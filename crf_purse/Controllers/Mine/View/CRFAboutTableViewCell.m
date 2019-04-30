//
//  CRFAboutCell.m
//  crf_purse
//
//  Created by maomao on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAboutTableViewCell.h"
@interface CRFAboutTableViewCell()

@end
@implementation CRFAboutTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _isCanSet = YES;
    if (self) {
        if ([reuseIdentifier isEqualToString:CRFAboutCell_ID]) {
            [self setUI];
            self.hasAccessoryView = YES;
        } else {
            self.hasAccessoryView = NO;
            [self setHaveSwitchUI];
        }
    }
    return self;
}

- (void)setHaveSwitchUI{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.textColor =UIColorFromRGBValue(0x333333);
    [self.contentView addSubview:_titleLabel];
    
    _mm_switch = [[UISwitch alloc]init];
    [_mm_switch setOnTintColor:kButtonNormalBackgroundColor];
    [_mm_switch addTarget:self action:@selector(swtichAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_mm_switch];
    
    [_mm_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-kSpace);
//        make.size.
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(15);
    }];

}
- (void)setUI{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.textColor =UIColorFromRGBValue(0x333333);
    
    _versionLabel = [[UILabel alloc]init];
    _versionLabel.textColor = UIColorFromRGBValue(0x666666);
    _versionLabel.font = [UIFont systemFontOfSize:14.0];
    
    _versionRed = [[UILabel alloc]init];
    _versionRed.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
    _versionRed.layer.masksToBounds = YES;
    _versionRed.layer.cornerRadius = 4;
   
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_versionLabel];
    [self.contentView addSubview:_versionRed];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(15);
    }];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [_versionRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_versionLabel);
        make.left.equalTo(_titleLabel.mas_right).with.mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
}
- (void)swtichAction:(UISwitch*)swtichBtn{
    if ([self.titleLabel.text isEqualToString:@"手势密码"]) {
        if (self.switchHandler) {
            self.switchHandler(swtichBtn);
        }
        return;
    }
    BOOL isButtonOn = [swtichBtn isOn];
    if (_isCanSet) {
        if (isButtonOn) {
            NSLog(@"开");
            [[CRFAppManager defaultManager] verifyTouchID:^(TouchStatus status) {
                [CRFUtils getMainQueue:^{
                    if (status == VerifySuccess) {
                        [CRFUserDefaultManager setTouchIDSwitch:YES];
                        [swtichBtn setOn:YES animated:YES];
                    } else {
                        if (status == ForceLogout) {
//                            [CRFUtils showMessage:@"指纹被锁，锁屏后重新验证"];
                            [CRFUtils showMessage:[[CRFAppManager defaultManager] supportFaceID]?@"FaceID短时间内失败多次，锁屏后重新验证":@"指纹被锁，锁屏后重新验证"];

                        } else if (status == VerifyFailed) {
//                            [CRFUtils showMessage:@"指纹验证失败"];
                            [CRFUtils showMessage:[[CRFAppManager defaultManager] supportFaceID]?@"FaceID验证失败":@"指纹验证失败"];

                        }
                        [CRFUserDefaultManager setTouchIDSwitch:NO];
                        [swtichBtn setOn:NO animated:YES];
                    }
                }];
            }];
        }else {
            [CRFUserDefaultManager setTouchIDSwitch:isButtonOn];
            [swtichBtn setOn:NO animated:YES];
        }
        
        
    }else{
        [swtichBtn setOn:[[CRFAppManager defaultManager] isOpenRemoteNotificationStatus]animated:YES];
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    if (isButtonOn) {
        NSLog(@"开");
    }else {
        NSLog(@"关");
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
