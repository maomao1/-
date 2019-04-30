//
//  CRFNewDiscoverCell.h
//  crf_purse
//
//  Created by maomao on 2018/7/4.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack)(NSInteger index);
static NSString *const CRFNewDiscoverCellId = @"CRFNewDiscoverCell_identifier";
@interface CRFNewDiscoverCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageViewFirst;
@property (nonatomic, strong) UIImageView *imageViewSecond;
@property (nonatomic, strong) UIImageView *imageViewThree;
@property (nonatomic, strong) NSArray     *dataArray;
@property (nonatomic, copy)  callBack     callImageClick;
@end
