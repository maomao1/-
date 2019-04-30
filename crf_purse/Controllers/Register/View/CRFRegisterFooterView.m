//
//  CRFRegisterFooterView.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/29.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFRegisterFooterView.h"
#import "CRFStringUtils.h"
#import "CRFHomeConfigHendler.h"
#import "UIImage+Color.h"
#import "UILabel+YBAttributeTextTapAction.h"

static CGFloat const kMarkImageHeight = 16;
@interface CRFRegisterFooterView()

@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UILabel *agreementTextView;

@property (nonatomic, assign) BOOL value;

@end

@implementation CRFRegisterFooterView

- (instancetype)initWithFrame:(CGRect)frame hasProtocol:(BOOL)value {
    if (self = [super initWithFrame:frame]) {
        _value = value;
        [self textView];
    }
    return self;
}

- (void)textView {
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.registerButton];
    [self.registerButton setTitle:NSLocalizedString(@"button_next_tep", nil) forState:UIControlStateNormal];
    [self.registerButton setBackgroundColor:kRegisterButtonBackgroundColor];
    [self.registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    //    self.registerButton.enabled = NO;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = 5.0f;
    self.registerButton.crf_acceptEventInterval = 0.5;
    
    if (self.value) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setImage:[UIImage imageNamed:@"register_protocol_unselected"] forState:UIControlStateNormal];
        [_markButton setImage:[UIImage imageNamed:@"register_protocol_selected"] forState:UIControlStateSelected];
        _markButton.crf_acceptEventInterval = 0.5;
        [self addSubview:self.markButton];
        [self.markButton addTarget:self action:@selector(mark:) forControlEvents:UIControlEventTouchUpInside];
        self.markButton.imageView.contentMode = UIViewContentModeRight;
        self.markButton.imageEdgeInsets = UIEdgeInsetsMake(kTopSpace / 2.0, 0, 0, -15);
        [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(kMarkImageHeight + 20, kMarkImageHeight + 15));
        }];
        UILabel *agreementTextView = [[UILabel alloc] init];
        self.agreementTextView = agreementTextView;
        [self addSubview:agreementTextView];
        [agreementTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.markButton.mas_right).with.offset(5);
            make.top.equalTo(self).with.offset(22);
            make.height.mas_equalTo(14);
            make.right.equalTo(self).with.offset(-kSpace);
        }];
        agreementTextView.backgroundColor = [UIColor clearColor];
        //        [agreementTextView setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:0 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range1:[string rangeOfString:@"我已阅读并同意"] attributes2:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(string.length - 1, 1) attributes3:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range3:[string rangeOfString:protocolName] attributes4:nil range4:NSRangeZero]];
        //        agreementTextView.enabledTapEffect = NO;
        //        weakSelf(self);
        //        [agreementTextView yb_addAttributeTapActionWithStrings:@[protocolName] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        //            strongSelf(weakSelf);
        //            if (strongSelf.protocolClick) {
        //                strongSelf.protocolClick(url);
        //            }
        //        }];
        agreementTextView.userInteractionEnabled = YES;
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(kRegisterSpace);
            make.top.equalTo(agreementTextView.mas_bottom).with.offset(21);
            make.height.mas_equalTo(kRegisterButtonHeight);
            make.right.equalTo(self).with.offset(-kRegisterSpace);
        }];
    } else {
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(kRegisterSpace);
            make.top.equalTo(self).with.offset(21);
            make.height.mas_equalTo(kRegisterButtonHeight);
            make.right.equalTo(self).with.offset(-kRegisterSpace);
        }];
    }
}

- (void)registerUser {
    if (self.registerHandle) {
        weakSelf(self);
        [CRFUtils getMainQueue:^{
            strongSelf(weakSelf);
            strongSelf.registerHandle();
        }];
    }
}

- (void)mark:(UIButton *)button {
    button.selected = !button.selected;
    //    [self registerEnable];
}

- (void)registerEnable {
    if (self.value) {
        if (self.enable && self.markButton.selected) {
            self.registerButton.enabled = YES;
        } else {
            self.registerButton.enabled = NO;
        }
    } else {
        self.registerButton.enabled = YES;
    }
    
}

- (void)setRegisterProtoocl:(NSArray<CRFProtocol *> *)registerProtoocl {
    _registerProtoocl = registerProtoocl;
    if (self.value) {
        CRFProtocol *registerProtocol = [_registerProtoocl firstObject];
        NSURL *url = nil;
        NSString *protocolName = @"";
        if (registerProtocol) {
            protocolName = registerProtocol.name;
            url = [NSURL URLWithString:registerProtocol.protocolUrl];
        } else {
            url = [NSURL new];
        }
        NSString *string = [NSString stringWithFormat:@"我已阅读并同意%@",protocolName];
        [self.agreementTextView setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:0 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range1:[string rangeOfString:@"我已阅读并同意"] attributes2:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(string.length - 1, 1) attributes3:@{NSForegroundColorAttributeName:kLinkTextColor, NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} range3:[string rangeOfString:protocolName] attributes4:nil range4:NSRangeZero]];
        self.agreementTextView.enabledTapEffect = NO;
        weakSelf(self);
        [self.agreementTextView yb_addAttributeTapActionWithStrings:@[protocolName] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            strongSelf(weakSelf);
            if (strongSelf.protocolClick) {
                strongSelf.protocolClick(url);
            }
        }];
        self.agreementTextView.userInteractionEnabled = YES;
    }
}

- (BOOL)enable {
    if (!self.value) {
        return YES;
    }
    return self.markButton.selected;
}

@end
