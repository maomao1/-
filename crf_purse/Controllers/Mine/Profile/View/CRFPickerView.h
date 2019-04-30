//
//  CRFPickerView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFCity.h"

typedef NS_ENUM(NSUInteger, PickerType) {
    Address                 = 0,
    Create_Account          = 1,
    
};

@interface CRFPickerView : UIView

- (instancetype)initWithType:(PickerType)type;

@property (nonatomic, copy) void (^(cancelHandler))(void);

@property (nonatomic, assign, readonly) PickerType pickerType;

@property (nonatomic, copy) void (^(complataHandler))(id object, NSInteger subCityIndex, NSInteger townIndex);

- (void)show;

- (void)update:(BOOL)show;

@end
