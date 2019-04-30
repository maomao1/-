//
//  CRFAddressViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAddressViewController.h"
#import "CRFEditAddressViewController.h"

@interface CRFAddressViewController ()

@property (nonatomic, strong) UITableViewCell *noAddressCell;
@property (nonatomic, strong) UITableViewCell *addressCell;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation CRFAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_address", nil);
    [self.view addSubview:self.noAddressCell];
    [self.view addSubview:self.addressCell];
    [self layoutSubviews];
    self.hasAddress = [CRFAppManager defaultManager].address?YES:NO;
}

- (void)setHasAddress:(BOOL)hasAddress {
    _hasAddress = hasAddress;
    if (_hasAddress) {
        self.addressCell.hidden = NO;
        self.noAddressCell.hidden = YES;
        self.titleLabel.text = [CRFAppManager defaultManager].address.contactName;
        self.detailLabel.text = [CRFAppManager defaultManager].address.addressName;
    } else {
        self.addressCell.hidden = YES;
        self.noAddressCell.hidden = NO;
    }
}

- (void)layoutSubviews{
    [self.noAddressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kTopSpace / 2.0);
        make.height.mas_equalTo(52);
    }];
    [self.addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
         make.top.equalTo(self.view).with.offset(kTopSpace / 2.0);
        make.height.mas_equalTo(70);
    }];
}

- (UITableViewCell *)noAddressCell {
    if (!_noAddressCell) {
        _noAddressCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _noAddressCell.backgroundColor = [UIColor whiteColor];
        _noAddressCell.hasAccessoryView = YES;
        _noAddressCell.imageView.image = [UIImage imageNamed:@"add_address"];
        _noAddressCell.textLabel.text = NSLocalizedString(@"cell_label_new_address", nil);
        _noAddressCell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        [_noAddressCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAddress)]];
        
    }
    return _noAddressCell;
}

- (UITableViewCell *)addressCell {
    if (!_addressCell) {
        _addressCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _addressCell.backgroundColor = [UIColor whiteColor];
        [_addressCell addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addressCell).with.offset(kSpace);
            make.right.equalTo(_addressCell);
            make.left.equalTo(_addressCell).with.offset(kSpace);
            make.height.mas_equalTo(20);
        }];
        _detailLabel = [UILabel new];
        [_addressCell addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_addressCell).with.offset(-kSpace);
            make.right.equalTo(_addressCell);
            make.left.equalTo(_addressCell).with.offset(kSpace);
            make.height.mas_equalTo(15);
        }];
        _detailLabel.textColor = UIColorFromRGBValue(0x666666);
        _detailLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = UIColorFromRGBValue(0x333333);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_edit"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAddress)]];
        [_addressCell addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_addressCell.mas_centerY);
            make.right.equalTo(_addressCell).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _addressCell;
}

- (void)addAddress {
    CRFEditAddressViewController *controller = [CRFEditAddressViewController new];
    controller.indexPath = self.indexPath;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)editAddress {
    CRFEditAddressViewController *controller = [CRFEditAddressViewController new];
    controller.indexPath = self.indexPath;
    controller.edit = YES;
    [self.navigationController pushViewController:controller animated:YES];

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
