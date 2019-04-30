//
//  CRFDebtModel.h
//  crf_purse
//
//  Created by maomao on 2018/9/21.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFDebtModel : NSObject
@property (nonatomic, copy) NSString *annualizedYieldDouble;    ///< 复利
@property (nonatomic, copy) NSString *annualizedYieldSingle;    ///< 单利
@property (nonatomic, copy) NSString *downRateRange;            ///< 最低利率
@property (nonatomic, copy) NSString *loanContractNo;           ///< 借款合同号
@property (nonatomic, copy) NSString *rightsNo;                 ///< 待转让的债权编号
@property (nonatomic, copy) NSString *transferAmount;           ///< 转让金额
@property (nonatomic, copy) NSString *transferStatus;           ///< 交易状态码（交易状态码 : 1-新建 2-已受理 6-审批通过 10-转让中 14-交易处理中,18-交易完成 98-交易失败 99-已取消）
@property (nonatomic, copy) NSString *transferingNo;            ///< 转让编号
@property (nonatomic, copy) NSString *upRateRange;              ///< 最高利率

-(NSString*)dealTransAmount;
-(NSString*)formatRate;
@end
