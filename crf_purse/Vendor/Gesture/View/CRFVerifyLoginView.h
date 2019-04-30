//
//  CRFVerifyLoginView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/4/10.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFVerifyLoginView : UIView

@property (nonatomic, copy) void (^(confirmEvent))(NSString *password);

- (void)show;

- (void)dismiss;

- (void)showErrorMessage:(NSString *)errorMessage;



@end
