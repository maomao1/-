//
//  CRFNovicesProductCollectionViewCell.h
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"
#import "CRFStringUtils.h"

static NSString *const CRFInvestListCellId  = @"CRFInvestListCellIdentifier";

NS_ASSUME_NONNULL_BEGIN

@interface CRFNovicesProductCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong) CRFProductModel *productModel;
@property (nonatomic, assign) BOOL newUserProduct;

@end

NS_ASSUME_NONNULL_END
