//
//  CRFBankCardViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFCardInfoCollectionViewCell.h"


@interface CRFBankCardViewController : CRFBasicViewController

@property (nonatomic, assign) CRFBankCardStatus bankCardStatus;

@property (nonatomic, copy) void (^ (updateBankStatus))(void);

@end
