//
//  CRFVersionTabCell.h
//  crf_purse
//
//  Created by maomao on 2017/8/11.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFLabel.h"
#import "CRFVersionModel.h"

static NSString *const CRFVERSIONCELL_ID = @"CRFVersionTabCell_identifier";
@interface CRFVersionTableViewCell : UITableViewCell
- (void)setContentForModel:(CRFVersionContentModel*)item;
@end
