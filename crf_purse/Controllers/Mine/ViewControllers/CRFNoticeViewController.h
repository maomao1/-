//
//  CRFMessageVC.h
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

typedef NS_ENUM(NSUInteger, NoticeType) {
    Message          = 0,
    Notice           = 1
};
typedef void(^MessageCountBlock)(NSInteger count);
@interface CRFNoticeViewController : CRFBasicViewController
@property (nonatomic,assign) NoticeType type;
@property (nonatomic,copy) MessageCountBlock refreshCountBlock;
@end
