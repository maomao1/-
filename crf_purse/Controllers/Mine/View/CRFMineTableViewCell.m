//
//  CRFMineTableViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMineTableViewCell.h"
#import "CRFNewMineCell.h"
@interface CRFMineTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *investBtn;
@property (nonatomic, strong) UIButton *packetBtn;
@property (nonatomic, strong) UIButton *messageBtn;

@property (nonatomic ,strong) UIImageView      *backgroundImg;
@end
@implementation CRFMineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
//        self.detailTextLabel.textColor = UIColorFromRGBValue(0x666666);
//        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
//        self.textLabel.textColor = UIColorFromRGBValue(0x333333);
//        [self configNewMessage];
//        self.hasAccessoryView = YES;
        if ([reuseIdentifier isEqualToString:CRFMineTableViewCellId]) {
            [self initContentView];
        }
        else{
            [self initCommondUI];
        }
    }
    return self;
}
-(void)initCommondUI{
    [self addSubview:self.backgroundImg];
    [self addSubview:self.mainCollectionView];
    [self.backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImg.mas_top).with.mas_offset(30*kWidthRatio);
        make.bottom.equalTo(self.backgroundImg.mas_bottom).with.mas_offset(-30*kWidthRatio);
        make.left.equalTo(self.backgroundImg.mas_left).with.mas_offset(45*kWidthRatio);
        make.right.equalTo(self.backgroundImg.mas_right).with.mas_offset(-45*kWidthRatio);
    }];
}
-(void)initContentView{
    self.investBtn = [self createBtnTitle:@"我的投资" ImageName:@"new_mine_invest"];
    self.packetBtn = [self createBtnTitle:@"优惠红包" ImageName:@"new_mine_red_packet"];
    self.messageBtn= [self createBtnTitle:@"消息中心" ImageName:@"new_mine_message"];
    [self addSubview:self.investBtn];
    [self addSubview:self.packetBtn];
    [self addSubview:self.messageBtn];
    
    [self.packetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.investBtn mas_makeConstraints:^(MASConstraintMaker *make) {\
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self configNewMessage];
}
- (void)configNewMessage {
    _messageLabel = [UILabel new];
    _messageLabel.hidden = YES;
    _messageLabel.clipsToBounds = YES;
    _messageLabel.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
    _messageLabel.layer.backgroundColor = UIColorFromRGBValue(0xFB4D3A).CGColor;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.layer.cornerRadius = 7.5f;
    [self addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageBtn.mas_right).with.offset(-5);
        make.top.equalTo(self.messageBtn.mas_top).with.offset(10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
}

- (void)setMessageStyle:(NewMessageStyle)messageStyle {
    _messageStyle = messageStyle;
    if (_messageStyle == None) {
        self.messageLabel.hidden = YES;
    } else if (_messageStyle == Number) {
        self.messageLabel.hidden = NO;
        self.messageLabel.font = [UIFont systemFontOfSize:13.0f];
        self.messageLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.badgeNumber];
        CGFloat width = [self.messageLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) fontNumber:13.0].width + 7;
        if (width < 15) {
            width = 15;
        }
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    } else {
        self.messageLabel.hidden = NO;
        self.messageLabel.font = [UIFont systemFontOfSize:12.0];
        self.messageLabel.text = NSLocalizedString(@"cell_label_velue_new_common", nil);
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
        }];
    }
}
-(void)btnClick:(UIButton*)btn{
    NSInteger index = -1;
    if ([btn isEqual:self.investBtn]) {
        index = 0;
    }
    else if ([btn isEqual:self.packetBtn]) {
        index = 1;
    }
    else if ([btn isEqual:self.messageBtn]) {
        index = 2;
    }
    
    if ([self.delegate respondsToSelector:@selector(crfSelectedMineIndex:)]) {
        [self.delegate crfSelectedMineIndex:index];
    }
}
-(void)setImages:(NSArray *)images{
    _images = images;
    [self.mainCollectionView reloadData];
}
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self.mainCollectionView reloadData];
}
-(void)setSecondTitles:(NSArray *)secondTitles{
    _secondTitles = secondTitles;
    [self.mainCollectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CRFNewMineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFNewMineCellId forIndexPath:indexPath];
    cell.title =self.titles[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.item]];
    cell.secondTitle = self.secondTitles[indexPath.item];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = -1;
    if (indexPath.item == 0) {
        index = 3;
    }
    if (indexPath.item == 1) {
        index = 4;
    }
    if (indexPath.item == 2) {
        index = 5;
    }
    if (indexPath.item == 3) {
        index = 6;
    }
    if ([self.delegate respondsToSelector:@selector(crfSelectedMineIndex:)]) {
        [self.delegate crfSelectedMineIndex:index];
    }
}
-(UIButton*)createBtnTitle:(NSString*)title ImageName:(NSString*)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGBValue(0x333333) forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    CGFloat offset = 40.0f;
    button.titleEdgeInsets = UIEdgeInsetsMake(20, -27, -button.imageView.frame.size.height-offset/2, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-offset/2 + 20, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(UICollectionView*)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.scrollEnabled = NO;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.itemSize = CGSizeMake(140*kWidthRatio, 60*kWidthRatio);
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        [_mainCollectionView registerClass:[CRFNewMineCell class] forCellWithReuseIdentifier:CRFNewMineCellId];
    }
    return _mainCollectionView;
}
-(UIImageView *)backgroundImg{
    if (!_backgroundImg) {
        _backgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_mine_shadowBg"]];
        _backgroundImg.contentMode = UIViewContentModeScaleToFill;
    }
    return _backgroundImg;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
     _messageLabel.backgroundColor = UIColorFromRGBValue(0xFB4D3A);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

@end
