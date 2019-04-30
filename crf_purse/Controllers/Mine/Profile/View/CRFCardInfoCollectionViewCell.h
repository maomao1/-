//
//  CRFCardInfoCollectionViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/11/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 银行卡状态描述

 - CRFBankCardStatus_Normal: 正常使用
 - CRFBankCardStatus_Pause: 暂停使用
 - CRFBankCardStatus_Audit: 审核中
 */
typedef NS_ENUM(NSUInteger, CRFBankCardStatus) {
    CRFBankCardStatus_Normal        = 0,
    CRFBankCardStatus_Pause         = 1,
    CRFBankCardStatus_Audit         = 2
};

@interface CRFCardInfoCollectionViewCell : UICollectionViewCell


/**
 银行卡背景图
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 银行名称
 */
@property (nonatomic, copy) NSString *cardName;

/**
 卡类型
 */
@property (nonatomic, copy) NSString *cardType;

/**
 卡号
 */
@property (nonatomic, copy) NSString *cardNo;

/**
 银行卡使用状态
 */
@property (nonatomic, assign) CRFBankCardStatus bankCardStatus;

@end
