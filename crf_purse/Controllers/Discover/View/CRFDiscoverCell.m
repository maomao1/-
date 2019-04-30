//
//  CRFDiscoverCell.m
//  crf_purse
//
//  Created by maomao on 2017/8/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDiscoverCell.h"

@implementation CRFDiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = 5.0f;
}

@end
