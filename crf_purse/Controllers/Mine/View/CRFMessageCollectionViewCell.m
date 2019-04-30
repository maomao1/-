//
//  CRFMessageCollectionViewCell.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFMessageCollectionViewCell.h"
#import "CRFMessageTableViewCell.h"
#import "MJRefresh.h"
#import "UIImage+Color.h"
#import "CRFAlertUtils.h"

@interface CRFMessageCollectionViewCell() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger unReadCount;
/**
 数组的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 选中删除的数组
 */
@property (nonatomic, strong) NSMutableArray *selectedSource;

/**
 消息数据
 */
@property (nonatomic, strong) NSMutableArray *messages;

/**
 公告数据
 */
@property (nonatomic, strong) NSMutableArray *notices;

/**
 当前分页的消息页数
 */
@property (nonatomic, assign) NSInteger messageCount;

/**
 当前分页的公告页数
 */
@property (nonatomic, assign) NSInteger noticeCount;

/**
 是否结束刷新
 */
@property (nonatomic, assign) BOOL endRefreshMessage;

/**
 是否需要添加上拉刷新（消息）
 */
@property (nonatomic, assign) BOOL messageFlag;

/**
 是否需要添加上拉刷新（公告）
 */
@property (nonatomic, assign) BOOL noticeFlag;

/**
 是否是下拉刷新
 */
@property (nonatomic, assign) BOOL isRefreshHeader;

//
@property (nonatomic, strong) UIButton  *selectedAll;
@property (nonatomic, strong) UIButton  *deleteBtn;

@end


@implementation CRFMessageCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorColor:kCellLineSeparatorColor];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[CRFMessageTableViewCell class] forCellReuseIdentifier:CRFMessageCell_Identifier];
    self.messageCount = 1;
    self.noticeCount = 1;
    [self addRefreshHeader];
    [self addSubview:self.selectedAll];
    [self addSubview:self.deleteBtn];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [CRFUtils isIPhoneXAll] ? - 34 : 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
