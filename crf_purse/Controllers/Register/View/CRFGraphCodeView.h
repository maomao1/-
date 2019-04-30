//
//  CRFGraphCodeView.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@interface CRFGraphCodeView : CRFBasicView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholer;
@property (nonatomic, copy) NSString *commitTitle;
@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) void (^(CancelHandler))(void);

- (void)refreshImage;

- (void)commitResult:(void (^)(NSString *value))handle;

- (void)addSubView;



@end
