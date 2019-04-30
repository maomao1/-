//
//  CRFSharedView.m
//  crf_purse
//
//  Created by xu_cheng on 2017/9/15.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFSharedView.h"
#import "CRFSharedCollectionViewCell.h"
#import <MessageUI/MessageUI.h>
#import "UMSocialSmsHandler.h"
#define  ItemWidth  kScreenWidth / 4.0
#define  ItemHeight  104
@interface CRFSharedView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    //    NSArray *images;
    //    NSArray *titles;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UMSocialMessageObject *messageObject;

@end

@implementation CRFSharedView

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.3];
        _bgView.alpha = .1f;
    }
    return _bgView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sharedProduct = YES;
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 2*ItemHeight+109);
        self.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
        [self configTitle];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).with.offset(51);
            make.bottom.equalTo(self).with.offset(-58);
        }];
        [self configFooterView];
    }
    return self;
}

- (void)configFooterView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:kRegisterButtonBackgroundColor forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(cancelShared) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
}
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self.collectionView reloadData];
}
- (void)configTitle {
    _images = @[@"shared_frends",@"shared_frends_circle",@"shared_QQ",@"shared_sms",@"shared_copy"];
    _titles = @[@"微信好友",@"微信朋友圈",@"QQ好友",@"短信",@"复制链接"];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"分享到";
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = UIColorFromRGBValue(0x333333);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        //        CGFloat width = kScreenWidth / 4.0;
        layout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
        [_collectionView registerNib:[UINib nibWithNibName:@"CRFSharedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"sharedCell"];
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFSharedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sharedCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_images[indexPath.item]];
    cell.nameLabel.text = _titles[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UMSocialPlatformType type;
    if (indexPath.item == 0) {
        type = UMSocialPlatformType_WechatSession;
        if (![[UMSocialManager defaultManager] isInstall:type]) {
            [self complate];
            [CRFUtils showMessage:@"您未安装微信客户端，请安装后再分享"];
            return;
        }
    } else if (indexPath.item == 1) {
        type = UMSocialPlatformType_WechatTimeLine;
        if (![[UMSocialManager defaultManager] isInstall:type]) {
            [self complate];
            [CRFUtils showMessage:@"您未安装微信客户端，请安装后再分享"];
            return;
        }
    } else if (indexPath.item == 2) {
        type = UMSocialPlatformType_QQ;
        if (![[UMSocialManager defaultManager] isInstall:type]) {
            [self complate];
            [CRFUtils showMessage:@"您未安装QQ客户端，请安装后再分享"];
            return;
        }
    }else{
        type = UMSocialPlatformType_Sms;
        if (![MFMessageComposeViewController canSendText]) {
            [self complate];
            [CRFUtils showMessage:@"您的设备不支持短信功能"];
            return;
        }
    }
    UIViewController *controller = nil;
    if (indexPath.item == 3) {
        controller = [CRFUtils getVisibleViewController];
        UMShareWebpageObject *object = self.messageObject.shareObject;
        UMShareSmsObject *smsObject = [UMShareSmsObject new];
        if (self.sharedProduct) {
            smsObject.smsContent = [NSString stringWithFormat:@"%@,%@%@",object.title,object.descr,object.webpageUrl];
        } else {
            smsObject.smsContent = [NSString stringWithFormat:@"【%@】%@%@",object.title,object.descr,object.webpageUrl];
        }
        self.messageObject.shareObject = smsObject;
    }else if (indexPath.item ==4){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        UMShareWebpageObject *object = self.messageObject.shareObject;
        pasteboard.string = object.webpageUrl;
        [CRFUtils showMessage:@"复制成功"];
        [self complate];
        return;
    }
    weakSelf(self);
    [CRFUtils getMainQueue:^{
        strongSelf(weakSelf);
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:strongSelf.messageObject currentViewController:controller completion:^(id data, NSError *error) {
            if (error) {
                [CRFUtils showMessage:@"分享失败"];
            } else {
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
                [CRFUtils showMessage:@"分享成功"];
            }
        }];
    }];
    [self complate];
}

- (void)show:(UMSocialMessageObject *)messageObject {
    self.messageObject = messageObject;
    [[UIApplication sharedApplication].delegate.window addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].delegate.window);
    }];
    [self.bgView addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 animations:^{
            self.frame = CGRectMake(0, kScreenHeight - (_titles.count>4 ? 2*ItemHeight+109 :ItemHeight+109), kScreenWidth,_titles.count>4? 2*ItemHeight+109:ItemHeight+109);
        }];
    }];
}

- (void)cancelShared {
    [self complate];
}

- (void)complate {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 2*ItemHeight+109);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            self.bgView.alpha = .0f;
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
        }];
    }];
}

@end
