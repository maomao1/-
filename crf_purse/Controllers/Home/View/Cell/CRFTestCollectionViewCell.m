//
//  CRFTestCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFTestCollectionViewCell.h"

@implementation CRFTestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0f;
}

@end
