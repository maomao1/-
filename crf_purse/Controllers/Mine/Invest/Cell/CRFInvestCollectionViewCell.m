//
//  CRFInvestCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/8/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestCollectionViewCell.h"
#import "CRFMineInvestTableViewCell.h"
#import "UIImage+Color.h"
#import "MJRefresh.h"

@interface CRFInvestCollectionViewCell  () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray <CRFMyInvestProduct *>*products;

@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 <#Description#>
 */
@property (nonatomic, assign) NSInteger blackSpactIndex;
@property (weak, nonatomic) IBOutlet UIButton *transformButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;
//计息中（ 修改为出借中）
@property (nonatomic, strong) NSMutableArray *bearingProducts;
@property (nonatomic, assign) NSInteger bearingPageNumber;
@property (nonatomic, assign) BOOL hasBearingMoreFlag;
//未计息（修改为退出中）
@property (nonatomic, strong) NSMutableArray *unBearingProducts;
@property (nonatomic, assign) NSInteger unBearingPageNumber;
@property (nonatomic, assign) BOOL hasUnBearingMoreFlag;
//已结束
@property (nonatomic, strong) NSMutableArray *finishedProducts;
@property (nonatomic, assign) NSInteger finishedPageNumber;
@property (nonatomic, assign) BOOL hasFinishedMoreFlag;


@end

@implementation CRFInvestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.unBearingPageNumber = 1;
    self.bearingPageNumber = 1;
    self.finishedPageNumber = 1;
    [self configButtonBorder:0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self config];
    [self addRefreshHeader];
}

- (void)addRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
}

- (void)addRefreshFooter {
    weakSelf(self);
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        if (strongSelf.indexPath.item == 0) {
            strongSelf.unBearingPageNumber ++;
        } else if (strongSelf.indexPath.item == 1) {
            strongSelf.bearingPageNumber ++;
        } else {
            strongSelf.finishedPageNumber ++;
        }
        [strongSelf requestDatas];
    }];
}

- (void)refreshHeader {
    if (self.indexPath.item == 0) {
        self.unBearingPageNumber = 1;
        [self.unBearingProducts removeAllObjects];
    } else if (self.indexPath.item == 1) {
        self.bearingPageNumber = 1;
        [self.bearingProducts removeAllObjects];
    } else {
        self.finishedPageNumber = 1;
        [self.finishedProducts removeAllObjects];
    }
    [self requestDatas];
}

- (void)endInvestRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 - kNavHeight)];
        _bgView.hidden = YES;
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (void)setBlackSpactIndex:(NSInteger)blackSpactIndex {
    _blackSpactIndex = blackSpactIndex;
    if (_blackSpactIndex == 0) {
        self.topView.hidden = YES;
        self.titleLabel.text = NSLocalizedString(@"label_record_mine_none", nil);
        self.bgView.hidden = NO;
        [self bringSubviewToFront:self.bgView];
    } else if (_blackSpactIndex == 1){
        self.topView.hidden = YES;
        self.bgView.hidden = NO;
        self.titleLabel.text = NSLocalizedString(@"label_record_mine_alerdy", nil);
        [self bringSubviewToFront:self.bgView];
    } else if (_blackSpactIndex == 2){
        self.bgView.hidden = NO;
        self.topView.hidden = YES;
        self.titleLabel.text = NSLocalizedString(@"label_record_mine_finished", nil);
        [self bringSubviewToFront:self.bgView];
    } else {
        self.bgView.hidden = YES;
        if (self.type == None) {
            self.topView.hidden = YES;
        } else {
            self.topView.hidden = NO;
        }
    }
}

- (void)config {
    [self addSubview:self.bgView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_no_invest"]];
    [self.bgView addSubview:imageView];
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(116 * kWidthRatio);
        make.size.mas_equalTo(CGSizeMake(135, 100));
        make.centerX.equalTo(self.bgView.mas_centerX);
    }];
    UILabel *label = [UILabel new];
    label.text = @"";
    self.titleLabel = label;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = UIColorFromRGBValue(0x666666);
    [self.bgView addSubview:label];
    UILabel *subLabel = [UILabel new];
    subLabel.text = NSLocalizedString(@"label_get_money_with_invest", nil);
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.textColor = UIColorFromRGBValue(0x999999);
    subLabel.font = [UIFont systemFontOfSize:12.0];
    [self.bgView addSubview:subLabel];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(15);
    }];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(label.mas_bottom).with.offset(10);
        make.height.mas_equalTo(12);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    [button setBackgroundImage:[UIImage imageWithColor:kButtonNormalBackgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xE14534)] forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"label_goto_invest_product", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"label_goto_invest_product", nil) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.bgView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.top.equalTo(subLabel.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(165, kButtonHeight));
    }];
    [button addTarget:self action:@selector(noInvestHandler) forControlEvents:UIControlEventTouchUpInside];
}

