//
//  CRFInvestHead.m
//  crf_purse
//
//  Created by maomao on 2017/11/8.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestHead.h"
#define CRFInvestHeadCellId  @"CRFInvestHeadCellIdentifier"
#import "CRFHomeConfigHendler.h"
@interface CRFInvestHead()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) UILabel          *lineLabel;
@property (nonatomic , strong) NSArray          *subTitles;
@property (nonatomic , assign) NSInteger        selectedIndex;

@end
@implementation CRFInvestHead

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self loadList];
    }
    return self;
}

- (void)loadList {
    NSArray <CRFAppHomeModel *>*list = [CRFHomeConfigHendler defaultHandler].productTitleList;
    if (!list) {
        weakSelf(self);
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),kProductTitleListKey] success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFHomeConfigHendler defaultHandler].productTitleList = [CRFResponseFactory handleDataForResult:response WithClass:[CRFAppHomeModel class]];
            [strongSelf initializeView:[CRFHomeConfigHendler defaultHandler].productTitleList];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [strongSelf setDefaultDatas];
        }];
    } else {
        [self initializeView:list];
    }
}

- (void)initializeView:(NSArray <CRFAppHomeModel *>*)list {
    if (list.count == 0) {
        [self setDefaultDatas];
    } else {
        self.titles = @[[list firstObject].name,[list objectAtIndex:1].name,[list objectAtIndex:2].name,[list lastObject].name];
        self.subTitles = @[[list firstObject].content,[list objectAtIndex:1].content,[list objectAtIndex:2].content,[list lastObject].content];;
        self.selectedIndex = 0;
        [self creatContent];
    }
}

- (void)setDefaultDatas {
    self.titles = @[@"全部",@"短期计划",@"中期计划",@"长期计划"];
    self.subTitles = @[@"全部",@"<=183天",@"183天～365天",@">=365天"];
    self.selectedIndex = 0;
    [self creatContent];
}

-(void)creatContent{
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.lineLabel];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(KHeadViewHeight - 2);
    }];
    self.lineLabel.frame = CGRectMake(0, KHeadViewHeight-2, kScreenWidth/self.titles.count, 2);
    if([self.delegate respondsToSelector:@selector(crfSelectedIndex:)]){
        [self.delegate crfSelectedIndex:self.selectedIndex];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titles.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CRFInvestHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRFInvestHeadCellId forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell crfSetcontent:self.titles[0] andSubtitle:nil IsSelected:self.selectedIndex==indexPath.row];
    }else{
        [cell crfSetcontent:self.titles[indexPath.row] andSubtitle:self.subTitles[indexPath.row] IsSelected:self.selectedIndex==indexPath.row];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    weakSelf(self);
    [UIView animateWithDuration:.2 animations:^{
        strongSelf(weakSelf);
        strongSelf.lineLabel.frame=CGRectMake(kScreenWidth/self.titles.count * indexPath.row, KHeadViewHeight-2, kScreenWidth/self.titles.count,2);
    } completion:^(BOOL finished) {
    }];
    CRFInvestHeadCell *lastCell = (CRFInvestHeadCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:indexPath.section]];
    [lastCell crfSetSelected:NO];
    CRFInvestHeadCell *cell = (CRFInvestHeadCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell crfSetSelected:YES];
    [CRFAPPCountManager setEventID:@"INVEST_PRODUCT_CYCLE_FILTER" EventName:cell.mainTitle.text];
    self.selectedIndex = indexPath.row;
    if([self.delegate respondsToSelector:@selector(crfSelectedIndex:)]){
        [self.delegate crfSelectedIndex:self.selectedIndex];
    }
    //    [collectionView reloadData];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/self.titles.count, KHeadViewHeight-2);
}
-(UICollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerClass:[CRFInvestHeadCell class] forCellWithReuseIdentifier:CRFInvestHeadCellId];
    }
    return _mainCollectionView;
}
-(UILabel *)lineLabel{
    if(!_lineLabel){
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = SelectedColor;
    }
    return _lineLabel;
}
@end
@implementation CRFInvestHeadCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mainTitle];
        [self addSubview:self.subTitle];
        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).with.mas_offset(0);
            make.top.mas_equalTo(11.5);
            make.left.right.equalTo(self);
        }];
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).with.mas_offset(0);
            
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
-(void)crfSetcontent:(NSString *)title andSubtitle:(NSString *)subtitle IsSelected:(BOOL)isSelected{
    self.mainTitle.text = title;
    self.subTitle.text  = subtitle;
    [self crfSetSelected:isSelected];
    if(!subtitle){
        [self.mainTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.subTitle.hidden = YES;
        //        [self.subTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.mainTitle.mas_bottom).with.mas_offset(6);
        //            make.width.equalTo(self);
        //            make.bottom.equalTo(self.mas_bottom);
        //        }];
    }else{
        self.subTitle.hidden = NO;
        [self.mainTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).with.mas_offset(0);
            make.top.mas_equalTo(11.5);
            make.left.right.equalTo(self);
        }];
        //        [self.subTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.mas_centerY).with.mas_offset(0);
        //
        //            make.left.right.equalTo(self);
        //            make.bottom.equalTo(self.mas_bottom);
        //        }];
    }
}
-(void)crfSetSelected:(BOOL)isSeleced{
    if(isSeleced){
        _mainTitle.textColor = SelectedColor;
        _subTitle.textColor = SelectedColor;
    }else{
        _mainTitle.textColor = UIColorFromRGBValue(0x666666);
        _subTitle.textColor = UIColorFromRGBValue(0x999999);
    }
    
}
-(CRFLabel *)mainTitle{
    if(!_mainTitle){
        _mainTitle = [[CRFLabel alloc]init];
        _mainTitle.font = [UIFont systemFontOfSize:14];
        _mainTitle.textColor = UIColorFromRGBValue(0x666666);
        _mainTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _mainTitle;
}
-(CRFLabel *)subTitle{
    if(!_subTitle){
        _subTitle = [[CRFLabel alloc]init];
        _subTitle.font = [UIFont systemFontOfSize:10];
        _subTitle.textColor = UIColorFromRGBValue(0x999999);
        _subTitle.textAlignment = NSTextAlignmentCenter;
        //        _subTitle.verticalAlignment = VerticalAlignmentTop;
    }
    return _subTitle;
}
@end
