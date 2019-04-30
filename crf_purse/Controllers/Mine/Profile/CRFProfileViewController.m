//
//  CRFProfileViewController.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFProfileViewController.h"
#import "CRFInformationTableViewCell.h"
#import "CRFEmailViewController.h"
#import "CRFEditAddressViewController.h"
#import "CRFBankCardViewController.h"
#import "CRFAddressViewController.h"
#import "CRFEditEmailViewController.h"
#import "CRFCreateAccountViewController.h"
#import "CRFSettingData.h"
#import "CRFRelateAccountViewController.h"
#import "CRFEvaluatingViewController.h"
#import "CRFAlertUtils.h"
#import "CRFControllerManager.h"

static NSString *const kSystemCellIdentifier = @"systemCell";
static NSString *const kHeaderCellIdentifier = @"header";

@interface CRFProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSArray <NSArray <NSString *>*>*datas;
    NSArray <NSArray <NSString *>*>*values;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, copy) NSString *headerImageURL;

@end

@implementation CRFProfileViewController

- (NSString *)fileName {
    if (_fileName) {
        return _fileName;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    _fileName = [NSString stringWithFormat:@"%@.jpg", str];
    return _fileName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"title_profile", nil);
    datas = @[@[NSLocalizedString(@"cell_label_mine_header_image", nil),NSLocalizedString(@"cell_label_phonenumber", nil),NSLocalizedString(@"cell_label_name", nil),NSLocalizedString(@"cell_label_identifier", nil),NSLocalizedString(@"cell_label_bank_card", nil)],@[NSLocalizedString(@"cell_label_text_user", nil)],@[NSLocalizedString(@"cell_label_email", nil),NSLocalizedString(@"cell_label_address", nil)]];
    self.tableView.separatorColor = kCellLineSeparatorColor;
    self.tableView.dataSource = self;
    [self autoLayoutSizeContentView:self.tableView];
    [self getDatas];
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetAddressListPath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
            [CRFAppManager defaultManager].addresses = [CRFResponseFactory getAddressList:response];
            [self getDatas];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"get address failed");
        [CRFUtils showMessage:response[kMessageKey]];
    }];
    [self updateProfile];
    self.tableView.tableFooterView = [UIView new];
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfo];
}

- (BOOL)fd_prefersNavigationBarHidden {
    return NO;
}

- (void)getUserInfo {
    [CRFLoadingView loading];
    [CRFLoadingView setWindowDisable];
    weakSelf(self);
    [[CRFRefreshUserInfoHandler defaultHandler] refreshStandardUserInfo:^(BOOL success, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
        if (success) {
            [strongSelf getDatas];
            [strongSelf.tableView reloadData];
        } else {
            NSLog(@"refresh user info failed");
             [CRFUtils showMessage:response[kMessageKey]];
        }
    }];
}

