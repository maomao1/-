//
//  CRFBannerView.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBannerView.h"
#import "CRFFunctionCollectionViewCell.h"
#import "UUMarqueeView.h"
#import "CRFBannerMoreView.h"
#import "CRFFunctionView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

static NSString *const kFunctionCellIdentifier = @"functionCell";
@interface CRFBannerView() <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UUMarqueeViewDelegate, NewPagedFlowViewDelegate,NewPagedFlowViewDataSource> {
    UIView *tempView;
}
@property (strong, nonatomic) NewPagedFlowView *bannerView;
@property (strong, nonatomic) UICollectionView *functionCollectionView;
@property (nonatomic, strong) UUMarqueeView *activityView;
@property (nonatomic, strong) NSTimer *bannerTimer;
//@property (nonatomic, strong) CRFFunctionView *funcView;
@property (nonatomic, strong) NSArray <UIImage *>*images;
@property (nonatomic, strong) CRFNewUserView *userView;

@end

@implementation CRFBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGBValue(0xF6F6F6);
        [self configBanner];
        [self addSubview:self.functionCollectionView];
        [self configActivityView];
        [self addSubview:self.userView];
//        [self addSubview:self.funcView];
        [self registerCollectionCell];
    }
    return self;
}

- (void)configBanner {/*375x159*/
    _bannerView = [[NewPagedFlowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeight * kWidthRatio)];
    _bannerView.backgroundColor = [UIColor whiteColor];
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.minimumPageAlpha = 0.1;
    _bannerView.leftRightMargin = 31.5 * kWidthRatio;
    _bannerView.topBottomMargin = 14.5 * 2 * kWidthRatio;
    _bannerView.autoTime = 3;
    [self addSubview:self.bannerView];
    if ([CRFAppManager defaultManager].majiabaoFlag) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apply_banner"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bannerView);
        }];
    }
}

- (CRFNewUserView *)userView {
    if (!_userView) {
        _userView = [[CRFNewUserView alloc] init];
        weakSelf(self);
        [_userView setDidSelectedCallback:^(NSInteger index){
            strongSelf(weakSelf);
            if ([strongSelf.bannerDelegate respondsToSelector:@selector(userToFinishFromRegister:)]) {
                [strongSelf.bannerDelegate userToFinishFromRegister:index];
            }
        }];
        [_userView setHelpHandler:^(CRFAppHomeModel *helpItem){
            strongSelf(weakSelf);
            if ([strongSelf.bannerDelegate respondsToSelector:@selector(userHelp:)]) {
                [strongSelf.bannerDelegate userHelp:helpItem];
            }
        }];
    }
    return _userView;
}

- (void)configActivityView {
    tempView = [[UIView alloc] init];
    tempView.backgroundColor = [UIColor whiteColor];
    _activityView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth - 50, kButtonHeight)];;
    _activityView.backgroundColor = [UIColor whiteColor];
    _activityView.delegate = self;
    _activityView.timeIntervalPerScroll = 3.0f;
    _activityView.timeDurationPerScroll = 1.0f;
    _activityView.touchEnabled = YES;
    [tempView addSubview:_activityView];
    UIImageView *trumpetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification"]];
    trumpetImageView.contentMode = UIViewContentModeCenter;
    [tempView addSubview:trumpetImageView];
    [trumpetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tempView);
        make.left.equalTo(tempView).with.offset(20);
        make.bottom.equalTo(tempView);
        make.width.mas_equalTo(20);
    }];
    [self addSubview:tempView];
}

- (UICollectionView *)functionCollectionView {
    if (!_functionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _functionCollectionView.dataSource = self;
        flowLayout.minimumLineSpacing = .0f;
        flowLayout.minimumInteritemSpacing = .0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _functionCollectionView.delegate = self;
        _functionCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _functionCollectionView;
}

//- (CRFFunctionView *)funcView {
//    if (!_funcView) {
//        _funcView = [[CRFFunctionView alloc] init];
//        _funcView.contentMode = UIViewContentModeRedraw;
//        _funcView.hidden = YES;
//        weakSelf(self);
//        [_funcView setDidSelected:^ (NSInteger index){
//            strongSelf(weakSelf);
//            if ([strongSelf.bannerDelegate respondsToSelector:@selector(loginAfterFunctionDidSelected:)]) {
//                [strongSelf.bannerDelegate loginAfterFunctionDidSelected:strongSelf.functions[index].jumpUrl];
//            }
//            CRFAppHomeModel *model =strongSelf.functions[index];
//            [CRFAPPCountManager setEventID:@"HOME_OLDUSER_MENU_EVENT" EventName:model.name];
//        }];
//    }
//    return _funcView;
//}

- (void)layoutViews {
    [self.functionCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.equalTo(self).with.offset(kBannerHeight * kWidthRatio);
        make.height.mas_equalTo(kFunctionViewHeight);
    }];
    [tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.functionCollectionView.mas_bottom).with.offset(kTopSpace / 2.0);
        make.height.mas_equalTo(kButtonHeight);
    }];
    [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(tempView.mas_bottom).with.offset(kTopSpace / 2.0);
        make.height.mas_equalTo(kNewUserViewHeight);
    }];
