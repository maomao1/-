//
//  CRFEditAddressViewController.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFEditAddressViewController.h"
#import "CRFAddressTableViewCell.h"
#import "CRFPickerView.h"
#import "CRFProfileViewController.h"
#import "CRFAddressViewController.h"
#import "CRFAlertUtils.h"

static NSString *const kAddressCellIdentifier = @"address";

@interface CRFEditAddressViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSArray <NSString *>*titles;
    NSArray <NSString *>*placeHolders;
    NSMutableArray <NSString *>*inputValues;
}
@property (nonatomic, strong) UITableView *addressTableView;
@property (nonatomic, strong) CRFPickerView *pickerView;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *districtCode;

@end

@implementation CRFEditAddressViewController

- (void)initializeView {
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _addressTableView.delegate = self;
    _addressTableView.dataSource = self;
    self.addressTableView.backgroundColor = UIColorFromRGBValue(0xf6f6f6);
    self.addressTableView.separatorColor = UIColorFromRGBValue(0xE2E2E2);
    [self.view addSubview:self.addressTableView];
     [self.addressTableView setTextEidt:YES];
    [self.addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(self.edit?@"title_modify_address":@"title_create_address", nil);
    
    // Do any additional setup after loading the view from its nib.
    [self initializeView];
    [self getTitles];
   
    //    [self addFooerView];
    [self addPickerView];
    [self cancelBarbutton];
    [self saveBarbutton];
    [self autoLayoutSizeContentView:self.addressTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self showPickerView:NO];
}

- (void)cancelBarbutton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"bar_cancel_edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)saveBarbutton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"bar_save_edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:kRegisterButtonBackgroundColor} forState:UIControlStateNormal];
}

- (void)save {
    [self saveAddress];
}

