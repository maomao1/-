//
//  CRFAlertUtils.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAlertUtils.h"
#import "JCAlertController.h"
#import "UIViewController+JCPresentQueue.h"
#import "CRFLabel.h"

@implementation CRFAlertUtils

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        JCAlertController *alertController = [JCAlertController alertWithTitle:title message:message];
        alertController.textAlignment = NSTextAlignmentCenter;
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        if (confirmTitle && confirmTitle.length > 0) {
            [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        }
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
    //    [container jc_presentViewController:alertController presentCompletion:nil dismissCompletion:nil];
}

+ (void)showAlertTitle:(NSString *)title imagedName:(NSString *)imagedName container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 96)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = UIColorFromRGBValue(0x333333);
        contentLabel.text = title;
        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [contentView addSubview:contentLabel];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagedName]];
        imageView.frame = CGRectMake(width / 2 - 30 / 2.0, 20, 30, 30);
        [contentView addSubview:imageView];
        contentLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, width, 16);
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}
+ (void)showAlertTitle:(NSString *)title  container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 96)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = UIColorFromRGBValue(0x333333);
        contentLabel.text = title;
        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [contentView addSubview:contentLabel];
        contentLabel.frame = CGRectMake(0, 0, width, 96);
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message imagedName:(NSString *)imagedName container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        CGFloat contentHeight = [message boundingRectWithSize:CGSizeMake(width - 40, CGFLOAT_MAX) fontNumber:14].height;
        if (contentHeight > 20) {
            contentHeight = 40;
        } else {
            contentHeight = 20;
        }
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 117 + contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = UIColorFromRGBValue(0x333333);
        contentLabel.text = title;
        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [contentView addSubview:contentLabel];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagedName]];
        imageView.frame = CGRectMake(width / 2 - 30 / 2.0, 20, 30, 30);
        [contentView addSubview:imageView];
        contentLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, width, 16);
        UILabel *messageLabel = [UILabel new];
        [contentView addSubview:messageLabel];
        messageLabel.frame = CGRectMake(20, CGRectGetMaxY(contentLabel.frame) + 15, width - 40, contentHeight);
        messageLabel.font = [UIFont systemFontOfSize:14.0];
        messageLabel.text = message;
        messageLabel.textColor = UIColorFromRGBValue(0x666666);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}

+ (void)showAlertMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        CGFloat contentHeight = [attributedMessage.string boundingRectWithSize:CGSizeMake(width - kSpace * 2, CGFLOAT_MAX) fontNumber:16.0 lineSpace:5].height;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        CRFLabel *contentLabel = [[CRFLabel alloc] init];
        contentLabel.frame = CGRectMake(kSpace, 0, width - kSpace * 2, contentHeight);
        //        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.verticalAlignment = VerticalAlignmentMiddle;
        contentLabel.textColor = kCellTitleTextColor;
        contentLabel.numberOfLines = 0;
        [contentLabel setAttributedText:attributedMessage];
        //        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [contentView addSubview:contentLabel];
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}
+ (void)showAlertMidMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        CGFloat contentHeight = [attributedMessage.string boundingRectWithSize:CGSizeMake(width - kSpace * 2, CGFLOAT_MAX) fontNumber:16.0 lineSpace:5].height;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, contentHeight+20)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *contentLabel = [[CRFLabel alloc] init];
        contentLabel.frame = CGRectMake(kSpace, 10, width - kSpace * 2, contentHeight);
        contentLabel.textAlignment = NSTextAlignmentCenter;
//        contentLabel.verticalAlignment = VerticalAlignmentMiddle;
        contentLabel.textColor = kCellTitleTextColor;
        contentLabel.numberOfLines = 0;
        [contentLabel setAttributedText:attributedMessage];
        //        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [contentView addSubview:contentLabel];
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}
+ (void)showAlertLeftTitle:(NSString *)title AttributedMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        CGFloat contentHeight = [attributedMessage.string boundingRectWithSize:CGSizeMake(width - kSpace * 2, CGFLOAT_MAX) fontNumber:16.0 lineSpace:5].height;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, contentHeight + 20 + 20 * 3)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, 20, kScreenWidth - 2 * kSpace, 20)];
        titleLabel.textColor = kTextDefaultColor;
        titleLabel.text = title;
        [contentView addSubview:titleLabel];
        CRFLabel *contentLabel = [[CRFLabel alloc] init];
        contentLabel.frame = CGRectMake(kSpace, 20 * 2 + 20, width - kSpace * 2, contentHeight);
        contentLabel.verticalAlignment = VerticalAlignmentMiddle;
        contentLabel.textColor = kCellTitleTextColor;
        contentLabel.numberOfLines = 0;
        [contentLabel setAttributedText:attributedMessage];
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:contentLabel];
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}


+ (void)showAlertTitle:(NSString *)title contentLeftMessage:(NSString *)message container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        JCAlertController *alertController = [JCAlertController alertWithTitle:title message:message];
        alertController.textAlignment = NSTextAlignmentLeft;
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
        //    [container jc_presentViewController:alertController presentCompletion:nil dismissCompletion:nil];
    }];
}

+ (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle items:(NSArray <NSString *>*)items completeHandler:(void (^)(NSInteger index))completeHandler cancelHandler:(void (^)(void))cancelHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *item in items) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completeHandler) {
                completeHandler([items indexOfObject:item]);
            }
        }];
        [alertController addAction:alertAction];
    }
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelHandler) {
                cancelHandler();
            }
        }];
        [alertController addAction:cancelAction];
    }
    [container presentViewController:alertController animated:YES completion:nil];
}

+ (void)actionSheetWithItems:(NSArray <NSString *> *)items container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle completeHandler:(void (^)(NSInteger index))completeHandler cancelHandler:(void (^)(void))cancelHandler {
    [self actionSheetWithTitle:nil message:nil container:container cancelTitle:cancelTitle items:items completeHandler:completeHandler cancelHandler:cancelHandler];
}

+ (void)showAppointmentForwardAlertMessage:(NSMutableAttributedString *)attributedMessage container:(UIViewController *)container cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancelHandler:(void (^)(void))cancelHandler confirmHandler:(void (^)(void))confirmHandler {
    [CRFUtils getMainQueue:^{
        CGFloat width = [UIScreen mainScreen].bounds.size.width == 320 ? 260 : 280;
        CGFloat contentHeight = [attributedMessage.string boundingRectWithSize:CGSizeMake(width - kSpace * 2, CGFLOAT_MAX) fontNumber:16.0 lineSpace:5].height + 20 * 2;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        CRFLabel *contentLabel = [[CRFLabel alloc] init];
        contentLabel.frame = CGRectMake(kSpace, 0, width - kSpace * 2, contentHeight);
        //        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.verticalAlignment = VerticalAlignmentMiddle;
        contentLabel.textColor = kTextDefaultColor;
        contentLabel.numberOfLines = 0;
        [contentLabel setAttributedText:attributedMessage];
        //        contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
        contentLabel.font = [UIFont systemFontOfSize:16.0f];
        [contentView addSubview:contentLabel];
        JCAlertController *alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
        if (cancelTitle && cancelTitle.length > 0) {
            [alertController addButtonWithTitle:cancelTitle type:JCButtonTypeCancel clicked:cancelHandler];
        }
        [alertController addButtonWithTitle:confirmTitle type:JCButtonTypeWarning clicked:confirmHandler];
        [container jc_presentViewController:alertController presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
    }];
}


@end

