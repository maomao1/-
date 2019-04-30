//
//  CRFFirstVC.h
//  crf_purse
//
//  Created by maomao on 2017/8/23.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CRFFirstVCDelegate <NSObject>

- (void)Crf_GetUpVersion;

@end
@interface CRFFirstVC : UIViewController

@property (nonatomic, weak) id<CRFFirstVCDelegate> crf_ladelegate;

- (instancetype)crfInit;

@end
