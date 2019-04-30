//
//  CRFStarPlayViewController.h
//  crf_purse
//
//  Created by maomao on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CRFPlayerDelegate <NSObject>
- (void)clickJumpBtn;
@end
@interface CRFStarPlayViewController : UIViewController
//@property(nonatomic,strong)NSURL *movieURL;
@property (nonatomic,weak)id<CRFPlayerDelegate> crf_delegate;
/** 进入首页按钮 */
@property (nonatomic,strong) UIButton *enterButton;
/** 创建视频新特性界面
 *  @param URL 视频路径
 *  @param enterBlock 进入主页面的回调
 *  @param configurationBlock 配置回调
 */
+ (instancetype)newFeatureVCWithPlayerURL:(NSURL *)URL enterBlock:(void(^)())enterBlock configuration:(void (^)(AVPlayerLayer *playerLayer))configurationBlock;

@end