//    [self.funcView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(kOldFunctionViewHeight);
//        make.top.equalTo(self).with.offset(kBannerHeight * kWidthRatio);
//    }];
}

- (void)setUpBanner {
    [self layoutViews];
}

- (void)registerCollectionCell {
    [self.functionCollectionView registerNib:[UINib nibWithNibName:@"CRFFunctionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kFunctionCellIdentifier];
}

- (void)setFunctions:(NSArray<CRFAppHomeModel *> *)functions {
    _functions = functions;
}

- (void)setBanners:(NSArray<CRFAppHomeModel *> *)banners {
    _banners = banners;
    [self layoutViews];
    if (_banners.count > 0) {
        self.bannerView.orginPageCount = _banners.count;
        [self.bannerView reloadData];
        [UIView animateWithDuration:.1 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.banners.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake((kScreenWidth - 315 * kWidthRatio) / 2.0, 14, 315 * kWidthRatio, 145 * kWidthRatio)];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = kTopSpace / 2.0;
        bannerView.layer.masksToBounds = YES;
    }
    CRFAppHomeModel *bannerModel = self.banners[index];
    bannerView.url = [NSURL URLWithString:bannerModel.iconUrl];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView{
    
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(315 * kWidthRatio, 145 * kWidthRatio);
}

- (void)didSelectCell:(PGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex {
    if ([self.bannerDelegate respondsToSelector:@selector(bannerDidSelected:)]) {
        CRFAppHomeModel *model = [self.banners objectAtIndex:subIndex];
        [CRFAPPCountManager setEventID:@"HOME_BANNER_EVENT" EventName:model.name];
        [self.bannerDelegate bannerDidSelected:model.jumpUrl];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 0;
    if (self.functions.count >= 4) {
        width = kScreenWidth / 4.0;
    } else {
        width = kScreenWidth / self.functions.count;
    }
    return CGSizeMake(width, kFunctionViewHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFunctionCellIdentifier forIndexPath:indexPath];
    CRFAppHomeModel *model = [self.functions objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"default_icon"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            cell.imageView.image = image;
//            cell.imageView.alpha = 0;
//            [UIView transitionWithView:cell.imageView
//                              duration:.1f
//                               options:UIViewAnimationOptionTransitionCrossDissolve
//                            animations:^{
//                                cell.imageView.alpha = 1.0;
//                            } completion:NULL];
        }
    }];
    cell.titleLabel.text = model.name;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.functions.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.bannerDelegate respondsToSelector:@selector(functionDidSelected:url:)]) {
        [self.bannerDelegate functionDidSelected:indexPath url:self.functions[indexPath.item].jumpUrl];
    }
    CRFAppHomeModel *model =self.functions[indexPath.row];
    [CRFAPPCountManager setEventID:@"HOME_NEW_USER_MENU_EVENT" EventName:model.name];
}

- (void)setType:(ActivityType)type {
    _type = type;
    [tempView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_type == None?0:kButtonHeight);
    }];
    if (_type == None) {
        tempView.hidden = YES;
        [self.userView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(tempView.mas_bottom);
            make.height.mas_equalTo(kNewUserViewHeight);
        }];
    } else {
        tempView.hidden = NO;
        [self.userView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(tempView.mas_bottom).with.offset(kTopSpace / 2.0);
            make.height.mas_equalTo(kNewUserViewHeight);
        }];
    }
}

- (void)setActivities:(NSArray *)activities {
    _activities = activities;
    [self.activityView start];
    [self.activityView reloadData];
}

