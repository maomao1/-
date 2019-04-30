//
//  CRFHomeNavView.m
//  crf_purse
//
//  Created by mystarains on 2019/1/9.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomeNavView.h"
#import "CRFLoginViewController.h"
#import "CRFMessageScrollViewController.h"
#import "UIView+CRFController.h"

@interface CRFHomeNavView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) enum MessageIconType messageIconType;

@end

@implementation CRFHomeNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
        self.titleLabel.text =  NSLocalizedString(@"title_home", nil);
    }
    return self;
}

- (void)initializeView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.line];
}

- (void)changeViewAlpha:(CGFloat)alpha{
    self.alpha = alpha;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    self.titleLabel.alpha = alpha;
    self.line.backgroundColor = UIColorFromRGBValueAndalpha(0xEEEEEE,alpha);
    self.line.alpha = alpha;
    [self setMessageCount:self.messageCount];
}

- (void)setMessageCount:(NSString *)messageCount{
    
    _messageCount = messageCount;
    
    if ([CRFAppManager defaultManager].login) {
        
        if (messageCount.intValue >0 && self.alpha >=1) {
            self.messageIconType = MessageIconTypeGrayMessage;
        }else if (messageCount.intValue == 0 && self.alpha >=1){
            self.messageIconType = MessageIconTypeGrayNoMessage;
        }else if (messageCount.intValue  > 0 && self.alpha < 1){
            self.messageIconType = MessageIconTypeWhiteMessage;
        }else{
            self.messageIconType = MessageIconTypeWhiteNoMessage;
        }
        
    }else{
        if (self.alpha >=1) {
          
            self.messageIconType = MessageIconTypeGrayNoMessage;
            
        }else{
            self.messageIconType = MessageIconTypeWhiteNoMessage;
        }
    }
    
}

- (void)actionButtonClick:(UIButton *)sender{
    
    if (![CRFAppManager defaultManager].login) {
       CRFLoginViewController *controller = [[CRFLoginViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    CRFMessageScrollViewController *controller = [CRFMessageScrollViewController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setMessageIconType:(enum MessageIconType)messageIconType{
    _messageIconType = messageIconType;
    switch (messageIconType) {
        case MessageIconTypeWhiteNoMessage:
             [_actionButton setImage:[UIImage imageNamed:@"home_message_white_no_point"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"home_message_white_no_point"] forState:UIControlStateHighlighted];
            break;
        case MessageIconTypeWhiteMessage:
             [_actionButton setImage:[UIImage imageNamed:@"home_message_white_point"] forState:UIControlStateNormal];
             [_actionButton setImage:[UIImage imageNamed:@"home_message_white_point"] forState:UIControlStateHighlighted];
            break;
        case MessageIconTypeGrayNoMessage:
             [_actionButton setImage:[UIImage imageNamed:@"home_message_gray_no_point"] forState:UIControlStateNormal];
            [_actionButton setImage:[UIImage imageNamed:@"home_message_gray_no_point"] forState:UIControlStateHighlighted];
            break;
        case MessageIconTypeGrayMessage:
             [_actionButton setImage:[UIImage imageNamed:@"home_message_gray_point"] forState:UIControlStateNormal];
             [_actionButton setImage:[UIImage imageNamed:@"home_message_gray_point"] forState:UIControlStateHighlighted];
            break;
            
        default:
            break;
    }

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    // 当前控件上的点转换到actionButton上
    CGPoint chatP = [self convertPoint:point toView:self.actionButton];
    
    // 判断下点在不在actionButton上
    if ([self.actionButton pointInside:chatP withEvent:event]) {
        return self.actionButton;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 200)/2, CGRectGetHeight(self.frame) - 30 - 7, 200, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.alpha = 0.f;
    }
    return _titleLabel;
}

- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 30 - 15,CGRectGetHeight(self.frame) - 30 - 7, 30, 30);
        [_actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setImage:[UIImage imageNamed:@"home_message_white_no_point"] forState:UIControlStateNormal];
        [_actionButton setImage:[UIImage imageNamed:@"home_message_white_no_point"] forState:UIControlStateHighlighted];
    }
    
    return _actionButton;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.frame = CGRectMake(0, self.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
        _line.backgroundColor =  UIColorFromRGBValueAndalpha(0xEEEEEE,0);
    }
    
    return _line;
}

@end
