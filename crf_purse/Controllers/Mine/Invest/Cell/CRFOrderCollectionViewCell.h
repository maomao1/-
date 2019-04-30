//
//  CRFOrderCollectionViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFInvestBill.h"

@interface CRFOrderCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CRFInvestBill *bill;

@property (nonatomic, assign) NSUInteger source;

@end