#pragma mark --
- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    if ([self.bannerDelegate respondsToSelector:@selector(activityDidSelected:)]) {
        [self.bannerDelegate activityDidSelected:self.activities[index]];
    }
}

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (NSArray*)dataSourceArrayForMarqueeView:(UUMarqueeView*)marqueeView {
    return self.activities;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView {
    itemView.backgroundColor = [UIColor whiteColor];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth - 60, kButtonHeight)];
    contentLabel.font = [UIFont systemFontOfSize:13.0f];
    contentLabel.tag = 1001;
    contentLabel.textColor = UIColorFromRGBValue(0x333333);
    [itemView addSubview:contentLabel];
}

- (void)updateItemView:(UIView*)itemView withData:(CRFActivity *)data forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *content = [itemView viewWithTag:1001];
    content.text = data.title;
}

- (void)setBannerTpye:(BannerType)bannerTpye {
    _bannerTpye = bannerTpye;
    switch (_bannerTpye) {
        case User_Default: {
            self.userView.hidden = YES;
//            self.funcView.hidden = YES;
//            self.funcView.functions = self.functions;
//            self.functionCollectionView.hidden = NO;
            [tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.functionCollectionView.mas_bottom).with.offset([CRFAppManager defaultManager].majiabaoFlag ? CGFLOAT_MIN : kTopSpace / 2.0);
                make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kButtonHeight);
            }];
            [self.functionCollectionView reloadData];
        }
            break;
        case Account_Bank_None: {
            self.userView.hidden = NO;
//            self.functionCollectionView.hidden = NO;
            self.userView.activity = Create_account;
//            self.funcView.hidden = YES;
            [self.functionCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.top.equalTo(self).with.offset(kBannerHeight * kWidthRatio);
                 make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kFunctionViewHeight);
            }];
            [tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.functionCollectionView.mas_bottom).with.offset([CRFAppManager defaultManager].majiabaoFlag? CGFLOAT_MIN : kTopSpace / 2.0);
                make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kButtonHeight);
            }];
            [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(tempView.mas_bottom).with.offset(kTopSpace / 2.0);
                make.height.mas_equalTo(kNewUserViewHeight);
            }];
             [self.functionCollectionView reloadData];
        }
            
            break;
        case Invest_None: {
//            if (self.functions.count > 2) {
//                self.functionCollectionView.hidden = NO;
//                self.funcView.hidden = YES;
//            } else {
//                self.functionCollectionView.hidden = YES;
//                self.funcView.hidden = NO;
//                self.funcView.functions = self.functions;
//            }
            self.userView.hidden = NO;
            self.userView.activity = Invest;
//            [self.funcView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_equalTo(self);
//                make.top.equalTo(self).with.offset(kBannerHeight * kWidthRatio);
//                make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kFunctionViewHeight);
//            }];
            [tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.functionCollectionView.mas_bottom).with.offset([CRFAppManager defaultManager].majiabaoFlag? CGFLOAT_MIN : kTopSpace / 2.0);
                make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kButtonHeight);
            }];
            [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(tempView.mas_bottom).with.offset(kTopSpace / 2.0);
                make.height.mas_equalTo(kNewUserViewHeight);
            }];
             [self.functionCollectionView reloadData];
        }
            
            break;
        case User_Logout: {
            self.userView.hidden = NO;
//            self.funcView.hidden = YES;
//            self.functionCollectionView.hidden = NO;
            self.userView.activity = Register;
            [self.functionCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.top.equalTo(self).with.offset(kBannerHeight * kWidthRatio);
                 make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kFunctionViewHeight);
            }];
            [tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.functionCollectionView.mas_bottom).with.offset([CRFAppManager defaultManager].majiabaoFlag? CGFLOAT_MIN : kTopSpace / 2.0);
                make.height.mas_equalTo(self.type == None?CGFLOAT_MIN: kButtonHeight);
            }];
            [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(tempView.mas_bottom).with.offset(kTopSpace / 2.0);
                make.height.mas_equalTo(kNewUserViewHeight);
            }];
             [self.functionCollectionView reloadData];
        }
            break;
            
        default:
            break;
    }
    [self layoutIfNeeded];
}

- (void)setHomeModel:(CRFAppHomeModel *)homeModel {
    _homeModel = homeModel;
    self.userView.homeModel = _homeModel;
}
-(void)setHelpModel:(CRFAppHomeModel *)helpModel{
    _helpModel = helpModel;
    self.userView.helpModel = _helpModel;
}

@end
