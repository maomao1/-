//
//  CRFEvaluateAlertView.h
//  crf_purse
//
//  Created by mystarains on 2019/1/11.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRFEvaluateAlertView : UIView

@property (nonatomic,copy) void(^goToEvaluate)();

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
