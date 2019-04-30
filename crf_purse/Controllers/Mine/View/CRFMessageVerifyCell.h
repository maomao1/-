//
//  CRFMessageVerifyCell.h
//  crf_purse
//
//  Created by maomao on 2018/6/15.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFVerifyCodeView.h"
#import "CRFTextField.h"
#import "CRFButton.h"
typedef void (^callBack)(CRFButton *codeBtn);
static NSString *const CRFMessageVerifyId_first = @"CRFMessageVerifyCell_identify_first";
static NSString *const CRFMessageVerifyId_second = @"CRFMessageVerifyCell_identify_second";
@interface CRFMessageVerifyCell : UITableViewCell
@property (nonatomic, strong) CRFVerifyCodeView *verifyCodeView;
@property (nonatomic, strong) CRFButton *codeButton;
@property (nonatomic ,copy) NSString *leftTitle;
@property (nonatomic ,copy) NSString *placeHoderStr;
@property (nonatomic ,copy) NSString *numberStr;
@property (nonatomic, strong) CRFTextField  * textField;
@property (nonatomic,copy) callBack  codeBack;
@end
