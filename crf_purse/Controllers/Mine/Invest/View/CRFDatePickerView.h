//
//  CRFDatePickerView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFDatePickerView : UIView

@property (nonatomic, strong) NSArray <NSString *>*dates;

@property (nonatomic, copy) void (^(didSelectedHandler))(NSInteger index);

- (void)addView;
- (void)show;
- (void)hidden;

@end
