//
//  CRFTabBarItem.h
//  crf_purse
//
//  Created by crf on 2017/7/3.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFTabBarItem : UIView


@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *selectedTextColor;

/**
 new message , default NO
 */
@property (nonatomic, assign) BOOL hasNewMessage;

@end
