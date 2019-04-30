//
//  CRFNewMineCell.h
//  crf_purse
//
//  Created by maomao on 2018/8/30.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *CRFNewMineCellId = @"CRFNewMineCellIdentifer";
@interface CRFNewMineCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic ,copy ) NSString *title;
@property (nonatomic ,copy ) NSString *secondTitle;

//-(void)updateLayout;
@end
