//
//  CRFADPagesView.h
//  crf_purse
//
//  Created by maomao on 2018/7/4.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRFADPagesViewCell;

@protocol CRFADPagesViewDelegate;
@protocol CRFADPagesViewDataSource;
@interface CRFADPagesView : UIView
@property (nonatomic, assign) NSTimeInterval intervalTime;  /**<  间隔时间 */
@property (nonatomic, weak) id<CRFADPagesViewDataSource> dataSource;
@property (nonatomic, weak) id<CRFADPagesViewDelegate> delegate;
- (void)reloadData;

- (CRFADPagesViewCell*)dequeueReusableCellWithIndex:(NSInteger)index;
- (void)startAnimation;     /**< viewDidAppear 时调用*/
- (void)stopAnimation;      /**< viewWillDisAppear 时调用*/
@end
@protocol CRFADPagesViewDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInADPagesView:(CRFADPagesView*)pagesView;
- (CRFADPagesViewCell*)pagesView:(CRFADPagesView*)pagesView cellForRowAtIndex:(NSInteger)index;

@end

@protocol CRFADPagesViewDelegate <NSObject>
@optional
- (void)pagesView:(CRFADPagesView*)pagesView didSelectCellAtIndex:(NSInteger)index;
@end
#pragma mark - CRFADPagesViewCell Class

@interface CRFADPagesViewCell : UIImageView
@end
