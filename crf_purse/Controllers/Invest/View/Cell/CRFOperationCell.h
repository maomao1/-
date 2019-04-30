//
//  CRFOperationCell.h
//  crf_purse
//
//  Created by maomao on 2017/8/14.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFBaseCell.h"
#import "CRFProductModel.h"
#import "CRFCouponModel.h"
#import "CRFProtocol.h"
typedef void (^AgreeBtnStatusBlock) (BOOL isSelected);
typedef void (^PushProtoclBlock) (CRFProductModel *model,NSString*urlstr);
typedef void (^TextViewBlock) (NSString *contentText);

typedef void (^couponResetBlock) ();
typedef void (^selectedBestBlock) (NSString *amountCount);

@interface CRFOperationCell : CRFBaseCell
@property (nonatomic,strong) CRFProductModel *model;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (nonatomic,copy) TextViewBlock  textBlock;
@property (nonatomic,copy) AgreeBtnStatusBlock  btnStatusBlock;
@property (nonatomic,copy) PushProtoclBlock   push_block;
@property (weak, nonatomic) IBOutlet UILabel *appointmentForwardLabel;

@property (nonatomic,copy) selectedBestBlock  selectedBlock;
@property (nonatomic,copy) NSString     *investAmount;

@property (nonatomic,strong) CRFProductModel *exclusiveModel;
@property (nonatomic,strong) NSString  *exclusiveAmount;

@property (nonatomic, assign) BOOL protocolDidSelected;

/**
 key:name, url, info
 */
@property (nonatomic, strong) NSDictionary *protocolInfo;


@end
