//
//  CRFTargetTableViewCell.h
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFTargetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, copy) void (^(didSelectedHandler))(CRFTargetTableViewCell *cell);

- (void)fillCellWithModek:(CRFProductModel *)sender;

- (void)resetUI;

@end
