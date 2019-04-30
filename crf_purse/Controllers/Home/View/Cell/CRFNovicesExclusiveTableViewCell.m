//
//  CRFNovicesExclusiveTableViewCell.m
//  crf_purse
//
//  Created by mystarains on 2019/1/7.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import "CRFNovicesExclusiveTableViewCell.h"
#import "CRFNovicesProductCollectionViewCell.h"
#import "UIView+CRFController.h"
#import "CRFProductDetailViewController.h"

@interface CRFNovicesExclusiveTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;

@end

@implementation CRFNovicesExclusiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CRFNovicesProductCollectionViewCell class] forCellWithReuseIdentifier:CRFInvestListCellId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showMoreActiom:(UIButton *)sender {
    
    if (self.showMoreBlock) {
        self.showMoreBlock();
    }
}

- (void)setProductFactory:(CRFHomeProductFactory *)productFactory{
    _productFactory = productFactory;

    self.pageLabel.hidden = !productFactory.hasNewProduct;
    self.showMoreButton.hidden = productFactory.hasNewProduct;
    
    self.titleLabel.text = productFactory.hasNewProduct ? @"新手专享" : @"精选推荐";
    NSString *pageStr = [NSString stringWithFormat:@"1/%lu",(unsigned long)productFactory.noviceProducts.count];
    NSRange range = [self.pageLabel.text rangeOfString:@"/"];
    
    [self.pageLabel setAttributedText:[CRFStringUtils setAttributedString:pageStr lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFA5D59)} range1:NSMakeRange(0, range.location) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(range.location, pageStr.length - range.location) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    
    [self.collectionView reloadData];
    
    if (self.productFactory.noviceProducts.count  > 0) {
      [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }

}

#pragma mark -----  UICollectionViewDelegate & UICollectionViewDataSource  -----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger sectionNum = self.productFactory.hasNewProduct ? self.productFactory.noviceProducts.count : self.productFactory.oldUserProducts.count;
    
    return sectionNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CRFNovicesProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFInvestListCellId forIndexPath:indexPath];
    cell.newUserProduct = self.productFactory.hasNewProduct;
    cell.productModel = self.productFactory.hasNewProduct? self.productFactory.noviceProducts[indexPath.row] : self.productFactory.oldUserProducts[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 20*2), kCollectionViewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CRFProductModel *productModel = self.productFactory.hasNewProduct? self.productFactory.noviceProducts[indexPath.row] : self.productFactory.oldUserProducts[indexPath.row];
    
    NSString *eventID = self.productFactory.hasNewProduct ? @"HOME_NEWFIRE_PRODUCT_EVENT" : @"HOME_OLDUSER_PRODUCT_EVENT";
    [CRFAPPCountManager setEventID:eventID EventName:productModel.contractPrefix];
    
    CRFProductDetailViewController *vc = [CRFProductDetailViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.productNo = productModel.contractPrefix;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentPage = scrollView.contentOffset.x/(kScreenWidth - 20*2);
    NSInteger pageNum     = self.productFactory.noviceProducts.count;
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld/%ld",(long)(currentPage + 1),pageNum];
    NSRange range = [pageStr rangeOfString:@"/"];
    
    [self.pageLabel setAttributedText:[CRFStringUtils setAttributedString:pageStr lineSpace:0 attributes1:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0xFA5D59)} range1:NSMakeRange(0, range.location) attributes2:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:UIColorFromRGBValue(0x999999)} range2:NSMakeRange(range.location, pageStr.length - range.location) attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    
}

@end
