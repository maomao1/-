//
//  CRFSignViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSignViewController.h"


@interface CRFSignHeaderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) void (^(backHandler))(void);

@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, strong) UILabel *line;

@end

@implementation CRFSignHeaderView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
    }
    return self;
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    self.line.hidden = !_showLine;
}

- (void)addSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.line];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).with.offset(kStatusBarHeight);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(45);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
        make.top.equalTo(self).with.offset(kStatusBarHeight);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = UIColorFromRGBValue(0xE2E2E2);
        _line.hidden = YES;
    }
    return _line;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.text = @"签到";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"back_white"];
        [image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
        
    }
    return _imageView;
}

- (void)back {
    if (self.backHandler) {
        self.backHandler();
    }
}


@end

@interface CRFSignViewController ()
@property (nonatomic, assign) BOOL updateStatusBarStyle;

@property (nonatomic, strong) CRFSignHeaderView *headerView;

@end

@implementation CRFSignViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.bounces = NO;
    self.headerView = [CRFSignHeaderView new];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kNavHeight);
    }];
    [self addObserver];
    weakSelf(self);
    [self.headerView setBackHandler:^{
        strongSelf(weakSelf);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)addObserver {
    [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([keyPath isEqualToString:@"title"]) {
        self.headerView.titleLabel.text = self.webView.title;
    } else {
        CGPoint point = [change[@"new"] CGPointValue];
        if (point.y <= 0) {
            self.headerView.alpha = 1;
            self.headerView.imageView.image = [UIImage imageNamed:@"back_white"];
            self.headerView.backgroundColor = [UIColor clearColor];
            self.headerView.titleLabel.textColor = [UIColor whiteColor];
            self.updateStatusBarStyle = NO;
            self.headerView.showLine = NO;
        } else {
            self.headerView.imageView.image = [UIImage imageNamed:@"back"];
            self.updateStatusBarStyle = YES;
            self.headerView.alpha = point.y / 100;
            self.headerView.titleLabel.textColor = [UIColor colorWithWhite:.0 alpha:self.headerView.alpha];
            self.headerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:self.headerView.alpha];
            self.headerView.showLine = self.headerView.alpha >= 1;
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.updateStatusBarStyle) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    @try {
       [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    } @catch (NSException *exception) {
        DLog(@"exception is %@",exception);
    } @finally {
        
    }
}

@end
