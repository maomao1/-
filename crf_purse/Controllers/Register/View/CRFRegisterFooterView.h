//
//  CRFRegisterFooterView.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFRegisterFooterView : UIView



@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) void (^(registerHandle))(void);

@property (nonatomic, copy) void (^(protocolClick))(NSURL *url);

@property (nonatomic, strong) NSArray <CRFProtocol *> *registerProtoocl;

- (instancetype)initWithFrame:(CGRect)frame hasProtocol:(BOOL)value;

@end
