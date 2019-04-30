//
//  CRFLoginViewController.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFCheckLoginViewController.h"
//#import "CRFStaticWebViewViewController.h"
@protocol CRFLoginViewControllerDelegate <NSObject>
-(void)loginSuccess;
-(void)reloadNavBarColor;
@end
@interface CRFLoginViewController : CRFBasicViewController
@property (nonatomic,weak) id <CRFLoginViewControllerDelegate>delegate;
@property (nonatomic, assign) PopType popType;
@property (nonatomic, copy) void (^ (reloadWebCall))(void);

//@property (nonatomic, copy)   NSString* successWebUrl;



@end
