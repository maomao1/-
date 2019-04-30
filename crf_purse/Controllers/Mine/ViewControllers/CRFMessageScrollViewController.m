//
//  CRFMessageScrollVC.m
//  crf_purse
//
//  Created by maomao on 2017/8/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMessageScrollViewController.h"
#import "CRFSegmentHead.h"
#import "CRFMineViewController.h"
#import "CRFMessageCollectionViewCell.h"
#import "CRFMessageDetailViewController.h"
#import "UILabel+Edge.h"
#import "CRFStaticWebViewViewController.h"

#define kMessageTopSpace   8
@interface CRFMessageScrollViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic ,strong) CRFSegmentHead*crf_ViewHead;
@property (nonatomic ,strong) UILabel  * countLabel;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property(nonatomic , assign) NSInteger unReadCount;
@property(nonatomic , strong) UIButton * rightBtn;
@property (nonatomic , strong) UIBarButtonItem *rightBarBtn;
@end

@implementation CRFMessageScrollViewController

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - kNavHeight - 40 - kMessageTopSpace);
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.bounces = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _mainCollectionView;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 35, 35);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"取消" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(btnEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)back {
    if (self.refreshUnReadBlock) {
        self.refreshUnReadBlock();
    }
    [super back];
}
-(void)btnEdit:(UIButton*)btn{
    btn.selected = !btn.selected;
   CRFMessageCollectionViewCell *cell = (CRFMessageCollectionViewCell*)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.isEditStatus = btn.selected;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"消息中心"];
    [self crfSetHeadItem];
    self.rightBarBtn =[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
}

- (void)setUnReadMessageCount:(NSInteger)messageCount {
    [CRFAppManager defaultManager].unMessageCount = [NSString stringWithFormat:@"%ld",(long)messageCount];
    self.unReadCount = messageCount;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)messageCount];
    if (messageCount>99) {
        CGFloat width = [self.countLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) fontNumber:10.0f].width + 8;
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, 16));
        }];
    }
    
    if (messageCount >0) {
        self.countLabel.hidden = NO;
    }else{
        self.countLabel.hidden = YES;
    }
}

- (void)crfSetHeadItem {
    NSArray *items =@[@"消息",@"系统公告"];
    weakSelf(self);
    self.crf_ViewHead = [[CRFSegmentHead alloc] initCommonWithFrame:CGRectMake(0, 0, kScreenWidth, 40) titles:items clickCallback:^(NSInteger index) {
        [weakSelf.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
    [self.view addSubview:self.crf_ViewHead];
    [self.view addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.crf_ViewHead);
        make.left.mas_equalTo(kScreenWidth/4 +15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"CRFMessageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"messageCell"];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(40 + kMessageTopSpace);
    }];
    [CRFUtils delayAfert:.0 handle:^{
        [self.crf_ViewHead setDefaultIndex:self.selectedIndex];
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:10.0];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = UIColorFromRGBValue(0xFF7945);
        _countLabel.layer.masksToBounds = YES;
        _countLabel.layer.cornerRadius = 8.0f;
    }
    return _countLabel;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"messageCell" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.type = TypeOfMessage;
    } else {
        cell.type = TypeOfNotice;
    }
    weakSelf(self);
    [cell setSetEditBtn:^(BOOL isEdit){
        weakSelf.rightBtn.selected = isEdit;
    }];
    [cell setGetUnRedMessageCount:^ (NSInteger count){
        strongSelf(weakSelf);
        [strongSelf setUnReadMessageCount:count];
    }];
    [cell setPushToMessageDetailHandler:^ (id selectedObject, MessageType type){
        strongSelf(weakSelf);
        CRFMessageModel *item;
        CRFActivity *actItem;
        CRFMessageDetailViewController *detailVc = [CRFMessageDetailViewController new];
        if ([selectedObject isKindOfClass:[CRFMessageModel class]]) {
            item = [selectedObject mutableCopy];
//            item.isRead = @"2";
            if (item.isRead.integerValue == 1) {
                strongSelf.unReadCount --;
            }
            detailVc.detailModel = item;
            ((CRFMessageModel *)selectedObject).isRead = @"2";
            [strongSelf setUnReadMessageCount:strongSelf.unReadCount];
        }else{
            actItem = selectedObject;
            if (![actItem.contentUrl isEmpty]) {
                CRFStaticWebViewViewController *webViewController = [CRFStaticWebViewViewController new];
                webViewController.urlString = actItem.contentUrl;
                [strongSelf.navigationController pushViewController:webViewController animated:YES];
                return ;
            }
            detailVc.activiModel = actItem;
            
        }
        detailVc.mesType  = type == TypeOfNotice ? SYSTEM_Detail : MESSAGE_Detail;
        [strongSelf.navigationController pushViewController:detailVc animated:YES];
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.crf_ViewHead.defaultIndex = scrollView.contentOffset.x / kScreenWidth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.crf_ViewHead scrollToContentsInSizeWithFloat:scrollView.contentOffset.x / kScreenWidth];
    if (scrollView.contentOffset.x / kScreenWidth > 0.5) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightBarBtn;

    }
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
