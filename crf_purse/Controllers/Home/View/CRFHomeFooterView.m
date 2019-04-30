//
//  CRFSectionFooterView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/13.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFHomeFooterView.h"
#import "CRFTestCollectionViewCell.h"
#import "CRFHomeConfigHendler.h"
#import "CRFPlatFormDataView.h"
static NSString *const kCellIdentifier = @"test";

@interface CRFHomeFooterView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CRFPlatFormDataView *platformView;

@end

@implementation CRFHomeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
        [self configCollectionView];
        [self configPlatFormView];
        [self configButton];
        [self configImageView];
    }
    return self;
}

- (void)setMainScrollView:(UIScrollView *)mainScrollView {
    _mainScrollView = mainScrollView;
    if (_mainScrollView.contentSize.height < CGRectGetHeight([UIScreen mainScreen].bounds) - kNavHeight) {
        self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.frame) + (CGRectGetHeight([UIScreen mainScreen].bounds) - kTabBarHeight - _mainScrollView.contentSize.height));
        ((UITableView *)_mainScrollView).tableFooterView = self;
    } else {
        if (_mainScrollView.contentSize.height > kScreenHeight + 20) {
            if (CGRectGetHeight(self.frame) != [CRFAppManager defaultManager].majiabaoFlag ? (50 + 26 + 85 + kTopSpace / 2.0) : (170+75 * kWidthRatio + 80 + 26 + 85 + kTopSpace / 2.0)) {
                self.frame = CGRectMake(0, 0, kScreenWidth, [CRFAppManager defaultManager].majiabaoFlag ? (50 + 26 + 85 + kTopSpace / 2.0) : (170+75 * kWidthRatio + 80 + 26 + 85 + kTopSpace / 2.0));
                ((UITableView *)_mainScrollView).tableFooterView = self;
            }
        }
    }
}

- (void)configButton {
    self.footerImg = [[UIImageView alloc]init];
    self.footerImg.layer.masksToBounds = YES;
    self.footerImg.userInteractionEnabled = YES;
    CRFAppHomeModel *model = [[[CRFHomeConfigHendler defaultHandler].homeDataDicM objectForKey:home_about_crfchina_key] objectAtIndex:0];
    [self.footerImg sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"home_about_crfchina"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
//    self.footerBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    [self.footerBtn setTitleColor:UIColorFromRGBValue(0xEE5250) forState:UIControlStateNormal];
    self.footerImg.layer.cornerRadius = 13;
//    self.footerImg.layer.borderColor = UIColorFromRGBValue(0xEE5250).CGColor;
//    self.footerImg.layer.borderWidth = 1.0f;
    [self addSubview:self.footerImg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(about)];
    [self.footerImg addGestureRecognizer:tap];
//    [self.footerBtn addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    [self.footerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.platformView.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(90, 26));
    }];
}
-(void)reloadFooterImg{
    CRFAppHomeModel *model = [[[CRFHomeConfigHendler defaultHandler].homeDataDicM objectForKey:home_about_crfchina_key] objectAtIndex:0];
    [self.footerImg sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"home_about_crfchina"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}
- (void)about {
    if (self.aboutCallback) {
        self.aboutCallback();
    }
}

- (void)configImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_refresh_footer"]];
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(85.0f);
    }];
}
-(void)configPlatFormView{
    self.platformView = [[CRFPlatFormDataView alloc]init];
    [self addSubview:self.platformView];
    [self.platformView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom).with.mas_offset(8);
        make.height.mas_equalTo(180);
    }];
//    [self.platformView updateContent:nil];
}
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    layout.itemSize = CGSizeMake(135 * kWidthRatio, 75 * kWidthRatio);
    layout.minimumLineSpacing = kSpace;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    layout.minimumInteritemSpacing = .0f;
    [self addSubview:self.collectionView];
    layout.sectionInset = UIEdgeInsetsMake(0, kSpace, 0, kSpace);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CRFTestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(kTopSpace / 2.0);
        make.height.mas_equalTo([CRFAppManager defaultManager].majiabaoFlag? 0 : (75 * kWidthRatio + 30));
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    CRFAppHomeModel *model = self.menuArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"new_user_default"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            cell.imageView.image = image;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"new_user_default"];
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFAppHomeModel *model = [self.menuArray objectAtIndex:indexPath.row];
    if (self.itemDidSelected) {
        self.itemDidSelected(model);
    }
}

- (void)setMenuArray:(NSArray<CRFAppHomeModel *> *)menuArray{
    _menuArray = menuArray;
    [self.collectionView reloadData];
}
-(void)setPlatformArray:(NSArray<CRFAppHomeModel *> *)platformArray{
    _platformArray = platformArray;
    [self.platformView updateContent:_platformArray];
}
@end

