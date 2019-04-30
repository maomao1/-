//
//  CRFBannerMoreView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/12.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBannerMoreView.h"

@interface CRFMoreTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation CRFMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self config];
    }
    return self;
}

- (void)config {
    _titleLabel = [UILabel new];
    self.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor =self.titleLabel.backgroundColor = [UIColor clearColor];
    self.separatorInset = UIEdgeInsetsMake(0, kSpace, 0, kSpace);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(50.0f);
        make.height.mas_equalTo(kCellHeight);
        make.centerY.equalTo(self.contentView).with.offset(kCellHeight / 2);
        make.right.equalTo(self.contentView).with.offset(-15.0f);
    }];
}

@end

@interface CRFBannerMoreView() <UITableViewDelegate, UITableViewDataSource> {
    NSArray *images;
    NSArray *titles;
}

@property (nonatomic, strong) UITableView *moreTableView;

@end

@implementation CRFBannerMoreView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.contents = (id)[UIImage imageNamed:@"home_more"].CGImage;
        images = @[[UIImage imageNamed:@"home_IM"],[UIImage imageNamed:@"home_feedback"],[UIImage imageNamed:@"home_notify"]];
        titles = @[NSLocalizedString(@"cell_label_IM_online", nil),NSLocalizedString(@"cell_label_help_feedback", nil),NSLocalizedString(@"cell_label_notification_mine", nil)];
        [self addSubview:self.moreTableView];
        [self.moreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UITableView *)moreTableView {
    if (!_moreTableView) {
        _moreTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _moreTableView.backgroundColor = [UIColor clearColor];
        _moreTableView.dataSource = self;
        _moreTableView.delegate = self;
        _moreTableView.scrollEnabled = NO;
        _moreTableView.showsVerticalScrollIndicator = NO;
        [_moreTableView setSeparatorColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    }
    return _moreTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CRFMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = images[indexPath.row];
    cell.titleLabel.text = titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 3.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return images.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewDidSeledted) {
        self.viewDidSeledted(indexPath);
    }
}


@end

@interface CRFNewUserView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *helpImageView;

@end


@implementation CRFNewUserView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self configTitle];
        [self layout];
        [self layoutImageView];
    }
    return self;
}

- (UIImageView *)helpImageView {
    if (!_helpImageView) {
        _helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_help"]];
        _helpImageView.userInteractionEnabled = YES;
        _helpImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_helpImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(help)]];
        if ([CRFAppManager defaultManager].majiabaoFlag) {
            _helpImageView.hidden = YES;
        }
    }
    return _helpImageView;
}

- (void)layoutImageView {
    [self addSubview:self.helpImageView];
    [self.helpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).with.offset(-5);
        make.right.equalTo(self).with.offset(-kSpace);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setContent {
    if (_helpModel) {
        [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:_helpModel.iconUrl] placeholderImage:[UIImage imageNamed:@"home_help"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                self.helpImageView.image = image;
            }
        }];
        self.titleLabel.text = _helpModel.name;
    }else{
        self.helpImageView.image = [UIImage imageNamed:@"home_help"];
        self.titleLabel.text = NSLocalizedString(@"label_new_user_prompt", nil);
    }
    
}

- (void)configTitle {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.contentButton = button;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)layout {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(15);
    }];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kSpace);
        make.width.mas_equalTo(kScreenWidth - 2 * kSpace);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(17);
        make.height.mas_equalTo(68 * kWidthRatio);
    }];
    [self.contentButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-15);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(211);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(20);
    }];
}

- (void)click:(UIButton *)button {
    if (self.didSelectedCallback) {
        NSInteger index = 0;
        if (self.activity == Register) {
            index = 0;
        } else if (self.activity == Create_account) {
            index = 1;
        } else {
            index = 2;
        }
        self.didSelectedCallback(index);
    }
}

- (void)setActivity:(UserActivity)activity {
    _activity = activity;
    switch (_activity) {
        case Register: {
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_home_register"] forState:UIControlStateNormal];
        }
            break;
            
        case Create_account: {
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_open_account"] forState:UIControlStateNormal];
        }
            break;
        case Invest: {
            [self.contentButton setBackgroundImage:[UIImage imageNamed:@"button_invest"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)help {
    if (self.helpHandler) {
        self.helpHandler(_helpModel);
    }
}

- (void)setHomeModel:(CRFAppHomeModel *)homeModel {
    _homeModel = homeModel;
//    [self setContent];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_homeModel.iconUrl] placeholderImage:[UIImage imageNamed:@"new_user_use_default"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            self.imageView.image = image;
        }
    }];
}
-(void)setHelpModel:(CRFAppHomeModel *)helpModel{
    _helpModel = helpModel;
    [self setContent];
}
@end


@interface CRFCustomHeaderView()

@property (nonatomic, strong) UILabel *line;

@end

@implementation CRFCustomHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(updateTitleContent) name:kReloadResourceNotificationName];
        if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"home_title_image"]) {
            [self addSubview:self.imageView];
            self.imageView.image = [CRFUtils loadImageResource:@"home_title_image"];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self);
                make.top.equalTo(self).with.offset(kStatusBarHeight);
            }];
        } else {
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self);
                make.top.equalTo(self).with.offset(kStatusBarHeight);
            }];
        }
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(0.5f);
        }];
        
    }
    return self;
}

- (void)updateTitleContent {
    if ([CRFAppManager defaultManager].supportPageConfig && [CRFUtils loadImageResource:@"home_title_image"]) {
        [self addSubview:self.imageView];
        [self.titleLabel removeFromSuperview];
        self.imageView.image = [CRFUtils loadImageResource:@"home_title_image"];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self).with.offset(kStatusBarHeight);
        }];
    }
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.hidden = YES;
        _line.backgroundColor = UIColorFromRGBValue(0xE2E2E2);
    }
    return _line;
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = _hiddenLine;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

@end

