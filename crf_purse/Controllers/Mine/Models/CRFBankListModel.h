//
//  CRFBankListModel.h
//  crf_purse
//
//  Created by maomao on 2017/8/1.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFBankListModel : NSObject
@property (nonatomic , copy)NSString * bankCode;
@property (nonatomic , copy)NSString * bankName;
@property (nonatomic , copy)NSString * bankUrl;
@property (nonatomic, copy) NSString *minimum;
@property (nonatomic , strong) NSDictionary * quotaMap;

@property (nonatomic , copy)NSString * bankSigle;
@property (nonatomic , copy)NSString * bankDay;
@property (nonatomic , copy)NSString * bankMonth;



- (NSString *)formatSingleOrder;

- (NSString *)formatDayOrder;

- (NSString *)formatMonthOrder;


@end
