//
//  UIViewController+Custom.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "UIViewController+Custom.h"
#import "CRFStringUtils.h"
#import "UIImage+Color.h"


@implementation UIViewController (Custom)

- (void)setCustomRightBarBorderButtonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize target:(id)target selector:(SEL)selector titleColor:(UIColor *)color {
     [self removeButton];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64,22)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = contentView.bounds;
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = kRightBarButtonFlag;
    [contentView addSubview:button];
    [button setTitleColor:color forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateDisabled];
//    [button setTitleColor:kTextEnableColor forState:UIControlStateDisabled];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 11.0;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.layer.borderWidth = .5f;
    button.layer.borderColor = color.CGColor;
//    button.enabled = enable;
//    if (!enable) {
//        button.layer.borderColor = kTextEnableColor.CGColor;
//    } else {
//        button.layer.borderColor = kCellTitleTextColor.CGColor;
//    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    button.imageView.contentMode = UIViewContentModeRight;
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).with.offset(-kSpace / 2.0);
//        make.top.equalTo(self.view).with.offset(kStatusBarHeight + 11);
//        make.size.mas_equalTo(CGSizeMake(62, 24));
//    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:contentView];
}

- (void)setSystemRightBarButtonWithImageNamed:(NSString *)imageNamed target:(id)target selector:(SEL)selector {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNameWithOriginMode:imageNamed] style:UIBarButtonItemStylePlain target:target action:selector];
}

- (void)setCustomRightBarButtonWithImageNamed:(NSString *)imageNamed target:(id)target selector:(SEL)selector {
    [self removeButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = kRightBarButtonFlag;
    [button setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeRight;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.size.mas_equalTo(CGSizeMake(50, kNavigationbarHeight));
    }];
}

- (void)setAttributedTitle:(NSString *)title lineSpace:(CGFloat)lineSpace attributedContent:(NSString *)content attributed:(NSDictionary *)attributed subContent:(NSString *)subContent subAttributed:(NSDictionary *)subAttributed{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, kStatusBarHeight, kScreenWidth - 80, kNavigationbarHeight)];
    titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = titleLabel;
    [self setTextView:titleLabel title:title lineSpace:lineSpace content:content attributed:attributed subContent:subContent subAttributed:subAttributed];
}

- (void)setCustomAttributedTitle:(NSString *)title lineSpace:(CGFloat)lineSpace attributedContent:(NSString *)content attributed:(NSDictionary *)attributed subContent:(NSString *)subContent subAttributed:(NSDictionary *)subAttributed{
    [self removeHeader];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight - 0.5, kScreenWidth, 0.5)];
    [headerView addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.1];
    headerView.tag = 100;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, kStatusBarHeight, kScreenWidth - 80, kNavigationbarHeight)];
    titleLabel.numberOfLines = 0;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavigationbarHeight);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(.5f);
        make.top.equalTo(self.view).with.offset(kNavHeight - 0.5);
    }];
    [self setTextView:titleLabel title:title lineSpace:lineSpace content:content attributed:attributed subContent:subContent subAttributed:subAttributed];
}

- (void)setSyatemTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)setTextView:(UILabel *)contentLabel title:(NSString *)title lineSpace:(CGFloat)lineSpace content:(NSString *)content attributed:(NSDictionary *)attributed subContent:(NSString *)subContent subAttributed:(NSDictionary *)subAttributed{
    [contentLabel setAttributedText:[CRFStringUtils setAttributedString:title lineSpace:lineSpace attributes1:attributed range1:[title rangeOfString:content] attributes2:subAttributed range2:[title rangeOfString:subContent] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)setCustomTitle:(NSString *)title {
    [self removeHeader];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    headerView.tag = 100;
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [headerView addSubview:titleLabel];
    titleLabel.textColor = kTextDefaultColor;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:headerView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavigationbarHeight);
    }];
}

- (void)setCustomLineTitle:(NSString *)title {
    [self removeHeader];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    headerView.tag = 100;
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight - 0.5, kScreenWidth, 0.5)];
    [headerView addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.1];
    UILabel *titleLabel = [[UILabel alloc] init];
    [headerView addSubview:titleLabel];
    titleLabel.textColor = kTextDefaultColor;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:headerView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(kNavigationbarHeight);
    }];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(.5f);
        make.top.equalTo(self.view).with.offset(kNavHeight - 0.5);
    }];
}

- (void)removeHeader {
    for (UIView *view in self.view.subviews) {
        if (view.tag == 100) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)removeButton {
    for (UIView *view in self.view.subviews) {
        if (view.tag == kRightBarButtonFlag) {
            [view removeFromSuperview];
        }
    }
}

- (void)setRightButtonDisplay:(BOOL)display {
    UIView *view = [self.view viewWithTag:kRightBarButtonFlag];
    if (view) {
        view.hidden = display;
    }
}

- (void)autoLayoutSizeContentView:(UIScrollView *)scrollView {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if ([scrollView isKindOfClass:[UITableView class]]) {
            ((UITableView *)scrollView).estimatedSectionHeaderHeight = 0;
            ((UITableView *)scrollView).estimatedSectionFooterHeight = 0;
        }
    }
#endif
}

@end

