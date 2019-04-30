//
//  CRFToast.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFToast.h"
#import "UILabel+Edge.h"


@interface CRFToastItem : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) CGFloat time;

@end

@implementation CRFToastItem

- (NSString *)message {
    if (!_message) {
        _message = @"";
    }
    return _message;
}

@end

@interface CRFToast ()

@property (nonatomic, strong) NSMutableArray <CRFToastItem *>*queues;

@end

@implementation CRFToast

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static CRFToast *toast = nil;
    dispatch_once(&once, ^{
        toast = [[self alloc] init];
    });
    return toast;
}

- (instancetype)init {
    if (self = [super init]) {
        _queues = [NSMutableArray new];
    }
    return self;
}

+ (void)showMessage:(NSString *)message drution:(CGFloat)time {
    CRFToastItem *toastItem = [CRFToastItem new];
    toastItem.message = message;
    toastItem.time = time;
    if ([CRFToast sharedInstance].queues.count <= 0) {
        [[CRFToast sharedInstance].queues addObject:toastItem];
        @synchronized([CRFToast sharedInstance]) {
            [self showToastItem:[[CRFToast sharedInstance].queues firstObject]];
        }
    } else {
        [[CRFToast sharedInstance].queues addObject:toastItem];
    }
}

+ (void)showToastItem:(CRFToastItem *)toastItem {
    if ([toastItem.message isEmpty]) {
        return;
    }
    UIView * container = [UIApplication sharedApplication].delegate.window;
    [CRFUtils getMainQueue:^{
        CGFloat width = [NSLocalizedString(toastItem.message, nil) boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 74) fontNumber:13.0].width;
        CGRect rect;
        if (width + kSpace * 2 + 40 * 2 > CGRectGetWidth([UIScreen mainScreen].bounds)) {
            CGFloat height = [NSLocalizedString(toastItem.message, nil) boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - kSpace * 2 - 40 * 2, CGFLOAT_MAX) fontNumber:13.0].height  + kSpace * 2;
            rect = CGRectMake(40, CGRectGetHeight([UIScreen mainScreen].bounds) / 2 - height / 2.0, CGRectGetWidth([UIScreen mainScreen].bounds) - 40 * 2, height);
        } else {
            rect = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - width - 30) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) / 2.0 - 43 / 2.0, width + 30, 43);
        }
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:rect];
        [container addSubview:messageLabel];
        messageLabel.contentInsets = UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
        [messageLabel sizeThatFits:CGSizeMake(rect.size.width, 0)];
        messageLabel.text = NSLocalizedString(toastItem.message, nil);
        messageLabel.numberOfLines = 0;
        messageLabel.layer.masksToBounds = YES;
        messageLabel.layer.cornerRadius = 5.0f;
        messageLabel.font = [UIFont systemFontOfSize:13.0];
        messageLabel.backgroundColor = [UIColor colorWithWhite:.0 alpha:0.8];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(toastItem.time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                messageLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [messageLabel removeFromSuperview];
                [[CRFToast sharedInstance].queues removeObject:toastItem];
                if ([CRFToast sharedInstance].queues.count > 0) {
                    [self showToastItem:[[CRFToast sharedInstance].queues firstObject]];
                }
            }];
        });
    }];
}

@end
