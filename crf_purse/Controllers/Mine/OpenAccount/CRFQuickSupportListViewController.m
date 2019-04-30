//
//  CRFQuickSupportListViewController.m
//  crf_purse
//
//  Created by maomao on 2019/3/6.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import "CRFQuickSupportListViewController.h"
#import "CRFStringUtils.h"
#import "CRFBankListCell.h"
@interface CRFQuickSupportListViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) NSArray  *dataSource;
@end

@implementation CRFQuickSupportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"支持银行"];
    [self initializeView];
    [self requestData];
}
-(void)initializeView{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, -60, kScreenWidth, 60)];
    [self.mainCollectionView addSubview:header];
    [header setBackgroundColor:self.view.backgroundColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSString *titleStr = @"转账充值支持银行（仅支持储蓄卡，暂不支持信用卡），具体充值限额请咨询发卡行。";
    NSMutableAttributedString *attribute =[[NSMutableAttributedString alloc]initWithString:titleStr];
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f];
    [attribute setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999), NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, titleStr.length)];
    titleLabel.frame = CGRectMake(kSpace, 0, kScreenWidth-2*kSpace, 60);
    titleLabel.numberOfLines = 0;
    [header addSubview:titleLabel];
    [titleLabel setAttributedText:attribute];
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.mainCollectionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);

}
-(void)requestData{
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@?customerUid=%@&moduleArea=%@&area=%@",APIFormat(kAppHomeConfigPath),kUserInfo.customerUid,kHomePageArea_key,@"app_bank_list"] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        NSArray *dataArray = [CRFResponseFactory handleProductDataForResult:response WithClass:[CRFAppHomeModel class] ForKey:@"app_bank_list"];
        [strongSelf parseDataArray:dataArray];
        
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}
-(void)parseDataArray:(NSArray*)dataArray{
    if (dataArray.count) {
        CRFAppHomeModel *model = dataArray[0];
        self.dataSource = [NSArray yy_modelArrayWithClass:[CRFAppHomeModel class] json:model.content];
        [self.mainCollectionView reloadData];
    }
}
#pragma mark -- UICollectionViewDelegate UICollectionViewDataSource-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRFBankListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFBankListCellID forIndexPath:indexPath];
    CRFAppHomeModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"bank_icon_default"] completed:nil];
    return cell;
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//        headerView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
        UILabel *title = [UILabel new];
        title.font = [UIFont systemFontOfSize:13.0*kWidthRatio];
        title.text = @"支持银行";
        title.textColor = UIColorFromRGBValue(0x666666);
        UILabel *line = [UILabel new];
        line.backgroundColor = kCellLineSeparatorColor;
        [headerView addSubview:line];
        [headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.right.mas_equalTo(-kSpace);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(headerView.mas_centerY);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_left);
            make.right.equalTo(title.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(-1);
        }];
        return headerView;
    }
    return [UICollectionReusableView new];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(22, 0, 0, 0);
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (kScreenWidth-320)/3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 22.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 64);
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 44);
    }
    return CGSizeZero;
}
- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
//        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
//        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerClass:[CRFBankListCell class] forCellWithReuseIdentifier:CRFBankListCellID];
        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseIdentifier"];
    }
    return _mainCollectionView;
}

@end
