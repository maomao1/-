//
//  CRFWelcomeViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^updateVersionCallback) ();
@interface CRFWelcomeViewController : UIViewController

@property (nonatomic,copy) NSString *urlImg;

@property (nonatomic,copy) updateVersionCallback  callBack;
@end
