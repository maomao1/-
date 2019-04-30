//
//  CRFMessageDetailVC.h
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
#import "CRFMessageModel.h"
typedef enum : NSUInteger {
    MESSAGE_Detail = 0,
    SYSTEM_Detail
} DetailType;
@interface CRFMessageDetailViewController : CRFBasicViewController
@property (nonatomic , assign) DetailType  mesType;
@property (nonatomic , copy) NSString *batchNo;//消息批次号，用来查询消息详情
@property (nonatomic , strong) CRFMessageModel *detailModel;
@property (nonatomic , strong) CRFActivity     *activiModel;
@end
