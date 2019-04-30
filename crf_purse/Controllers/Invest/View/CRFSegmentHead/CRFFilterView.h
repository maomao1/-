//
//  CRFFilterView.h
//  crf_purse
//
//  Created by maomao on 2017/7/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CRFFilterViewDelegate <NSObject>

- (void)filterResult:(UIButton *)btn;

@end

@interface CRFFilterView : UIView
@property  (nonatomic , weak) id <CRFFilterViewDelegate>delegate;
- (void)resetButtonStatus;
@end
