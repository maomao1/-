//
//  CRFLabel.h
//  crf_purse
//
//  Created by maomao on 2017/8/10.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface CRFLabel : UILabel
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
