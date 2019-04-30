//
//  CRFADView.h
//  crf_purse
//
//  Created by maomao on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

/**
 delegate
 */
@protocol HomeAdvertisementViewDelegate <NSObject>


/**
 关闭视图
 */
- (void)close;

/**
 查看详情

 @param url url
 */
- (void)pushAdvertisementDetail:(NSString*)url;

@end

/**
 广告页
 */
@interface CRFHomeAdvertisementView : CRFBasicView

/**
 delegate
 */
@property(weak ,nonatomic) id <HomeAdvertisementViewDelegate> pushDelegate;

/**
 imageUrl
 */
@property(copy ,nonatomic) NSString *imageUrl;


/**
 init object

 @param frame frame
 @param imageArray images
 @return object
 */
- (instancetype)initWithframe:(CGRect)frame images:(NSArray *)imageArray;

/**
 show

 @param containerView view
 */
- (void)showAdView:(UIView*)containerView;
@end