#endif
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFMessageCell_Identifier];
    cell.selectedBackgroundView = [[UIView alloc] init];
    id model = self.dataSource[indexPath.row];
    [cell crfSetContent:model];
    if ([model isKindOfClass:[CRFMessageModel class]]&&tableView.editing) {
        CRFMessageModel *item = (CRFMessageModel*)model;
        if (item.isSelected) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        self.selectedAll.selected = YES;
        for (CRFMessageModel *model in self.dataSource) {
            if (!model.isSelected) {
                self.selectedAll.selected = NO;
            }
        }
        CRFMessageModel *selectedModel = self.dataSource[indexPath.row];
        selectedModel.isSelected =! selectedModel.isSelected;

    }else{
        id model = self.dataSource[indexPath.row];
        if (self.pushToMessageDetailHandler) {
            self.pushToMessageDetailHandler(model, self.type);
        }
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        self.selectedAll.selected = NO;
    }
}
- (void)getDatas{
    [CRFLoadingView loading];
    weakSelf(self);
    if (self.type == TypeOfNotice) {
        [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:@"%@/2",APIFormat(kHomeAnnouncementPath)] paragrams:@{kPageNumberKey:[NSString stringWithFormat:@"%ld",self.noticeCount]} success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            if (strongSelf.isRefreshHeader) {
                strongSelf.isRefreshHeader = NO;
                [strongSelf.notices removeAllObjects];
            }
            [strongSelf endRefresh];
            NSArray *array = [CRFResponseFactory handlerAnnouncementWithResult:response];
            if (!strongSelf.notices) {
                strongSelf.notices = [NSMutableArray new];
            }
            [strongSelf.notices addObjectsFromArray:array];
            if (!strongSelf.noticeFlag) {
                if (strongSelf.notices.count >= 20) {
                    strongSelf.noticeFlag = YES;
                    [strongSelf addRefreshFooter];
                }
            }
            strongSelf.dataSource = strongSelf.notices;
            [strongSelf.tableView reloadData];
        } failed:^(CRFNetworkCompleteType errorType, id response) {
             [CRFUtils showMessage:response[kMessageKey]];
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            [strongSelf endRefresh];
        }];
    } else {
        [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetMessagePath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:@{kPageNumberKey:[NSString stringWithFormat:@"%ld",self.messageCount]} success:^(CRFNetworkCompleteType errorType, id response) {
            strongSelf(weakSelf);
            [CRFLoadingView dismiss];
            [strongSelf endRefresh];
            if (strongSelf.isRefreshHeader) {
                strongSelf.isRefreshHeader = NO;
                [strongSelf.messages removeAllObjects];
            }
            NSArray *array = [CRFResponseFactory getMessageList:response];
            if (!strongSelf.messages) {
                strongSelf.messages = [NSMutableArray new];
            }
            [strongSelf.messages addObjectsFromArray:array];
            strongSelf.unReadCount = [response[kDataKey][@"unReadCount"] integerValue];
            if (strongSelf.getUnRedMessageCount) {
                strongSelf.getUnRedMessageCount(strongSelf.unReadCount);
            }
            if (!strongSelf.messageFlag) {
                if (strongSelf.messages.count >= 20) {
                    strongSelf.messageFlag = YES;
                    [strongSelf addRefreshFooter];
                }
            }
            strongSelf.dataSource = strongSelf.messages;
            [strongSelf setSeletedStatus];
            [strongSelf.tableView reloadData];
            
        } failed:^(CRFNetworkCompleteType errorType, id response) {
            [CRFLoadingView dismiss];
            [CRFUtils showMessage:response[kMessageKey]];
            strongSelf(weakSelf);
            [strongSelf endRefresh];
        }];
    }
}
-(void)deleteMessagePath{
    NSMutableArray *idArr = [NSMutableArray new];
    NSMutableArray *indexArr = [NSMutableArray new];
    for (int i = 0; i<self.dataSource.count; i++) {
        CRFMessageModel *model = self.dataSource[i];
        if (model.isSelected) {
            [idArr addObject:model.mes_id];
            if (model.isRead.integerValue == 1) {
                self.unReadCount--;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArr addObject:indexPath];
        }
    }
    weakSelf(self);
    [CRFLoadingView loading];
//    NSString *idsStr = [idArr componentsJoinedByString:@","];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kDeleteMessagePath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:@{@"ids":idArr} success:^(CRFNetworkCompleteType errorType, id response) {
        [weakSelf setIsEditStatus:NO];
//
        for (int i = 0; i< self.dataSource.count; i++) {
            CRFMessageModel *model = self.dataSource[i];
            if (model.isSelected) {
                [weakSelf.dataSource removeObject:model];
            }
        }
        [CRFUtils showMessage:@"删除成功"];
        weakSelf.selectedAll.selected = NO;
        [weakSelf.tableView reloadData];
        if (weakSelf.getUnRedMessageCount) {
            weakSelf.getUnRedMessageCount(weakSelf.unReadCount);
        }
//        [weakSelf.tableView beginUpdates];
//        [self.tableView endUpdates];
        [CRFLoadingView dismiss];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
    
 }
-(void)setSeletedStatus{
    if (self.selectedAll.selected) {
//        for (int i = 0; i <self.dataSource.count; i++) {
//            CRFMessageModel *model = self.dataSource[i];
//            model.isSelected  = YES;
//        }
        for (CRFMessageModel *model in self.dataSource) {
            model.isSelected = YES;
        }
    }
}
- (void)addRefreshHeader {
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.endRefreshMessage = YES;
        strongSelf.isRefreshHeader = YES;
        if (strongSelf.type == TypeOfMessage) {
             strongSelf.messageCount = 1;
        } else {
            strongSelf.noticeCount = 1;
        }
        [strongSelf getDatas];
    }];
}

