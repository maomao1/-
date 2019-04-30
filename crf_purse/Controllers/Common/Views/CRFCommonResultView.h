//
//  CRFCommonResultView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

@protocol CRFCommonResultViewDelegate;

@interface CRFCommonResultView : CRFBasicView

@property (nonatomic, weak) id <CRFCommonResultViewDelegate> commonResultDelegate;

- (instancetype)initWithResultImage:(UIImage *)image result:(NSString *)result reason:(NSString *)reason buttonTitles:(NSArray <NSString *>*)buttonTitles;


@end

@protocol CRFCommonResultViewDelegate<NSObject>

@optional

- (void)commonResultDidTouched:(NSInteger)index;

@end
