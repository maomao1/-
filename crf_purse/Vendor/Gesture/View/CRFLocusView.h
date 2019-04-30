//
//  CRFLocusView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/4/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCircleView.h"

@interface CRFLocusView : UIView

@property (nonatomic, assign) BOOL clip;

@property (nonatomic, strong) PCCircleView *circleView;

/**
 *  是否有箭头 default is YES
 */
@property (nonatomic, assign) BOOL arrow;

@property (nonatomic, strong) NSArray *locusSubviews;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
