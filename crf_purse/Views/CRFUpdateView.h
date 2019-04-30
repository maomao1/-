//
//  CRFUpdateView.h
//  crf_purse
//
//  Created by maomao on 2017/7/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"
typedef void(^UpdateVersionBlock)();
typedef void(^CancelVersionBlock)();
@interface CRFUpdateView : CRFBasicView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title Content:(NSString*)content IsForce:(NSString*)level ClickCallBack:(UpdateVersionBlock)callBack CancelCallBack:(CancelVersionBlock)cancelBack IsHome:(BOOL)isHome;
- (void)show;
@end
