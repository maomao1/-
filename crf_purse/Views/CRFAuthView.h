//
//  CRFAuthView.h
//  crf_purse
//
//  Created by maomao on 2017/11/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"
#import "CRFHomeConfigHendler.h"
@protocol CRFAuthViewDelegate <NSObject>
- (void)crf_pushPotocol:(NSString *)urlStr;
- (void)crf_agreeAuthBank;
@end
@interface CRFAuthView : CRFBasicView

@property (nonatomic , weak) id<CRFAuthViewDelegate> crf_delegate;



- (void)showInView:(UIView*)view;

- (void)dismiss;

- (void)crfSetContent;




@end
