//
//  CRFComplianceBillTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFComplianceBillTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hasAttributed;


- (void)configTitle:(NSString *)title value:(NSString *)value;

@end
