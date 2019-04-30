//
//  CRFLoginFootView.h
//  CRFWallet
//
//  Created by SHLPC1321 on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFLoginFootView : UIView
//- (void)setLoginBtnColor;
- (void)footLoginBtnCallback:(void(^)(UIButton *loginBtn))loginCallback registerCallback:(void(^)(UIButton *registerBtn))registerCallback forgetCallback:(void (^)(UIButton *forgetBtn))forgetCallback;
@end
