//
//  CRFSectionFooterView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CRFSectionStyle) {
    CRFSectionStyleNovice               = 0,
    CRFSectionStyleOld                  = 1,
};

@interface CRFSectionFooterView : UIView

- (instancetype)initWithStyle:(CRFSectionStyle)style;

@property (nonatomic, copy) void (^(tapHandler))(void);

@end
