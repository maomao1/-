//
//  CRFBaseCell.h
//  crf_purse
//
//  Created by maomao on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFBaseCell : UITableViewCell
+ (instancetype)crfReuseIdentifier:(UITableView *)tableView;
+ (instancetype)crfReuseIdentifier:(UITableView *)tableView index:(NSInteger)index;
- (void)crfSetCellLine;
- (void)crfSetContent:(id)item;
@end