- (void)noInvestHandler {
    if (self.blackSpaceHandler) {
        self.blackSpaceHandler(self.indexPath);
    }
}

- (void)setType:(CellType)type {
    _type = type;
    if (_type == None) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).with.offset(58);
        }];
    }
}

- (void)configButtonBorder:(NSInteger)index {
    if (index == 0) {
        self.transformButton.selected = YES;
        self.timeButton.selected = NO;
        self.transformButton.layer.borderColor = kButtonNormalBackgroundColor.CGColor;
        self.timeButton.layer.borderColor = UIColorFromRGBValue(0x666666).CGColor;
        [self.transformButton setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateSelected];
    } else {
        self.transformButton.selected = NO;
        self.timeButton.selected = YES;
        self.timeButton.layer.borderColor = kButtonNormalBackgroundColor.CGColor;
        self.transformButton.layer.borderColor = UIColorFromRGBValue(0x666666).CGColor;
        [self.timeButton setTitleColor:kButtonNormalBackgroundColor forState:UIControlStateSelected];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFMineInvestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CRFMineInvestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.type = self.indexPath.item;
    cell.product = self.products[indexPath.section];
    cell.indexPath = indexPath;
    weakSelf(self);
    [cell setHelpHandler:^ (BOOL attributedImage, NSIndexPath *targetIndexPath){
        strongSelf(weakSelf);
        if (attributedImage) {
            if (strongSelf.helpHandler) {
                strongSelf.helpHandler();
            }
        } else {
            if (strongSelf.investChooseHandler) {
                strongSelf.investChooseHandler(strongSelf.indexPath.row, strongSelf.products[targetIndexPath.section]);
            }
        }
    }];
    return cell;
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == self.transformButton) {
        [self configButtonBorder:0];
        self.sortIndex = 0;
        self.products = [CRFUtils sortDatas:self.products type:0];
    } else {
        self.sortIndex = 1;
        [self configButtonBorder:1];
        if (self.indexPath.item == 2) {
            self.products = [CRFUtils sortDatas:self.products];
        }else{
            self.products = [CRFUtils sortDatas:self.products type:1];
        }
        
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.investChooseHandler) {
        self.investChooseHandler(self.indexPath.item, self.products[indexPath.section]);
    }
}

- (void)setProducts:(NSArray<CRFMyInvestProduct *> *)products {
    _products = products;
    [self configButtonBorder:self.sortIndex];
    

    if (self.type == None) {
        [self.tableView reloadData];
        return;
    }
    if (self.sortIndex == 0) {
//        [self configButtonBorder:0];
        _products = [CRFUtils sortDatas:_products type:0];
    } else {
//        [self configButtonBorder:1];
        if (self.indexPath.item == 2) {
            _products = [CRFUtils sortDatas:_products];
        } else {
            _products = [CRFUtils sortDatas:_products type:1];
        }
    }
    [self.tableView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return NO;
}

- (void)requestDatas {
    NSNumber *number = nil;
    /*
     此处修改 investStatusType  未计息 计息中 修改为 出借中 退出中。0，1-->3，4
     */
    NSString *investStatusType = nil;
    if (self.indexPath.item == 0) {
        number = @(self.unBearingPageNumber);
        investStatusType = @"3";
        [self.timeButton setTitle:@"按到期时间排序" forState:UIControlStateNormal];
        [self.timeButton setTitle:@"按到期时间排序" forState:UIControlStateSelected];
    } else if (_indexPath.item == 1) {
        number = @(self.bearingPageNumber);
        investStatusType = @"4";
        [self.timeButton setTitle:@"按到期时间排序" forState:UIControlStateNormal];
        [self.timeButton setTitle:@"按到期时间排序" forState:UIControlStateSelected];
    } else {
        number = @(self.finishedPageNumber);
        investStatusType = @"2";
        [self.timeButton setTitle:@"按结束时间排序" forState:UIControlStateNormal];
        [self.timeButton setTitle:@"按结束时间排序" forState:UIControlStateSelected];

    }
    [CRFLoadingView loading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kInvestListPath),kUuid] paragrams:@{@"investStatusType":investStatusType,kPageNumberKey:number,kPageSizeKey:@"20"} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        [strongSelf parseResponse:response index:strongSelf.indexPath.item];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf endInvestRefresh];
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
        [strongSelf configDefault];
    }];
}

