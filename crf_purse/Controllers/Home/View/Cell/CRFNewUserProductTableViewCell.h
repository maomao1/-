//
//  CRFNewUserProductTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFNewUserProductTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray <CRFProductModel *>*products;


@property (nonatomic, copy) void (^(selectedProductHandler))(CRFProductModel *model);

@end
