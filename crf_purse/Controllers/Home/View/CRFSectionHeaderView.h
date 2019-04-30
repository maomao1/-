//
//  CRFSectionHeaderView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CRFSectionHeaderStyle) {
    CRFSectionHeaderStyleTopMargen                      = 0,
    CRFSectionHeaderStyleTopMargenAndContent            = 1,
    CRFSectionHeaderStyleContent                        = 2,
    
};

@interface CRFSectionHeaderView : UIView

- (instancetype)initWithSectionStyle:(CRFSectionHeaderStyle)style;

@end
