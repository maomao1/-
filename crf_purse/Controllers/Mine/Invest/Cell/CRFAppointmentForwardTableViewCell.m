//
//  CRFAppointmentForwardTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <YYText/YYLabel.h>

@interface CRFAppointmentForwardSubView : UIView

@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, copy) void (^(eventHandler))(BOOL selected);

@end

@implementation CRFAppointmentForwardSubView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iconButton setImage:[UIImage imageNamed:@"forward_filter_icon_unselected"] forState:UIControlStateNormal];
    [_iconButton addTarget:self action:@selector(seletedEvent) forControlEvents:UIControlEventTouchUpInside];
    [_iconButton setImage:[UIImage imageNamed:@"forward_filter_icon_selected"] forState:UIControlStateSelected];
    _iconButton.imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.iconButton];
    _titleLabel = [YYLabel new];
    _titleLabel.font = [CRFUtils fontWithSize:14.0];
    _titleLabel.textColor = kTextDefaultColor;
    [self addSubview:self.titleLabel];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconButton.mas_right);
        make.top.equalTo(self.iconButton);
        make.height.mas_equalTo(34);
        make.right.equalTo(self);
    }];
}

- (void)seletedEvent {
    if (self.iconButton.selected) {
        return;
    }
    self.iconButton.selected = !self.iconButton.selected;
    if (self.eventHandler) {
        self.eventHandler(self.iconButton.selected);
    }
}

@end


#import "CRFAppointmentForwardTableViewCell.h"

@interface CRFAppointmentForwardTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) CRFAppointmentForwardSubView *firstView;

@property (nonatomic, strong) CRFAppointmentForwardSubView *secondView;

@property (nonatomic, strong) CRFAppointmentForwardSubView *lastView;

@end

@implementation CRFAppointmentForwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (CRFAppointmentForwardSubView *)firstView {
    if (!_firstView) {
        _firstView = [CRFAppointmentForwardSubView new];
        weakSelf(self);
        [_firstView setEventHandler:^(BOOL selected){
            strongSelf(weakSelf);
            if (selected) {
                strongSelf.lastView.iconButton.selected = NO;
                strongSelf.secondView.iconButton.selected = NO;
            }
            if (strongSelf.itemDidSelectedHandler) {
                strongSelf.itemDidSelectedHandler(strongSelf.indexPath,1, selected);
            }
        }];
        [_firstView.titleLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            strongSelf(weakSelf);
            if (CGRectGetWidth(rect) == 30 && CGRectGetHeight(rect) == 30) {
                if (strongSelf.explainHandler) {
                    strongSelf.explainHandler();
                }
            }
        }];
    }
    return _firstView;
}

- (void)setItemDisable:(BOOL)itemDisable {
    _itemDisable = itemDisable;
    self.firstView.iconButton.userInteractionEnabled = _itemDisable;
    self.secondView.iconButton.userInteractionEnabled = _itemDisable;
    if (!itemDisable) {
        self.firstView.iconButton.selected = YES;
    } else {
        self.firstView.iconButton.selected = NO;
    }
}

- (CRFAppointmentForwardSubView *)secondView {
    if (!_secondView) {
        _secondView = [CRFAppointmentForwardSubView new];
        weakSelf(self);
        [_secondView setEventHandler:^(BOOL selected){
            strongSelf(weakSelf);
            if (selected) {
                strongSelf.firstView.iconButton.selected = NO;
                strongSelf.lastView.iconButton.selected = NO;
            }
            if (strongSelf.itemDidSelectedHandler) {
                strongSelf.itemDidSelectedHandler(strongSelf.indexPath,2, selected);
            }
        }];
    }
    return _secondView;
}

