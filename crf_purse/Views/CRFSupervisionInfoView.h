//
//  CRFSupervisionInfoView.h
//  crf_purse
//
//  Created by maomao on 2018/1/10.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"
@protocol CRFSupervisionInfoViewDelegate <NSObject>
- (void)crf_pushPotocol:(NSString *)urlStr;
- (void)crf_agreeAuthPotocol;
@end
@interface CRFSupervisionInfoView : CRFBasicView
@property (nonatomic , weak) id<CRFSupervisionInfoViewDelegate> crf_delegate;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)crfSetContent;
@end
