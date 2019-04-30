//
//  CRFInfoTableViewCell.h
//  crf_purse
//
//  Created by maomao on 2018/6/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CRFInfoTabCellId = @"CRFInfoTableViewCell_Identify";
@interface CRFInfoTableViewCell : UITableViewCell
@property (nonatomic , copy) NSString *mainLabelStr;
@property (nonatomic , copy) NSString *nameLabelStr;
@end
