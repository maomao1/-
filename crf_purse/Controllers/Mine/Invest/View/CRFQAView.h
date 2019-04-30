//
//  CRFQAView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CRFQAViewStyle) {
    CRFQADefault                = 0,
    CRFQAExplain                = 1,
    
};
@interface CRFQAView : UIView
@property (nonatomic , strong) NSString *title;
@property (nonatomic , strong) NSString *title1;
@property (nonatomic , strong) NSString *content1;
@property (nonatomic , strong) NSString *title2;
@property (nonatomic , strong) NSString *content2;
@property (nonatomic , strong) NSString *title3;
@property (nonatomic , strong) NSString *content3;
@property (nonatomic ,assign) CRFQAViewStyle  qaStyle;
- (void)show;

@end
