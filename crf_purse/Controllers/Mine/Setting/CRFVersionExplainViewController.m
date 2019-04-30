//
//  CRFVersionExplainVC.m
//  crf_purse
//
//  Created by maomao on 2017/8/10.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFVersionExplainViewController.h"
#import "CRFVersionTableViewCell.h"
@interface CRFVersionExplainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *contentTab;
@property (nonatomic ,strong) NSArray *dataSource;
@end

@implementation CRFVersionExplainViewController
- (UITableView *)contentTab{
    if (!_contentTab) {
        _contentTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTab.backgroundColor = [UIColor clearColor];
        _contentTab.delegate = self;
        _contentTab.dataSource = self;
        _contentTab.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_contentTab setSeparatorColor:UIColorFromRGBValueAndalpha(0x000000, 0.1f)];
    }
    return _contentTab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:NSLocalizedString(@"title_version_explain", nil)];
    [self.view addSubview:self.contentTab];
    [self.contentTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    self.contentTab.estimatedRowHeight = 100;
    self.contentTab.estimatedSectionHeaderHeight = .0f;
    self.contentTab.estimatedSectionFooterHeight = .0f;
    self.contentTab.rowHeight = UITableViewAutomaticDimension;
    [self.contentTab registerClass:[CRFVersionTableViewCell class] forCellReuseIdentifier:CRFVERSIONCELL_ID];
    [self.contentTab registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerId"];
    [self initData];
    
}
- (void)initData{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"version_tips" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    _dataSource = [NSArray yy_modelArrayWithClass:[CRFVersionModel class] json:jsonObject];
    [self.contentTab reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CRFVersionModel *model = _dataSource[section];
    return model.versionContent.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFVersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFVERSIONCELL_ID];
    CRFVersionModel *model = _dataSource[indexPath.section];
    CRFVersionContentModel *item = [CRFVersionContentModel yy_modelWithDictionary:model.versionContent[indexPath.row]];
    [cell setContentForModel:item];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 56*kHeightRatio)];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kCellLineSeparatorColor;
    
    headerView.backgroundColor = [UIColor whiteColor];
    CRFLabel *title = [CRFLabel new];
    title.verticalAlignment = VerticalAlignmentTop;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UIColorFromRGBValue(0x333333);
    title.font = [UIFont boldSystemFontOfSize:15];
    [headerView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSpace);
        make.right.mas_equalTo(-kSpace);
        make.top.mas_equalTo(20*kHeightRatio);
    }];
    if (section !=0) {
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSpace);
            make.right.equalTo(headerView);
            make.top.equalTo(headerView.mas_top).with.mas_offset(18*kHeightRatio);
            make.height.mas_equalTo(0.5);
        }];
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40*kHeightRatio);
        }];
    }
    CRFVersionModel *model =_dataSource[section];
    title.text =[NSString stringWithFormat:@"%@",model.versionName] ;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section !=0) {
        return 76*kHeightRatio;
    }
    return 56*kHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
