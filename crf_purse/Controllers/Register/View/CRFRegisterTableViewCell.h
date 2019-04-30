//
//  CRFRegisterTableViewCell.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFVerifyCodeView.h"
#import "CRFTextField.h"
typedef NS_ENUM(NSUInteger, CellType) {
    Normal      = 0,
    Verify      = 1,
    Secret      = 2,
};


static CGFloat const kButtonWidth = 120;

@interface CRFRegisterTableViewCell : UITableViewCell

@property (nonatomic, strong) CRFVerifyCodeView *verifyCodeView;

@property (weak, nonatomic) IBOutlet CRFTextField *textField;

@property (nonatomic, assign) BOOL hiddenSecret;

@property (nonatomic, assign) CellType type;

@property (nonatomic, copy) void (^(updateTextFieldHandler))(BOOL secret);


- (void)configCell:(NSString *)placeholder;
@end
