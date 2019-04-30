//
//  CRFDiscoverListCollectionViewCell.h
//  crf_purse
//
//  Created by maomao on 2017/8/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFLabel.h"

static NSString *const CRFDiscoverListCellId = @"CRFDiscoverListCell_identifier";
@interface CRFDiscoverListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CRFLabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;
- (void)setTitleStr:(NSString*)titleStr;


@end
