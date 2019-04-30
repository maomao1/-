//
//  CRFDatePickerView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDatePickerView.h"

@interface CRFDatePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger index;

@end

@implementation CRFDatePickerView

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.4];
    }
    return _bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).with.offset(45);
        }];
        [self addLine];
    }
    return self;
}

- (void)addLine {
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:.0 alpha:.1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(45);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)setDates:(NSArray<NSString *> *)dates {
    _dates = dates;
    [self.pickerView reloadAllComponents];
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dates.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = self.dates[row];
    label.textColor = UIColorFromRGBValue(0x666666);
        return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreenWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.index = row;
}

- (void)config {
    UILabel *label = [UILabel new];
    label.textColor = UIColorFromRGBValue(0x333333);
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = @"选择账单";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorFromRGBValue(0x3333333) forState:UIControlStateNormal];
    [self addSubview:leftButton];
    [leftButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGBValue(0x3333333) forState:UIControlStateNormal];
    [self addSubview:rightButton];
    [rightButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(200);
    }];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(35);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-kSpace);
        make.top.equalTo(self);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(35);
    }];
}

- (void)cancelAction {
    [self hidden];
}

- (void)confirmAction {
    [self hidden];
    if (self.didSelectedHandler) {
        self.didSelectedHandler(self.index);
    }
}

- (void)addView {
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 233);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self.bgView];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self];
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(0, kScreenHeight - 233, kScreenWidth, 233);
    }];
}

- (void)hidden {
    [self.bgView removeFromSuperview];
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 233);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedHandler) {
        self.didSelectedHandler(indexPath.row);
    }
}



@end
