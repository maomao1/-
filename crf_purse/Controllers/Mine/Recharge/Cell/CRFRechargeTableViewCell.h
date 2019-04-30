//
//  CRFRechargeTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/17.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFRechargeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) BOOL edit;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)initializeView;

@end
