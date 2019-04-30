//
//  CRFPickerView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFPickerView.h"


@interface CRFPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *jsonArray;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) id selectedObject;

@property (nonatomic, assign) NSInteger middleIndex;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIWindow *rootWindow;
@property (nonatomic, strong) UIView *brigeView;

@end

@implementation CRFPickerView

- (UIWindow *)rootWindow {
    if (!_rootWindow) {
        _rootWindow = [UIApplication sharedApplication].delegate.window;
    }
    return _rootWindow;
}

- (UIView *)brigeView {
    if (!_brigeView) {
        _brigeView = [UIView new];
        _brigeView.backgroundColor = [UIColor colorWithWhite:.0 alpha:0.4];
    }
    return _brigeView;
}

- (instancetype)initWithType:(PickerType)type {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _pickerType = type;
        [self getJsonData];
        [self.brigeView addSubview:self];
        [self addSubview:self.pickerView];
        [self addSubview:self.topView];
        [self.topView addSubview:self.leftButton];
        [self.topView addSubview:self.rightButton];
        [self layoutViews];
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
        _leftButton.backgroundColor = [UIColor whiteColor];
        [_leftButton setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_leftButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:NSLocalizedString(@"button_complate", nil) forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColorFromRGBValue(0xFB4D3A) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_rightButton addTarget:self action:@selector(complata) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)layoutViews {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.brigeView);
        make.top.equalTo(self.brigeView).with.offset(kScreenHeight - (198 * kHeightRatio + 45));
        make.height.mas_equalTo(198 * kHeightRatio + 45);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).with.offset(45);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-kSpace);
        make.top.equalTo(self.leftButton);
        make.size.equalTo(self.leftButton);
    }];
}

- (id)selectedObject {
    if (!_selectedObject) {
        _selectedObject = [self.jsonArray firstObject];
    }
    return _selectedObject;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (void)getJsonData {
    if (self.pickerType == Address) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"crf_cities" ofType:@"json"];
        NSData *data=[NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        _jsonArray = [NSArray yy_modelArrayWithClass:[CRFCity class] json:jsonObject];
    } else {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"bank_cities" ofType:@"json"];
        NSData *data=[NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        _jsonArray = [NSArray yy_modelArrayWithClass:[CRFBankCity class] json:jsonObject];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerType == Create_Account) {
        return 2;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerType == Create_Account) {
        if (component == 0) {
            return self.jsonArray.count;
        }
        return ((CRFBankCity *)self.selectedObject).bankCities.count;
    }
    if (component == 0) {
        return self.jsonArray.count;
    } else if (component == 1) {
        if (((CRFCity *)self.selectedObject).subCities.count == 0) {
            return 1;
        }
        return ((CRFCity *)self.selectedObject).subCities.count;
    }
    return ((CRFCity *)self.selectedObject).subCities[self.middleIndex].lastTowns.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = UIColorFromRGBValue(0x333333);
    if (self.pickerType == Create_Account) {
        label.frame = CGRectMake(0, 0, kScreenWidth / 3, 40);
        if (component == 0) {
            label.text = ((CRFBankCity *)self.jsonArray[row]).name;
        } else {
            label.text = ((CRFSubBankCity *)((CRFBankCity *)self.selectedObject).bankCities[row]).name;
        }
    } else {
        if (component == 0) {
            label.text = ((CRFCity *)self.jsonArray[row]).name;
        }
        if (component == 1) {
            if (((CRFCity *)self.selectedObject).subCities.count == 0) {
                label.text = ((CRFCity *)self.selectedObject).name;
            } else {
                if (row >= ((CRFCity *)self.selectedObject).subCities.count) {
                    label.text = ((CRFCity *)self.selectedObject).subCities[0].name;
                } else {
                    label.text = ((CRFCity *)self.selectedObject).subCities[row].name;
                }
            }
        }
        if (component == 2) {
            if (row >= ((CRFCity *)self.selectedObject).subCities[self.middleIndex].lastTowns.count) {
                
                label.text = ((CRFCity *)self.selectedObject).subCities[self.middleIndex].lastTowns[0].name;
            } else {
                label.text = ((CRFCity *)self.selectedObject).subCities[self.middleIndex].lastTowns[row].name;
            }
        }
    }
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerType == Create_Account) {
        return kScreenWidth / 2.0;
    }
    return kScreenWidth / 3.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerType == Create_Account) {
        if (component == 0) {
            self.selectedObject = self.jsonArray[row];
            self.firstIndex = row;
            [self.pickerView reloadComponent:1];
        } else {
            self.lastIndex = row;
        }
        return;
    }
    if (component == 0) {
        self.firstIndex = row;
        self.selectedObject = self.jsonArray[row];
        self.middleIndex = 0;
        self.lastIndex = 0;
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES]
        ;
    } else if (component == 1) {
        self.middleIndex = row;
        self.lastIndex = 0;
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    } else {
        self.lastIndex = row;
    }
}

- (void)cancelAction {
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (void)complata {
    if (self.complataHandler) {
        self.complataHandler(self.selectedObject, self.middleIndex, self.lastIndex);
    }
}

- (void)show {
    [self.rootWindow addSubview:self.brigeView];
    [self.brigeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.rootWindow);
        make.top.equalTo(self.rootWindow).with.offset(kScreenHeight);
    }];
}

- (void)update:(BOOL)show {
    [self.brigeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootWindow.mas_top).with.offset(show? .0f:kScreenHeight);
    }];
}

@end
