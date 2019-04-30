//
//  CRFNovicesExclusiveTableViewCell.h
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFHomeProductFactory.h"

#define kCollectionViewHeight ((kScreenWidth - 20*2)*42/67)

NS_ASSUME_NONNULL_BEGIN

@interface CRFNovicesExclusiveTableViewCell : UITableViewCell

@property (nonatomic, strong) CRFHomeProductFactory *productFactory;
@property (nonatomic,copy) void(^showMoreBlock)();

@end

NS_ASSUME_NONNULL_END
