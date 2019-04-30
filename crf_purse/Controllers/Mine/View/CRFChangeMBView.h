//
//  CRFChangeMBView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/30.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFChangeMBView : NSObject

@property (nonatomic, copy) void (^(commitHandler))(NSString *code, NSString *moblePhone);

- (void)show;

@end
