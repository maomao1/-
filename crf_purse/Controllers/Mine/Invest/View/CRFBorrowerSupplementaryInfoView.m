//
//  CRFBorrowerSupplementaryInfoView.m
//  crf_purse
//
//  Created by mystarains on 2018/11/28.
//  Copyright © 2018 com.crfchina. All rights reserved.
//

#import "CRFBorrowerSupplementaryInfoView.h"

@interface CRFBorrowerSupplementaryInfoView()

@property (nonatomic, strong) UIVisualEffectView *effectview;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation CRFBorrowerSupplementaryInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
}

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        
        _effectview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _effectview.alpha = 1;
    }
    return _effectview;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = .0f;
        self.effectview.alpha = .0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.effectview removeFromSuperview];
    }];
}

- (void)setContentWithBorrowerInfoModel:(CRFBorrowerInfoModel*)borrowerInfoModel{
    NSArray *contentArr = @[@{@"title":@"还款方式：",@"content":[NSString stringWithFormat:@"%@\n",borrowerInfoModel.repayType]},
                            @{@"title":@"起息日：",@"content":[NSString stringWithFormat:@"%@\n",borrowerInfoModel.interestDate]},
                            @{@"title":@"还款来源：",@"content":[NSString stringWithFormat:@"%@\n",borrowerInfoModel.repaySource]},
                            @{@"title":@"还款保障措施：",@"content":[NSString stringWithFormat:@"%@\n",borrowerInfoModel.repaySecurity]},
                            @{@"title":@"借款人风险评估及可能产生的风险结果：",@"content":[NSString stringWithFormat:@"%@\n",borrowerInfoModel.riskLevel]},
                            @{@"title":@"已撮合未到期资金运作情况：",@"content":[NSString stringWithFormat:@"%@\n",borrowerInfoModel.capitalUseCase]}
                            ];
    //初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    for (NSDictionary *itemDic in contentArr) {
        NSString *str0 = itemDic[@"title"];
        NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorFromRGBValue(0x103586)};
        NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
        [attributedString appendAttributedString:attr0];
        
        NSString *str1 = itemDic[@"content"];
        NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorFromRGBValue(0x9D9D9D)};
        NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
        [attributedString appendAttributedString:attr1];
        
        //段落样式
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        //行间距
        paragraph.lineSpacing = 5;
        //段落间距
        paragraph.paragraphSpacing = 10;
        //对齐方式
        paragraph.alignment = NSTextAlignmentLeft;
        
        NSRange range = [attributedString.string rangeOfString:attr0.string];
        
        //添加段落设置
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(range.location, attributedString.length-range.location)];
        
    }
    
    self.contentLabel.attributedText = attributedString;
    
}

- (void)showAlert {
    [[UIApplication sharedApplication].delegate.window addSubview:self.effectview];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1;
        self.effectview.alpha = 1;
    }];
}


@end
