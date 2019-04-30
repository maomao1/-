//
//  CRFCollectionHeader.h
//  crf_purse
//
//  Created by maomao on 2017/8/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CRFCollectionHeaderDelegate <NSObject>

- (void)crf_pushList;

@end

@interface CRFCollectionHeader : UICollectionReusableView

@property (nonatomic, weak) id <CRFCollectionHeaderDelegate> crf_delegate;

@end