- (void)updateProfile {
    weakSelf(self);
    self.updateProfileHandler = ^(NSIndexPath *indexPath) {
        strongSelf(weakSelf);
        [strongSelf getDatas];
        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
}

- (void)getDatas {
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    NSString *s = nil;
    if ([userInfo.riskLevel isEmpty]) {
        s = NSLocalizedString(@"cell_value_go_test", nil);
    } else if ([userInfo.riskLevel integerValue] == 1) {
        s = @"保守型";
    } else if ([userInfo.riskLevel integerValue] == 2) {
        s = @"平衡型";
    } else {
        s = @"进取型";
    }
    values = @[@[@"",[userInfo formatMobilePhone],[userInfo.userName isEmpty]?NSLocalizedString(@"cell_value_auth", nil):[userInfo formatUserName],[userInfo.openAccountIdno isEmpty]?NSLocalizedString(@"cell_value_auth", nil):userInfo.openAccountIdno,[userInfo.openBankCardNo isEmpty]?NSLocalizedString(@"cell_value_bind_card", nil):userInfo.openBankCardNo],@[s],@[[userInfo.emailNo isEmpty]?NSLocalizedString(@"cell_value_go_input", nil):userInfo.emailNo,[CRFAppManager defaultManager].address?[[CRFAppManager defaultManager].address formatAddress]:NSLocalizedString(@"cell_value_go_input", nil)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFInformationTableViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell =  [tableView dequeueReusableCellWithIdentifier:kHeaderCellIdentifier];;
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInformationTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.hasAccessoryView = YES;
#ifdef WALLET
        UIImage *image = [CRFUtils normalUser]?[UIImage imageNamed:@"login_default_avatar"]:[UIImage imageNamed:@"默认头像"];
#else
        UIImage *image = [UIImage imageNamed:@"login_default_avatar"];
#endif
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:image];
    } else {
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CRFInformationTableViewCell" owner:nil options:nil] lastObject];
        }
        if (indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 3)) {
            if ([[CRFAppManager defaultManager].userInfo.userName isEmpty]) {
                cell.hasAccessoryView = YES;
            } else {
                cell.customAccessoryView = YES;
            }
        } else {
            if (indexPath.section == 0 && indexPath.row == 1) {
                if ([[CRFAppManager defaultManager].userInfo.phoneNo isEmpty]) {
                    cell.hasAccessoryView = YES;
                } else {
                    cell.hasAccessoryView = NO;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.hasAccessoryView = YES;
            }
        }
    }
    cell.contentlabel.text = values[indexPath.section][indexPath.row];
    [self setCellContentTextColor:cell indexPath:indexPath];
    cell.textLabel.text = datas[indexPath.section][indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *keyName = datas[indexPath.section][indexPath.row];
    if ([keyName isEqualToString:@"头像"]) {
        keyName = @"个人资料头像";
    }
    [CRFAPPCountManager getEventIdForKey:keyName];//埋点
    UIViewController *controller = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                    [self showActionSheet];
            }
                
                break;
            case 1: {
                
            }
                break;
            case 2:
            case 3:{
                if (![CRFAppManager defaultManager].accountStatus) {
                    [self checkUserAccountStatus];
                }
            }
                break;
            case 4: {
                if ([[CRFAppManager defaultManager].userInfo.openBankCardNo isEmpty]) {
                    [self checkUserAccountStatus];
                } else {
                    controller = [CRFBankCardViewController new];
                }
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        if (![CRFAppManager defaultManager].accountStatus) {
            [self checkUserAccountStatus];
        } else {
            controller = [CRFEvaluatingViewController new];
            NSString *urlString = nil;
            if ([CRFAppManager defaultManager].majiabaoFlag) {
                if (![[CRFAppManager defaultManager].userInfo.riskLevel isEmpty]) {
                    NSString *rootString = nil;
                    if ([[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 1) {
                        rootString = kEvaluatingResult3H5;
                    } else if ([[CRFAppManager defaultManager].userInfo.riskLevel integerValue] == 2) {
                        rootString = kEvaluatingResult2H5;
                    } else {
                        rootString = kEvaluatingResult1H5;
                    }
                     urlString = [NSString stringWithFormat:@"%@?%@&realName=%@&idNoType=%@",rootString,kH5NeedHeaderInfo,[[CRFAppManager defaultManager].userInfo.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[CRFAppManager defaultManager].userInfo.idNo];
                } else {
                    urlString = [NSString stringWithFormat:@"%@?%@",kInvestTestH5,kH5NeedHeaderInfo];
                }
                ((CRFEvaluatingViewController *)controller).urlString = urlString;
            } else {
               
                ((CRFEvaluatingViewController *)controller).urlString = [NSString stringWithFormat:@"%@?%@",kRiskRevealH5,kH5NeedHeaderInfo];
            }
        }
    } else {
        if (indexPath.row == 0) {
            if ([[CRFAppManager defaultManager].userInfo.emailNo isEmpty]) {
                controller = [CRFEditEmailViewController new];
                ((CRFEditEmailViewController *)controller).indexPath = indexPath;
            } else {
                controller = [CRFEmailViewController new];
                ((CRFEmailViewController *)controller).indexPath = indexPath;
            }
        } else {
            controller = [CRFAddressViewController new];
            ((CRFAddressViewController *)controller).indexPath = indexPath;
        }
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)showActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"action_sheet_cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"action_sheet_take_photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongSelf(weakSelf);
        if (![CRFUtils allowCamera]) {
            NSString *message = [NSString stringWithFormat:@"为了能访问您的相机继续操作，请您开启%@中的相机权限",[NSString appName]];
            [CRFAlertUtils showAlertTitle:message message:nil container:strongSelf cancelTitle:@"取消" confirmTitle:@"去开启" cancelHandler:nil confirmHandler:^{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            return ;
        }
        weakSelf.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        weakSelf.imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        weakSelf.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [weakSelf presentViewController:weakSelf.imagePickerController animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"altion_photos_selected", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![CRFUtils allowPhotos]) {
            strongSelf(weakSelf);
            NSString *message = [NSString stringWithFormat:@"为了能访问您的相册继续操作，请您开启%@中的照片权限",[NSString appName]];
            [CRFAlertUtils showAlertTitle:message message:nil container:strongSelf cancelTitle:@"取消" confirmTitle:@"去开启" cancelHandler:nil confirmHandler:^{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            return ;
        }
        weakSelf.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [weakSelf presentViewController:weakSelf.imagePickerController animated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.selectedImage = selectedImage;
    [self uploadImage:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image {
    [CRFLoadingView disableLoading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] postWithUploadImage:[NSString stringWithFormat:APIFormat(kUploadImagePath),[CRFAppManager defaultManager].userInfo.customerUid] datas:UIImageJPEGRepresentation([CRFUtils scaleImage:image toSize:[CRFUtils croppedImage:image]], 0.4) fileName:self.fileName paragram:nil success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
            DLog(@"upload success");
            strongSelf.headerImageURL = [response[@"data"] objectForKey:@"headImgUrl"];
            [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kModifyUserInfoPath),kUuid] paragrams:@{@"headImgUrl":self.headerImageURL} success:^(CRFNetworkCompleteType errorType, id response) {
                [CRFLoadingView dismiss];
                [CRFUtils showMessage:@"头像上传成功"];
                [CRFAppManager defaultManager].userInfo.headUrl = strongSelf.headerImageURL;
                [strongSelf getCellWithSection:0 row:0].avatarImageView.image = strongSelf.selectedImage;
                [CRFSettingData setCurrentAccountInfo:[CRFAppManager defaultManager].userInfo];
                [CRFControllerManager refreshUserInfo];
                [CRFUtils delayAfert:kToastDuringTime handle:^{
                    [CRFControllerManager loadingHomeUserAvatar];
                }];
            } failed:^(CRFNetworkCompleteType errorType, id response) {
                [CRFUtils showMessage:response[kMessageKey]];
                [CRFLoadingView disableLoading];
            }];
            strongSelf.fileName = nil;
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
    
}

- (CRFInformationTableViewCell *)getCellWithSection:(NSInteger)section row:(NSInteger)row {
    CRFInformationTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}

- (void)setCellContentTextColor:(CRFInformationTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    CRFUserInfo *userInfo = [CRFAppManager defaultManager].userInfo;
    if (indexPath.section == 0) {
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.contentlabel.textColor = [userInfo.userName isEmpty]?UIColorFromRGBValue(0xFB4D3A):UIColorFromRGBValue(0x666666);
        } else if (indexPath.row == 1) {
            cell.contentlabel.textColor = UIColorFromRGBValue(0x666666);
        } else if (indexPath.row == 4) {
            cell.contentlabel.textColor = [userInfo.openBankCardNo isEmpty]?UIColorFromRGBValue(0xFB4D3A):UIColorFromRGBValue(0x666666);
        }
    } else if (indexPath.section == 1) {
        cell.contentlabel.textColor = [userInfo.riskLevel isEmpty]?UIColorFromRGBValue(0xFB4D3A):UIColorFromRGBValue(0x666666);
    } else {
        if (indexPath.row == 0) {
            cell.contentlabel.textColor = [userInfo.emailNo isEmpty]?UIColorFromRGBValue(0xFB4D3A):UIColorFromRGBValue(0x666666);
        } else {
            cell.contentlabel.textColor = ![CRFAppManager defaultManager].address?UIColorFromRGBValue(0xFB4D3A):UIColorFromRGBValue(0x666666);
        }
    }
}

#pragma mark -----
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkUserAccountStatus {
    [CRFLoadingView disableLoading];
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:APIFormat(kCheckUserAccountStatusPath) paragrams:@{@"phoneNo":[CRFAppManager defaultManager].userInfo.phoneNo} success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [CRFLoadingView dismiss];
            if ([response[@"data"][@"hasAccount"] integerValue] == 0) {
                CRFRelateAccountViewController *controller = [CRFRelateAccountViewController new];
                controller.hidesBottomBarWhenPushed = YES;
                controller.relatePhone = [CRFAppManager defaultManager].userInfo.phoneNo;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            } else {
                CRFCreateAccountViewController *controller = [CRFCreateAccountViewController new];
                controller.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:controller animated:YES];
            }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}


@end
