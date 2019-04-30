//
//  CRFSharedView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/9/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface CRFSharedView : UIView

/**
 是否分享产品
 */
@property (nonatomic, assign) BOOL sharedProduct;

/**
 分享
 
 @param messageObject 分享对象
 */
- (void)show:(UMSocialMessageObject *)messageObject;

/**
 完成
 */
- (void)complate;
@property(nonatomic ,copy) NSString *dupUrl;
@property (nonatomic , strong) NSArray *images;
@property (nonatomic , strong) NSArray *titles;

@end
