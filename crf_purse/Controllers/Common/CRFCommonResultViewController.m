//
//  CRFCommonResultViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFCommonResultViewController.h"
#import "CRFCommonResultView.h"

@interface CRFCommonResultViewController () <CRFCommonResultViewDelegate>

@property (nonatomic, strong) CRFCommonResultView *resultView;

@end

@implementation CRFCommonResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}

- (void)back {
    if (self.popHandler) {
        self.popHandler(self);
    } else {
        [super back];
    }
}

- (NSString *)commonButtonTitle {
    if (!_commonButtonTitle) {
        _commonButtonTitle = @"关闭";
    }
    return _commonButtonTitle;
}

- (void)initializeView {
    NSString *imageNamed = nil;
    if (self.commonResult == CRFCommonResultFailed) {
        imageNamed = @"feedback_icon_fail";
    } else if (self.commonResult == CRFCommonResultSuccess) {
        imageNamed = @"feedback_icon_succeed";
    } else {
        imageNamed = @"feedback_icon_hold_on";
    }
    _resultView = [[CRFCommonResultView alloc] initWithResultImage:[UIImage imageNamed:imageNamed] result:self.result reason:self.reason buttonTitles:self.commonButtonTitles?self.commonButtonTitles:@[self.commonButtonTitle]];
    self.resultView.commonResultDelegate = self;
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)commonResultDidTouched:(NSInteger)index {
    if (self.commonButtonHandler) {
        self.commonButtonHandler(index, self);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
