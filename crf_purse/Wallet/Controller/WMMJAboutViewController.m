//
//  WMAboutVC.m
//  crf_purse
//
//  Created by maomao on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "WMMJAboutViewController.h"
#import "CRFAboutTableViewCell.h"
#import "CRFUpdateView.h"
#import "WMMJCopyRightViewController.h"
@interface WMMJAboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *contentTab;
@property (nonatomic ,strong) NSArray     *dataSource;
@property (nonatomic ,strong) UIView      *headerView;
@property (nonatomic ,strong) CRFVersionInfo *versionInfo;
@end

@implementation WMMJAboutViewController
-(UITableView *)contentTab{
    if (!_contentTab) {
        _contentTab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTab.backgroundColor = [UIColor clearColor];
        _contentTab.scrollEnabled = NO;
        _contentTab.delegate = self;
        _contentTab.dataSource = self;
        [_contentTab setSeparatorColor:UIColorFromRGBValueAndalpha(0x000000, 0.1f)];
    }
    return _contentTab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSyatemTitle:@"关于我们"];
    [self setUIStyle];
    [self crfGetData];
}
-(void)crfGetData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[CRFAppManager defaultManager].clientInfo.os forKey: @"mobileOs"];//手机系统，Android、IOS
    [param setValue:[NSString getAppId] forKey:@"packageName"];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kUpVersionPath) paragrams:param success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf paserResponse:response];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"check new version failed, %@",response);
    }];
}

-(void)paserResponse:(id)response {
    NSDictionary *resultDic = (NSDictionary*)response;
    NSString  *status = resultDic[kResult];
    if ([status isEqualToString:kSuccessResultStatus]) {
        self.versionInfo = [CRFResponseFactory hadleVersionDataForResult:response];
        [self.contentTab reloadData];
    }
}

-(void)setUIStyle{
    self.dataSource = @[NSLocalizedString(@"cell_label_update_version", nil),NSLocalizedString(@"cell_label_common", nil),@"版权信息"];
    [self.view addSubview:self.contentTab];
    [self.contentTab registerClass:[CRFAboutTableViewCell class] forCellReuseIdentifier:CRFAboutCell_ID];
    UIImageView *imageIcon = [[UIImageView alloc]init];
    imageIcon.image = [UIImage imageNamed:@"about_mine_logo"];
    UILabel  *editionLabel = [[UILabel alloc]init];
    editionLabel.text =[NSString stringWithFormat:NSLocalizedString(@"label_version_number", nil),[CRFAppManager defaultManager].clientInfo.versionNum];
    editionLabel.textAlignment = NSTextAlignmentCenter;
    editionLabel.font = [UIFont systemFontOfSize:13.0f];
    editionLabel.textColor = UIColorFromRGBValue(0x666666);
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 153)];
    [_headerView addSubview:imageIcon];
    [_headerView addSubview:editionLabel];
    
    [_contentTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.equalTo(_headerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 85));
    }];
    [editionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView.mas_centerX);
        make.top.equalTo(imageIcon.mas_bottom).with.mas_offset(0);
        make.height.mas_equalTo(13);
    }];
    _contentTab.rowHeight = 49;
    _contentTab.tableHeaderView = _headerView;
    _contentTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CRFAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFAboutCell_ID];
    
    cell.hasAccessoryView = YES;
    cell.titleLabel.text = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        if (_versionInfo.versionCode.integerValue > [[CRFAppManager defaultManager].clientInfo.versionCode integerValue]){
            cell.versionLabel.text = NSLocalizedString(@"cell_label_value_new_version", nil);
            cell.versionRed.hidden = NO;
        }else{
            cell.versionLabel.text = NSLocalizedString(@"cell_label_value_no_new_version", nil);
            cell.versionRed.hidden = YES;
        }
    }else{
        cell.versionLabel.hidden = YES;
        cell.versionRed.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [CRFAPPCountManager getEventIdForKey:self.dataSource[indexPath.row]];//埋点
    switch (indexPath.row) {
        case 0:
        {
            if (_versionInfo.versionCode.integerValue > [[CRFAppManager defaultManager].clientInfo.versionCode integerValue]){
                CRFUpdateView *alertView = [[CRFUpdateView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) Title:NSLocalizedString(@"label_new_version_explain", nil) Content:_versionInfo.appTips IsForce:_versionInfo.level ClickCallBack:^{
                    if ([_versionInfo.appLink isKindOfClass: [NSString class]]) {
                        if ([_versionInfo.appLink hasPrefix: @"http://"] || [_versionInfo.appLink hasPrefix: @"https://"]) {
                            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: _versionInfo.appLink]];
                        }
                        if ([_versionInfo.level isEqualToString:@"1"]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                exit(0);
                            });
                        }
                    }
                } CancelCallBack:nil IsHome:NO];
                [alertView show];
                
            }
        }
            break;
        case 1:
        {
            if ([_versionInfo.appLink isKindOfClass: [NSString class]]) {
                if ([_versionInfo.appLink hasPrefix: @"http://"] || [_versionInfo.appLink hasPrefix: @"https://"]) {
                    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: _versionInfo.appLink]];
                }
            }
        }
            break;
        case 2: {
            [self.navigationController pushViewController:[WMMJCopyRightViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

