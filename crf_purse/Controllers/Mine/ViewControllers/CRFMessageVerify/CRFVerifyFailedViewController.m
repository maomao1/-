//
//  CRFVerifyFailedViewController.m
//  crf_purse
//
//  Created by maomao on 2018/6/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFVerifyFailedViewController.h"
#import "CRFStringUtils.h"
@interface CRFVerifyFailedViewController ()
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UIButton*sureBtn;
@end

@implementation CRFVerifyFailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证存管账户信息";
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kSpace/2, self.view.frame.size.width, self.view.frame.size.height-kSpace/2)];
    bgView.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.titleLabel = [[UILabel alloc]init];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [bgView addSubview:self.titleLabel];
    [bgView addSubview:self.contentLabel];
    [bgView addSubview:self.sureBtn];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kSpace/2);
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(self.view.frame.size.height-kSpace/2);
//    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 17));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(20);
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.mas_offset(3*kSpace);
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.height.mas_equalTo(kRegisterButtonHeight);
    }];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = UIColorFromRGBValue(0x333333);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = UIColorFromRGBValue(0x666666);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5.0f;
    self.sureBtn.backgroundColor = UIColorFromRGBValue(0xfb4d3a);
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = @"验证失败";
    [self.contentLabel setAttributedText: [CRFStringUtils changedLineSpaceWithTotalString:@"1)如果您当前的注册手机号与银行预留手机号不一致，请前往银行网点或联系信而富客服400-178-9898进行修改。\n\n2)如果是姓名、身份证号或银行卡其中任何一项存在问题，请联系信而富客服400-178-9898进行存管账户注销；注销后重新开户即可。\n\n感谢您的理解与支持~" lineSpace:5]];
//    self.contentLabel.text = @"1)如果您当前的注册手机号与银行预留手机号不一致，请前往银行网点或联系信而富客服400-688-8692进行修改。\n\n2)如果是姓名、身份证号或银行卡其中任何一项存在问题，请联系信而富客服400-688-8692进行存管账户注销；注销后重新开户即可。\n\n感谢您的理解与支持~";
}
-(void)sureClick{
    [self.navigationController popViewControllerAnimated:YES];
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
