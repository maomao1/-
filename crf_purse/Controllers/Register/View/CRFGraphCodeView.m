//
//  CRFGraphCodeView.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFGraphCodeView.h"
#import "CRFTimeUtil.h"

static CGFloat const kCodeViewWidth = 265;
static CGFloat const kCodeViewHeight = 180;

@interface CRFGraphCodeView() {
    UIButton *button;
    UILabel *titleLabel;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void (^(resultHandle))(NSString *value);
@property (nonatomic, strong) UIWindow *rootWindow;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation CRFGraphCodeView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
         [self.bgView addSubview:self];
        self.layer.cornerRadius = 8.0f;
        [self configTitleView];
        [self configTextView];
        [self closeView];
        [self configButton];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:.0 alpha:0.6];
    }
    return _bgView;
}

- (UIWindow *)rootWindow {
    if (!_rootWindow) {
        _rootWindow = [UIApplication sharedApplication].delegate.window;
    }
    return _rootWindow;
}

- (void)configTitleView {
    titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"label_verify_code_place", nil);
    titleLabel.textColor = UIColorFromRGBValue(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(19);
        make.height.mas_equalTo(16);
    }];
}

- (void)configTextView {
    _textField = [[UITextField alloc] init];
    _textField.placeholder = NSLocalizedString(@"placeholder_verify_code", nil);
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:self.textField];
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshImage)]];
    [self addSubview:self.imageView];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self).with.offset(kRegisterSpace);
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(kCellHeight);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_right).with.offset(10);
        make.top.equalTo(self.textField);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(kCellHeight);
    }];
}

- (void)closeView {
    UIImageView *closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    closeImageView.userInteractionEnabled = YES;
    [closeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)]];
    [self.bgView addSubview:closeImageView];
    [closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).with.offset(30);
        make.left.equalTo(self.bgView).with.offset(170 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
}

- (void)configButton {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"button_commit", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = kRegisterButtonBackgroundColor;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kRegisterSpace);
        make.right.bottom.equalTo(self).with.offset(-kRegisterSpace);
        make.height.mas_equalTo(40);
    }];
}

- (void)commit:(UIButton *)button {
    [self.bgView removeFromSuperview];
    if (self.resultHandle) {
        self.resultHandle(self.textField.text);
    }
}

- (void)commitResult:(void (^)(NSString *))handle {
    self.resultHandle = handle;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = title;
}

- (void)setPlaceholer:(NSString *)placeholer {
    _placeholer = placeholer;
    self.textField.placeholder = placeholer;
}

- (void)setCommitTitle:(NSString *)commitTitle {
    _commitTitle = commitTitle;
    [button setTitle:commitTitle forState:UIControlStateNormal];
}

- (void)refreshImage {
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] getWithGraphCode:[NSString stringWithFormat:APIFormat(kGraphicCaptchaPath),self.phoneNumber] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf paserResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)close {
    [self.bgView removeFromSuperview];
    if (self.CancelHandler) {
        self.CancelHandler();
    }
}

- (void)paserResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        [self close];
        [CRFUtils showMessage:response[kMessageKey]];
        return;
    }
    self.imageView.image = [UIImage imageWithData:(NSData *)response];
}

- (void)addSubView {
    self.textField.text = nil;
    [self.rootWindow addSubview:self.bgView];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(223 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(kCodeViewWidth, kCodeViewHeight));
        make.left.equalTo(self.bgView).with.offset((kScreenWidth - kCodeViewWidth) / 2.0);
    }];
}

- (void)endEdit {
    [self endEditing:YES];
    if (self.CancelHandler) {
        self.CancelHandler();
    }
}

@end
