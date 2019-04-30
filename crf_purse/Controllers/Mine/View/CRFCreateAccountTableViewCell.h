//
//  CRFCreateAccountTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFBankNoTextField.h"
#import "CRFButton.h"

typedef NS_ENUM(NSUInteger, RightViewStyle) {
    Default         = 0,
    Help            = 1,
    List            = 2,
    Modify          = 3,
    CanEdit         = 4,
    Verify          = 5,
    CodeValue       = 6,
    PhoneNumber     = 7,
};

@interface CRFCreateAccountTableViewCell : UITableViewCell

@property (nonatomic, strong) CRFBankNoTextField *textField;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) RightViewStyle rightViewStyle;


@property (nonatomic, copy) void (^(rightHandler))(NSInteger index);

@property (nonatomic, strong) CRFButton *codeBtn;


- (void)updateWithTitle:(NSString *)title;

@end
