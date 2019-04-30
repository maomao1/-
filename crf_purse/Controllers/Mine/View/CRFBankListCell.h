//
//  CRFBankListCell.h
//  crf_purse
//
//  Created by maomao on 2019/3/7.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const CRFBankListCellID = @"CRFBankListCell_identifier";

@interface CRFBankListCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