- (CRFAppointmentForwardSubView *)lastView {
    if (!_lastView) {
        _lastView = [CRFAppointmentForwardSubView new];
        weakSelf(self);
        [_lastView setEventHandler:^(BOOL selected){
            strongSelf(weakSelf);
            if (selected) {
                strongSelf.firstView.iconButton.selected = NO;
                strongSelf.secondView.iconButton.selected = NO;
            }
            if (strongSelf.itemDidSelectedHandler) {
                strongSelf.itemDidSelectedHandler(strongSelf.indexPath,3, selected);
            }
        }];
    }
    return _lastView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initializeView {
    _iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textColor = kCellTitleTextColor;
    [self addSubview:self.titleLabel];
    _line = [UIView new];
    _line.backgroundColor = kCellLineSeparatorColor;
    [self addSubview:self.line];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(kSpace);
        make.size.mas_equalTo(CGSizeMake(kSpace, kSpace));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(kSpace);
        make.right.equalTo(self);
        make.height.mas_equalTo(kSpace);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).with.offset(44);
        make.height.mas_equalTo(1);
        make.left.equalTo(self).with.offset(40);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setIconNamed:(NSString *)iconNamed {
    _iconNamed = iconNamed;
    self.iconImageView.image = [UIImage imageNamed:_iconNamed];
}

- (void)setEventNames:(NSArray<NSString *> *)eventNames {
    _eventNames = eventNames;
    if (_eventNames.count == 1) {
        [self configFirstView];
    } else if (_eventNames.count == 2) {
        [self configFirstView];
        [self configSecondView];
    } else if (_eventNames.count == 3) {
        [self configFirstView];
        [self configSecondView];
        [self configLastView];
    }
    
}

- (void)setAttributedEventNames:(NSArray<NSAttributedString *> *)attributedEventNames {
    _attributedEventNames = attributedEventNames;
    if (_attributedEventNames.count == 1) {
        [self configFirstView];
    } else if (_attributedEventNames.count == 2) {
        [self configFirstView];
        [self configSecondView];
    } else if (_attributedEventNames.count == 3) {
        [self configFirstView];
        [self configSecondView];
        [self configLastView];
    }
}

- (void)configFirstView {
    if (self.attributedEventNames) {
        [self.firstView.titleLabel setAttributedText:[self.attributedEventNames firstObject]];
    } else {
        self.firstView.titleLabel.text = [self.eventNames firstObject];
    }
    if (self.firstView.superview) {
        return;
    }
    [self addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.top.equalTo(self).with.offset(56);
        make.right.equalTo(self);
        make.height.mas_equalTo(34);
        if (self.eventNames.count == 1 || self.attributedEventNames.count == 1) {
            make.bottom.equalTo(self).with.offset(-10);
        }
    }];
}

- (void)configSecondView {
    if (self.attributedEventNames) {
        [self.secondView.titleLabel setAttributedText:self.attributedEventNames[1]];
    } else {
        self.secondView.titleLabel.text = [self.eventNames objectAtIndex:1];
    }
    if (self.secondView.superview) {
        return;
    }
    [self addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.firstView);
        make.top.equalTo(self.firstView.mas_bottom).with.offset(5);
        if (self.eventNames.count == 2 || self.attributedEventNames.count == 2) {
            make.bottom.equalTo(self).with.offset(-10);
        }
    }];
}

- (void)configLastView {
    if (self.attributedEventNames) {
        [self.lastView.titleLabel setAttributedText:[self.attributedEventNames lastObject]];
    } else {
        self.lastView.titleLabel.text = [self.eventNames lastObject];
    }
    if (self.lastView.superview) {
        return;
    }
    [self addSubview:self.lastView];
    [self.lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.secondView);
        make.top.equalTo(self.secondView.mas_bottom).with.offset(5);
        make.bottom.equalTo(self).with.offset(-10);
    }];
}

- (void)setSelectedItem:(NSInteger)selectedItem {
    _selectedItem = selectedItem;
    if (_selectedItem == 1) {
        self.firstView.iconButton.selected = YES;
    } else if (_selectedItem == 2) {
         self.secondView.iconButton.selected = YES;
    } else if (_selectedItem == 3){
         self.lastView.iconButton.selected = YES;
    }
}


@end
