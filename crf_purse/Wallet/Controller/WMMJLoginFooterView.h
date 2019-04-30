//
//  WMMJLoginFooterView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMJLoginFooterView : UIView

- (void)footLoginBtnCallback:(void(^)(UIButton *loginBtn))loginCallback registerCallback:(void(^)(UIButton *registerBtn))registerCallback forgetCallback:(void (^)(UIButton *forgetBtn))forgetCallback;

@end
