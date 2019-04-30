//
//  CRFUploadImageViewController.h
//  crf_purse
//
//  Created by xu_cheng on 2017/10/31.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"

@interface CRFUploadImageViewController : CRFBasicViewController

/**
 城市ID， 银行卡号， 银行编号
 */
@property (nonatomic, copy) NSString *cityID, *cardNO, *bankNo;

@end
