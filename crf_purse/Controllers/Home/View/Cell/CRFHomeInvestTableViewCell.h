//
//  CRFHomeInvestTableViewCell.h
//  crf_purse
//
//  Created by mystarains on 2019/1/9.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFHomeProductFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRFHomeInvestTableViewCell : UITableViewCell

@property (nonatomic, strong) CRFHomeProductFactory *productFactory;

@property (nonatomic,copy) void(^showMoreBlock)();

@end

NS_ASSUME_NONNULL_END
