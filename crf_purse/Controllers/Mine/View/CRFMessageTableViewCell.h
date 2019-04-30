//
//  CRFMessageCell.h
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFMessageModel.h"
#import "CRFActivity.h"
static NSString *const CRFMessageCell_Identifier = @"CRFMessageCell_Identifier";
static NSString *const CRFRecordCell_Identifier  =@"CRFRecordCell_Identifier";
static NSString *const CRFBankCell_Identifier    =@"CRFBankCell_Identifier";

@interface CRFMessageTableViewCell : UITableViewCell
- (void)crfSetContent:(id)item;
- (void)crfSetBankCellContent:(CRFBankListModel*)item;
- (void)crfSetRecordCellContent:(CRFCashRecordModel*)item;

@property (nonatomic, assign) BOOL isRead;
@end