- (void)parseResponse:(id)response index:(NSInteger)index {
    [self endInvestRefresh];
    if (self.getInvestListAmount) {
        self.getInvestListAmount([response[kDataKey][@"interestCount"] integerValue],[response[kDataKey][@"processCount"] integerValue],[response[kDataKey][@"retiredCount"] integerValue]);
    }
    NSArray <CRFMyInvestProduct *>*array = [CRFResponseFactory myInvestList:response];
    DLog(@"datas count is %ld",array.count);
    if (index == 0) {
        //未计息处理
        if (!self.unBearingProducts) {
            self.unBearingProducts = [NSMutableArray new];
        }
        [self.unBearingProducts addObjectsFromArray:array];
        if (self.indexPath.item == index) {
            self.products = [NSArray arrayWithArray:self.unBearingProducts];
        }
        if (array.count >= 20 && !self.hasUnBearingMoreFlag) {
            self.hasUnBearingMoreFlag = YES;
            [self addRefreshFooter];
        } else if (array.count < 20) {
            [self removeFooterView];
            self.hasUnBearingMoreFlag = NO;
        }
    } else if (index == 1) {
        //计息中处理
        if (!self.bearingProducts) {
            self.bearingProducts = [NSMutableArray new];
        }
        [self.bearingProducts addObjectsFromArray:array];
        if (self.indexPath.item == index) {
            self.products = [NSArray arrayWithArray:self.bearingProducts];
        }
        if (array.count >= 20 && !self.hasBearingMoreFlag) {
            self.hasBearingMoreFlag = YES;
            [self addRefreshFooter];
        } else if (array.count < 20) {
            [self removeFooterView];
            self.hasBearingMoreFlag = NO;
        }
    } else {
        //已结束处理
        if (!self.finishedProducts) {
            self.finishedProducts = [NSMutableArray new];
        }
        [self.finishedProducts addObjectsFromArray:array];
        if (self.indexPath.item == index) {
            self.products = [NSArray arrayWithArray:self.finishedProducts];
        }
        if (array.count >= 20 && !self.hasFinishedMoreFlag) {
            self.hasBearingMoreFlag = YES;
            [self addRefreshFooter];
        } else if (array.count < 20) {
            [self removeFooterView];
            self.hasFinishedMoreFlag = NO;
        }
    }
    [self.tableView reloadData];
    if (self.updateLayout) {
        self.updateLayout();
    }
    [self configDefault];
}

- (void)setNeedRefresh:(BOOL)needRefresh {
    _needRefresh = needRefresh;
    if (_needRefresh) {
        self.bearingProducts = nil;
        self.finishedProducts = nil;
        self.unBearingProducts = nil;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (_indexPath.item == 0) {
        if (self.unBearingProducts) {
            self.products = [NSArray arrayWithArray:self.unBearingProducts];
            [self configDefault];
            [self.tableView reloadData];
        } else {
            [self requestDatas];
        }
    } else if (_indexPath.item == 1) {
        if (self.bearingProducts) {
            self.products = [NSArray arrayWithArray:self.bearingProducts];
            [self configDefault];
            [self.tableView reloadData];
        } else {
            [self requestDatas];
        }
    } else {
        if (self.finishedProducts) {
            self.products = [NSArray arrayWithArray:self.finishedProducts];
            [self configDefault];
            [self.tableView reloadData];
        } else {
            [self requestDatas];
        }
    }
}

- (void)configDefault {
    if (self.products.count == 0) {
        self.blackSpactIndex = self.indexPath.item;
    } else {
        self.blackSpactIndex = NSIntegerMax;
    }
    [UIView animateWithDuration:.0 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)removeFooterView {
    [self.tableView.mj_footer removeFromSuperview];
}

@end
