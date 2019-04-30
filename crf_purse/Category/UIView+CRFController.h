//
//  UIView+CRFController.h
//  crf_purse
//
//  Created by mystarains on 2019/1/10.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CRFController)

- (UIViewController *)viewController;
- (UINavigationController *)navigationController;

- (UIViewController *)currentViewController;
- (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
