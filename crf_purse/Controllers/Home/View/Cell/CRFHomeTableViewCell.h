//
//  CRFHomeTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"

typedef NS_ENUM(NSUInteger, ProductType) {
    Old_Product             = 0,
    New_Product             = 1,
};

typedef NS_ENUM(NSUInteger, Product_Variable) {
    Simple                  = 0,
    More                    = 1,
};

@interface CRFHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldUserContentlabel;
@property (weak, nonatomic) IBOutlet UILabel *oldUserTitleLabel;
@property (nonatomic, assign) BOOL supportGesture;
@property (nonatomic, copy) void (^(clickHandler))(NSInteger index);

@property (nonatomic, strong) NSArray <CRFProductModel *>*products;
@property (nonatomic, assign) ProductType productType;

@property (nonatomic, assign) Product_Variable variableStyle;

@property (nonatomic, copy) NSString *tipText;


@end
