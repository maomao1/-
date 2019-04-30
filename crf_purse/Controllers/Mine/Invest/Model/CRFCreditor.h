//
//  CRFCreditor.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFAgreementDto.h"

@interface CRFCreditor : NSObject



/*investNo = INV100000055;
 loanContractNo = d655515631a54a3cbc8bd965f3f34a8d;
 loanerIdNo = "**************0341";
 loanerName = "\U90b9*";
 rightAmount = "0.00";
 rightNo = R170128110023002086T;
 rightStatus = effective;
*/

//Source 2

@property (nonatomic, copy) NSString *investNo;
@property (nonatomic, copy) NSString *loanContractNo;
@property (nonatomic, copy) NSString *loanerName;
@property (nonatomic, copy) NSString *rightAmount;
@property (nonatomic, copy) NSString *rightNo;
@property (nonatomic, copy) NSString *rightStatus;
@property (nonatomic, copy) NSString *loanerIdNo;


//Source 1

/**
 借款人姓名
 */
@property (nonatomic, copy) NSString *borrowerName;

/**
 借款人身份证号码
 */
@property (nonatomic, copy) NSString *borrowerIdNumber;

/**
 借款用途
 */
@property (nonatomic, copy) NSString *detailUse;

/**
 借款人合同号
 */
@property (nonatomic, copy) NSString *borrowerContractNo;

/**
 借款人职业
 */
@property (nonatomic, copy) NSString *borrowerProfession;

/**
 本期债权
 */
@property (nonatomic, copy) NSString *surplusCapital;

/**
 借款期限
 */
@property (nonatomic, copy) NSString *payTerm;

/**
  待收期数
 */
@property (nonatomic, copy) NSString *dueinTerm;

/**
 初始债权本金
 */
@property (nonatomic, copy) NSString *transferCapital;

/**
 待收本金
 */
@property (nonatomic, copy) NSString *dueinCapital;

/**
 逾期年化收益率
 */
@property (nonatomic, copy) NSString *yearofProfit;

/**
 出借协议URL
 */
@property (nonatomic, copy) NSString *agreementHtmlUrl;


@property (nonatomic, copy) NSArray <NSDictionary *>*agreementList;


@property (nonatomic, copy) NSArray <CRFAgreementDto *>*protocols;


- (NSString *)formatPayTerm;

- (NSString *)formatDueinTerm;

- (NSString *)formatTransferCapital;

- (NSString *)formatDueinCapital;

@end
