//
//  CRFDepositoryManagementAlertView.h
//  crf_purse
//
//  Created by mystarains on 2019/1/14.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRFDepositoryManagementAlertView : UIView

@property (nonatomic,copy) NSString *contentUrl;
@property (nonatomic,copy) void(^goToDepositoryManagement)();

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
