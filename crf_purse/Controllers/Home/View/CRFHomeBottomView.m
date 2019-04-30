//
//  CRFHomeBottomView.m
//  crf_purse
//
//  Created by mystarains on 2019/1/10.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomeBottomView.h"
#import "CRFBottomView.h"

@interface CRFHomeBottomView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleBottomView;
@property (nonatomic, strong) UIImageView *infoImageView;
@property (nonatomic, strong) CRFBottomView *bottomView;

@end

@implementation CRFHomeBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleBottomView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.infoImageView];
    [self addSubview:self.bottomView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    [self.titleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.titleLabel.mas_bottom).with.offset(2);
        make.width.equalTo(self.titleLabel);
        make.height.mas_equalTo(10);
    }];
    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(17);
        make.height.mas_equalTo(_infoImageView.mas_width).multipliedBy((20.f/67));
        
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(35*2 + 12);
        
    }];
    
}

- (void)setHomeHeaderViewDic:(NSDictionary *)homeHeaderViewDic{
    _homeHeaderViewDic = homeHeaderViewDic;
    
    NSArray *itemArr = [homeHeaderViewDic objectForKey:bottomList_key];
    
    if (itemArr.count) {
        CRFAppHomeModel *model = itemArr[0];
        [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"information_disclosureell_bg"]];
    }
    
}

- (void)tap:(UIGestureRecognizer *)sender{
    NSArray *itemArr = [self.homeHeaderViewDic objectForKey:bottomList_key];
    if (itemArr.count) {
        CRFAppHomeModel *model = itemArr[0];
        [CRFAPPCountManager setEventID:@"HOME_BOTTOM_MENU_EVENT" EventName:model.name];

        if (self.showInformationBlock) {
            self.showInformationBlock(model);
        }
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _titleLabel.text = @"信息披露";
    }
    return _titleLabel;
}

- (UIView *)titleBottomView{
    if (!_titleBottomView) {
        _titleBottomView = [UIView new];
        _titleBottomView.backgroundColor = UIColorFromRGBValue(0xFFF5CE);
    }
    return _titleBottomView;
}

-(UIImageView *)infoImageView{
    if (!_infoImageView) {
        _infoImageView = [UIImageView new];
        _infoImageView.userInteractionEnabled = YES;
        _infoImageView.image = [UIImage imageNamed:@"information_disclosureell_bg"];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_infoImageView addGestureRecognizer:tapGestureRecognizer];
        
    }
    return _infoImageView;
}

-(CRFBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"CRFBottomView" owner:self options:nil] lastObject];
        _bottomView.frame = CGRectMake(0, 0, kScreenWidth, 35*2 + 12);
    }
    
    return _bottomView;
}

@end
