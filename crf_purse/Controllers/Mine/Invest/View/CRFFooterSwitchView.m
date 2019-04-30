//
//  CRFFooterSwitchView.m
//  crf_purse
//
//  Created by maomao on 2018/6/21.
//  Copyright © 2018年 com.crfchina. All rights reserved.
// 到期自动续投开关view

#import "CRFFooterSwitchView.h"
#import "CRFStringUtils.h"
#import "UILabel+YBAttributeTextTapAction.h"
@implementation CRFFooterSwitchView
-(instancetype)initWithFrame:(CGRect)frame{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    if (self = [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc]init];
        bgView.userInteractionEnabled = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [helpBtn setImage:[UIImage imageNamed:@"mine_invest_help"] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(helpEvent) forControlEvents:UIControlEventTouchUpInside];
        helpBtn.crf_acceptEventInterval = 0.5;
        [bgView addSubview:helpBtn];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = UIColorFromRGBValue(0x999999);
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.text = @"到期处理方式：";
        [bgView addSubview:self.titleLabel];
    
        self.switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.switchBtn setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateNormal];
        [self.switchBtn setTitleColor:UIColorFromRGBValue(0xfb4d3a) forState:UIControlStateSelected];
        [self.switchBtn setTitle:@"更改" forState:UIControlStateNormal];
        self.switchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.switchBtn addTarget:self action:@selector(switchEvent:) forControlEvents:UIControlEventTouchUpInside];
        self.switchBtn.crf_acceptEventInterval = 0.5;
        
        [bgView addSubview: self.switchBtn];
         [self addSubview:bgView];
        
        self.switchBtn.layer.masksToBounds = YES;
        self.switchBtn.layer.cornerRadius  = 9.0f;
        self.switchBtn.layer.borderColor  = UIColorFromRGBValue(0xfb4d3a).CGColor;
        self.switchBtn.layer.borderWidth = 1.0;
        
        self.switchBtn.backgroundColor = [UIColor clearColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        helpBtn.backgroundColor = [UIColor clearColor];
        
        self.linkLabel = [[UILabel alloc]init];
        self.linkLabel.backgroundColor = [UIColor clearColor];
        self.linkLabel.font = [UIFont systemFontOfSize:11];
        self.linkLabel.textColor = kTextEnableColor;
        
        self.linkLabel.numberOfLines = 0;
        [self addSubview:self.linkLabel];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50));
            make.left.equalTo(self);
            make.top.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.switchBtn.mas_left).with.mas_offset(-3);
            make.height.mas_equalTo(18);
            make.centerY.equalTo(bgView.mas_centerY);
            make.centerX.equalTo(self.mas_centerX).with.mas_offset(-20);
        }];
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 18));
            make.centerY.equalTo(bgView.mas_centerY);
        }];
        [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.right.equalTo(self.titleLabel.mas_left).with.mas_offset(0);
            make.centerY.equalTo(self.switchBtn.mas_centerY);
        }];
        [self.linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom).with.mas_offset(kSpace);
            make.left.mas_equalTo(kSpace);
            make.right.mas_equalTo(-kSpace);
        }];
    }
    return self;
}
-(void)setProtocolArr:(NSArray *)protocolArr{
    _protocolArr = protocolArr;
    NSMutableArray *names =[[NSMutableArray alloc]init];
    NSMutableArray *linkUrls = [[NSMutableArray alloc]init];
    if (_protocolArr.count) {
        for (CRFProtocol *item in _protocolArr) {
            [names addObject:item.name];
            [linkUrls addObject:item.protocolUrl];
        }
    }
    NSString *namesStr = [names componentsJoinedByString:@""];
    NSString *totalStr = [NSString stringWithFormat:@"您确认并同意，除您选择“到期债转退出”外，当前计划到期后将自动加入到自动续投计划，并自动适用如下协议及文件：%@。您对此充分知悉且无异议。",namesStr];
    self.LinkHeight = [totalStr boundingRectWithSize:CGSizeMake(kScreenWidth - kSpace * 2, CGFLOAT_MAX) fontNumber:11.0 lineSpace:5].height+80;
    [self.linkLabel setAttributedText:[CRFStringUtils setAttributedString:totalStr lineSpace:5 attributes1:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0xFB4D3A)} range1:[totalStr rangeOfString:namesStr] attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    self.linkLabel.userInteractionEnabled = YES;
    weakSelf(self);
    [self.linkLabel yb_addAttributeTapActionWithStrings:names tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        strongSelf(weakSelf);
        if (strongSelf.pushBlock) {
            strongSelf.pushBlock ([linkUrls objectAtIndex:index]);
        }
    }];
}
-(void)setBtnTitle:(NSString *)title{
//    [self.switchBtn setTitle:title forState:UIControlStateNormal];
}
-(void)updateLabelTitleString:(NSString *)title{
    NSString *string = [NSString stringWithFormat:@"到期处理方式： %@",title];
    [self.titleLabel setAttributedText:[CRFStringUtils setAttributedString:string lineSpace:.0f attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range1:NSMakeRange(0, string.length) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x333333)} range2:[string rangeOfString:title] attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
}
-(void)helpEvent{
    if (self.helpBlock) {
        self.helpBlock();
    }
}
-(void)switchEvent:(UIButton*)btn{
    if (self.switchBlock) {
        self.switchBlock();
    }
}
@end
