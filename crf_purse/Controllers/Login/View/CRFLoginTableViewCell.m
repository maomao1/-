//
//  CRFLoginTableViewCell.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFLoginTableViewCell.h"

@interface CRFLoginTableViewCell()

@property (nonatomic, copy) void (^(editCallback))(NSString *content);

@end

@implementation CRFLoginTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.hiddenMenu = YES;
    [self.textField setValue:UIColorFromRGBValue(0xBBBBBB) forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldContentChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    self.textField.secureTextEntry = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldContentChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (self.editCallback) {
        self.editCallback(textField.text);
    }
}

- (void)cellLeftImgName:(NSString *)imageName placeholder:(NSString *)placeholder editCompleteCallback:(void (^)(NSString *))completeCallback {
//    self.titleLabel.text = title;
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 37, 22)];
    leftImg.image = [UIImage imageNamed:imageName];
    leftImg.contentMode = UIViewContentModeLeft;
    self.textField.leftView = leftImg;
    
    self.textField.placeholder = placeholder;
    self.editCallback = completeCallback;
    
    if ([placeholder isEqualToString:@"请输入密码"]) {
        self.textField.secureTextEntry = YES;
    }else{
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        if ([CRFUserDefaultManager getInputAccout]) {
            self.textField.text = [CRFUserDefaultManager getInputAccout];
        }
    }
}

@end
