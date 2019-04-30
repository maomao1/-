//
//  CRFRechargeDetailCell.h
//  crf_purse
//
//  Created by maomao on 2018/8/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CRFRechargeDetailCellId = @"CRFRechargeDetailCellIdentifier";
@interface CRFRechargeDetailCell : UITableViewCell
-(void)crfSetContent:(id)item AndTitle:(NSString*)title;
@end