- (void)addRefreshFooter {
    weakSelf(self);
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        strongSelf(weakSelf);
        strongSelf.endRefreshMessage = YES;
        if (strongSelf.type == TypeOfMessage) {
            strongSelf.messageCount ++;
        } else {
            strongSelf.noticeCount ++;
        }
        [strongSelf getDatas];
    }];
}

- (void)endRefresh {
    if (self.endRefreshMessage) {
        self.endRefreshMessage = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}
-(void)setIsEditStatus:(BOOL)isEditStatus{
    _isEditStatus = isEditStatus;
    if (self.setEditBtn) {
        self.setEditBtn(isEditStatus);
    }
    [self.tableView setEditing:_isEditStatus animated:YES];
    if (_isEditStatus) {
        [self.selectedAll mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 48));
        }];
        [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.selectedAll.mas_right);
            make.bottom.mas_equalTo(self.selectedAll.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 48));
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.selectedAll.mas_top);
            make.left.right.top.equalTo(self);
        }];
    }else{
        [self.selectedAll mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.selectedAll.mas_right);
            make.bottom.mas_equalTo(self.selectedAll.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.selectedAll.mas_top);
            make.bottom.left.right.top.equalTo(self);
        }];
    }
}
- (void)setType:(MessageType)type {
    _type = type;
    if (_type == TypeOfMessage) {
        if (self.messages) {
            self.dataSource = self.messages;
            [self.tableView reloadData];
        } else {
            [self getDatas];
        }
    } else {
        if (self.notices) {
            self.dataSource = self.notices;
            [self.tableView reloadData];
        } else {
            [self getDatas];
        }
    }
}
-(void)selectedAllMessage:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        for (CRFMessageModel *model in self.dataSource) {
            model.isSelected = YES;
        }
    }else{
        for (CRFMessageModel *model in self.dataSource) {
            model.isSelected = NO;
        }
    }
    [self.tableView reloadData];
}
-(void)deleteMessage:(UIButton *)btn{
    weakSelf(self);
    [CRFAlertUtils showAlertTitle:@"您确定要删除选中的信息吗？" message:nil container:[CRFUtils getVisibleViewController] cancelTitle:@"取消" confirmTitle:@"确定" cancelHandler:^{
        [weakSelf setIsEditStatus:NO];
    } confirmHandler:^{
        [weakSelf deleteMessagePath];
    }];
}
-(UIButton *)selectedAll{
    if (!_selectedAll) {
        _selectedAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedAll setTitle:@"全选" forState:UIControlStateNormal];
        [_selectedAll setTitle:@"全选" forState:UIControlStateSelected];
        _selectedAll.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_selectedAll setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateNormal];
        [_selectedAll setTitleColor:UIColorFromRGBValue(0x666666) forState:UIControlStateSelected];
        [_selectedAll setImage:[UIImage imageNamed:@"message_unselected"] forState:UIControlStateNormal];
        [_selectedAll setImage:[UIImage imageNamed:@"message_selected"] forState:UIControlStateSelected];
        [_selectedAll addTarget:self action:@selector(selectedAllMessage:) forControlEvents:UIControlEventTouchUpInside];
        _selectedAll.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return _selectedAll;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateSelected];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        NSMutableArray *colorArray = [@[UIColorFromRGBValue(0xFF7945),
                                        UIColorFromRGBValue(0xFB4D3A)] mutableCopy];
        UIImage *bgImg = [UIImage bgImageFromColors:colorArray withFrame:CGRectMake(kScreenWidth/2, kScreenHeight-48, kScreenWidth/2, 48)];
        [_deleteBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:bgImg forState:UIControlStateHighlighted];
        [_deleteBtn addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
-(NSMutableArray *)selectedSource{
    if (!_selectedSource) {
        _selectedSource = [NSMutableArray new];
    }
    return _selectedSource;
}
@end