- (void)cancel {
    [CRFAlertUtils showAlertTitle:NSLocalizedString(@"alert_view_give_up_address", nil) message:nil container:self cancelTitle:NSLocalizedString(@"alert_view_button_cancel", nil) confirmTitle:NSLocalizedString(@"alert_view_button_comfirm", nil) cancelHandler:nil confirmHandler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getTitles {
    titles = @[NSLocalizedString(@"label_address_contact", nil),NSLocalizedString(@"label_address_mobile_phone", nil),NSLocalizedString(@"label_address_city", nil),NSLocalizedString(@"label_address_detail", nil),NSLocalizedString(@"label_address_email_no", nil)];
    placeHolders = @[NSLocalizedString(@"placeholder_name", nil),NSLocalizedString(@"placeholder_mobile_phone", nil),NSLocalizedString(@"placeholder_choose", nil),NSLocalizedString(@"placeholder_detail", nil),NSLocalizedString(@"placeholder_email_no", nil)];
    if (self.edit) {
        CRFAddress *address = [CRFAppManager defaultManager].address;
        inputValues = [@[address.contactName,address.mobilePhone,address.subAddress,address.address,address.postCode] mutableCopy];
        self.provinceCode = address.provinceCode;
        self.cityCode = address.cityCode;
        self.districtCode = address.districtCode;
    } else {
        inputValues = [@[@"",@"",@"",@"",@""] mutableCopy];
    }
}

- (void)addPickerView {
    _pickerView = [[CRFPickerView alloc] initWithType:Address];
    weakSelf(self);
    [_pickerView setCancelHandler:^{
        strongSelf(weakSelf);
        [strongSelf showPickerView:NO];
    }];
    __weak __typeof(inputValues) weakArray = inputValues;
    [_pickerView setComplataHandler:^ (CRFCity *city, NSInteger subCityIndex, NSInteger townIndex){
        strongSelf(weakSelf);
        [strongSelf showPickerView:NO];
        strongSelf.provinceCode = city.code;
        strongSelf.cityCode = city.subCities[subCityIndex].code;
        strongSelf.districtCode = city.subCities[subCityIndex].lastTowns[townIndex].code;
        NSString *string = [NSString stringWithFormat:@"%@%@%@",city.name,city.subCities[subCityIndex].name,city.subCities[subCityIndex].lastTowns[townIndex].name];
        [weakArray replaceObjectAtIndex:2 withObject:string];
        [weakArray replaceObjectAtIndex:4 withObject:city.postCode];
        [strongSelf.addressTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.pickerView show];
}

- (void)showPickerView:(BOOL)show {
    if (self.show == show) {
        return;
    }
    self.show = show;
    [self.pickerView update:self.show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRFAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellIdentifier];
    if (!cell) {
        cell = [[CRFAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kAddressCellIdentifier];
    }
    if (indexPath.row == 2) {
        cell.hasAccessoryView = YES;
        NSString *value = [inputValues objectAtIndex:indexPath.row];
        cell.textField.hidden = YES;
        if ([value isEmpty]) {
            cell.detailTextLabel.textColor = UIColorFromRGBValue(0x999999);
            cell.detailTextLabel.text = placeHolders[indexPath.row];
        } else {
            cell.detailTextLabel.textColor = UIColorFromRGBValue(0x333333);
            cell.detailTextLabel.text = value;
        }
    } else {
        if (indexPath.row == 4 || indexPath.row == 1) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            cell.textField.keyboardType = UIKeyboardTypeDefault;
        }
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = self;
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(textFieldContentDidChanged:) name:UITextFieldTextDidChangeNotification object:cell.textField];
        cell.textField.hidden = NO;
        cell.hasAccessoryView = NO;
        cell.textField.placeholder = placeHolders[indexPath.row];
        NSString *value = [inputValues objectAtIndex:indexPath.row];
        cell.textField.text = [value isEmpty]?nil:value;
    }
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self showPickerView:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTopSpace / 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldContentDidChanged:(NSNotification *)notification {
    UITextField *tf = notification.object;
    [inputValues replaceObjectAtIndex:tf.tag withObject:tf.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showPickerView:NO];
    return YES;
}

- (void)saveAddress {
    [self.view endEditing:YES];
    if ([[inputValues firstObject] isEmpty]) {
        [CRFUtils showMessage:@"toast_name_not_null"];
        return;
    }
    if ([inputValues[1] isEmpty]) {
        [CRFUtils showMessage:@"toast_mobile_phone_not_null"];
        return;
    }
    if (![inputValues[1] validatePhoneNumber]) {
        [CRFUtils showMessage:@"toast_phone_validate_not_null"];
        return;
    }
    if ([inputValues[2] isEmpty]) {
        [CRFUtils showMessage:@"toast_city_not_null"];
        return;
    }
    if ([inputValues[3] isEmpty]) {
        [CRFUtils showMessage:@"toast_address_not_null"];
        return;
    }
    if ([inputValues[4] isEmpty]) {
        [CRFUtils showMessage:@"toast_email_no_not_null"];
        return;
    }
    [CRFLoadingView disableLoading];
    NSString *urlString = nil;
    if (self.edit) {
        urlString = [NSString stringWithFormat:APIFormat(kUpdateAddressPath),[CRFAppManager defaultManager].userInfo.customerUid,[CRFAppManager defaultManager].address.addressId];
    } else {
        urlString = [NSString stringWithFormat:APIFormat(kAddAddressPath),[CRFAppManager defaultManager].userInfo.customerUid];
    }
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:urlString paragrams:[self getUserAddressInfo] success:^(CRFNetworkCompleteType errorType, id response) {
        strongSelf(weakSelf);
        [strongSelf updateUserAddress];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFUtils showMessage:response[kMessageKey]];
        [CRFLoadingView dismiss];
    }];
}

- (NSDictionary *)getUserAddressInfo {
    return @{@"contactName":inputValues[0],@"mobilePhone":inputValues[1],@"address":inputValues[3],@"postCode":inputValues[4],@"provinceCode":self.provinceCode,@"cityCode":self.cityCode,@"districtCode":self.districtCode};
}

- (void)updateUserAddress {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] post:[NSString stringWithFormat:APIFormat(kGetAddressListPath),[CRFAppManager defaultManager].userInfo.customerUid] paragrams:nil success:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        strongSelf(weakSelf);
        [CRFAppManager defaultManager].address = nil;
        [CRFAppManager defaultManager].addresses = [CRFResponseFactory getAddressList:response];
        [strongSelf update];
        [CRFUtils showMessage:strongSelf.edit?@"收获地址修改成功": @"收获地址添加成功"];
        [CRFUtils delayAfert:kToastDuringTime handle:^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        [CRFLoadingView dismiss];
        [CRFUtils showMessage:response[kMessageKey]];
    }];
}

- (void)update {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CRFProfileViewController class]]) {
            ((CRFProfileViewController *)vc).updateProfileHandler(self.indexPath);
        }
        if ([vc isKindOfClass:[CRFAddressViewController class]]) {
            ((CRFAddressViewController *)vc).hasAddress = [CRFAppManager defaultManager].address?YES:NO;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case 0:{
            [[self getTextField:textField.tag] becomeFirstResponder];
        }
            break;
        case 1: {
            [[self getTextField:textField.tag + 1] becomeFirstResponder];
        }
            break;
        case 3: {
            [[self getTextField:textField.tag] becomeFirstResponder];
        }
            break;
        case 4: {
            [self.view endEditing:YES];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (UITextField *)getTextField:(NSInteger)tag {
    CRFAddressTableViewCell *cell = [self.addressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag + 1 inSection:0]];
    return cell.textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 1) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 11) {
            return NO;
        }
    } else if (textField.tag == 4) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 6) {
            return NO;
        }
    }
    return YES;
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
