//
//  CRFUploadImageViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUploadImageViewController.h"
#import "CRFUploadImageView.h"
#import "CRFStringUtils.h"
#import "UIImage+Color.h"
#import "CRFAlertUtils.h"
#import "CRFBankCardViewController.h"

static CGFloat kMaxFileSize = 4 * 1024 * 1024;

@interface CRFUploadImageViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
}
@property (nonatomic, strong) CRFUploadImageView *imageView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSThread *thread;
@end

@implementation CRFUploadImageViewController

- (NSString *)bankNo {
    if (!_bankNo) {
        _bankNo = @"";
    }
    return _bankNo;
}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

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

//- (void)back {
////    [self goBackNeedUpdate:NO];
//    [super back];
//}

- (void)goBackNeedUpdate:(BOOL)update {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CRFBankCardViewController class]]) {
            if (update) {
                CRFBankCardViewController *controller = (CRFBankCardViewController *)viewController;
                if (controller.updateBankStatus) {
                    controller.updateBankStatus();
                }
            }
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    [super back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换银行卡";
    [self configImageView];
    [self configBottomView];
    [self initThread];
}

- (void)initThread {
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(otherThread) object:nil];
    [_thread start];
}

- (void)otherThread {
    @autoreleasepool {
        if (!_imagePickerController) {
            _imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.delegate = self;
            _imagePickerController.allowsEditing = YES;
        }
    }
}

- (void)configImageView {
    _imageView = [[CRFUploadImageView alloc] init];
    [self.view addSubview:self.imageView];
    weakSelf(self);
    [self.imageView setTapHandler:^{
        strongSelf(weakSelf);
        if ([strongSelf.thread isFinished]) {
             [strongSelf showActionSheet];
        }
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(55 + 275 * kWidthRatio);
    }];
}

- (void)configBottomView {
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = @"拍照要求：";
    promptLabel.textColor = UIColorFromRGBValue(0xAAAAAA);
    promptLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kSpace);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(20);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = UIColorFromRGBValue(0x666666);
    descriptionLabel.font = [UIFont systemFontOfSize:14.0];
    NSString *descriptionString = @"1、必须同时包含银行卡正面和身份证正面；\n2、证件上的所有信息须清晰可见，尤其是证件号；\n3、手持证件人须免冠且五官清晰；";
    [descriptionLabel setAttributedText:[CRFStringUtils setAttributedString:descriptionString lineSpace:5 attributes1:nil range1:NSRangeZero attributes2:nil range2:NSRangeZero attributes3:nil range3:NSRangeZero attributes4:nil range4:NSRangeZero]];
    [self.view addSubview:descriptionLabel];
    CGFloat descriptionHeight = [descriptionString boundingRectWithSize:CGSizeMake(kScreenWidth - kSpace * 2, CGFLOAT_MAX) fontNumber:14.0 lineSpace:5].height;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kSpace);
        make.top.equalTo(promptLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.view).with.offset(-kSpace);
        make.height.mas_equalTo(descriptionHeight);
    }];
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.commitButton];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xCCCCCC)] forState:UIControlStateDisabled];
    self.commitButton.enabled = NO;
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.layer.cornerRadius = 5.0f;
    [self.commitButton setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.commitButton setTitle:@"提交审核" forState:UIControlStateDisabled];
    [self.commitButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xFB4D3A)] forState:UIControlStateNormal];
     [self.commitButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xFB4D3A)] forState:UIControlStateHighlighted];
    [self.commitButton addTarget:self action:@selector(commitUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionLabel.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(kSpace);
        make.right.equalTo(self.view).with.offset(-kSpace);
        make.height.mas_equalTo(kRegisterButtonHeight);
    }];
}

- (void)showActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"action_sheet_cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    [alertController addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    self.imageView.imageView.image = selectedImage;
    self.imageView.hasImage = YES;
    self.commitButton.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)commitUserInfo {
    if (!self.imageView.hasImage) {
        [CRFUtils showMessage:@"请先上传图片"];
        return;
    }
     [CRFLoadingView loading];
    [[CRFStandardNetworkManager defaultManager] postWithUploadImage:[NSString stringWithFormat:APIFormat(kUploadImagePath),[CRFAppManager defaultManager].userInfo.customerUid] datas:[self compressImageSize:self.imageView.imageView.image] fileName:self.fileName paragram:nil success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            [self changeBankCard:response[kDataKey][@"headImgUrl"]];
        } else {
            [CRFLoadingView dismiss];
             DLog(@"==%@==",response);
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
         [CRFLoadingView dismiss];
         DLog(@"==%@==",response);
         [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)changeBankCard:(NSString *)imageUrl {
    DLog(@"upload bank card info is %@==%@==%@",self.bankNo,self.cityID,self.cardNO);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kChangeBankCardPath),kUuid] paragrams:@{@"newCityId":self.cityID,@"newBankNum":self.bankNo,@"newCardNo":self.cardNO,@"imagePath":imageUrl} success:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
         [CRFLoadingView dismiss];
        if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
            weakSelf(self);
            [CRFUserDefaultManager setBankCardAuditErrorFlag:NO];
            [CRFUserDefaultManager setBankAuditStatus:YES];
            [CRFAlertUtils showAlertTitle:@"更换银行卡申请成功！" imagedName:@"alert_success" container:self cancelTitle:nil confirmTitle:@"我知道了" cancelHandler:nil confirmHandler:^{
                strongSelf(weakSelf);
                [strongSelf goBackNeedUpdate:YES];
            }];
        } else {
            [CRFUtils showMessage:response[kMessageKey]];
        }
    } failed:^(CRFNetworkCompleteType errorType, id  _Nullable response) {
        [CRFLoadingView dismiss];
         [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData *)compressImageSize:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation([CRFUtils scaleImage:image toSize:[CRFUtils croppedImage:image]], 1);
    while (data.length > kMaxFileSize) {
        UIImage *img = [UIImage imageWithData:data];
        data = UIImageJPEGRepresentation([CRFUtils scaleImage:img toSize:[CRFUtils croppedImage:image]], .9);
    }
    return data;
}


@end
