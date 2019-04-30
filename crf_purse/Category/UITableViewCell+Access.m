//
//  UITableViewCell+Access.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "UITableViewCell+Access.h"
#import <objc/runtime.h>
static char kAccessKey;
static char kCustomAccessKey;

@implementation UITableViewCell (Access)

- (void)setHasAccessoryView:(BOOL)hasAccessoryView {
    if (hasAccessoryView) {
        [self configAccessView];
    } else {
        self.accessoryView = nil;
    }
      objc_setAssociatedObject(self, &kAccessKey, @(hasAccessoryView), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)hasAccessoryView {
     return [objc_getAssociatedObject(self, &kAccessKey) boolValue];
}

- (void)setCustomAccessoryView:(BOOL)customAccessoryView {
    if (customAccessoryView) {
        [self configCustomView];
    } else {
        self.accessoryView = nil;
    }
    objc_setAssociatedObject(self, &kCustomAccessKey, @(customAccessoryView), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)configCustomView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_already_auth"]];
    self.accessoryView = imageView;
}

- (BOOL)customAccessoryView {
     return [objc_getAssociatedObject(self, &kCustomAccessKey) boolValue];
}

- (void)configAccessView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_accessory"]];
    self.accessoryView = imageView;
}

@end
