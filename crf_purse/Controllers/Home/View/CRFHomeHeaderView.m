//
//  CRFHomeHeaderView.m
//  crf_purse
//
//  Created by mystarains on 2019/1/4.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "EllipsePageControl.h"
#import "CRFFunctionCollectionViewCell.h"
#import "UIButton+WebCache.h"

static NSString *const kFunctionCellIdentifier = @"functionCell";
static CGFloat const kBannerHeight = 200.f;
static CGFloat const kFunctionViewSpace = 20.f;

@interface CRFHomeHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic,strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UICollectionView *functionCollectionView;
@property (nonatomic, strong) UIButton *actionButton;

/**
 banner的url
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*banners;

/**
 功能按钮的集合
 */
@property (nonatomic, strong) NSArray <CRFAppHomeModel *>*functions;

/**
 newUserModel
 */
@property (nonatomic, strong) CRFAppHomeModel *novicesModel;

@end

@implementation CRFHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView{
    [self addSubview:self.bannerView];
    [self addSubview:self.pageControl];
    [self addSubview:self.functionCollectionView];
    [self addSubview:self.actionButton];
    [self registerCollectionCell];
    self.frame = CGRectMake(0, 0, kScreenWidth, kFunctionViewTop*kWidthRatio + kFunctionViewHeight + 20 + kActionViewHeight + 20);
}

- (void)registerCollectionCell {
    [self.functionCollectionView registerNib:[UINib nibWithNibName:@"CRFFunctionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kFunctionCellIdentifier];
}

- (void)setFunctions:(NSArray<CRFAppHomeModel *> *)functions {
    _functions = functions;
    [self.functionCollectionView reloadData];
}

- (void)setHomeHeaderViewDic:(NSDictionary *)homeHeaderViewDic{
    
    _homeHeaderViewDic = homeHeaderViewDic;
    
    //banner 数据
    self.banners = [homeHeaderViewDic objectForKey:banner_key];
    //菜单栏数据
    if ([homeHeaderViewDic.allKeys containsObject:kProductExclusivePlanKey]) {
        self.functions = [homeHeaderViewDic objectForKey:kProductExclusivePlanKey];
    } else {
        self.functions = [homeHeaderViewDic objectForKey:topMenu_key];
    }

    //新用户引导
    CRFAppHomeModel *newUserModel = [[homeHeaderViewDic objectForKey:newUser_key] firstObject];
    self.novicesModel = newUserModel;
    
    [self.functionCollectionView reloadData];
    
    [self refreshViewHeight];
}

- (void)setBanners:(NSArray<CRFAppHomeModel *> *)banners{
    
    _banners = banners;
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    
    [banners enumerateObjectsUsingBlock:^(CRFAppHomeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imagesURLStrings addObject:obj.iconUrl];
    }];
    
    self.bannerView.imageURLStringsGroup = imagesURLStrings;
    self.pageControl.numberOfPages = imagesURLStrings.count;

}

- (void)setNovicesModel:(CRFAppHomeModel *)novicesModel {
    _novicesModel = novicesModel;
    
    [self.actionButton sd_setImageWithURL:[NSURL URLWithString:_novicesModel.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"new_user_action_default"]];
    [self.actionButton sd_setImageWithURL:[NSURL URLWithString:_novicesModel.iconUrl] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"new_user_action_default"]];
}

- (void)refreshViewHeight{
    
    CGFloat viewHeight = kBannerHeight*kWidthRatio;
    
    if (self.functions.count > 0) {
        viewHeight = kFunctionViewTop*kWidthRatio + kFunctionViewHeight;
        self.functionCollectionView.hidden = NO;
    }else{
        self.functionCollectionView.hidden = YES;
    }
    
    if ([self.novicesModel.urlKey isEqualToString:kRegisterUserKey]||[self.novicesModel.urlKey isEqualToString:kOpenAccountKey]||[self.novicesModel.urlKey isEqualToString:kInvestmentKey]) {
        self.actionButton.hidden = NO;
        viewHeight = viewHeight + 20 + (kActionViewHeight + 20);
    }else{
        self.actionButton.hidden = YES;
    }
    self.frame = CGRectMake(0, 0, kScreenWidth, viewHeight);
    self.actionButton.frame = CGRectMake(25,viewHeight - kActionViewHeight - 20, (kScreenWidth - 25*2), kActionViewHeight);
}

- (void)actionButtonClick:(UIButton *)sender{
    
    NSInteger index = 0;
    
    if ([self.novicesModel.urlKey isEqualToString:kRegisterUserKey]) {
        index = 0;
    } else if ([self.novicesModel.urlKey isEqualToString:kOpenAccountKey]) {
        index = 1;
    } else if ([self.novicesModel.urlKey isEqualToString:kInvestmentKey]){
        index = 2;
    }
    
    if ([self.delegate respondsToSelector:@selector(userToFinishFromRegister:)]) {
        [self.delegate userToFinishFromRegister:index];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(bannerDidSelected:)]) {
        CRFAppHomeModel *model = [self.banners objectAtIndex:index];
        [CRFAPPCountManager setEventID:@"HOME_BANNER_EVENT" EventName:model.name];
        [self.delegate bannerDidSelected:model.jumpUrl];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    self.pageControl.currentPage = index;
    
}

#pragma mark -----  UICollectionViewDelegate & UICollectionViewDataSource  -----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.functions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFunctionCellIdentifier forIndexPath:indexPath];
    CRFAppHomeModel *model = [self.functions objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"home_functions_default"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            cell.imageView.image = image;
        }
    }];
    cell.titleLabel.text = model.name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 0;
    if (self.functions.count >= 4) {
        width = (kScreenWidth - kFunctionViewSpace *2) / 4.0;
    } else {
        width = (kScreenWidth - kFunctionViewSpace *2)  / self.functions.count;
    }
    return CGSizeMake(width, kFunctionViewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(functionDidSelected:url:)]) {
        [self.delegate functionDidSelected:indexPath url:self.functions[indexPath.item].jumpUrl];
    }
    CRFAppHomeModel *model =self.functions[indexPath.row];
    [CRFAPPCountManager setEventID:@"HOME_NEW_USER_MENU_EVENT" EventName:model.name];
}

#pragma mark -----  getter & setter  -----

- (SDCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeight*kWidthRatio) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
        
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    }
    
    return _bannerView;
}

- (EllipsePageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[EllipsePageControl alloc] initWithFrame:CGRectMake(0, 144*kWidthRatio,[UIScreen mainScreen].bounds.size.width, 6)];
        _pageControl.otherColor=[UIColor colorWithWhite:1 alpha:0.5];
        _pageControl.currentColor=[UIColor whiteColor];
    }
    return _pageControl;
}

- (UICollectionView *)functionCollectionView {
    if (!_functionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kFunctionViewSpace, kFunctionViewTop*kWidthRatio, (kScreenWidth - kFunctionViewSpace*2), kFunctionViewHeight) collectionViewLayout:flowLayout];
        _functionCollectionView.showsHorizontalScrollIndicator = NO;
        _functionCollectionView.layer.cornerRadius = 10.f;
        _functionCollectionView.dataSource = self;
        _functionCollectionView.delegate = self;
        flowLayout.minimumLineSpacing = .0f;
        flowLayout.minimumInteritemSpacing = .0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _functionCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _functionCollectionView;
}

- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(25,kFunctionViewTop*kWidthRatio + kFunctionViewHeight + 20, (kScreenWidth - 25*2), kActionViewHeight);
        _actionButton.clipsToBounds = YES;
        [_actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _actionButton;
}

@end
