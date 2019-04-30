//
//  CRFAddressTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) BOOL addContact;

@property (nonatomic, copy) void (^(addContactHandler))(void);

@end
