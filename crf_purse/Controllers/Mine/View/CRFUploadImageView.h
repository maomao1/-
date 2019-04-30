//
//  CRFUploadImageView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFUploadImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL hasImage;

@property (nonatomic, copy) void (^ (tapHandler))(void);

@end
