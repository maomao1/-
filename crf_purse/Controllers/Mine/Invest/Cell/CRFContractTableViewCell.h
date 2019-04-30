//
//  CRFContractTableViewCell.h
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFContractModel.h"

@interface CRFContractTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *loanLab;
@property (weak, nonatomic) IBOutlet UILabel *switchLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak,nonatomic) CRFContractModel *model;
@property (weak,nonatomic) UITableView *tab;

- (void)fillCellWithMoel:(CRFContractModel *)sender;

@end
