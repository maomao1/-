//
//  CRFComplianceBillCollectionViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFComplianceBill.h"

@interface CRFComplianceBillCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CRFComplianceBill *bill;

@property (nonatomic, strong) CRFComplianceHistoryBill *historyBill;

@property (nonatomic, strong) CRFComplianceCurrentBill *currrentBill;

@end
